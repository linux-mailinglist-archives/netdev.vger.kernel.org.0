Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B024CE40F
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 10:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbiCEJ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 04:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCEJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 04:57:01 -0500
Received: from sender4-of-o53.zoho.com (sender4-of-o53.zoho.com [136.143.188.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F157B2D;
        Sat,  5 Mar 2022 01:56:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1646474162; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Our1pnjEm3wEeZp5KFJrRiLbsuNIBDTA6aEc1VZpzJ8nzWM3+wuSY79vdGpUMtfNX7mE1J5qt80/NdbfCPTrEdB9kndiNJqNka+etdkFNqwAKRAENqv4V6N7OO5bXym4fJDkx6fKHGUEfFck9ERowhGeGLs9DgtcjumwRw0pz/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1646474162; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=DCSRpNWrnHSQa2u5Cncgea/UlXhpttbCIaNQ2y3CigU=; 
        b=LO2Mh7OM/kPbSLn+jA4ZdxmHmW/781SASE3gTj8NSqjxfdRL9RmJOu+hbjvAtRlIjLVZQpTvJ+ulBmV9eAwVV9ruW9Jna8VWZur3sgRT2bzaa3Ln0Zh9p8qqy0mRRJO66iYG9A3+vgDu2vTAsGQ8C5YyS83Gxa8rm9QhgP1SjQs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1646474162;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=DCSRpNWrnHSQa2u5Cncgea/UlXhpttbCIaNQ2y3CigU=;
        b=dys0TUCXkIgliqh90qFYPqUTjNPdb0u1wF+YLiBlRwWnLB0KYTxu5evnvE2pbTlY
        DKowcNfwzJmpUJOLmhiPfwupP8hnHNaY7WI1vrB492sw4cRZYJkTorKSoqFciouk+g0
        8GIAptVu3TDfXbKN2Iz9qkXa9h2a2/Z9ZTy+64So=
Received: from localhost.localdomain (49.207.224.178 [49.207.224.178]) by mx.zohomail.com
        with SMTPS id 1646474159765555.5049508686128; Sat, 5 Mar 2022 01:55:59 -0800 (PST)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     mail@anirudhrb.com,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] vhost: fix hung thread due to erroneous iotlb entries
Date:   Sat,  5 Mar 2022 15:25:25 +0530
Message-Id: <20220305095525.5145-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_iotlb_add_range_ctx(), range size can overflow to 0 when
start is 0 and last is ULONG_MAX. One instance where it can happen
is when userspace sends an IOTLB message with iova=size=uaddr=0
(vhost_process_iotlb_msg). So, an entry with size = 0, start = 0,
last = ULONG_MAX ends up in the iotlb. Next time a packet is sent,
iotlb_access_ok() loops indefinitely due to that erroneous entry.

	Call Trace:
	 <TASK>
	 iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
	 vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
	 vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
	 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
	 kthread+0x2e9/0x3a0 kernel/kthread.c:377
	 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
	 </TASK>

Reported by syzbot at:
	https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87

To fix this, do two things:

1. Return -EINVAL in vhost_chr_write_iter() when userspace asks to map
   a range with size 0.
2. Fix vhost_iotlb_add_range_ctx() to handle the range [0, ULONG_MAX]
   by splitting it into two entries.

Fixes: 0bbe30668d89e ("vhost: factor out IOTLB")
Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
Changes in v3:
1. Simplify expression since start is always 0
2. Fix checkpatch issue
3. Add Fixes tag

v2: https://lore.kernel.org/kvm/20220224143320.3751-1-mail@anirudhrb.com/
Changes in v2:
1. Don't reject range [0, ULONG_MAX], split it instead.
2. Validate msg.size in vhost_chr_write_iter().

v1: https://lore.kernel.org/lkml/20220221195303.13560-1-mail@anirudhrb.com/

---
 drivers/vhost/iotlb.c | 11 +++++++++++
 drivers/vhost/vhost.c |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 670d56c879e5..40b098320b2a 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -57,6 +57,17 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
 	if (last < start)
 		return -EFAULT;
 
+	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
+	 * otherwise its size would overflow u64.
+	 */
+	if (start == 0 && last == ULONG_MAX) {
+		u64 mid = last / 2;
+
+		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
+		addr += mid + 1;
+		start = mid + 1;
+	}
+
 	if (iotlb->limit &&
 	    iotlb->nmaps == iotlb->limit &&
 	    iotlb->flags & VHOST_IOTLB_FLAG_RETIRE) {
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..55475fd59fb7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1170,6 +1170,11 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
+	if (msg.size == 0) {
+		ret = -EINVAL;
+		goto done;
+	}
+
 	if (dev->msg_handler)
 		ret = dev->msg_handler(dev, &msg);
 	else
-- 
2.35.1

