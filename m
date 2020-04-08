Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B411A24EB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgDHPW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:22:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39125 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbgDHPWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:46 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXL-0001BO-JW; Wed, 08 Apr 2020 15:22:43 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 7/8] loopfs: start attaching correct namespace during loop_add()
Date:   Wed,  8 Apr 2020 17:21:50 +0200
Message-Id: <20200408152151.5780-8-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that kernfs and the block_class optionally support setting user
namespace tags we can start tagging loop devices with the namespace the
loopfs instance was mounted in. This has the consequence that loopfs
devices carry the correct sysfs permissions for all their core files.
All other classes will continue to be correctly owned by the initial
namespaces. Here is sample output:

root@b1:~# mount -t loop loop /mnt
root@b1:~# ln -sf /mnt/loop-control /dev/loop-control
root@b1:~# losetup -f
/dev/loop8
root@b1:~# ln -sf /mnt/loop8 /dev/loop8
root@b1:~# ls -al /sys/class/block/loop8
lrwxrwxrwx 1 root root 0 Apr  7 13:06 /sys/class/block/loop8 -> ../../devices/virtual/block/loop8
root@b1:~# ls -al /sys/class/block/loop8/
total 0
drwxr-xr-x  9 root   root       0 Apr  7 13:06 .
drwxr-xr-x 18 nobody nogroup    0 Apr  7 13:07 ..
-r--r--r--  1 root   root    4096 Apr  7 13:06 alignment_offset
lrwxrwxrwx  1 nobody nogroup    0 Apr  7 13:07 bdi -> ../../bdi/7:8
-r--r--r--  1 root   root    4096 Apr  7 13:06 capability
-r--r--r--  1 root   root    4096 Apr  7 13:06 dev
-r--r--r--  1 root   root    4096 Apr  7 13:06 discard_alignment
-r--r--r--  1 root   root    4096 Apr  7 13:06 events
-r--r--r--  1 root   root    4096 Apr  7 13:06 events_async
-rw-r--r--  1 root   root    4096 Apr  7 13:06 events_poll_msecs
-r--r--r--  1 root   root    4096 Apr  7 13:06 ext_range
-r--r--r--  1 root   root    4096 Apr  7 13:06 hidden
drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 holders
-r--r--r--  1 root   root    4096 Apr  7 13:06 inflight
drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 integrity
drwxr-xr-x  3 nobody nogroup    0 Apr  7 13:07 mq
drwxr-xr-x  2 root   root       0 Apr  7 13:06 power
drwxr-xr-x  3 nobody nogroup    0 Apr  7 13:07 queue
-r--r--r--  1 root   root    4096 Apr  7 13:06 range
-r--r--r--  1 root   root    4096 Apr  7 13:06 removable
-r--r--r--  1 root   root    4096 Apr  7 13:06 ro
-r--r--r--  1 root   root    4096 Apr  7 13:06 size
drwxr-xr-x  2 nobody nogroup    0 Apr  7 13:07 slaves
-r--r--r--  1 root   root    4096 Apr  7 13:06 stat
lrwxrwxrwx  1 nobody nogroup    0 Apr  7 13:07 subsystem -> ../../../../class/block
drwxr-xr-x  2 root   root       0 Apr  7 13:06 trace
-rw-r--r--  1 root   root    4096 Apr  7 13:06 uevent
root@b1:~#

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 drivers/block/loop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b1c3436d6e38..7a14fd3e4329 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2154,6 +2154,10 @@ static int loop_add(struct loop_device **l, int i, struct inode *inode)
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
+#ifdef CONFIG_BLK_DEV_LOOPFS
+	if (loopfs_i_sb(inode))
+		disk->user_ns = loopfs_i_sb(inode)->s_user_ns;
+#endif
 
 	add_disk(disk);
 
-- 
2.26.0

