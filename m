Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5893183EF2
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 03:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCMCF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 22:05:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45336 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgCMCF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 22:05:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so4028744pgv.12
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 19:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=olOQEz57ZCzh/4Ac5WIJGRCjx7A0NQAXIpw0Gv1qrdQ=;
        b=nJc4XyYm/XgUgPL+K4vCKd8cSTKdMfqHcINXcWcpWwkW3y0IVKx18c4Dg2w8qcv+di
         RgXYk71nkWCwVsxYw1WY8GKxawJU+VfvvTtyzj2qaIEcYdChHZa70sIsJzRb1YdrJikx
         Uq2PwKHFNxsoZ35cOREVhQRMFSYcI6oiZxCIzZqxWEBQRCVEl2faDYDjR72KyJJb4dQS
         RLEL8WcDn8LM9VZS4T5Mcbq3tV+W7UGJ+SoN2j+jbmYEkCXQ3ken61PEUObwQ6GtAm/p
         maYdKT2O8xHB49gtyPN6427SPiaVko/CRIuA1Rq+5DXlJzB3JoBujL+/X8iNxlpxGXVh
         vJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=olOQEz57ZCzh/4Ac5WIJGRCjx7A0NQAXIpw0Gv1qrdQ=;
        b=DljAMqq+L1TCnR56Op5hdE7i5ZRxcmjLpeqQuuGy829mSnqkTBtjmzr8kamsQERQDy
         Z0WtMU1YQQhx3cHKXX0A/7GHdzKpyGX8X0VBu5mC1LSp49v8sAoDK+USk1BlFpDBIOgi
         o+TmQZl5zMWaCESjNqYa5zALFkypGALFobhKUlZYC7O/KOXlLhK6875f+0gjqesFEDxf
         1KNGInq5S0frrLb2URTuUNImF4lJWo6DuqshRpeAxgACqZiaR6ZMccb92NvgW9sXCD6/
         jrnjGC9hmtkA9S9j30nHcJbq6vo3Bdqie5DxZ17ZWIQnC4J/llqI9/LEDBUWZwOMuzbY
         g+gA==
X-Gm-Message-State: ANhLgQ1uVUqCZ555baR252nDNqOh9KRhjFJTnb1ACotVP2gGpyR1x4uZ
        1SbGrAgvc26ojOAM2k+R0ks=
X-Google-Smtp-Source: ADFU+vukxF8wANHtMqPTO8lHkyl5IdYhBbByKHPLXS4eUb0UrHsYk0WsrBCBPYr4breDXm58DVWpnw==
X-Received: by 2002:a63:48e:: with SMTP id 136mr10464885pge.169.1584065157536;
        Thu, 12 Mar 2020 19:05:57 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id z20sm25967229pge.62.2020.03.12.19.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:05:56 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/3] hsr: add restart routine into hsr_get_node_list()
Date:   Fri, 13 Mar 2020 02:05:50 +0000
Message-Id: <20200313020550.31514-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr_get_node_list() is to send node addresses to the userspace.
If there are so many nodes, it could fail because of buffer size.
In order to avoid this failure, the restart routine is added.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_netlink.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index d6760df2ad1f..6a6e092153ef 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -368,9 +368,10 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	struct sk_buff *skb_out;
 	void *msg_head;
 	struct hsr_priv *hsr;
-	void *pos;
+	void *pos = NULL;
 	unsigned char addr[ETH_ALEN];
 	int res;
+	bool restart = false;
 
 	if (!info)
 		goto invalid;
@@ -387,8 +388,9 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	if (!is_hsr_master(hsr_dev))
 		goto rcu_unlock;
 
+restart:
 	/* Send reply */
-	skb_out = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	skb_out = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb_out) {
 		res = -ENOMEM;
 		goto fail;
@@ -402,17 +404,28 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 		goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
-	if (res < 0)
-		goto nla_put_failure;
+	if (!restart) {
+		res = nla_put_u32(skb_out, HSR_A_IFINDEX, hsr_dev->ifindex);
+		if (res < 0)
+			goto nla_put_failure;
+	}
 
 	hsr = netdev_priv(hsr_dev);
 
-	pos = hsr_get_next_node(hsr, NULL, addr);
+	if (!pos)
+		pos = hsr_get_next_node(hsr, NULL, addr);
 	while (pos) {
 		res = nla_put(skb_out, HSR_A_NODE_ADDR, ETH_ALEN, addr);
-		if (res < 0)
+		if (res < 0) {
+			if (res == -EMSGSIZE) {
+				genlmsg_end(skb_out, msg_head);
+				genlmsg_unicast(genl_info_net(info), skb_out,
+						info->snd_portid);
+				restart = true;
+				goto restart;
+			}
 			goto nla_put_failure;
+		}
 		pos = hsr_get_next_node(hsr, pos, addr);
 	}
 	rcu_read_unlock();
@@ -429,7 +442,7 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 	return 0;
 
 nla_put_failure:
-	kfree_skb(skb_out);
+	nlmsg_free(skb_out);
 	/* Fall through */
 
 fail:
-- 
2.17.1

