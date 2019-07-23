Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F8771360
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388630AbfGWH5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388605AbfGWH5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:57:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1ACB308FBAC;
        Tue, 23 Jul 2019 07:57:30 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 925FC60606;
        Tue, 23 Jul 2019 07:57:25 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] vhost: don't set uaddr for invalid address
Date:   Tue, 23 Jul 2019 03:57:13 -0400
Message-Id: <20190723075718.6275-2-jasowang@redhat.com>
In-Reply-To: <20190723075718.6275-1-jasowang@redhat.com>
References: <20190723075718.6275-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 23 Jul 2019 07:57:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should not setup uaddr for the invalid address, otherwise we may
try to pin or prefetch mapping of wrong pages.

Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dc9301d31f12..34c0d970bcbc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2083,7 +2083,8 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 	}
 
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	vhost_setup_vq_uaddr(vq);
+	if (r == 0)
+		vhost_setup_vq_uaddr(vq);
 
 	if (d->mm)
 		mmu_notifier_register(&d->mmu_notifier, d->mm);
-- 
2.18.1

