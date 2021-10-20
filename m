Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA70F4355AF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJTWH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 18:07:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59621 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S229695AbhJTWHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 18:07:25 -0400
Received: (qmail 1140490 invoked by uid 1000); 20 Oct 2021 18:05:03 -0400
Date:   Wed, 20 Oct 2021 18:05:03 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <20211020220503.GB1140001@rowland.harvard.edu>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
 <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 10:56:42PM +0200, Krzysztof Kozlowski wrote:
> Hi Alan, Felipe, Greg and others,
> 
> This is an old issue reported by syzkaller for NFC port100 driver [1].
> There is something similar for pn533 [2].
> 
> I was looking at it some time ago, took a break and now I am trying to
> fix it again. Without success.
> 
> The issue is reproducible via USB gadget on QEMU, not on real HW. I
> looked and debugged the code and I think previously mentioned
> double-URB-submit is not the reason here. Or I miss how the USB works
> (which is quite probable...).
> 
> 1. The port100 driver calls port100_send_cmd_sync() which eventually
> goes to port100_send_frame_async(). After it, it waits for "sync"
> completion.
> 
> 2. In port100_send_frame_async(), driver indeed first submits "out_urb"
> which quite fast is being processed by dummy_hcd with "no ep configured"
> and -EPROTO.
> 
> 3. Then (or sometimes before -EPROTO response from (2) above) the
> port100_send_frame_async() submits "in_urb" via
> port100_submit_urb_for_ack() and waits for its completion. Completion of
> "in_urb" (or the "ack") in port100_recv_ack() would schedule work to
> complete the (1) above - the sync completion.
> 
> 4. Usually, when reproducer works fine (does not trigger issue), the
> dummy_timer() from gadget responds with the same "no ep configured for
> urb" for this "in_urb" (3). This completes "in_urb", which eventually
> completes (1) and probe finishes with error. Error is expected, because
> it's random junk-gadget...
> 
> The syzkaller reproducer fails if >1 of threads are running these usb
> gadgets.  When this happens, no "in_urb" completion happens. No this
> "ack" port100_recv_ack().
> 
> I added some debugs and simply dummy_hcd dummy_timer() is woken up on
> enqueuing in_urb and then is looping crazy on a previous URB (some older
> URB, coming from before port100 driver probe started). The dummy_timer()
> loop never reaches the second "in_urb" to process it, I think.

Is there any way you can track down what's happening in that crazy loop?  
That is, what driver was responsible for the previous URB?

We have seen this sort of thing before, where a driver submits an URB 
for a gadget which has disconnected.  The URB fails with -EPROTO status 
but the URB's completion handler does an automatic resubmit.  That can 
lead to a very tight loop with dummy-hcd, and it could easily prevent 
some other important processing from occurring.  The simple solution is 
to prevent the driver from resubmitting when the completion status is 
-EPROTO.

Alan Stern

> The pn533 NFC driver has similar design, but I have now really doubts it
> is a NFC driver issue. Instead an issue in dummy gadget HCD is somehow
> triggered by the reproducer.
> 
> Reproduction - just follow [1] or [2]. Eventually I slightly tweaked the
> code and put here:
> https://github.com/krzk/tools/tree/master/tests-var/nfc/port100_probe
> $ make
> $ sudo ./port100_probe
> 
> 
> [1] https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
> [2] https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca
> 
> 
> Best regards,
> Krzysztof
