Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C83B1DDF51
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgEVF0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgEVF02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:26:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0240C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:28 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y198so4712566pfb.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0A1SB7apeaP5tWiurMazUWk/Ny6XL0dP6a/ejg1E9HU=;
        b=bl7FHv6CgwxM9aiSNSHgzLhoECMylCE6FyVBKzG3lLde/oMTI5JTQhg7RljLMTo7Fs
         GwfFkcw22rHMGjPCeCktgeDaepA4X2TYnMM4r8buraEpxFbPMzgY1/A7IIgeL81pwVG0
         HU8c5eiZRqYMY7cRVYQAQ/uuN7CNbk6GuNCDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0A1SB7apeaP5tWiurMazUWk/Ny6XL0dP6a/ejg1E9HU=;
        b=CKD8410m4bSYy6gqoj19QguvF+01eBAwspohgkHdQWXgHWm0QOi6OzIaI3zfD/iVN1
         G1BXJ9F+ZOKPXiyNbdcv2xryWaCELcoa00agPLehmZnHS6YluK1W/uWxhs9+QvApPYeS
         fnDEKtS5P8BrTOSUXdIgG/RbN3OB+OwSp+e9HSQ9EksGahfCIVN1bNgVkg0VoyfVagXL
         L/TalZLpnwMWi8+psdP6b0ooQuolHFc14WWA7RkpjNZOgFntG806vsGd7izxIJA6n9Rv
         9FD5CKH1gburcxBSYVvOxxudKjZxCYhWeRixmnR9W+BGlWBJxoyctGaS3s3weNk1znM1
         NMDg==
X-Gm-Message-State: AOAM531QL/qvEoZZEQkD90Ia4bMmtR95I7Jv6Q9ZDiq7HmmkFM1xy4gA
        XC7sfN5G3bcPcZL2ntr5Oant+Q==
X-Google-Smtp-Source: ABdhPJzly1DIaEUQWpurlZutKUFT875wHo2Uti/lnDm3QyCMYf1shdfwSCbIKMQ8njeKvUTzhjFpfQ==
X-Received: by 2002:a63:6604:: with SMTP id a4mr12199171pgc.12.1590125188328;
        Thu, 21 May 2020 22:26:28 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id a16sm5670310pff.41.2020.05.21.22.26.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 22:26:27 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v4 4/5] vxlan: support for nexthop notifiers
Date:   Thu, 21 May 2020 22:26:16 -0700
Message-Id: <1590125177-39176-5-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590125177-39176-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

vxlan driver registers for nexthop add/del notifiers to
cleanup fdb entries pointing to such nexthops.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 754e002..3e88fbe 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -81,6 +81,7 @@ struct vxlan_fdb {
 	u16		  flags;	/* see ndm_flags and below */
 	struct list_head  nh_list;
 	struct nexthop __rcu *nh;
+	struct vxlan_dev  *vdev;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -813,8 +814,9 @@ static int vxlan_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 	return eth_gro_complete(skb, nhoff + sizeof(struct vxlanhdr));
 }
 
-static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
-					 __be32 src_vni, __u16 ndm_flags)
+static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan, const u8 *mac,
+					 __u16 state, __be32 src_vni,
+					 __u16 ndm_flags)
 {
 	struct vxlan_fdb *f;
 
@@ -826,6 +828,7 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
 	f->nh = NULL;
+	f->vdev = vxlan;
 	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
@@ -923,7 +926,7 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return -ENOSPC;
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
-	f = vxlan_fdb_alloc(mac, state, src_vni, ndm_flags);
+	f = vxlan_fdb_alloc(vxlan, mac, state, src_vni, ndm_flags);
 	if (!f)
 		return -ENOMEM;
 
@@ -988,6 +991,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	}
 
 	hlist_del_rcu(&f->hlist);
+	f->vdev = NULL;
 	call_rcu(&f->rcu, vxlan_fdb_free);
 }
 
@@ -4598,6 +4602,25 @@ static struct notifier_block vxlan_switchdev_notifier_block __read_mostly = {
 	.notifier_call = vxlan_switchdev_event,
 };
 
+static int vxlan_nexthop_event(struct notifier_block *nb,
+			       unsigned long event, void *ptr)
+{
+	struct nexthop *nh = ptr;
+	struct vxlan_fdb *fdb, *tmp;
+
+	if (!nh || event != NEXTHOP_EVENT_DEL)
+		return NOTIFY_DONE;
+
+	list_for_each_entry_safe(fdb, tmp, &nh->fdb_list, nh_list)
+		vxlan_fdb_destroy(fdb->vdev, fdb, false, false);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block vxlan_nexthop_notifier_block __read_mostly = {
+	.notifier_call = vxlan_nexthop_event,
+};
+
 static __net_init int vxlan_init_net(struct net *net)
 {
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
@@ -4609,7 +4632,7 @@ static __net_init int vxlan_init_net(struct net *net)
 	for (h = 0; h < PORT_HASH_SIZE; ++h)
 		INIT_HLIST_HEAD(&vn->sock_list[h]);
 
-	return 0;
+	return register_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
 }
 
 static void vxlan_destroy_tunnels(struct net *net, struct list_head *head)
@@ -4642,6 +4665,8 @@ static void __net_exit vxlan_exit_batch_net(struct list_head *net_list)
 
 	rtnl_lock();
 	list_for_each_entry(net, net_list, exit_list)
+		unregister_nexthop_notifier(net, &vxlan_nexthop_notifier_block);
+	list_for_each_entry(net, net_list, exit_list)
 		vxlan_destroy_tunnels(net, &list);
 
 	unregister_netdevice_many(&list);
-- 
2.1.4

