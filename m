Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B642218A26
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfEIM6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfEIM6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 08:58:09 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 404063087BD2;
        Thu,  9 May 2019 12:58:08 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97CD462DE;
        Thu,  9 May 2019 12:58:01 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
Subject: [RFC PATCH V2] vhost: don't use kmap() to log dirty pages
Date:   Thu,  9 May 2019 08:58:00 -0400
Message-Id: <1557406680-4087-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 09 May 2019 12:58:08 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vhost log dirty pages directly to a userspace bitmap through GUP and
kmap_atomic() since kernel doesn't have a set_bit_to_user()
helper. This will cause issues for the arch that has virtually tagged
caches. The way to fix is to keep using userspace virtual
address. Fortunately, futex has arch_futex_atomic_op_inuser() which
could be used for setting a bit to user.

Note:
- There're archs (few non popular ones) that don't implement futex
  helper, we can't log dirty pages. We can fix them e.g for non
  virtually tagged archs implement a kmap fallback on top or simply
  disable LOG_ALL features of vhost.
- The helper also requires userspace pointer is located at 4-byte
  boundary, need to check during dirty log setting

Cc: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- switch to use arch_futex_atomic_op_inuser()
---
 drivers/vhost/vhost.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 351af88..4e5a004 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -31,6 +31,7 @@
 #include <linux/sched/signal.h>
 #include <linux/interval_tree_generic.h>
 #include <linux/nospec.h>
+#include <asm/futex.h>
 
 #include "vhost.h"
 
@@ -1652,6 +1653,10 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 			r = -EFAULT;
 			break;
 		}
+		if (p & 0x3) {
+			r = -EINVAL;
+			break;
+		}
 		for (i = 0; i < d->nvqs; ++i) {
 			struct vhost_virtqueue *vq;
 			void __user *base = (void __user *)(unsigned long)p;
@@ -1692,31 +1697,27 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 }
 EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
 
-/* TODO: This is really inefficient.  We need something like get_user()
- * (instruction directly accesses the data, with an exception table entry
- * returning -EFAULT). See Documentation/x86/exception-tables.txt.
- */
-static int set_bit_to_user(int nr, void __user *addr)
+static int set_bit_to_user(int nr, u32 __user *addr)
 {
 	unsigned long log = (unsigned long)addr;
 	struct page *page;
-	void *base;
-	int bit = nr + (log % PAGE_SIZE) * 8;
+	u32 old;
 	int r;
 
 	r = get_user_pages_fast(log, 1, 1, &page);
 	if (r < 0)
 		return r;
 	BUG_ON(r != 1);
-	base = kmap_atomic(page);
-	set_bit(bit, base);
-	kunmap_atomic(base);
+
+	r = arch_futex_atomic_op_inuser(FUTEX_OP_ADD, 1 << nr, &old, addr);
+	/* TODO: fallback to kmap() when -ENOSYS? */
+
 	set_page_dirty_lock(page);
 	put_page(page);
-	return 0;
+	return r;
 }
 
-static int log_write(void __user *log_base,
+static int log_write(u32 __user *log_base,
 		     u64 write_address, u64 write_length)
 {
 	u64 write_page = write_address / VHOST_PAGE_SIZE;
@@ -1726,12 +1727,10 @@ static int log_write(void __user *log_base,
 		return 0;
 	write_length += write_address % VHOST_PAGE_SIZE;
 	for (;;) {
-		u64 base = (u64)(unsigned long)log_base;
-		u64 log = base + write_page / 8;
-		int bit = write_page % 8;
-		if ((u64)(unsigned long)log != log)
-			return -EFAULT;
-		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
+		u32 __user *log = log_base + write_page / 32;
+		int bit = write_page % 32;
+
+		r = set_bit_to_user(bit, log);
 		if (r < 0)
 			return r;
 		if (write_length <= VHOST_PAGE_SIZE)
-- 
1.8.3.1

