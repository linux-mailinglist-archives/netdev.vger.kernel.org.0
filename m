Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC6995D7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbfHVOG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:06:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:43766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732658AbfHVOG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 10:06:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB216AC47;
        Thu, 22 Aug 2019 14:06:25 +0000 (UTC)
Message-ID: <1566482782.8347.51.camel@suse.com>
Subject: Re: WARNING in rollback_registered_many (2)
From:   Oliver Neukum <oneukum@suse.com>
To:     Andrey Konovalov <andreyknvl@google.com>,
        syzbot <syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com>,
        USB list <linux-usb@vger.kernel.org>
Cc:     Kai Heng Feng <kai.heng.feng@canonical.com>, tyhicks@canonical.com,
        "David S. Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org, straube.linux@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        florian.c.schilhabel@googlemail.com,
        Matthew Wilcox <willy@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, avagin@virtuozzo.com,
        ktkhai@virtuozzo.com, "Eric W . Biederman" <ebiederm@xmission.com>
Date:   Thu, 22 Aug 2019 16:06:22 +0200
In-Reply-To: <CAAeHK+w+asSQ3axWymToQ+uzPfEAYS2QimVBL85GuJRBtxkjDA@mail.gmail.com>
References: <000000000000d9f094057a17b97b@google.com>
         <000000000000b439370586498dff@google.com>
         <CAAeHK+zUHJswwHfVUCV0qTgvFVFZpT0hJqioLyYgbA0yQC0H8Q@mail.gmail.com>
         <CAAeHK+w+asSQ3axWymToQ+uzPfEAYS2QimVBL85GuJRBtxkjDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 07.08.2019, 16:03 +0200 schrieb Andrey Konovalov:

I may offer a preliminary analysis.

	Regards
		Oliver

> On Fri, Apr 12, 2019 at 1:32 PM Andrey Konovalov <andreyknvl@google.com> wrote:
> > 
> > On Fri, Apr 12, 2019 at 1:29 AM syzbot
> > <syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com> wrote:
> > > 
> > > syzbot has found a reproducer for the following crash on:
> > > 
> > > HEAD commit:    9a33b369 usb-fuzzer: main usb gadget fuzzer driver
> > > git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10d552b7200000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=23e37f59d94ddd15
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=40918e4d826fb2ff9b96
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a4c1af200000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121b274b200000
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+40918e4d826fb2ff9b96@syzkaller.appspotmail.com
> > > 
> > > usb 1-1: r8712u: MAC Address from efuse = 00:e0:4c:87:00:00
> > > usb 1-1: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
> > > usb 1-1: USB disconnect, device number 2

Disconnect will run which leads to

static void r871xu_dev_remove(struct usb_interface *pusb_intf)
{
        struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
        struct usb_device *udev = interface_to_usbdev(pusb_intf);

        if (pnetdev) {

^^^ This is supposed to save us

                struct _adapter *padapter = netdev_priv(pnetdev);

                usb_set_intfdata(pusb_intf, NULL);
                release_firmware(padapter->fw);
                /* never exit with a firmware callback pending */
                wait_for_completion(&padapter->rtl8712_fw_ready);
                if (drvpriv.drv_registered)
                        padapter->surprise_removed = true;
                unregister_netdev(pnetdev); /* will call netdev_close() */

So we will call unregister_netdev()


> > > usb 1-1: Direct firmware load for rtlwifi/rtl8712u.bin failed with error -2
> > > usb 1-1: r8712u: Firmware request failed

So we ran into the error handling of:


static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
{
        struct _adapter *adapter = context;


        complete(&adapter->rtl8712_fw_ready);
        if (!firmware) {
                struct usb_device *udev = adapter->dvobjpriv.pusbdev;
                struct usb_interface *usb_intf = adapter->pusb_intf;


                dev_err(&udev->dev, "r8712u: Firmware request failed\n");
                usb_put_dev(udev);
                usb_set_intfdata(usb_intf, NULL);

^^^ This is supposed to save us from deregistering an unregistered device
	but it comes too late. We have already called complete.

                return;
        }
        adapter->fw = firmware;
        /* firmware available - start netdev */
        register_netdev(adapter->pnetdev);

register_netdev() is not called.
> > > Kernel panic - not syncing: panic_on_warn set ...
> > > CPU: 0 PID: 575 Comm: kworker/0:4 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > > Google 01/01/2011
> > > Workqueue: usb_hub_wq hub_event
> > > Call Trace:
> > >   __dump_stack lib/dump_stack.c:77 [inline]
> > >   dump_stack+0xe8/0x16e lib/dump_stack.c:113
> > >   panic+0x29d/0x5f2 kernel/panic.c:214
> > >   __warn.cold+0x20/0x48 kernel/panic.c:571
> > >   report_bug+0x262/0x2a0 lib/bug.c:186
> > >   fixup_bug arch/x86/kernel/traps.c:179 [inline]
> > >   fixup_bug arch/x86/kernel/traps.c:174 [inline]
> > >   do_error_trap+0x130/0x1f0 arch/x86/kernel/traps.c:272
> > >   do_invalid_op+0x37/0x40 arch/x86/kernel/traps.c:291
> > >   invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973

This kills us.

> > > RIP: 0010:rollback_registered_many+0x1f3/0xe70 net/core/dev.c:8152
> > > Code: 05 00 00 31 ff 44 89 fe e8 5a 15 f3 f4 45 84 ff 0f 85 49 ff ff ff e8
> > > 1c 14 f3 f4 0f 1f 44 00 00 e8 12 14 f3 f4 e8 0d 14 f3 f4 <0f> 0b 4c 89 e7
> > > e8 33 72 f2 f6 31 ff 41 89 c4 89 c6 e8 27 15 f3 f4
> > > RSP: 0018:ffff88809d087698 EFLAGS: 00010293
> > > RAX: ffff88809d058000 RBX: ffff888096240000 RCX: ffffffff8c7eb146
> > > RDX: 0000000000000000 RSI: ffffffff8c7eb163 RDI: 0000000000000001
> > > RBP: ffff88809d0877c8 R08: ffff88809d058000 R09: fffffbfff2708111
> > > R10: fffffbfff2708110 R11: ffffffff93840887 R12: ffff888096240070
> > > R13: dffffc0000000000 R14: ffff88809d087758 R15: 0000000000000000
> > >   rollback_registered+0xf7/0x1c0 net/core/dev.c:8228
> > >   unregister_netdevice_queue net/core/dev.c:9275 [inline]
> > >   unregister_netdevice_queue+0x1dc/0x2b0 net/core/dev.c:9268
> > >   unregister_netdevice include/linux/netdevice.h:2655 [inline]
> > >   unregister_netdev+0x1d/0x30 net/core/dev.c:9316
> > >   r871xu_dev_remove+0xe7/0x223 drivers/staging/rtl8712/usb_intf.c:604

We end up here:

static void rollback_registered_many(struct list_head *head)
{
        struct net_device *dev, *tmp;
        LIST_HEAD(close_head);


        BUG_ON(dev_boot_phase);
        ASSERT_RTNL();


        list_for_each_entry_safe(dev, tmp, head, unreg_list) {
                /* Some devices call without registering
                 * for initialization unwind. Remove those
                 * devices and proceed with the remaining.
                 */
                if (dev->reg_state == NETREG_UNINITIALIZED) {
                        pr_debug("unregister_netdevice: device %s/%p never was registered\n",
                                 dev->name, dev);


                        WARN_ON(1);


