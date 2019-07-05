Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE231609FC
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfGEQIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:08:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36533 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfGEQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:08:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so498437pgm.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 09:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5821t224BVm4ju+jmkb14mu7merwb0UqWRTFANBzu6k=;
        b=JQAwlDBMS3wY0c/9vW/QEdgS5fYerKk/avCS34XsYSnSivCLxN0gWT1cHPGLJw00rK
         tP5pUShD0rSoKwq13SROhe7DqyOaBZN50VE7+aoRqmCXNc2vR+DnFwDN+bNlsF87SiBp
         EYfy1QYAttUgRvzspmMQe69qwGSsRHmpt0R4isXSz54KqA/5B74j2O4zK9TnWfvUwfar
         L9ojsnTGQxjE6E40jpCpIzHEOWldSQOPFDpytDq5eDjTn3luVD2wvGkaHP9HHmXv5QtG
         9/+B5CZKz+qr5nP1dBKTkMkIY8/kywZZNvcQoZpJKZC2aUxbgERZoePWhZAZlc653Lcn
         7K0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5821t224BVm4ju+jmkb14mu7merwb0UqWRTFANBzu6k=;
        b=f3yaB3Tk+zzvy3zvwyrCteB7xLZNSMCsMqZeo7S+yHJQu6wx5ECYavSgt5x0sQHTj4
         HbDsLmz+TkTBkl89eVLKDdzTZ/gYZsG0OgIl0UdyGujzQcBtddkGjd+xRamCI/me0I1p
         FwrzOaZ7LMMIMde9HIUc8ovhG8i6+UYUkSWQmNQeP5uECjGMT/fGnVyNBrIl1acaTpTZ
         kRT9P/Umo/9V0iImyBF66NtRB8CHwDM5+btWJmvYTyjuOh6EFFvehyqGE1lkJsu5buYN
         jMS8q2rIrOo/DJ0hgFtDAUGJqp0xePY5JkW8sMq/sAmNUP+g0EVzkW2VXpnRwkjbry8n
         NAvQ==
X-Gm-Message-State: APjAAAXlQ5wewZRmTpECQTu/sY2pqPPxKcBjg4DJlqblVYp592zK0S9f
        sB/yQkPtjJHbvjRhtzaACR0=
X-Google-Smtp-Source: APXvYqy7qfv7QQxqrlxI+i1/ntAlTTC5bJX4zMlLCCCTQTJXTm4L+z6tjGyB1Y52EyH0BYQtUenGsw==
X-Received: by 2002:a63:dc50:: with SMTP id f16mr6377474pgj.447.1562342895366;
        Fri, 05 Jul 2019 09:08:15 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id n140sm9584373pfd.132.2019.07.05.09.08.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 09:08:14 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: openvswitch: do not update max_headroom if new headroom is equal to old headroom
Date:   Sat,  6 Jul 2019 01:08:09 +0900
Message-Id: <20190705160809.5202-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a vport is deleted, the maximum headroom size would be changed.
If the vport which has the largest headroom is deleted,
the new max_headroom would be set.
But, if the new headroom size is equal to the old headroom size,
updating routine is unnecessary.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/openvswitch/datapath.c | 39 +++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 33b388103741..892287d06c17 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1958,10 +1958,9 @@ static struct vport *lookup_vport(struct net *net,
 
 }
 
-/* Called with ovs_mutex */
-static void update_headroom(struct datapath *dp)
+static unsigned int ovs_get_max_headroom(struct datapath *dp)
 {
-	unsigned dev_headroom, max_headroom = 0;
+	unsigned int dev_headroom, max_headroom = 0;
 	struct net_device *dev;
 	struct vport *vport;
 	int i;
@@ -1975,10 +1974,19 @@ static void update_headroom(struct datapath *dp)
 		}
 	}
 
-	dp->max_headroom = max_headroom;
+	return max_headroom;
+}
+
+/* Called with ovs_mutex */
+static void ovs_update_headroom(struct datapath *dp, unsigned int new_headroom)
+{
+	struct vport *vport;
+	int i;
+
+	dp->max_headroom = new_headroom;
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++)
 		hlist_for_each_entry_rcu(vport, &dp->ports[i], dp_hash_node)
-			netdev_set_rx_headroom(vport->dev, max_headroom);
+			netdev_set_rx_headroom(vport->dev, new_headroom);
 }
 
 static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
@@ -1989,6 +1997,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct sk_buff *reply;
 	struct vport *vport;
 	struct datapath *dp;
+	unsigned int new_headroom;
 	u32 port_no;
 	int err;
 
@@ -2050,8 +2059,10 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 				      info->snd_portid, info->snd_seq, 0,
 				      OVS_VPORT_CMD_NEW);
 
-	if (netdev_get_fwd_headroom(vport->dev) > dp->max_headroom)
-		update_headroom(dp);
+	new_headroom = netdev_get_fwd_headroom(vport->dev);
+
+	if (new_headroom > dp->max_headroom)
+		ovs_update_headroom(dp, new_headroom);
 	else
 		netdev_set_rx_headroom(vport->dev, dp->max_headroom);
 
@@ -2122,11 +2133,12 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 {
-	bool must_update_headroom = false;
+	bool update_headroom = false;
 	struct nlattr **a = info->attrs;
 	struct sk_buff *reply;
 	struct datapath *dp;
 	struct vport *vport;
+	unsigned int new_headroom;
 	int err;
 
 	reply = ovs_vport_cmd_alloc_info();
@@ -2152,12 +2164,17 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 	/* the vport deletion may trigger dp headroom update */
 	dp = vport->dp;
 	if (netdev_get_fwd_headroom(vport->dev) == dp->max_headroom)
-		must_update_headroom = true;
+		update_headroom = true;
+
 	netdev_reset_rx_headroom(vport->dev);
 	ovs_dp_detach_port(vport);
 
-	if (must_update_headroom)
-		update_headroom(dp);
+	if (update_headroom) {
+		new_headroom = ovs_get_max_headroom(dp);
+
+		if (new_headroom < dp->max_headroom)
+			ovs_update_headroom(dp, new_headroom);
+	}
 	ovs_unlock();
 
 	ovs_notify(&dp_vport_genl_family, reply, info);
-- 
2.17.1

