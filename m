Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B31E4A30
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390629AbgE0Qah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387775AbgE0Qah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:30:37 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E476DC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:30:36 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id i17so1806172pli.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UTwbexvgFhJPIZqs/uQ1kLbv9iWggexIcOLQ2cVrdNk=;
        b=QY9RgfrQTk8BZ2NGGsXGfeaV6xUdh+OvKsJKfSJKnYYP7G+1pt9f5QYagJBupqjf8q
         uTiSg42lZP4g+rpXk+4LOUr3AmsAcKMiTUiin2DctuwD9bgmM6vF5G2X4KPT166/2pj2
         3rINFID8Vj50p2PJvTjO7nZhBIS0EnaRCYa1EiCnvr1feJXli684CZjDW2kuBZOvxLVV
         0wLIipX2Bp2Nb/jpMYqEYgQ1kE3hUmdWaVksWFQpEOLimOnwnPG2IY1xfM4++olQtL/o
         WxQmQpF0woICSlWS+e3fvZvZoDCoUPrBp16hw/L80O2LSDjVlPyYiS9ums4NdGfwfJMc
         Gc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UTwbexvgFhJPIZqs/uQ1kLbv9iWggexIcOLQ2cVrdNk=;
        b=czzb7N58Wrkne3amn1xZ8Xqol4jT+9EP+MNVX73+dLxg4G7AwDXL1y2aj9ZuiXaq9b
         l8PsnSh1+ICIJN4PBa9RAb7BHKv/xgd22QMuuZm5vi4knxNTX+A2XboEZObnZ5EHeK2T
         2Im6fWsLw8KR9IXHvmgIZOOUV1L2EQCztYpRd7/B2eIpDRrTwgBdNCtUzC+lDGepU6RN
         V2sdBOGxzJWIze+8+SQbWXUzm3Y3niSNHq/0KZXkBnBu3aLD0cPZyq2FaRtHeRLxoHak
         ZmiqR98wT5LpFVzsLFf5HFVDGCvyJxsw5JjE1/2jDLP0PB0Z1FFs1udjPg5wHNkTBujt
         1h5w==
X-Gm-Message-State: AOAM530COnuC4XPzWLKiPtyS6cdSBIf3MHddFK9sQ9A/Lrz4bJT6FYCr
        AQpEcJ7aqKBguVpkmJMtARS+0KFDPFQ=
X-Google-Smtp-Source: ABdhPJwMUOfChf7jR69/TQ4ROe/PBspxMdUReyZHKwMTAZgP0B0qwp/IAx5zUbjGqKA40dCuTCN3mQ==
X-Received: by 2002:a17:90a:734b:: with SMTP id j11mr5712938pjs.114.1590597036360;
        Wed, 27 May 2020 09:30:36 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id 65sm2514822pfy.219.2020.05.27.09.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:30:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] vxlan: remove fdb when out interface is removed
Date:   Wed, 27 May 2020 16:29:50 +0000
Message-Id: <20200527162950.9343-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan fdb can have NDA_IFINDEX, which indicates an out interface.
If the interface is removed, that fdb will not work.
So, when interface is removed, vxlan's fdb can be removed.

Test commands:
    ip link add dummy0 type dummy
    ip link add vxlan0 type vxlan vni 1000
    bridge fdb add 11:22:33:44:55:66 dst 1.1.1.1 dev vxlan0 via dummy0 self
    ip link del dummy0

Before this patch, fdbs will not be removed.
Result:
    bridge fdb show dev vxlan0
11:22:33:44:55:66 dst 1.1.1.1 via if10 self permanent

'if10' indicates 'dummy0' interface index.
But the dummy0 interface was removed so this fdb will not work.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a0015cdedfaf..52ca735bd91a 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4440,6 +4440,39 @@ struct net_device *vxlan_dev_create(struct net *net, const char *name,
 }
 EXPORT_SYMBOL_GPL(vxlan_dev_create);
 
+static void vxlan_delete_rdst(struct vxlan_dev *vxlan, unsigned int h,
+			      int ifindex)
+{
+	struct hlist_node *tmp;
+	struct vxlan_fdb *f;
+
+	spin_lock_bh(&vxlan->hash_lock[h]);
+	hlist_for_each_entry_safe(f, tmp, &vxlan->fdb_head[h], hlist) {
+		struct vxlan_rdst *rd, *rd_next;
+
+		list_for_each_entry_safe(rd, rd_next, &f->remotes, list) {
+			if (rd->remote_ifindex != ifindex)
+				continue;
+
+			if (list_is_singular(&f->remotes))
+				vxlan_fdb_destroy(vxlan, f, true, true);
+			else
+				vxlan_fdb_dst_destroy(vxlan, f, rd, true);
+		}
+	}
+	spin_unlock_bh(&vxlan->hash_lock[h]);
+}
+
+static void vxlan_delete_rdsts(struct vxlan_net *vn, struct net_device *dev)
+{
+	struct vxlan_dev *vxlan, *next;
+	unsigned int h;
+
+	list_for_each_entry_safe(vxlan, next, &vn->vxlan_list, next)
+		for (h = 0; h < FDB_HASH_SIZE; ++h)
+			vxlan_delete_rdst(vxlan, h, dev->ifindex);
+}
+
 static void vxlan_handle_lowerdev_unregister(struct vxlan_net *vn,
 					     struct net_device *dev)
 {
@@ -4470,6 +4503,7 @@ static int vxlan_netdevice_event(struct notifier_block *unused,
 
 	if (event == NETDEV_UNREGISTER) {
 		vxlan_offload_rx_ports(dev, false);
+		vxlan_delete_rdsts(vn, dev);
 		vxlan_handle_lowerdev_unregister(vn, dev);
 	} else if (event == NETDEV_REGISTER) {
 		vxlan_offload_rx_ports(dev, true);
-- 
2.17.1

