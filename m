Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894523D261C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhGVOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:06:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56819 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S232449AbhGVOGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 10:06:48 -0400
Received: (qmail 8120 invoked by uid 1000); 22 Jul 2021 10:47:22 -0400
Date:   Thu, 22 Jul 2021 10:47:21 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <20210722144721.GA6592@rowland.harvard.edu>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 04:20:10PM +0200, Krzysztof Kozlowski wrote:
> On 22/06/2021 17:43, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13e1500c300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
> > dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1792e284300000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad9d48300000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com
> > 
> > INFO: task kworker/0:1:7 blocked for more than 143 seconds.
> >       Not tainted 5.13.0-rc6-syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:kworker/0:1     state:D stack:25584 pid:    7 ppid:     2 flags:0x00004000
> > Workqueue: usb_hub_wq hub_event
> > Call Trace:
> >  context_switch kernel/sched/core.c:4339 [inline]
> >  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
> >  schedule+0xcf/0x270 kernel/sched/core.c:5226
> >  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
> >  do_wait_for_common kernel/sched/completion.c:85 [inline]
> >  __wait_for_common kernel/sched/completion.c:106 [inline]
> >  wait_for_common kernel/sched/completion.c:117 [inline]
> >  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
> >  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
> >  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
> >  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
> >  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
...

> Cc: Thierry, Alan, Andrey,
> 
> The issue is reproducible immediately on QEMU instance with
> USB_DUMMY_HCD and USB_RAW_GADGET. I don't know about real port100 NFC
> device.
> 
> I spent some time looking into this and have no clue, except that it
> looks like an effect of a race condition.
> 
> 1. When using syskaller reproducer against one USB device (In the C
> reproducer change the loop in main() to use procid=0) - issue does not
> happen.
> 
> 2. With two threads or more talking to separate Dummy USB devices, the
> issue appears. The more of them, the better...
> 
> 3. The reported problem is in missing complete. The correct flow is like:
> port100_probe()
> port100_get_command_type_mask()
> port100_send_cmd_sync()
> port100_send_cmd_async()
> port100_submit_urb_for_ack()
> port100_send_complete()
> [   63.363863] port100 2-1:0.0: NFC: Urb failure (status -71)
> port100_recv_ack()
> [   63.369942] port100 2-1:0.0: NFC: Urb failure (status -71)
> 
> and schedule_work() which completes and unblocks port100_send_cmd_sync
> 
> However in the failing case (hung task) the port100_recv_ack() is never
> called. It looks like USB core / HCD / gadget does not send the Ack/URB
> complete.
> 
> I don't know why. The port100 NFC driver code looks OK, except it is not
> prepared for missing ack/urb so it waits indefinitely. I could try to
> convert it to wait_for_completion_timeout() but it won't be trivial and
> more important - I am not sure if this is the problem. Somehow the ACK
> with Urb failure is not sent back to the port100 device. Therefore I am
> guessing that the race condition is somwhere in USB stack, not in
> port100 driver.
> 
> The lockdep and other testing tools did not find anything here.
> 
> Anyone hints where the issue could be?

Here's what I wrote earlier: "It looks like the problem stems from the fact 
that port100_send_frame_async() submits two URBs, but 
port100_send_cmd_sync() only waits for one of them to complete.  The other 
URB may then still be active when the driver tries to reuse it."

Of course, there may be more than one problem, so we may not be talking 
about the same thing.

Does that help at all?

Alan Stern
