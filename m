Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B0A650815
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 08:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiLSHed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 02:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiLSHe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 02:34:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9ACA440
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 23:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671435222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VzssRu5rC+27vv5HkiX3uUCEC9dLPIbrWZcvoE6Jfts=;
        b=D8iKcfUOF/86FYh+KVfYni0SKBwopEaFKzOFoeAywzDA23hUrpsIYK/+JISKwazCAfQX4M
        XwGe3um0joWOOA9jTTDgtxZJIKuOULLx/KrLsEbvVUYXyisj2Kb1Tf9ZzMxrz3bAlJ9DVS
        QqmWg6mY8n/VaH9fJ1Mbpdm5IWZmD3Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-6vnfGTMqN2WktPChZXRpuw-1; Mon, 19 Dec 2022 02:33:38 -0500
X-MC-Unique: 6vnfGTMqN2WktPChZXRpuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B59B185A78B;
        Mon, 19 Dec 2022 07:33:38 +0000 (UTC)
Received: from server.redhat.com (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E55B40C2064;
        Mon, 19 Dec 2022 07:33:34 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v4] vhost_vdpa: fix the crash in unmap a large memory
Date:   Mon, 19 Dec 2022 15:33:31 +0800
Message-Id: <20221219073331.556140-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing in vIOMMU, sometimes Guest will unmap very large memory,
which will cause the crash. To fix this, add a new function
vhost_vdpa_general_unmap(). This function will only unmap the memory
that saved in iotlb.

Call Trace:
[  647.820144] ------------[ cut here ]------------
[  647.820848] kernel BUG at drivers/iommu/intel/iommu.c:1174!
[  647.821486] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  647.822082] CPU: 10 PID: 1181 Comm: qemu-system-x86 Not tainted 6.0.0-rc1home_lulu_2452_lulu7_vhost+ #62
[  647.823139] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-29-g6a62e0cb0dfe-prebuilt.qem4
[  647.824365] RIP: 0010:domain_unmap+0x48/0x110
[  647.825424] Code: 48 89 fb 8d 4c f6 1e 39 c1 0f 4f c8 83 e9 0c 83 f9 3f 7f 18 48 89 e8 48 d3 e8 48 85 c0 75 59
[  647.828064] RSP: 0018:ffffae5340c0bbf0 EFLAGS: 00010202
[  647.828973] RAX: 0000000000000001 RBX: ffff921793d10540 RCX: 000000000000001b
[  647.830083] RDX: 00000000080000ff RSI: 0000000000000001 RDI: ffff921793d10540
[  647.831214] RBP: 0000000007fc0100 R08: ffffae5340c0bcd0 R09: 0000000000000003
[  647.832388] R10: 0000007fc0100000 R11: 0000000000100000 R12: 00000000080000ff
[  647.833668] R13: ffffae5340c0bcd0 R14: ffff921793d10590 R15: 0000008000100000
[  647.834782] FS:  00007f772ec90640(0000) GS:ffff921ce7a80000(0000) knlGS:0000000000000000
[  647.836004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  647.836990] CR2: 00007f02c27a3a20 CR3: 0000000101b0c006 CR4: 0000000000372ee0
[  647.838107] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  647.839283] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  647.840666] Call Trace:
[  647.841437]  <TASK>
[  647.842107]  intel_iommu_unmap_pages+0x93/0x140
[  647.843112]  __iommu_unmap+0x91/0x1b0
[  647.844003]  iommu_unmap+0x6a/0x95
[  647.844885]  vhost_vdpa_unmap+0x1de/0x1f0 [vhost_vdpa]
[  647.845985]  vhost_vdpa_process_iotlb_msg+0xf0/0x90b [vhost_vdpa]
[  647.847235]  ? _raw_spin_unlock+0x15/0x30
[  647.848181]  ? _copy_from_iter+0x8c/0x580
[  647.849137]  vhost_chr_write_iter+0xb3/0x430 [vhost]
[  647.850126]  vfs_write+0x1e4/0x3a0
[  647.850897]  ksys_write+0x53/0xd0
[  647.851688]  do_syscall_64+0x3a/0x90
[  647.852508]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  647.853457] RIP: 0033:0x7f7734ef9f4f
[  647.854408] Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 29 76 f8 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c8
[  647.857217] RSP: 002b:00007f772ec8f040 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  647.858486] RAX: ffffffffffffffda RBX: 00000000fef00000 RCX: 00007f7734ef9f4f
[  647.859713] RDX: 0000000000000048 RSI: 00007f772ec8f090 RDI: 0000000000000010
[  647.860942] RBP: 00007f772ec8f1a0 R08: 0000000000000000 R09: 0000000000000000
[  647.862206] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000010
[  647.863446] R13: 0000000000000002 R14: 0000000000000000 R15: ffffffff01100000
[  647.864692]  </TASK>
[  647.865458] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs v]
[  647.874688] ---[ end trace 0000000000000000 ]---

Cc: stable@vger.kernel.org
Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 166044642fd5..f8da6a3f98d2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -683,10 +683,20 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	mutex_unlock(&d->mutex);
 	return r;
 }
+static void vhost_vdpa_general_unmap(struct vhost_vdpa *v,
+				     struct vhost_iotlb_map *map, u32 asid)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+	if (ops->dma_map) {
+		ops->dma_unmap(vdpa, asid, map->start, map->size);
+	} else if (ops->set_map == NULL) {
+		iommu_unmap(v->domain, map->start, map->size);
+	}
+}
 
-static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
-				struct vhost_iotlb *iotlb,
-				u64 start, u64 last)
+static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+				u64 start, u64 last, u32 asid)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb_map *map;
@@ -703,13 +713,13 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v,
 			unpin_user_page(page);
 		}
 		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
 
-static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
-				struct vhost_iotlb *iotlb,
-				u64 start, u64 last)
+static void vhost_vdpa_va_unmap(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
+				u64 start, u64 last, u32 asid)
 {
 	struct vhost_iotlb_map *map;
 	struct vdpa_map_file *map_file;
@@ -718,20 +728,21 @@ static void vhost_vdpa_va_unmap(struct vhost_vdpa *v,
 		map_file = (struct vdpa_map_file *)map->opaque;
 		fput(map_file->file);
 		kfree(map_file);
+		vhost_vdpa_general_unmap(v, map, asid);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
 
 static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
-				   struct vhost_iotlb *iotlb,
-				   u64 start, u64 last)
+				   struct vhost_iotlb *iotlb, u64 start,
+				   u64 last, u32 asid)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 
 	if (vdpa->use_va)
-		return vhost_vdpa_va_unmap(v, iotlb, start, last);
+		return vhost_vdpa_va_unmap(v, iotlb, start, last, asid);
 
-	return vhost_vdpa_pa_unmap(v, iotlb, start, last);
+	return vhost_vdpa_pa_unmap(v, iotlb, start, last, asid);
 }
 
 static int perm_to_iommu_flags(u32 perm)
@@ -798,17 +809,12 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u32 asid = iotlb_to_asid(iotlb);
 
-	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
+	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1, asid);
 
-	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, asid, iova, size);
-	} else if (ops->set_map) {
+	if (ops->set_map) {
 		if (!v->in_batch)
 			ops->set_map(vdpa, asid, iotlb);
-	} else {
-		iommu_unmap(v->domain, iova, size);
 	}
-
 	/* If we are in the middle of batch processing, delay the free
 	 * of AS until BATCH_END.
 	 */
-- 
2.34.3

