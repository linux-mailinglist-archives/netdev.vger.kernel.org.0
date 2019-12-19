Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207BB125A65
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 06:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbfLSFE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 00:04:56 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33274 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725843AbfLSFE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 00:04:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 531A34BF49;
        Thu, 19 Dec 2019 16:04:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1576731890; bh=cChcS
        DIIPngbKOLvmEtUmmg2oFeXRl23pxhs+8WZ9tE=; b=lGCerUc+TBNnI2rGBCLaS
        MADaHTJgr5QEq8U2ntSrpCrM8Sh6tpquDfNDr47BeXaMs91FVPIwti9WJKC98mFk
        +RZG1hXRnClTgny/OGpBfri+rU6qdUmPQw+PmN0jBMjOlDnJNExWLZRrzY3k8h80
        6gLISFxw262hWd0lbw0Xfo=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id doP51jQm92V4; Thu, 19 Dec 2019 16:04:50 +1100 (AEDT)
Received: from cba01.dek-tpc.internal (cba01.dek-tpc.internal [172.16.83.49])
        by mail.dektech.com.au (Postfix) with ESMTP id EBC544BE57;
        Thu, 19 Dec 2019 16:04:49 +1100 (AEDT)
Received: by cba01.dek-tpc.internal (Postfix, from userid 1014)
        id 83269181D65; Thu, 19 Dec 2019 16:04:49 +1100 (AEDT)
From:   john.rutherford@dektech.com.au
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     John Rutherford <john.rutherford@dektech.com.au>
Subject: [net-next] tipc: make legacy address flag readable over netlink
Date:   Thu, 19 Dec 2019 16:03:57 +1100
Message-Id: <20191219050357.22583-1-john.rutherford@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Rutherford <john.rutherford@dektech.com.au>

To enable iproute2/tipc to generate backwards compatible
printouts and validate command parameters for nodes using a
<z.c.n> node address, it needs to be able to read the legacy
address flag from the kernel.  The legacy address flag records
the way in which the node identity was originally specified.

The legacy address flag is requested by the netlink message
TIPC_NL_ADDR_LEGACY_GET.  If the flag is set the attribute
TIPC_NLA_NET_ADDR_LEGACY is set in the return message.

Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 include/uapi/linux/tipc_netlink.h |  2 ++
 net/tipc/net.c                    | 56 +++++++++++++++++++++++++++++++++++++++
 net/tipc/net.h                    |  1 +
 net/tipc/netlink.c                |  6 +++++
 4 files changed, 65 insertions(+)

diff --git a/include/uapi/linux/tipc_netlink.h b/include/uapi/linux/tipc_netlink.h
index 6c2194ab745b..dc0d23a50e69 100644
--- a/include/uapi/linux/tipc_netlink.h
+++ b/include/uapi/linux/tipc_netlink.h
@@ -65,6 +65,7 @@ enum {
 	TIPC_NL_UDP_GET_REMOTEIP,
 	TIPC_NL_KEY_SET,
 	TIPC_NL_KEY_FLUSH,
+	TIPC_NL_ADDR_LEGACY_GET,
 
 	__TIPC_NL_CMD_MAX,
 	TIPC_NL_CMD_MAX = __TIPC_NL_CMD_MAX - 1
@@ -176,6 +177,7 @@ enum {
 	TIPC_NLA_NET_ADDR,		/* u32 */
 	TIPC_NLA_NET_NODEID,		/* u64 */
 	TIPC_NLA_NET_NODEID_W1,		/* u64 */
+	TIPC_NLA_NET_ADDR_LEGACY,	/* flag */
 
 	__TIPC_NLA_NET_MAX,
 	TIPC_NLA_NET_MAX = __TIPC_NLA_NET_MAX - 1
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 2de3cec9929d..85400e4242de 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -302,3 +302,59 @@ int tipc_nl_net_set(struct sk_buff *skb, struct genl_info *info)
 
 	return err;
 }
+
+static int __tipc_nl_addr_legacy_get(struct net *net, struct tipc_nl_msg *msg)
+{
+	struct tipc_net *tn = tipc_net(net);
+	struct nlattr *attrs;
+	void *hdr;
+
+	hdr = genlmsg_put(msg->skb, msg->portid, msg->seq, &tipc_genl_family,
+			  0, TIPC_NL_ADDR_LEGACY_GET);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	attrs = nla_nest_start(msg->skb, TIPC_NLA_NET);
+	if (!attrs)
+		goto msg_full;
+
+	if (tn->legacy_addr_format)
+		if (nla_put_flag(msg->skb, TIPC_NLA_NET_ADDR_LEGACY))
+			goto attr_msg_full;
+
+	nla_nest_end(msg->skb, attrs);
+	genlmsg_end(msg->skb, hdr);
+
+	return 0;
+
+attr_msg_full:
+	nla_nest_cancel(msg->skb, attrs);
+msg_full:
+	genlmsg_cancel(msg->skb, hdr);
+
+	return -EMSGSIZE;
+}
+
+int tipc_nl_net_addr_legacy_get(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = sock_net(skb->sk);
+	struct tipc_nl_msg msg;
+	struct sk_buff *rep;
+	int err;
+
+	rep = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!rep)
+		return -ENOMEM;
+
+	msg.skb = rep;
+	msg.portid = info->snd_portid;
+	msg.seq = info->snd_seq;
+
+	err = __tipc_nl_addr_legacy_get(net, &msg);
+	if (err) {
+		nlmsg_free(msg.skb);
+		return err;
+	}
+
+	return genlmsg_reply(msg.skb, info);
+}
diff --git a/net/tipc/net.h b/net/tipc/net.h
index b7f2e364eb99..6740d97c706e 100644
--- a/net/tipc/net.h
+++ b/net/tipc/net.h
@@ -47,5 +47,6 @@ void tipc_net_stop(struct net *net);
 int tipc_nl_net_dump(struct sk_buff *skb, struct netlink_callback *cb);
 int tipc_nl_net_set(struct sk_buff *skb, struct genl_info *info);
 int __tipc_nl_net_set(struct sk_buff *skb, struct genl_info *info);
+int tipc_nl_net_addr_legacy_get(struct sk_buff *skb, struct genl_info *info);
 
 #endif
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index e53231bd23b4..7c35094c20b8 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -83,6 +83,7 @@ const struct nla_policy tipc_nl_net_policy[TIPC_NLA_NET_MAX + 1] = {
 	[TIPC_NLA_NET_ADDR]		= { .type = NLA_U32 },
 	[TIPC_NLA_NET_NODEID]		= { .type = NLA_U64 },
 	[TIPC_NLA_NET_NODEID_W1]	= { .type = NLA_U64 },
+	[TIPC_NLA_NET_ADDR_LEGACY]	= { .type = NLA_FLAG }
 };
 
 const struct nla_policy tipc_nl_link_policy[TIPC_NLA_LINK_MAX + 1] = {
@@ -273,6 +274,11 @@ static const struct genl_ops tipc_genl_v2_ops[] = {
 		.doit	= tipc_nl_node_flush_key,
 	},
 #endif
+	{
+		.cmd	= TIPC_NL_ADDR_LEGACY_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= tipc_nl_net_addr_legacy_get,
+	},
 };
 
 struct genl_family tipc_genl_family __ro_after_init = {
-- 
2.1.4

