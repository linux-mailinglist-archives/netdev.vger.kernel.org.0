Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638DB6BA7D2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCOGcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCOGcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:32:06 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 23:32:04 PDT
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C8E361A88
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 23:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=YPtXI
        JlVHkWT3PhVn9Gb/0wW7kJfmR92BsS5WqyHN+8=; b=AivW6m8WG8YHIryF4ruad
        R7hcW4eLxrKnKw23wQr/VfsqWDN3V+z9ewiLpBwseIU+6JlBm90OMhTsES5Zo4fE
        1fn4Qi0m/9ZRk0hz4lb/h4AtCnP3rR6fcPUnNSouA7jyV+8GmGRmt1yIYJJQDWw7
        PNIPPW28RsJzuZ3Iud+M3w=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wC3vxf3XhFkPuB0AA--.7117S2;
        Wed, 15 Mar 2023 14:00:24 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, windhl@126.com
Subject: [PATCH] ethernet: sun: add check for the mdesc_grab()
Date:   Wed, 15 Mar 2023 14:00:21 +0800
Message-Id: <20230315060021.1741151-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3vxf3XhFkPuB0AA--.7117S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF4kury7Ar4DAFWkXr1rtFb_yoW8Xry8pa
        yDAFy7uwn7t3WUWwnrJa1kAF95G3W7tFW5uFW2ywn5ur92yFyUAr4UKayYkFWjyrW8GFya
        qr1jv3Z3JF4DA37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UY_MfUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbizhMzF18RQpUdkAABss
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vnet_port_probe() and vsw_port_probe(), we should
check the return value of mdesc_grab() as it may
return NULL which can caused NPD bugs.

Fixes: 5d01fa0c6bd8 ("ldmvsw: Add ldmvsw.c driver code")
Fixes: 43fdf27470b2 ("[SPARC64]: Abstract out mdesc accesses for better MD update handling.")
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/ethernet/sun/ldmvsw.c  | 3 +++
 drivers/net/ethernet/sun/sunvnet.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 8addee6d04bd..734a817d3c94 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -287,6 +287,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index fe86fbd58586..e220620d0ffc 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -433,6 +433,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
-- 
2.25.1

