Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737DFA49DD
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbfIAOe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 10:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfIAOeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 10:34:25 -0400
Received: from zzz.tds (h184-61-154-48.mdsnwi.dsl.dynamic.tds.net [184.61.154.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A943822CE9;
        Sun,  1 Sep 2019 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567348464;
        bh=gk2OvUfPAWwW3W4/Jk9tCyRaDsCsDZb7stv3qVAQsRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ct4Q3SZPnhHtX+AWMMRBzvyD0bRoXD3TAtmpPG1Ly2yXp0FE4m9XU2/NMxIEjc6x4
         mO3d16JZHSLfXLWkQZJ7LV+DNjV0pZ+Q3NF7c7qjxD0bd8KSDxlaHgVMdOT1BzK7Y9
         asr7ZanemHbQboC16eprkS8kQMrbjeXf+fTdfVQY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Karsten Keil <isdn@linux-pingi.de>, syzkaller-bugs@googlegroups.com
Subject: [PATCH net] isdn/capi: check message length in capi_write()
Date:   Sun,  1 Sep 2019 09:32:39 -0500
Message-Id: <20190901143239.13828-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <0000000000000e35f00581a579cd@google.com>
References: <0000000000000e35f00581a579cd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

syzbot reported:

    BUG: KMSAN: uninit-value in capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
    CPU: 0 PID: 10025 Comm: syz-executor379 Not tainted 4.20.0-rc7+ #2
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
    Call Trace:
      __dump_stack lib/dump_stack.c:77 [inline]
      dump_stack+0x173/0x1d0 lib/dump_stack.c:113
      kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:613
      __msan_warning+0x82/0xf0 mm/kmsan/kmsan_instr.c:313
      capi_write+0x791/0xa90 drivers/isdn/capi/capi.c:700
      do_loop_readv_writev fs/read_write.c:703 [inline]
      do_iter_write+0x83e/0xd80 fs/read_write.c:961
      vfs_writev fs/read_write.c:1004 [inline]
      do_writev+0x397/0x840 fs/read_write.c:1039
      __do_sys_writev fs/read_write.c:1112 [inline]
      __se_sys_writev+0x9b/0xb0 fs/read_write.c:1109
      __x64_sys_writev+0x4a/0x70 fs/read_write.c:1109
      do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
      entry_SYSCALL_64_after_hwframe+0x63/0xe7
    [...]

The problem is that capi_write() is reading past the end of the message.
Fix it by checking the message's length in the needed places.

Reported-and-tested-by: syzbot+0849c524d9c634f5ae66@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/isdn/capi/capi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 3c3ad42f22bf..a016d8c3c410 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -688,6 +688,9 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
 	if (!cdev->ap.applid)
 		return -ENODEV;
 
+	if (count < CAPIMSG_BASELEN)
+		return -EINVAL;
+
 	skb = alloc_skb(count, GFP_USER);
 	if (!skb)
 		return -ENOMEM;
@@ -698,7 +701,8 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
 	}
 	mlen = CAPIMSG_LEN(skb->data);
 	if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_REQ) {
-		if ((size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
+		if (count < 18 ||
+		    (size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
@@ -711,6 +715,10 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
 	CAPIMSG_SETAPPID(skb->data, cdev->ap.applid);
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_DISCONNECT_B3_RESP) {
+		if (count < 12) {
+			kfree_skb(skb);
+			return -EINVAL;
+		}
 		mutex_lock(&cdev->lock);
 		capincci_free(cdev, CAPIMSG_NCCI(skb->data));
 		mutex_unlock(&cdev->lock);
-- 
2.23.0

