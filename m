Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BECE5D04
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfJZNRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:17:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbfJZNRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59AD21E6F;
        Sat, 26 Oct 2019 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095851;
        bh=xsJdWmDimaKeMJFNZnPlF0z0rT2wgQoTu+Oy1fqFb2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14nigGu+k1scsjRTls/Xbgt6p0pvgE5TG+rpYaOX4QgnI0JEmIUwjphxfoJGnStdA
         Z6lgqZZILojNCHvM2NOr1KbGdma38kt2z7i6vrqhJHahuevwUXR6k6XAT1prb+OCxv
         z47NUgiQ4358Cv5kVgkU8JQZ7pqdzt3r+izpWGfE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 48/99] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Date:   Sat, 26 Oct 2019 09:15:09 -0400
Message-Id: <20191026131600.2507-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 993e4c929a073595d22c85f59082f0c387e31c21 ]

The flag NLM_F_ECHO aims to reply to the user the message notified to all
listeners.
It was not the case with the command RTM_NEWNSID, let's fix this.

Fixes: 0c7aecd4bde4 ("netns: add rtnl cmd to add and get peer netns ids")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net_namespace.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c9918..6d3e4821b02d8 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -245,7 +245,8 @@ static int __peernet2id(struct net *net, struct net *peer)
 	return __peernet2id_alloc(net, peer, &no);
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id);
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
+			      struct nlmsghdr *nlh);
 /* This function returns the id of a peer netns. If no id is assigned, one will
  * be allocated and returned.
  */
@@ -268,7 +269,7 @@ int peernet2id_alloc(struct net *net, struct net *peer)
 	id = __peernet2id_alloc(net, peer, &alloc);
 	spin_unlock_bh(&net->nsid_lock);
 	if (alloc && id >= 0)
-		rtnl_net_notifyid(net, RTM_NEWNSID, id);
+		rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL);
 	if (alive)
 		put_net(peer);
 	return id;
@@ -532,7 +533,7 @@ static void unhash_nsid(struct net *net, struct net *last)
 			idr_remove(&tmp->netns_ids, id);
 		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
-			rtnl_net_notifyid(tmp, RTM_DELNSID, id);
+			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL);
 		if (tmp == last)
 			break;
 	}
@@ -764,7 +765,8 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = alloc_netid(net, peer, nsid);
 	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
-		rtnl_net_notifyid(net, RTM_NEWNSID, err);
+		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
+				  nlh);
 		err = 0;
 	} else if (err == -ENOSPC && nsid >= 0) {
 		err = -EEXIST;
@@ -1051,9 +1053,12 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 	return err < 0 ? err : skb->len;
 }
 
-static void rtnl_net_notifyid(struct net *net, int cmd, int id)
+static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
+			      struct nlmsghdr *nlh)
 {
 	struct net_fill_args fillargs = {
+		.portid = portid,
+		.seq = nlh ? nlh->nlmsg_seq : 0,
 		.cmd = cmd,
 		.nsid = id,
 	};
@@ -1068,7 +1073,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id)
 	if (err < 0)
 		goto err_out;
 
-	rtnl_notify(msg, net, 0, RTNLGRP_NSID, NULL, 0);
+	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlh, 0);
 	return;
 
 err_out:
-- 
2.20.1

