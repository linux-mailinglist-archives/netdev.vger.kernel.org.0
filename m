Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699193A659
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 16:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfFIO0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 10:26:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45727 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfFIO0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 10:26:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id w34so3625148pga.12
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 07:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zMc+lSqBJ11vvf1CfQWDh5kyUt+vjPHiNuH6HWG+vHo=;
        b=NyWk3u8JhTiHCEvHaipIH393r5hkd9YGygUWAMxrtG0979iQf+t+yUM5NRcntI5je1
         KqSiexoVAdsHZJ5VOnvGrgOHl7eE7vqaxnCOMBVmU3c6hltl6AIle/iMt9dV1B1gbfFF
         ATQvdlO6mYfju7ZVWAB4r4fS7oNiQCVTaTDDbz9yoqVHRmXwovdRhB83Yud1hvXKKFpU
         xTGAwD9cyZBz1+SR2WaD3UrT/MdUYa+HYGL74BszdVswzA5Ua1fTPBCzhgx1QX6escIm
         oNa+ASqlB8xhU9X+gUC3nOKbleZIqGaCxE6eXUZIzX7qHf0ryeQWWKmcE50YMSxLglxU
         Zt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zMc+lSqBJ11vvf1CfQWDh5kyUt+vjPHiNuH6HWG+vHo=;
        b=O8/Jmt2FjsBV+cSNJD89Gh7wC6TKBDSOKBhf0tYETmyKNQf0MsE6nQSuJbey1N8CnO
         cdL+xIRUksa3nNMZDR/tHPw73dtn/3j2RTzlJhAhnR76oqwoboEggZ0OFpMo8CT4PMAm
         1Bk1FJsk+osiO0S8KQRYDTJbxyStZuxvcymWjMhbDuQzUgCVb41HCINwLoOUpW7kf7eL
         RBOEfADNMBzBzDJH+YOm9BWBizbaa7UMWk9yynE6E0ZHqXzVLCYxDF/rt0hkWGh7n8QJ
         eIjNf9grM3E8OY9UI/09tjnVG00FNfj5irZFgSdbWmHgRat/OTD3iw9+kFgIHCcZIYwi
         OdIA==
X-Gm-Message-State: APjAAAWu5DXXGmyL7OL/0u9hFCmn5aPpyG5Z7eINTd6C31q8KGBzBqSe
        fypI70QZEhzlIEDPTR076f0=
X-Google-Smtp-Source: APXvYqzfIPYR7QG/n7V+rBUAeeVBW/jhNM+mLy+ZasYxrxFcQe4S7kB7SzGB995J3lwbU5i64UXIxg==
X-Received: by 2002:a17:90a:3310:: with SMTP id m16mr3751151pjb.7.1560090391136;
        Sun, 09 Jun 2019 07:26:31 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id a11sm7659599pff.128.2019.06.09.07.26.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 07:26:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: openvswitch: do not free vport if register_netdevice() is failed.
Date:   Sun,  9 Jun 2019 23:26:21 +0900
Message-Id: <20190609142621.30674-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to create an internal vport, internal_dev_create() is used and
that calls register_netdevice() internally.
If register_netdevice() fails, it calls dev->priv_destructor() to free
private data of netdev. actually, a private data of this is a vport.

Hence internal_dev_create() should not free and use a vport after failure
of register_netdevice().

Test command
    ovs-dpctl add-dp bonding_masters

Splat looks like:
[ 1035.667767] kasan: GPF could be caused by NULL-ptr deref or user memory access
[ 1035.675958] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[ 1035.676916] CPU: 1 PID: 1028 Comm: ovs-vswitchd Tainted: G    B             5.2.0-rc3+ #240
[ 1035.676916] RIP: 0010:internal_dev_create+0x2e5/0x4e0 [openvswitch]
[ 1035.676916] Code: 48 c1 ea 03 80 3c 02 00 0f 85 9f 01 00 00 4c 8b 23 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 60 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 86 01 00 00 49 8b bc 24 60 05 00 00 e8 e4 68 f4
[ 1035.713720] RSP: 0018:ffff88810dcb7578 EFLAGS: 00010206
[ 1035.713720] RAX: dffffc0000000000 RBX: ffff88810d13fe08 RCX: ffffffff84297704
[ 1035.713720] RDX: 00000000000000ac RSI: 0000000000000000 RDI: 0000000000000560
[ 1035.713720] RBP: 00000000ffffffef R08: fffffbfff0d3b881 R09: fffffbfff0d3b881
[ 1035.713720] R10: 0000000000000001 R11: fffffbfff0d3b880 R12: 0000000000000000
[ 1035.768776] R13: 0000607ee460b900 R14: ffff88810dcb7690 R15: ffff88810dcb7698
[ 1035.777709] FS:  00007f02095fc980(0000) GS:ffff88811b400000(0000) knlGS:0000000000000000
[ 1035.777709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1035.777709] CR2: 00007ffdf01d2f28 CR3: 0000000108258000 CR4: 00000000001006e0
[ 1035.777709] Call Trace:
[ 1035.777709]  ovs_vport_add+0x267/0x4f0 [openvswitch]
[ 1035.777709]  new_vport+0x15/0x1e0 [openvswitch]
[ 1035.777709]  ovs_vport_cmd_new+0x567/0xd10 [openvswitch]
[ 1035.777709]  ? ovs_dp_cmd_dump+0x490/0x490 [openvswitch]
[ 1035.777709]  ? __kmalloc+0x131/0x2e0
[ 1035.777709]  ? genl_family_rcv_msg+0xa54/0x1030
[ 1035.777709]  genl_family_rcv_msg+0x63a/0x1030
[ 1035.777709]  ? genl_unregister_family+0x630/0x630
[ 1035.841681]  ? debug_show_all_locks+0x2d0/0x2d0
[ ... ]

Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/openvswitch/vport-internal_dev.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 26f71cbf7527..5993405c25c1 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -170,7 +170,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 {
 	struct vport *vport;
 	struct internal_dev *internal_dev;
+	struct net_device *dev;
 	int err;
+	bool free_vport = true;
 
 	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
 	if (IS_ERR(vport)) {
@@ -178,8 +180,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 		goto error;
 	}
 
-	vport->dev = alloc_netdev(sizeof(struct internal_dev),
-				  parms->name, NET_NAME_USER, do_setup);
+	dev = alloc_netdev(sizeof(struct internal_dev),
+			   parms->name, NET_NAME_USER, do_setup);
+	vport->dev = dev;
 	if (!vport->dev) {
 		err = -ENOMEM;
 		goto error_free_vport;
@@ -200,8 +203,10 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
-	if (err)
+	if (err) {
+		free_vport = false;
 		goto error_unlock;
+	}
 
 	dev_set_promiscuity(vport->dev, 1);
 	rtnl_unlock();
@@ -211,11 +216,12 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 error_unlock:
 	rtnl_unlock();
-	free_percpu(vport->dev->tstats);
+	free_percpu(dev->tstats);
 error_free_netdev:
-	free_netdev(vport->dev);
+	free_netdev(dev);
 error_free_vport:
-	ovs_vport_free(vport);
+	if (free_vport)
+		ovs_vport_free(vport);
 error:
 	return ERR_PTR(err);
 }
-- 
2.17.1

