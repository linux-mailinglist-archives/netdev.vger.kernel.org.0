Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA106DD48A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjDKHo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDKHoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:44:12 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB8449DD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:43:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id C2A19220003;
        Tue, 11 Apr 2023 09:43:26 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id viRC-bAz_n97; Tue, 11 Apr 2023 09:43:25 +0200 (CEST)
Received: from think.wlp.is (unknown [185.12.128.225])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 65BEC220001;
        Tue, 11 Apr 2023 09:43:25 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Guillaume Nault <gnault@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification behavior
Date:   Tue, 11 Apr 2023 09:43:19 +0200
Message-Id: <20230411074319.24133-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commits referenced below allows userspace to use the NLM_F_ECHO flag
for RTM_NEW/DELLINK operations to receive unicast notifications for the
affected link. Prior to these changes, applications may have relied on
multicast notifications to learn the same information without specifying
the NLM_F_ECHO flag.

For such applications, the mentioned commits changed the behavior for
requests not using NLM_F_ECHO. Multicast notifications are still received,
but now use the portid of the requester and the sequence number of the
request instead of zero values used previously. For the application, this
message may be unexpected and likely handled as a response to the
NLM_F_ACKed request, especially if it uses the same socket to handle
requests and notifications.

To fix existing applications relying on the old notification behavior,
set the portid and sequence number in the notification only if the
request included the NLM_F_ECHO flag. This restores the old behavior
for applications not using it, but allows unicasted notifications for
others.

Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 include/linux/rtnetlink.h |  3 ++-
 net/core/dev.c            |  2 +-
 net/core/rtnetlink.c      | 11 +++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 92ad75549e9c..b6e6378dcbbd 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -25,7 +25,8 @@ void rtmsg_ifinfo_newnet(int type, struct net_device *dev, unsigned int change,
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned change, u32 event,
 				       gfp_t flags, int *new_nsid,
-				       int new_ifindex, u32 portid, u32 seq);
+				       int new_ifindex, u32 portid,
+				       const struct nlmsghdr *nlh);
 void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev,
 		       gfp_t flags, u32 portid, const struct nlmsghdr *nlh);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 48067321c0db..1488f700bf81 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10847,7 +10847,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 			skb = rtmsg_ifinfo_build_skb(RTM_DELLINK, dev, ~0U, 0,
 						     GFP_KERNEL, NULL, 0,
-						     portid, nlmsg_seq(nlh));
+						     portid, nlh);
 
 		/*
 		 *	Flush the unicast and multicast chains
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5d8eb57867a9..6e44e92ebdf5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3972,16 +3972,23 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 				       unsigned int change,
 				       u32 event, gfp_t flags, int *new_nsid,
-				       int new_ifindex, u32 portid, u32 seq)
+				       int new_ifindex, u32 portid,
+				       const struct nlmsghdr *nlh)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
+	u32 seq = 0;
 
 	skb = nlmsg_new(if_nlmsg_size(dev, 0), flags);
 	if (skb == NULL)
 		goto errout;
 
+	if (nlmsg_report(nlh))
+		seq = nlmsg_seq(nlh);
+	else
+		portid = 0;
+
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, portid, seq, change, 0, 0, event,
 			       new_nsid, new_ifindex, -1, flags);
@@ -4017,7 +4024,7 @@ static void rtmsg_ifinfo_event(int type, struct net_device *dev,
 		return;
 
 	skb = rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_nsid,
-				     new_ifindex, portid, nlmsg_seq(nlh));
+				     new_ifindex, portid, nlh);
 	if (skb)
 		rtmsg_ifinfo_send(skb, dev, flags, portid, nlh);
 }
-- 
2.34.1

