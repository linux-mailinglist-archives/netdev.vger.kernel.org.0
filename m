Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E286E97C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732057AbfGSQpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:45:53 -0400
Received: from mail.us.es ([193.147.175.20]:49940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728389AbfGSQpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3023DBAEE2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 162485765B
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0B6E918524; Fri, 19 Jul 2019 18:45:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65006115101;
        Fri, 19 Jul 2019 18:45:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C27E440705C4;
        Fri, 19 Jul 2019 18:45:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/14] netfilter: nf_conntrack_sip: fix expectation clash
Date:   Fri, 19 Jul 2019 18:45:06 +0200
Message-Id: <20190719164517.29496-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiao ruizhu <katrina.xiaorz@gmail.com>

When conntracks change during a dialog, SDP messages may be sent from
different conntracks to establish expects with identical tuples. In this
case expects conflict may be detected for the 2nd SDP message and end up
with a process failure.

The fixing here is to reuse an existing expect who has the same tuple for a
different conntrack if any.

Here are two scenarios for the case.

1)
         SERVER                   CPE

           |      INVITE SDP       |
      5060 |<----------------------|5060
           |      100 Trying       |
      5060 |---------------------->|5060
           |      183 SDP          |
      5060 |---------------------->|5060    ===> Conntrack 1
           |       PRACK           |
     50601 |<----------------------|5060
           |    200 OK (PRACK)     |
     50601 |---------------------->|5060
           |    200 OK (INVITE)    |
      5060 |---------------------->|5060
           |        ACK            |
     50601 |<----------------------|5060
           |                       |
           |<--- RTP stream ------>|
           |                       |
           |    INVITE SDP (t38)   |
     50601 |---------------------->|5060    ===> Conntrack 2

With a certain configuration in the CPE, SIP messages "183 with SDP" and
"re-INVITE with SDP t38" will go through the sip helper to create
expects for RTP and RTCP.

It is okay to create RTP and RTCP expects for "183", whose master
connection source port is 5060, and destination port is 5060.

In the "183" message, port in Contact header changes to 50601 (from the
original 5060). So the following requests e.g. PRACK and ACK are sent to
port 50601. It is a different conntrack (let call Conntrack 2) from the
original INVITE (let call Conntrack 1) due to the port difference.

In this example, after the call is established, there is RTP stream but no
RTCP stream for Conntrack 1, so the RTP expect created upon "183" is
cleared, and RTCP expect created for Conntrack 1 retains.

When "re-INVITE with SDP t38" arrives to create RTP&RTCP expects, current
ALG implementation will call nf_ct_expect_related() for RTP and RTCP. The
expects tuples are identical to those for Conntrack 1. RTP expect for
Conntrack 2 succeeds in creation as the one for Conntrack 1 has been
removed. RTCP expect for Conntrack 2 fails in creation because it has
idential tuples and 'conflict' with the one retained for Conntrack 1. And
then result in a failure in processing of the re-INVITE.

2)

    SERVER A                 CPE

       |      REGISTER     |
  5060 |<------------------| 5060  ==> CT1
       |       200         |
  5060 |------------------>| 5060
       |                   |
       |   INVITE SDP(1)   |
  5060 |<------------------| 5060
       | 300(multi choice) |
  5060 |------------------>| 5060                    SERVER B
       |       ACK         |
  5060 |<------------------| 5060
                                  |    INVITE SDP(2)    |
                             5060 |-------------------->| 5060  ==> CT2
                                  |       100           |
                             5060 |<--------------------| 5060
                                  | 200(contact changes)|
                             5060 |<--------------------| 5060
                                  |       ACK           |
                             5060 |-------------------->| 50601 ==> CT3
                                  |                     |
                                  |<--- RTP stream ---->|
                                  |                     |
                                  |       BYE           |
                             5060 |<--------------------| 50601
                                  |       200           |
                             5060 |-------------------->| 50601
       |   INVITE SDP(3)   |
  5060 |<------------------| 5060  ==> CT1

CPE sends an INVITE request(1) to Server A, and creates a RTP&RTCP expect
pair for this Conntrack 1 (CT1). Server A responds 300 to redirect to
Server B. The RTP&RTCP expect pairs created on CT1 are removed upon 300
response.

CPE sends the INVITE request(2) to Server B, and creates an expect pair
for the new conntrack (due to destination address difference), let call
CT2. Server B changes the port to 50601 in 200 OK response, and the
following requests ACK and BYE from CPE are sent to 50601. The call is
established. There is RTP stream and no RTCP stream. So RTP expect is
removed and RTCP expect for CT2 retains.

As BYE request is sent from port 50601, it is another conntrack, let call
CT3, different from CT2 due to the port difference. So the BYE request will
not remove the RTCP expect for CT2.

Then another outgoing call is made, with the same RTP port being used (not
definitely but possibly). CPE firstly sends the INVITE request(3) to Server
A, and tries to create a RTP&RTCP expect pairs for this CT1. In current ALG
implementation, the RTCP expect for CT1 fails in creation because it
'conflicts' with the residual one for CT2. As a result the INVITE request
fails to send.

Signed-off-by: xiao ruizhu <katrina.xiaorz@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_expect.h | 12 +++++++++---
 net/ipv4/netfilter/nf_nat_h323.c            | 12 ++++++------
 net/netfilter/ipvs/ip_vs_nfct.c             |  2 +-
 net/netfilter/nf_conntrack_amanda.c         |  2 +-
 net/netfilter/nf_conntrack_broadcast.c      |  2 +-
 net/netfilter/nf_conntrack_expect.c         | 26 +++++++++++++++++++-------
 net/netfilter/nf_conntrack_ftp.c            |  2 +-
 net/netfilter/nf_conntrack_h323_main.c      | 18 +++++++++---------
 net/netfilter/nf_conntrack_irc.c            |  2 +-
 net/netfilter/nf_conntrack_netlink.c        |  4 ++--
 net/netfilter/nf_conntrack_pptp.c           |  4 ++--
 net/netfilter/nf_conntrack_sane.c           |  2 +-
 net/netfilter/nf_conntrack_sip.c            | 10 +++++++---
 net/netfilter/nf_conntrack_tftp.c           |  2 +-
 net/netfilter/nf_nat_amanda.c               |  2 +-
 net/netfilter/nf_nat_ftp.c                  |  2 +-
 net/netfilter/nf_nat_irc.c                  |  2 +-
 net/netfilter/nf_nat_sip.c                  |  8 +++++---
 net/netfilter/nf_nat_tftp.c                 |  2 +-
 net/netfilter/nft_ct.c                      |  2 +-
 20 files changed, 71 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 93ce6b0daaba..573429be4d59 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -76,6 +76,11 @@ struct nf_conntrack_expect_policy {
 #define NF_CT_EXPECT_CLASS_DEFAULT	0
 #define NF_CT_EXPECT_MAX_CNT		255
 
+/* Allow to reuse expectations with the same tuples from different master
+ * conntracks.
+ */
+#define NF_CT_EXP_F_SKIP_MASTER	0x1
+
 int nf_conntrack_expect_pernet_init(struct net *net);
 void nf_conntrack_expect_pernet_fini(struct net *net);
 
@@ -122,10 +127,11 @@ void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
-				u32 portid, int report);
-static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect)
+				u32 portid, int report, unsigned int flags);
+static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
+				       unsigned int flags)
 {
-	return nf_ct_expect_related_report(expect, 0, 0);
+	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
 #endif /*_NF_CONNTRACK_EXPECT_H*/
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 87b711fd5a44..3e2685c120c7 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -221,11 +221,11 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		ret = nf_ct_expect_related(rtp_exp);
+		ret = nf_ct_expect_related(rtp_exp, 0);
 		if (ret == 0) {
 			rtcp_exp->tuple.dst.u.udp.port =
 			    htons(nated_port + 1);
-			ret = nf_ct_expect_related(rtcp_exp);
+			ret = nf_ct_expect_related(rtcp_exp, 0);
 			if (ret == 0)
 				break;
 			else if (ret == -EBUSY) {
@@ -296,7 +296,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -352,7 +352,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -444,7 +444,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -537,7 +537,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index 403541996952..08adcb222986 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -231,7 +231,7 @@ void ip_vs_nfct_expect_related(struct sk_buff *skb, struct nf_conn *ct,
 
 	IP_VS_DBG_BUF(7, "%s: ct=%p, expect tuple=" FMT_TUPLE "\n",
 		      __func__, ct, ARG_TUPLE(&exp->tuple));
-	nf_ct_expect_related(exp);
+	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 }
 EXPORT_SYMBOL(ip_vs_nfct_expect_related);
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 42ee659d0d1e..d011d2eb0848 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -159,7 +159,7 @@ static int amanda_help(struct sk_buff *skb,
 		if (nf_nat_amanda && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_amanda(skb, ctinfo, protoff,
 					    off - dataoff, len, exp);
-		else if (nf_ct_expect_related(exp) != 0) {
+		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		}
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 921a7b95be68..1ba6becc3079 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -68,7 +68,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	exp->class		  = NF_CT_EXPECT_CLASS_DEFAULT;
 	exp->helper               = NULL;
 
-	nf_ct_expect_related(exp);
+	nf_ct_expect_related(exp, 0);
 	nf_ct_expect_put(exp);
 
 	nf_ct_refresh(ct, skb, timeout * HZ);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index ffd1f4906c4f..65364de915d1 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -249,13 +249,22 @@ static inline int expect_clash(const struct nf_conntrack_expect *a,
 static inline int expect_matches(const struct nf_conntrack_expect *a,
 				 const struct nf_conntrack_expect *b)
 {
-	return a->master == b->master &&
-	       nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
+	return nf_ct_tuple_equal(&a->tuple, &b->tuple) &&
 	       nf_ct_tuple_mask_equal(&a->mask, &b->mask) &&
 	       net_eq(nf_ct_net(a->master), nf_ct_net(b->master)) &&
 	       nf_ct_zone_equal_any(a->master, nf_ct_zone(b->master));
 }
 
+static bool master_matches(const struct nf_conntrack_expect *a,
+			   const struct nf_conntrack_expect *b,
+			   unsigned int flags)
+{
+	if (flags & NF_CT_EXP_F_SKIP_MASTER)
+		return true;
+
+	return a->master == b->master;
+}
+
 /* Generally a bad idea to call this: could have matched already. */
 void nf_ct_unexpect_related(struct nf_conntrack_expect *exp)
 {
@@ -399,7 +408,8 @@ static void evict_oldest_expect(struct nf_conn *master,
 		nf_ct_remove_expect(last);
 }
 
-static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
+static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
+				       unsigned int flags)
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
@@ -417,8 +427,10 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 	}
 	h = nf_ct_expect_dst_hash(net, &expect->tuple);
 	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
-		if (expect_matches(i, expect)) {
-			if (i->class != expect->class)
+		if (master_matches(i, expect, flags) &&
+		    expect_matches(i, expect)) {
+			if (i->class != expect->class ||
+			    i->master != expect->master)
 				return -EALREADY;
 
 			if (nf_ct_remove_expect(i))
@@ -453,12 +465,12 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect)
 }
 
 int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
-				u32 portid, int report)
+				u32 portid, int report, unsigned int flags)
 {
 	int ret;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	ret = __nf_ct_expect_check(expect);
+	ret = __nf_ct_expect_check(expect, flags);
 	if (ret < 0)
 		goto out;
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 8c6c11bab5b6..0ecb3e289ef2 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -525,7 +525,7 @@ static int help(struct sk_buff *skb,
 				 protoff, matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (nf_ct_expect_related(exp) != 0) {
+		if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		} else
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6497e5fc0871..8ba037b76ad3 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -305,8 +305,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_rtp_rtcp(skb, ct, ctinfo, protoff, data, dataoff,
 				   taddr, port, rtp_port, rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(rtp_exp) == 0) {
-			if (nf_ct_expect_related(rtcp_exp) == 0) {
+		if (nf_ct_expect_related(rtp_exp, 0) == 0) {
+			if (nf_ct_expect_related(rtcp_exp, 0) == 0) {
 				pr_debug("nf_ct_h323: expect RTP ");
 				nf_ct_dump_tuple(&rtp_exp->tuple);
 				pr_debug("nf_ct_h323: expect RTCP ");
@@ -364,7 +364,7 @@ static int expect_t120(struct sk_buff *skb,
 		ret = nat_t120(skb, ct, ctinfo, protoff, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_h323: expect T.120 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -701,7 +701,7 @@ static int expect_h245(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_h245(skb, ct, ctinfo, protoff, data, dataoff, taddr,
 			       port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_q931: expect H.245 ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -825,7 +825,7 @@ static int expect_callforwarding(struct sk_buff *skb,
 					 protoff, data, dataoff,
 					 taddr, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_q931: expect Call Forwarding ");
 			nf_ct_dump_tuple(&exp->tuple);
 		} else
@@ -1284,7 +1284,7 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 		ret = nat_q931(skb, ct, ctinfo, protoff, data,
 			       taddr, i, port, exp);
 	} else {		/* Conntrack only */
-		if (nf_ct_expect_related(exp) == 0) {
+		if (nf_ct_expect_related(exp, 0) == 0) {
 			pr_debug("nf_ct_ras: expect Q.931 ");
 			nf_ct_dump_tuple(&exp->tuple);
 
@@ -1349,7 +1349,7 @@ static int process_gcf(struct sk_buff *skb, struct nf_conn *ct,
 			  IPPROTO_UDP, NULL, &port);
 	exp->helper = nf_conntrack_helper_ras;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect RAS ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
@@ -1561,7 +1561,7 @@ static int process_acf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
@@ -1615,7 +1615,7 @@ static int process_lcf(struct sk_buff *skb, struct nf_conn *ct,
 	exp->flags = NF_CT_EXPECT_PERMANENT;
 	exp->helper = nf_conntrack_helper_q931;
 
-	if (nf_ct_expect_related(exp) == 0) {
+	if (nf_ct_expect_related(exp, 0) == 0) {
 		pr_debug("nf_ct_ras: expect Q.931 ");
 		nf_ct_dump_tuple(&exp->tuple);
 	} else
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 7ac156f1f3bc..e40988a2f22f 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -213,7 +213,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 						 addr_beg_p - ib_ptr,
 						 addr_end_p - addr_beg_p,
 						 exp);
-			else if (nf_ct_expect_related(exp) != 0) {
+			else if (nf_ct_expect_related(exp, 0) != 0) {
 				nf_ct_helper_log(skb, ct,
 						 "cannot add expectation");
 				ret = NF_DROP;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1b77444d5b52..6aa01eb6fe99 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2616,7 +2616,7 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	if (IS_ERR(exp))
 		return PTR_ERR(exp);
 
-	err = nf_ct_expect_related_report(exp, portid, report);
+	err = nf_ct_expect_related_report(exp, portid, report, 0);
 	nf_ct_expect_put(exp);
 	return err;
 }
@@ -3367,7 +3367,7 @@ ctnetlink_create_expect(struct net *net,
 		goto err_rcu;
 	}
 
-	err = nf_ct_expect_related_report(exp, portid, report);
+	err = nf_ct_expect_related_report(exp, portid, report, 0);
 	nf_ct_expect_put(exp);
 err_rcu:
 	rcu_read_unlock();
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index b22042ad0fca..a971183f11af 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -234,9 +234,9 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	nf_nat_pptp_exp_gre = rcu_dereference(nf_nat_pptp_hook_exp_gre);
 	if (nf_nat_pptp_exp_gre && ct->status & IPS_NAT_MASK)
 		nf_nat_pptp_exp_gre(exp_orig, exp_reply);
-	if (nf_ct_expect_related(exp_orig) != 0)
+	if (nf_ct_expect_related(exp_orig, 0) != 0)
 		goto out_put_both;
-	if (nf_ct_expect_related(exp_reply) != 0)
+	if (nf_ct_expect_related(exp_reply, 0) != 0)
 		goto out_unexpect_orig;
 
 	/* Add GRE keymap entries */
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 81448c3db661..1aebd6569d4e 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -153,7 +153,7 @@ static int help(struct sk_buff *skb,
 	nf_ct_dump_tuple(&exp->tuple);
 
 	/* Can't expect this?  Best to drop packet now. */
-	if (nf_ct_expect_related(exp) != 0) {
+	if (nf_ct_expect_related(exp, 0) != 0) {
 		nf_ct_helper_log(skb, ct, "cannot add expectation");
 		ret = NF_DROP;
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 107251731809..b83dc9bf0a5d 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -977,11 +977,15 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		/* -EALREADY handling works around end-points that send
 		 * SDP messages with identical port but different media type,
 		 * we pretend expectation was set up.
+		 * It also works in the case that SDP messages are sent with
+		 * identical expect tuples but for different master conntracks.
 		 */
-		int errp = nf_ct_expect_related(rtp_exp);
+		int errp = nf_ct_expect_related(rtp_exp,
+						NF_CT_EXP_F_SKIP_MASTER);
 
 		if (errp == 0 || errp == -EALREADY) {
-			int errcp = nf_ct_expect_related(rtcp_exp);
+			int errcp = nf_ct_expect_related(rtcp_exp,
+						NF_CT_EXP_F_SKIP_MASTER);
 
 			if (errcp == 0 || errcp == -EALREADY)
 				ret = NF_ACCEPT;
@@ -1296,7 +1300,7 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		ret = hooks->expect(skb, protoff, dataoff, dptr, datalen,
 				    exp, matchoff, matchlen);
 	else {
-		if (nf_ct_expect_related(exp) != 0) {
+		if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		} else
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index df6d6d61bd58..80ee53f29f68 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -78,7 +78,7 @@ static int tftp_help(struct sk_buff *skb,
 		nf_nat_tftp = rcu_dereference(nf_nat_tftp_hook);
 		if (nf_nat_tftp && ct->status & IPS_NAT_MASK)
 			ret = nf_nat_tftp(skb, ctinfo, exp);
-		else if (nf_ct_expect_related(exp) != 0) {
+		else if (nf_ct_expect_related(exp, 0) != 0) {
 			nf_ct_helper_log(skb, ct, "cannot add expectation");
 			ret = NF_DROP;
 		}
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index a352604d6186..3bc7e0854efe 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -48,7 +48,7 @@ static unsigned int help(struct sk_buff *skb,
 		int res;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		res = nf_ct_expect_related(exp);
+		res = nf_ct_expect_related(exp, 0);
 		if (res == 0)
 			break;
 		else if (res != -EBUSY) {
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index d48484a9d52d..aace6768a64e 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -91,7 +91,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index dfb7ef8845bd..c691ab8d234c 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -53,7 +53,7 @@ static unsigned int help(struct sk_buff *skb,
 		int ret;
 
 		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, 0);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index e338d91980d8..f0a735e86851 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -414,7 +414,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(exp);
+		ret = nf_ct_expect_related(exp, NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == 0)
 			break;
 		else if (ret != -EBUSY) {
@@ -607,7 +607,8 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(rtp_exp);
+		ret = nf_ct_expect_related(rtp_exp,
+					   NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == -EBUSY)
 			continue;
 		else if (ret < 0) {
@@ -615,7 +616,8 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 			break;
 		}
 		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
-		ret = nf_ct_expect_related(rtcp_exp);
+		ret = nf_ct_expect_related(rtcp_exp,
+					   NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == 0)
 			break;
 		else if (ret == -EBUSY) {
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 833a11f68031..1a591132d6eb 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -30,7 +30,7 @@ static unsigned int help(struct sk_buff *skb,
 		= ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.udp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
-	if (nf_ct_expect_related(exp) != 0) {
+	if (nf_ct_expect_related(exp, 0) != 0) {
 		nf_ct_helper_log(skb, exp->master, "cannot add expectation");
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 827ab6196df9..46ca8bcca1bd 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1252,7 +1252,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout.expires = jiffies + priv->timeout * HZ;
 
-	if (nf_ct_expect_related(exp) != 0)
+	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
 }
 
-- 
2.11.0


