Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3560C1E1778
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgEYVye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:54:34 -0400
Received: from correo.us.es ([193.147.175.20]:47364 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgEYVyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 17:54:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1352FA4DB
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E980DA712
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7E078DA705; Mon, 25 May 2020 23:54:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E99CDA705;
        Mon, 25 May 2020 23:54:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E538B42EE38E;
        Mon, 25 May 2020 23:54:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/5] netfilter: nf_conntrack_pptp: prevent buffer overflows in debug code
Date:   Mon, 25 May 2020 23:54:18 +0200
Message-Id: <20200525215420.2290-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter says: "Smatch complains that the value for "cmd" comes
from the network and can't be trusted."

Add pptp_msg_name() helper function that checks for the array boundary.

Fixes: f09943fefe6b ("[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_pptp.h |  2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            |  7 +--
 net/netfilter/nf_conntrack_pptp.c           | 62 ++++++++++++---------
 3 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index fcc409de31a4..6a4ff6d5ebc2 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -10,7 +10,7 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
-extern const char *const pptp_msg_name[];
+extern const char *const pptp_msg_name(u_int16_t msg);
 
 /* state of the control session */
 enum pptp_ctrlsess_state {
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 3c25a467b3ef..7afde8828b4c 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -166,8 +166,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 		break;
 	default:
 		pr_debug("unknown outbound packet 0x%04x:%s\n", msg,
-			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
-					       pptp_msg_name[0]);
+			 pptp_msg_name(msg));
 		fallthrough;
 	case PPTP_SET_LINK_INFO:
 		/* only need to NAT in case PAC is behind NAT box */
@@ -268,9 +267,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		pcid_off = offsetof(union pptp_ctrl_union, setlink.peersCallID);
 		break;
 	default:
-		pr_debug("unknown inbound packet %s\n",
-			 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] :
-					       pptp_msg_name[0]);
+		pr_debug("unknown inbound packet %s\n", pptp_msg_name(msg));
 		fallthrough;
 	case PPTP_START_SESSION_REQUEST:
 	case PPTP_START_SESSION_REPLY:
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index a971183f11af..7ad247784cfa 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -72,24 +72,32 @@ EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
 #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
 /* PptpControlMessageType names */
-const char *const pptp_msg_name[] = {
-	"UNKNOWN_MESSAGE",
-	"START_SESSION_REQUEST",
-	"START_SESSION_REPLY",
-	"STOP_SESSION_REQUEST",
-	"STOP_SESSION_REPLY",
-	"ECHO_REQUEST",
-	"ECHO_REPLY",
-	"OUT_CALL_REQUEST",
-	"OUT_CALL_REPLY",
-	"IN_CALL_REQUEST",
-	"IN_CALL_REPLY",
-	"IN_CALL_CONNECT",
-	"CALL_CLEAR_REQUEST",
-	"CALL_DISCONNECT_NOTIFY",
-	"WAN_ERROR_NOTIFY",
-	"SET_LINK_INFO"
+static const char *const pptp_msg_name_array[PPTP_MSG_MAX + 1] = {
+	[0]				= "UNKNOWN_MESSAGE",
+	[PPTP_START_SESSION_REQUEST]	= "START_SESSION_REQUEST",
+	[PPTP_START_SESSION_REPLY]	= "START_SESSION_REPLY",
+	[PPTP_STOP_SESSION_REQUEST]	= "STOP_SESSION_REQUEST",
+	[PPTP_STOP_SESSION_REPLY]	= "STOP_SESSION_REPLY",
+	[PPTP_ECHO_REQUEST]		= "ECHO_REQUEST",
+	[PPTP_ECHO_REPLY]		= "ECHO_REPLY",
+	[PPTP_OUT_CALL_REQUEST]		= "OUT_CALL_REQUEST",
+	[PPTP_OUT_CALL_REPLY]		= "OUT_CALL_REPLY",
+	[PPTP_IN_CALL_REQUEST]		= "IN_CALL_REQUEST",
+	[PPTP_IN_CALL_REPLY]		= "IN_CALL_REPLY",
+	[PPTP_IN_CALL_CONNECT]		= "IN_CALL_CONNECT",
+	[PPTP_CALL_CLEAR_REQUEST]	= "CALL_CLEAR_REQUEST",
+	[PPTP_CALL_DISCONNECT_NOTIFY]	= "CALL_DISCONNECT_NOTIFY",
+	[PPTP_WAN_ERROR_NOTIFY]		= "WAN_ERROR_NOTIFY",
+	[PPTP_SET_LINK_INFO]		= "SET_LINK_INFO"
 };
+
+const char *const pptp_msg_name(u_int16_t msg)
+{
+	if (msg > PPTP_MSG_MAX)
+		return pptp_msg_name_array[0];
+
+	return pptp_msg_name_array[msg];
+}
 EXPORT_SYMBOL(pptp_msg_name);
 #endif
 
@@ -276,7 +284,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("inbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("inbound control message %s\n", pptp_msg_name(msg));
 
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
@@ -311,7 +319,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		pcid = pptpReq->ocack.peersCallID;
 		if (info->pns_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name[msg],
+		pr_debug("%s, CID=%X, PCID=%X\n", pptp_msg_name(msg),
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->ocack.resultCode == PPTP_OUTCALL_CONNECT) {
@@ -328,7 +336,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 			goto invalid;
 
 		cid = pptpReq->icreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->cstate = PPTP_CALL_IN_REQ;
 		info->pac_call_id = cid;
 		break;
@@ -347,7 +355,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		if (info->pns_call_id != pcid)
 			goto invalid;
 
-		pr_debug("%s, PCID=%X\n", pptp_msg_name[msg], ntohs(pcid));
+		pr_debug("%s, PCID=%X\n", pptp_msg_name(msg), ntohs(pcid));
 		info->cstate = PPTP_CALL_IN_CONF;
 
 		/* we expect a GRE connection from PAC to PNS */
@@ -357,7 +365,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	case PPTP_CALL_DISCONNECT_NOTIFY:
 		/* server confirms disconnect */
 		cid = pptpReq->disc.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->cstate = PPTP_CALL_NONE;
 
 		/* untrack this call id, unexpect GRE packets */
@@ -384,7 +392,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 invalid:
 	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 pptp_msg_name(msg),
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
 		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
@@ -404,7 +412,7 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("outbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("outbound control message %s\n", pptp_msg_name(msg));
 
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
@@ -426,7 +434,7 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		info->cstate = PPTP_CALL_OUT_REQ;
 		/* track PNS call id */
 		cid = pptpReq->ocreq.callID;
-		pr_debug("%s, CID=%X\n", pptp_msg_name[msg], ntohs(cid));
+		pr_debug("%s, CID=%X\n", pptp_msg_name(msg), ntohs(cid));
 		info->pns_call_id = cid;
 		break;
 
@@ -440,7 +448,7 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		pcid = pptpReq->icack.peersCallID;
 		if (info->pac_call_id != pcid)
 			goto invalid;
-		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name[msg],
+		pr_debug("%s, CID=%X PCID=%X\n", pptp_msg_name(msg),
 			 ntohs(cid), ntohs(pcid));
 
 		if (pptpReq->icack.resultCode == PPTP_INCALL_ACCEPT) {
@@ -480,7 +488,7 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 invalid:
 	pr_debug("invalid %s: type=%d cid=%u pcid=%u "
 		 "cstate=%d sstate=%d pns_cid=%u pac_cid=%u\n",
-		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0],
+		 pptp_msg_name(msg),
 		 msg, ntohs(cid), ntohs(pcid),  info->cstate, info->sstate,
 		 ntohs(info->pns_call_id), ntohs(info->pac_call_id));
 	return NF_ACCEPT;
-- 
2.20.1

