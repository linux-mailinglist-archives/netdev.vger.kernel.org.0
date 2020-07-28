Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0E230377
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgG1HGD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jul 2020 03:06:03 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:57429 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgG1HGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:06:02 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 8AD33CECCC;
        Tue, 28 Jul 2020 09:16:01 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Fix suspend notifier race
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200727142231.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
Date:   Tue, 28 Jul 2020 09:05:59 +0200
Cc:     chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <534A8246-5B96-487F-A042-43F717A1CA24@holtmann.org>
References: <20200727142231.1.I7ebe9eaf684ddb07ae28634cb4d28cf7754641f1@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Unregister from suspend notifications and cancel suspend preparations
> before running hci_dev_do_close. Otherwise, the suspend notifier may
> race with unregister and cause cmd_timeout even after hdev has been
> freed.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> Hi Marcel,
> 
> This fixes a race between hci_unregister_dev and the suspend notifier.
> Without these changes, we encountered the following kernel panic when
> a USB disconnect (with btusb) occurred on resume:
> 
> [  832.578518] Bluetooth: hci_core.c:hci_cmd_timeout() hci0: command 0x0c05 tx timeout
> [  832.586200] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [  832.586203] #PF: supervisor read access in kernel mode
> [  832.586205] #PF: error_code(0x0000) - not-present page
> [  832.586206] PGD 0 P4D 0
> [  832.586210] PM: suspend exit
> [  832.608870] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  832.613232] CPU: 3 PID: 10755 Comm: kworker/3:7 Not tainted 5.4.44-04894-g1e9dbb96a161 #1
> [  832.630036] Workqueue: events hci_cmd_timeout [bluetooth]
> [  832.630046] RIP: 0010:__queue_work+0xf0/0x374
> [  832.630051] RSP: 0018:ffff9b5285f1fdf8 EFLAGS: 00010046
> [  832.674033] RAX: ffff8a97681bac00 RBX: 0000000000000000 RCX: ffff8a976a000600
> [  832.681162] RDX: 0000000000000000 RSI: 0000000000000009 RDI: ffff8a976a000748
> [  832.688289] RBP: ffff9b5285f1fe38 R08: 0000000000000000 R09: ffff8a97681bac00
> [  832.695418] R10: 0000000000000002 R11: ffff8a976a0006d8 R12: ffff8a9745107600
> [  832.698045] usb 1-6: new full-speed USB device number 119 using xhci_hcd
> [  832.702547] R13: ffff8a9673658850 R14: 0000000000000040 R15: 000000000000001e
> [  832.702549] FS:  0000000000000000(0000) GS:ffff8a976af80000(0000) knlGS:0000000000000000
> [  832.702550] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  832.702550] CR2: 0000000000000000 CR3: 000000010415a000 CR4: 00000000003406e0
> [  832.702551] Call Trace:
> [  832.702558]  queue_work_on+0x3f/0x68
> [  832.702562]  process_one_work+0x1db/0x396
> [  832.747397]  worker_thread+0x216/0x375
> [  832.751147]  kthread+0x138/0x140
> [  832.754377]  ? pr_cont_work+0x58/0x58
> [  832.758037]  ? kthread_blkcg+0x2e/0x2e
> [  832.761787]  ret_from_fork+0x22/0x40
> [  832.846191] ---[ end trace fa93f466da517212 ]---
> 
> The suspend notifier handler seemed to be scheduling commands even after
> it was cleaned up and this was resulting in a panic in cmd_timeout (when
> it tries to requeue the cmd_timer).
> 
> This was tested on 5.4 kernel with a suspend+resume stress test for 500+
> iterations. I also confirmed that after a usb disconnect, the suspend
> notifier times out before the USB device is probed again (fixing the
> original race between the usb_disconnect + probe and the notifier).

Can you please structure the commit message so that the oops is included. It is valuable information Everything after --- is a personal note to the maintainer. And we might want to include a Fixes tag as well.

Regards

Marcel

