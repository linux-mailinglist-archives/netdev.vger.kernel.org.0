Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D049F0B7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 02:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345168AbiA1Bvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 20:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiA1Bvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 20:51:53 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBA2C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:51:53 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o12so8739810lfg.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sWjNh2W0k8aJoofcO0dRSIIhxPuCA1JHHTuxfdhHitc=;
        b=PQoDowfYFiG7x0sDRzKzcTZnkiY0sOzbx3Z+C6yUy4nBMsNPMgGorToRCS65AlyPLs
         bE542TTfCJWSefj3RdTb4zy8gjoo2/AHygBdnxFoaFgdahLXGLpU6WyXeUXabzlCVid0
         GqwFL/a/TE59OChQ6saxc1RVOw0lDVdHau1sTkK7f+1qIC2f7yL/ihDandRY3Nionvwz
         KfHcw34Wrt6ZkY1KZ7GJIHjxsHzlrD3cFLRPtMSCLpjedw71zOwr1IFnZa8K9XKqqoMr
         sABPFR5mcXbVRVlcEKi7qzomyvpP1Om7DcA1Qmed7oBA7JUNb0evLDcYOAj3ZbeX2WUa
         wnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sWjNh2W0k8aJoofcO0dRSIIhxPuCA1JHHTuxfdhHitc=;
        b=m8noZsqSoqbkJZCuUMWubIZVIItoxmeF0HpXuD23OkYHgVnfJtyDJ7UMjLL2A6BrnR
         lamYjaaywN5CAZEx9lfZ4VdlZeWVthkLQpBrUdA6Ou5IFW8U7yu2Jh0luhjVUfaz02LZ
         iMBp/u76CFLNmYDEfQZCnzOHUUrFJ2yeCWiXx10QvlHOnWjgPhepnxhZFfVW8b1ZajnM
         iSSiYfZVCxcyFtX257I5uoWDRE8LvCNngJVyEip+Zg7yui8hDQ7l2TJYgvf0gKQpZ20G
         73Zq0kxQD1pN2FQG6XCDPGv50DvdDtgPISmeZct3/CBHyYArkqYkGVhVfDGcCogLXX5q
         VK5g==
X-Gm-Message-State: AOAM532zSqQTHgv5h6zO9cndKEHcswpgFEr0zVt1Xzxdoa5UN4eUX8Br
        IlWjt2WgyaZkGdWiV5B6o9LzBzk+1pxi0HiCZurgDQ==
X-Google-Smtp-Source: ABdhPJx24zP/u8QPQoI1dY+zw4a2lXlUkCiutabhsmOgyULj6gvGXTP3ImPsvbfprJ0NykvKhxrYiNJEv3jtN3H9EhE=
X-Received: by 2002:a05:6512:3e07:: with SMTP id i7mr2786252lfv.283.1643334711241;
 Thu, 27 Jan 2022 17:51:51 -0800 (PST)
MIME-Version: 1.0
From:   Jann Horn <jannh@google.com>
Date:   Fri, 28 Jan 2022 02:51:24 +0100
Message-ID: <CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com>
Subject: [BUG] net_device UAF: linkwatch_fire_event() calls dev_hold() after
 netdev_wait_allrefs() is done
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I stumbled over a (fairly hard to hit, I think?) UAF that can be
triggered through a race condition when a USB network adapter that
uses the driver drivers/net/usb/ax88179_178a.c is disconnected while
ax88179_link_reset() is running (called from usbnet_deferred_kevent(),
running on the system_wq).

The problem is essentially that linkwatch_fire_event(), called by a
workqueue item, calls dev_hold() when the device has already gone
through netdev_wait_allrefs(), meaning dev_hold() has no effect
anymore. That happens with the following stack:

  linkwatch_fire_event+0x14b/0x180
  netif_carrier_on+0x70/0xc0
  ax88179_link_reset+0x2f7/0x490
  usbnet_deferred_kevent+0x3b1/0x900
  process_one_work+0x91d/0x15d0
  worker_thread+0x57b/0x1240
  kthread+0x2a5/0x350
  ret_from_fork+0x22/0x30

The symptom of this race is that KASAN reports a use-after-free later
on in __linkwatch_run_queue(), because the freed netdev was still
queued up on the lweventlist list. (KASAN report is appended at the
end of this mail.)

Looking through
https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot , it
looks like syzbot has also found some crashes with the same symptom in
the past? Though I can't easily tell whether it's actually the same
bug...

The following race between usbnet_deferred_kevent() (running
EVENT_LINK_RESET work) and usbnet_disconnect() triggers the bug:

 - USB network adapter notifies about link going up (ax88179_status())
 - ax88179_status() -> usbnet_link_change(..., 1, 1) queues
EVENT_LINK_RESET work
 - system_wq starts executing EVENT_LINK_RESET work, it runs up to
   the call to netif_carrier_on() in ax88179_link_reset()
 - USB hub signals that the USB network adapter has been disconnected
 - usbnet_disconnect() calls unregister_netdev(),
   which goes through netdev_wait_allrefs()
[from this point on, dev_hold() doesn't work anymore]
 - EVENT_LINK_RESET work continues, calls
   netif_carrier_on()->linkwatch_fire_event()->linkwatch_add_event(),
   which does dev_hold() (without effect) and places the device on lweventlist

After that, cleanup continues and the net_device gets freed while its
refcount is elevated.

I'm not sure what the right fix for this is.

Is the bug that usbnet_disconnect() should be stopping &dev->kevent
before calling unregister_netdev()?
Or is the bug that ax88179_link_reset() doesn't take some kind of lock
and re-check that the netdev is still alive?
Or should netif_carrier_on() be doing that?
Or is it the responsibility of the linkwatch code to check whether the
netdev is already going away?

If you think having a proper reproducer for this would help, I can
also put that together, but it's ugly and involves /dev/raw-gadget
(for emulating a USB device) and patching delays into the kernel...

==================== ASAN crash ====================

BUG: KASAN: use-after-free in __linkwatch_run_queue
(./include/linux/list.h:442 ./include/linux/list.h:484
net/core/link_watch.c:203)
Write of size 8 at addr ffff888013c52580 by task kworker/1:0/949

CPU: 1 PID: 949 Comm: kworker/1:0 Tainted: G        W
5.16.0-10660-g0c947b893d69-dirty #900
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Workqueue: events linkwatch_event
Call Trace:
 <TASK>
dump_stack_lvl (lib/dump_stack.c:107 (discriminator 4))
print_address_description.constprop.0 (mm/kasan/report.c:256)
kasan_report.cold (mm/kasan/report.c:443 mm/kasan/report.c:459)
__linkwatch_run_queue (./include/linux/list.h:442
./include/linux/list.h:484 net/core/link_watch.c:203)
linkwatch_event (net/core/link_watch.c:264)
process_one_work (kernel/workqueue.c:2312)
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2455)
kthread (kernel/kthread.c:359)
ret_from_fork (arch/x86/entry/entry_64.S:301)
 </TASK>

Allocated by task 29:
kasan_save_stack (mm/kasan/common.c:38)
__kasan_kmalloc (mm/kasan/common.c:46 mm/kasan/common.c:437
mm/kasan/common.c:516 mm/kasan/common.c:525)
kvmalloc_node (mm/util.c:586)
alloc_netdev_mqs (net/core/dev.c:10158)    // allocated type: struct net_device
usbnet_probe (drivers/net/usb/usbnet.c:1695)
usb_probe_interface (drivers/usb/core/driver.c:397)
really_probe.part.0 (drivers/base/dd.c:517 drivers/base/dd.c:596)
__driver_probe_device (drivers/base/dd.c:558 drivers/base/dd.c:752)
driver_probe_device (drivers/base/dd.c:782)
__device_attach_driver (drivers/base/dd.c:903)
bus_for_each_drv (drivers/base/bus.c:385 drivers/base/bus.c:426)
__device_attach (drivers/base/dd.c:970)
bus_probe_device (drivers/base/bus.c:489)
device_add (drivers/base/core.c:3412)
usb_set_configuration (drivers/usb/core/message.c:2171)
usb_generic_driver_probe (drivers/usb/core/generic.c:239)
usb_probe_device (drivers/usb/core/driver.c:293)
really_probe.part.0 (drivers/base/dd.c:517 drivers/base/dd.c:596)
__driver_probe_device (drivers/base/dd.c:558 drivers/base/dd.c:752)
driver_probe_device (drivers/base/dd.c:782)
__device_attach_driver (drivers/base/dd.c:903)
bus_for_each_drv (drivers/base/bus.c:385 drivers/base/bus.c:426)
__device_attach (drivers/base/dd.c:970)
bus_probe_device (drivers/base/bus.c:489)
device_add (drivers/base/core.c:3412)
usb_new_device.cold (drivers/usb/core/hub.c:2566)
hub_event (drivers/usb/core/hub.c:5358 drivers/usb/core/hub.c:5502
drivers/usb/core/hub.c:5660 drivers/usb/core/hub.c:5742)
process_one_work (kernel/workqueue.c:2312)
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2455)
kthread (kernel/kthread.c:359)
ret_from_fork (arch/x86/entry/entry_64.S:301)

Freed by task 29:
kasan_save_stack (mm/kasan/common.c:38)
kasan_set_track (mm/kasan/common.c:46)
kasan_set_free_info (mm/kasan/generic.c:372)
__kasan_slab_free (mm/kasan/common.c:369 mm/kasan/common.c:329
mm/kasan/common.c:375)
kfree (mm/slub.c:1754 mm/slub.c:3509 mm/slub.c:4562)
device_release (drivers/base/core.c:2234)
kobject_put (lib/kobject.c:709 lib/kobject.c:736
./include/linux/kref.h:65 lib/kobject.c:753)
usb_unbind_interface (drivers/usb/core/driver.c:461)
__device_release_driver (drivers/base/dd.c:1206)
device_release_driver (./include/linux/device.h:782
drivers/base/dd.c:1047 drivers/base/dd.c:1239 drivers/base/dd.c:1260)
bus_remove_device (drivers/base/bus.c:530 (discriminator 3))
device_del (drivers/base/core.c:3593)
usb_disable_device (drivers/usb/core/message.c:1409 (discriminator 2))
usb_disconnect.cold (drivers/usb/core/hub.c:2229)
hub_event (drivers/usb/core/hub.c:5208 drivers/usb/core/hub.c:5502
drivers/usb/core/hub.c:5660 drivers/usb/core/hub.c:5742)
process_one_work (kernel/workqueue.c:2312)
worker_thread (./include/linux/list.h:284 kernel/workqueue.c:2455)
kthread (kernel/kthread.c:359)
ret_from_fork (arch/x86/entry/entry_64.S:301)

Last potentially related work creation:
kasan_save_stack (mm/kasan/common.c:38)
__kasan_record_aux_stack (mm/kasan/generic.c:348)
insert_work (./include/linux/instrumented.h:71
./include/asm-generic/bitops/instrumented-non-atomic.h:134
kernel/workqueue.c:630 kernel/workqueue.c:637 kernel/workqueue.c:1371)
__queue_work (kernel/workqueue.c:1537)
queue_work_on (kernel/workqueue.c:1563)
ax88179_status (drivers/net/usb/ax88179_178a.c:353
drivers/net/usb/ax88179_178a.c:338)
intr_complete (./include/linux/instrumented.h:71 (discriminator 1)
./include/asm-generic/bitops/instrumented-non-atomic.h:134
(discriminator 1) ./include/linux/netdevice.h:3388 (discriminator 1)
drivers/net/usb/lan78xx.c:4205 (discriminator 1))
__usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1666)
dummy_timer (./include/linux/spinlock.h:349
drivers/usb/gadget/udc/dummy_hcd.c:1988)
call_timer_fn (./include/linux/instrumented.h:71
./include/linux/atomic/atomic-instrumented.h:27
./include/linux/jump_label.h:266 ./include/linux/jump_label.h:276
./include/trace/events/timer.h:125 kernel/time/timer.c:1422)
__run_timers.part.0 (kernel/time/timer.c:1467 kernel/time/timer.c:1734)
run_timer_softirq (kernel/time/timer.c:1749)
__do_softirq (./include/linux/instrumented.h:71
./include/linux/atomic/atomic-instrumented.h:27
./include/linux/jump_label.h:266 ./include/linux/jump_label.h:276
./include/trace/events/irq.h:142 kernel/softirq.c:559)

Second to last potentially related work creation:
kasan_save_stack (mm/kasan/common.c:38)
__kasan_record_aux_stack (mm/kasan/generic.c:348)
insert_work (./include/linux/instrumented.h:71
./include/asm-generic/bitops/instrumented-non-atomic.h:134
kernel/workqueue.c:630 kernel/workqueue.c:637 kernel/workqueue.c:1371)
__queue_work (kernel/workqueue.c:1537)
queue_work_on (kernel/workqueue.c:1563)
ax88179_reset (drivers/net/usb/ax88179_178a.c:1635)
usbnet_open (drivers/net/usb/usbnet.c:894 (discriminator 1))
__dev_open (net/core/dev.c:1407)
__dev_change_flags (net/core/dev.c:8139)
dev_change_flags (net/core/dev.c:8210)
do_setlink (net/core/rtnetlink.c:2729)
__rtnl_newlink (net/core/rtnetlink.c:3412)
rtnl_newlink (net/core/rtnetlink.c:3528)
rtnetlink_rcv_msg (net/core/rtnetlink.c:5592)
netlink_rcv_skb (net/netlink/af_netlink.c:2494)
netlink_unicast (net/netlink/af_netlink.c:1318 net/netlink/af_netlink.c:1343)
netlink_sendmsg (net/netlink/af_netlink.c:1919)
sock_sendmsg (net/socket.c:705 net/socket.c:725)
____sys_sendmsg (net/socket.c:2413)
___sys_sendmsg (net/socket.c:2469)
__sys_sendmsg (./include/linux/file.h:32 net/socket.c:2498)
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

The buggy address belongs to the object at ffff888013c52000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 1408 bytes inside of
 8192-byte region [ffff888013c52000, ffff888013c54000)
