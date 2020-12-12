Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF52D8A83
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408184AbgLLXG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:06:27 -0500
Received: from correo.us.es ([193.147.175.20]:46778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408161AbgLLXGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 391EC303D10
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2972FDA78F
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1EF6ADA78C; Sun, 13 Dec 2020 00:05:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0E5DDA722;
        Sun, 13 Dec 2020 00:05:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 85A494265A5A;
        Sun, 13 Dec 2020 00:05:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/10] netfilter: ctnetlink: add timeout and protoinfo to destroy events
Date:   Sun, 13 Dec 2020 00:05:09 +0100
Message-Id: <20201212230513.3465-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

DESTROY events do not include the remaining timeout.

Add the timeout if the entry was removed explicitly. This can happen
when a conntrack gets deleted prematurely, e.g. due to a tcp reset,
module removal, netdev notifier (nat/masquerade device went down),
ctnetlink and so on.

Add the protocol state too for the destroy message to check for abnormal
state on connection termination.

Joint work with Pablo.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
 net/netfilter/nf_conntrack_netlink.c         | 31 +++++++++++++-------
 net/netfilter/nf_conntrack_proto_dccp.c      | 13 ++++++--
 net/netfilter/nf_conntrack_proto_sctp.c      | 13 +++++---
 net/netfilter/nf_conntrack_proto_tcp.c       | 13 +++++---
 5 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 9be7320b994f..96f9cf81f46b 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -32,7 +32,7 @@ struct nf_conntrack_l4proto {
 
 	/* convert protoinfo to nfnetink attributes */
 	int (*to_nlattr)(struct sk_buff *skb, struct nlattr *nla,
-			 struct nf_conn *ct);
+			 struct nf_conn *ct, bool destroy);
 
 	/* convert nfnetlink attributes to protoinfo */
 	int (*from_nlattr)(struct nlattr *tb[], struct nf_conn *ct);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3d0fd33be018..84caf3316946 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -167,10 +167,14 @@ static int ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 
-static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
+				  bool skip_zero)
 {
 	long timeout = nf_ct_expires(ct) / HZ;
 
+	if (skip_zero && timeout == 0)
+		return 0;
+
 	if (nla_put_be32(skb, CTA_TIMEOUT, htonl(timeout)))
 		goto nla_put_failure;
 	return 0;
@@ -179,7 +183,8 @@ static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 
-static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
+static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct,
+				    bool destroy)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *nest_proto;
@@ -193,7 +198,7 @@ static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct)
 	if (!nest_proto)
 		goto nla_put_failure;
 
-	ret = l4proto->to_nlattr(skb, nest_proto, ct);
+	ret = l4proto->to_nlattr(skb, nest_proto, ct, destroy);
 
 	nla_nest_end(skb, nest_proto);
 
@@ -537,8 +542,8 @@ static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 		return -1;
 
 	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
-	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
-	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+	    (ctnetlink_dump_timeout(skb, ct, false) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct, false) < 0))
 		return -1;
 
 	return 0;
@@ -780,15 +785,19 @@ ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
 		goto nla_put_failure;
 
 	if (events & (1 << IPCT_DESTROY)) {
+		if (ctnetlink_dump_timeout(skb, ct, true) < 0)
+			goto nla_put_failure;
+
 		if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
-		    ctnetlink_dump_timestamp(skb, ct) < 0)
+		    ctnetlink_dump_timestamp(skb, ct) < 0 ||
+		    ctnetlink_dump_protoinfo(skb, ct, true) < 0)
 			goto nla_put_failure;
 	} else {
-		if (ctnetlink_dump_timeout(skb, ct) < 0)
+		if (ctnetlink_dump_timeout(skb, ct, false) < 0)
 			goto nla_put_failure;
 
-		if (events & (1 << IPCT_PROTOINFO)
-		    && ctnetlink_dump_protoinfo(skb, ct) < 0)
+		if (events & (1 << IPCT_PROTOINFO) &&
+		    ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 			goto nla_put_failure;
 
 		if ((events & (1 << IPCT_HELPER) || nfct_help(ct))
@@ -2720,10 +2729,10 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (ctnetlink_dump_status(skb, ct) < 0)
 		goto nla_put_failure;
 
-	if (ctnetlink_dump_timeout(skb, ct) < 0)
+	if (ctnetlink_dump_timeout(skb, ct, false) < 0)
 		goto nla_put_failure;
 
-	if (ctnetlink_dump_protoinfo(skb, ct) < 0)
+	if (ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_helpinfo(skb, ct) < 0)
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b3f4a334f9d7..db7479db8512 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -589,7 +589,7 @@ static void dccp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			  struct nf_conn *ct)
+			  struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 
@@ -597,15 +597,22 @@ static int dccp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	nest_parms = nla_nest_start(skb, CTA_PROTOINFO_DCCP);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state) ||
-	    nla_put_u8(skb, CTA_PROTOINFO_DCCP_ROLE,
+	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_STATE, ct->proto.dccp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
+	if (nla_put_u8(skb, CTA_PROTOINFO_DCCP_ROLE,
 		       ct->proto.dccp.role[IP_CT_DIR_ORIGINAL]) ||
 	    nla_put_be64(skb, CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
 			 cpu_to_be64(ct->proto.dccp.handshake_seq),
 			 CTA_PROTOINFO_DCCP_PAD))
 		goto nla_put_failure;
+skip_state:
 	nla_nest_end(skb, nest_parms);
 	spin_unlock_bh(&ct->lock);
+
 	return 0;
 
 nla_put_failure:
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 810cca24b399..fb8dc02e502f 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -543,7 +543,7 @@ static bool sctp_can_early_drop(const struct nf_conn *ct)
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			  struct nf_conn *ct)
+			  struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 
@@ -552,15 +552,20 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, CTA_PROTOINFO_SCTP_STATE, ct->proto.sctp.state) ||
-	    nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
+	if (nla_put_u8(skb, CTA_PROTOINFO_SCTP_STATE, ct->proto.sctp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
+	if (nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_ORIGINAL,
 			 ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL]) ||
 	    nla_put_be32(skb, CTA_PROTOINFO_SCTP_VTAG_REPLY,
 			 ct->proto.sctp.vtag[IP_CT_DIR_REPLY]))
 		goto nla_put_failure;
 
+skip_state:
 	spin_unlock_bh(&ct->lock);
-
 	nla_nest_end(skb, nest_parms);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 811c6c9b59e1..1d7e1c595546 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1186,7 +1186,7 @@ static bool tcp_can_early_drop(const struct nf_conn *ct)
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
-			 struct nf_conn *ct)
+			 struct nf_conn *ct, bool destroy)
 {
 	struct nlattr *nest_parms;
 	struct nf_ct_tcp_flags tmp = {};
@@ -1196,8 +1196,13 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (!nest_parms)
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, CTA_PROTOINFO_TCP_STATE, ct->proto.tcp.state) ||
-	    nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
+	if (nla_put_u8(skb, CTA_PROTOINFO_TCP_STATE, ct->proto.tcp.state))
+		goto nla_put_failure;
+
+	if (destroy)
+		goto skip_state;
+
+	if (nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL,
 		       ct->proto.tcp.seen[0].td_scale) ||
 	    nla_put_u8(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY,
 		       ct->proto.tcp.seen[1].td_scale))
@@ -1212,8 +1217,8 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	if (nla_put(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY,
 		    sizeof(struct nf_ct_tcp_flags), &tmp))
 		goto nla_put_failure;
+skip_state:
 	spin_unlock_bh(&ct->lock);
-
 	nla_nest_end(skb, nest_parms);
 
 	return 0;
-- 
2.20.1

