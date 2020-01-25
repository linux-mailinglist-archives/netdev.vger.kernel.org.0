Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A3414977F
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 20:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgAYTjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 14:39:32 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:45727 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAYTjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 14:39:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 170C66740117;
        Sat, 25 Jan 2020 20:39:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1579981166; x=1581795567; bh=o6B/u85TTAYQbWbOC0O46Un9+pO2wLzCQtf
        /iOnQNK8=; b=q+/XVW9A+O1i7s2E+r8U0T6u4615KP2bAWt62mR5/t0QdL0a4ft
        qk/WWVUbrxFpmfd6NioMka2+oda7FE/nDZd94FLkTZdw8P5KJXGqvI4HmT1BSQ/I
        Z2jkBxOTi7s1e6qQ9MglBfrjrUVWDpC7piqBFFg3onyLG+XsaaW39wUE=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 25 Jan 2020 20:39:26 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id BF3846740114;
        Sat, 25 Jan 2020 20:39:25 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 977962151F; Sat, 25 Jan 2020 20:39:25 +0100 (CET)
Date:   Sat, 25 Jan 2020 20:39:25 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     syzbot <syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com>
cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH 1/1] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
Message-ID: <alpine.DEB.2.20.2001252034050.23279@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
However, in the error path there can be a follow-up recvmsg() without
the mutex held. Use the start() function of struct netlink_dump_control
instead of dump() to verify and report if the specified set does not
exist.

Thanks to Pablo Neira Ayuso for helping me to understand the subleties
of the netlink protocol.

Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 41 ++++++++++++++++---------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index cf895bc80871..69c107f9ba8d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1483,31 +1483,34 @@ ip_set_dump_policy[IPSET_ATTR_CMD_MAX + 1] = {
 };
 
 static int
-dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
+ip_set_dump_start(struct netlink_callback *cb)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
 	int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 	struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 	struct nlattr *attr = (void *)nlh + min_len;
+	struct sk_buff *skb = cb->skb;
+	struct ip_set_net *inst = ip_set_pernet(sock_net(skb->sk));
 	u32 dump_type;
-	ip_set_id_t index;
 	int ret;
 
 	ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, attr,
 			nlh->nlmsg_len - min_len,
 			ip_set_dump_policy, NULL);
 	if (ret)
-		return ret;
+		goto error;
 
 	cb->args[IPSET_CB_PROTO] = nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
+		ip_set_id_t index;
 		struct ip_set *set;
 
 		set = find_set_and_id(inst, nla_data(cda[IPSET_ATTR_SETNAME]),
 				      &index);
-		if (!set)
-			return -ENOENT;
-
+		if (!set) {
+			ret = -ENOENT;
+			goto error;
+		}
 		dump_type = DUMP_ONE;
 		cb->args[IPSET_CB_INDEX] = index;
 	} else {
@@ -1523,10 +1526,17 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	cb->args[IPSET_CB_DUMP] = dump_type;
 
 	return 0;
+
+error:
+	/* We have to create and send the error message manually :-( */
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		netlink_ack(cb->skb, nlh, ret, NULL);
+	}
+	return ret;
 }
 
 static int
-ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
+ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	ip_set_id_t index = IPSET_INVALID_ID, max;
 	struct ip_set *set = NULL;
@@ -1537,18 +1547,8 @@ ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
 	bool is_destroyed;
 	int ret = 0;
 
-	if (!cb->args[IPSET_CB_DUMP]) {
-		ret = dump_init(cb, inst);
-		if (ret < 0) {
-			nlh = nlmsg_hdr(cb->skb);
-			/* We have to create and send the error message
-			 * manually :-(
-			 */
-			if (nlh->nlmsg_flags & NLM_F_ACK)
-				netlink_ack(cb->skb, nlh, ret, NULL);
-			return ret;
-		}
-	}
+	if (!cb->args[IPSET_CB_DUMP])
+		return -EINVAL;
 
 	if (cb->args[IPSET_CB_INDEX] >= inst->ip_set_max)
 		goto out;
@@ -1684,7 +1684,8 @@ static int ip_set_dump(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	{
 		struct netlink_dump_control c = {
-			.dump = ip_set_dump_start,
+			.start = ip_set_dump_start,
+			.dump = ip_set_dump_do,
 			.done = ip_set_dump_done,
 		};
 		return netlink_dump_start(ctnl, skb, nlh, &c);
-- 
2.20.1

