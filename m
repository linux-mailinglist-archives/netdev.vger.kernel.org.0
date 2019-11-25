Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4302D108E46
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfKYMyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:54:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49292 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbfKYMyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:54:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574686448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iRxRQELuN94CvU53t48FEHCDA62GPIy2JK0S4shzCn4=;
        b=LH5T5OE69Vdyr4xPD34PDh3OgSVYnYJ70MGkmXiJn9qbivlf42FDeARshLrVJyaLfCngHI
        9WKQWINBGTqxerG1ctwWRuCz2bh/AGZTgJ47tqLKGV2pmyTw9UemwYRpj9I6k0MYsNsDGh
        R/zUZEPw0EG7YubiYMOk+SBLHB0nDqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-KXsqlLjLNnyH22xgBNIFRA-1; Mon, 25 Nov 2019 07:54:04 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B64181870618;
        Mon, 25 Nov 2019 12:54:03 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.40.205.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A318600C6;
        Mon, 25 Nov 2019 12:53:55 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vdronov@redhat.com
Subject: [PATCH] fs: fix use-after-free in __fput() when a chardev is removed but a file is still open
Date:   Mon, 25 Nov 2019 13:53:42 +0100
Message-Id: <20191125125342.6189-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: KXsqlLjLNnyH22xgBNIFRA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a case when a chardev file (like /dev/ptp0) is open but an underlying
device is removed, closing this file leads to a use-after-free. This
reproduces easily in a KVM virtual machine:

# cat openptp0.c
int main() { ... fp =3D fopen("/dev/ptp0", "r"); ... sleep(10); }

# uname -r
5.4.0-219d5433
# cat /proc/cmdline
... slub_debug=3DFZP
# modprobe ptp_kvm
# ./openptp0 &
[1] 670
opened /dev/ptp0, sleeping 10s...
# rmmod ptp_kvm
# ls /dev/ptp*
ls: cannot access '/dev/ptp*': No such file or directory
# ...woken up
[  102.375849] general protection fault: 0000 [#1] SMP
[  102.377372] CPU: 1 PID: 670 Comm: openptp0 Not tainted 5.4.0-219d5433 #1
[  102.379163] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[  102.381129] RIP: 0010:module_put.part.0+0x7/0x80
[  102.383019] RSP: 0018:ffff9ba440687e00 EFLAGS: 00010202
[  102.383451] RAX: 0000000000002000 RBX: 6b6b6b6b6b6b6b6b RCX: ffff91e7368=
00ad0
[  102.384030] RDX: ffffcf6408bc2808 RSI: 0000000000000247 RDI: 6b6b6b6b6b6=
b6b6b
[  102.386032] ...                                              ^^^ a slub =
poison
[  102.389866] Call Trace:
[  102.390086]  __fput+0x21f/0x240
[  102.390363]  task_work_run+0x79/0x90
[  102.390671]  do_exit+0x2c9/0xad0
[  102.390931]  ? vfs_write+0x16a/0x190
[  102.391241]  do_group_exit+0x35/0x90
[  102.391549]  __x64_sys_exit_group+0xf/0x10
[  102.391898]  do_syscall_64+0x3d/0x110
[  102.392240]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  102.392695] RIP: 0033:0x7f0fa7016246
[  102.396615] ...
[  102.397225] Modules linked in: [last unloaded: ptp_kvm]
[  102.410323] Fixing recursive fault but reboot is needed!

This happens in:

static void __fput(struct file *file)
{   ...
    if (file->f_op->release)
        file->f_op->release(inode, file); <<< cdev is kfree'd here
    if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev !=3D NULL &&
             !(mode & FMODE_PATH))) {
        cdev_put(inode->i_cdev); <<< cdev fields are accessed here

because of:

__fput()
  posix_clock_release()
    kref_put(&clk->kref, delete_clock) <<< the last reference
      delete_clock()
        delete_ptp_clock()
          kfree(ptp) <<< cdev is embedded in ptp
  cdev_put
    module_put(p->owner) <<< *p is kfree'd

The fix is to call cdev_put() before file->f_op->release(). This fix the
class of bugs when a chardev device is removed when its file is open, for
example:

# lspci
00:09.0 System peripheral: Intel Corporation 6300ESB Watchdog Timer
# ./openwdog0 &
[1] 672
opened /dev/watchdog0, sleeping 10s...
# echo 1 > /sys/devices/pci0000:00/0000:00:09.0/remove
# ls /dev/watch*
ls: cannot access '/dev/watch*': No such file or directory
# ...woken up
[   63.500271] general protection fault: 0000 [#1] SMP
[   63.501757] CPU: 1 PID: 672 Comm: openwdog0 Not tainted 5.4.0-219d5433 #=
4
[   63.503605] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
[   63.507064] RIP: 0010:module_put.part.0+0x7/0x80
[   63.513841] RSP: 0018:ffffb96b00667e00 EFLAGS: 00010202
[   63.515376] RAX: 0000000000002000 RBX: 6b6b6b6b6b6b6b6b RCX: 00000000001=
50013
[   63.517478] RDX: 0000000000000246 RSI: 0000000000000000 RDI: 6b6b6b6b6b6=
b6b6b

Analyzed-by: Stephen Johnston <sjohnsto@redhat.com>
Analyzed-by: Vern Lovejoy <vlovejoy@redhat.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 fs/file_table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 30d55c9a1744..21ba35024950 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -276,12 +276,12 @@ static void __fput(struct file *file)
 =09=09if (file->f_op->fasync)
 =09=09=09file->f_op->fasync(-1, file, 0);
 =09}
-=09if (file->f_op->release)
-=09=09file->f_op->release(inode, file);
 =09if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev !=3D NULL &&
 =09=09     !(mode & FMODE_PATH))) {
 =09=09cdev_put(inode->i_cdev);
 =09}
+=09if (file->f_op->release)
+=09=09file->f_op->release(inode, file);
 =09fops_put(file->f_op);
 =09put_pid(file->f_owner.pid);
 =09if ((mode & (FMODE_READ | FMODE_WRITE)) =3D=3D FMODE_READ)
--=20
2.20.1

