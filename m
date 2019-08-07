Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD21844FC
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfHGGz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13179 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfHGGz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 02:55:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD0ED30C5859;
        Wed,  7 Aug 2019 06:55:27 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33C2A1001281;
        Wed,  7 Aug 2019 06:55:24 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 07/10] vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
Date:   Wed,  7 Aug 2019 02:54:46 -0400
Message-Id: <20190807065449.23373-8-jasowang@redhat.com>
In-Reply-To: <20190807065449.23373-1-jasowang@redhat.com>
References: <20190807065449.23373-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 07 Aug 2019 06:55:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for RCU synchronization in vhost_uninit_vq_maps()
since we've already serialized with readers (memory accessors). This
also avoid the possible userspace DOS through ioctl() because of the
possible high latency caused by synchronize_rcu().

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c12cdadb0855..cfc11f9ed9c9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -333,7 +333,9 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
 	}
 	spin_unlock(&vq->mmu_lock);
 
-	synchronize_rcu();
+	/* No need for synchronize_rcu() or kfree_rcu() since we are
+	 * serialized with memory accessors (e.g vq mutex held).
+	 */
 
 	for (i = 0; i < VHOST_NUM_ADDRS; i++)
 		if (map[i])
-- 
2.18.1

