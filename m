Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5DAB0AF
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 04:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391995AbfIFCh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 22:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391988AbfIFCh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 22:37:27 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7592070C;
        Fri,  6 Sep 2019 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567737447;
        bh=y2FHYeQIYqiYAixpBIaG984FZRnJE1xNjWg5jUjEjtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vtc3I8D8cjclhBGEaNn08EnE1fXjdecgA4cH/8REkuW/r6lu8+oth8M5Yn+bFJZB0
         FRZ9i4NmaXCq6KKHaOXzKpGhMkfAJZdd0naVQuKDq3Ea53LDiK9TQi2yAZeLcBdRmK
         5SqucaqmuH3jsX61bvEr/hV0DoA50WoMqFh+FyBE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Cc:     Karsten Keil <isdn@linux-pingi.de>, syzkaller-bugs@googlegroups.com
Subject: [PATCH net v2] isdn/capi: check message length in capi_write()
Date:   Thu,  5 Sep 2019 19:36:37 -0700
Message-Id: <20190906023637.768-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190901.114406.528788701327829265.davem@davemloft.net>
References: <20190901.114406.528788701327829265.davem@davemloft.net>
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

Changed v1 => v2:

- Use CAPI_DATA_B3_REQ_LEN, and define and use a constant for
  CAPI_DISCONNECT_B3_RESP_LEN.

 drivers/isdn/capi/capi.c          | 10 +++++++++-
 include/uapi/linux/isdn/capicmd.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 3c3ad42f22bf..c92b405b7646 100644
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
+		if (count < CAPI_DATA_B3_REQ_LEN ||
+		    (size_t)(mlen + CAPIMSG_DATALEN(skb->data)) != count) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
@@ -711,6 +715,10 @@ capi_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos
 	CAPIMSG_SETAPPID(skb->data, cdev->ap.applid);
 
 	if (CAPIMSG_CMD(skb->data) == CAPI_DISCONNECT_B3_RESP) {
+		if (count < CAPI_DISCONNECT_B3_RESP_LEN) {
+			kfree_skb(skb);
+			return -EINVAL;
+		}
 		mutex_lock(&cdev->lock);
 		capincci_free(cdev, CAPIMSG_NCCI(skb->data));
 		mutex_unlock(&cdev->lock);
diff --git a/include/uapi/linux/isdn/capicmd.h b/include/uapi/linux/isdn/capicmd.h
index 4941628a4fb9..5ec88e7548a9 100644
--- a/include/uapi/linux/isdn/capicmd.h
+++ b/include/uapi/linux/isdn/capicmd.h
@@ -16,6 +16,7 @@
 #define CAPI_MSG_BASELEN		8
 #define CAPI_DATA_B3_REQ_LEN		(CAPI_MSG_BASELEN+4+4+2+2+2)
 #define CAPI_DATA_B3_RESP_LEN		(CAPI_MSG_BASELEN+4+2)
+#define CAPI_DISCONNECT_B3_RESP_LEN	(CAPI_MSG_BASELEN+4)
 
 /*----- CAPI commands -----*/
 #define CAPI_ALERT		    0x01
-- 
2.23.0

