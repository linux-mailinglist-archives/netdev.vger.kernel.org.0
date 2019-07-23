Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0457136E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbfGWH5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388681AbfGWH5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:57:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEAD03092647;
        Tue, 23 Jul 2019 07:57:50 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E44760603;
        Tue, 23 Jul 2019 07:57:40 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] vhost: reset invalidate_count in vhost_set_vring_num_addr()
Date:   Tue, 23 Jul 2019 03:57:16 -0400
Message-Id: <20190723075718.6275-5-jasowang@redhat.com>
In-Reply-To: <20190723075718.6275-1-jasowang@redhat.com>
References: <20190723075718.6275-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 23 Jul 2019 07:57:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vhost_set_vring_num_addr() could be called in the middle of
invalidate_range_start() and invalidate_range_end(). If we don't reset
invalidate_count after the un-registering of MMU notifier, the
invalidate_cont will run out of sync (e.g never reach zero). This will
in fact disable the fast accessor path. Fixing by reset the count to
zero.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 03666b702498..89c9f08b5146 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2074,6 +2074,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 		d->has_notifier = false;
 	}
 
+	/* reset invalidate_count in case we are in the middle of
+	 * invalidate_start() and invalidate_end().
+	 */
+	vq->invalidate_count = 0;
 	vhost_uninit_vq_maps(vq);
 #endif
 
-- 
2.18.1

