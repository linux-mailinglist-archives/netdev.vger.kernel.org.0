Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E69439B6A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhJYQYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:24:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55845 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S233932AbhJYQYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 12:24:24 -0400
Received: (qmail 1263247 invoked by uid 1000); 25 Oct 2021 12:22:00 -0400
Date:   Mon, 25 Oct 2021 12:22:00 -0400
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
Message-ID: <20211025162200.GC1258186@rowland.harvard.edu>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
 <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
 <20211020220503.GB1140001@rowland.harvard.edu>
 <7d26fa0f-3a45-cefc-fd83-e8979ba6107c@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d26fa0f-3a45-cefc-fd83-e8979ba6107c@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 04:57:23PM +0200, Krzysztof Kozlowski wrote:
> On 21/10/2021 00:05, Alan Stern wrote:
> >>
> >> The syzkaller reproducer fails if >1 of threads are running these usb
> >> gadgets.  When this happens, no "in_urb" completion happens. No this
> >> "ack" port100_recv_ack().
> >>
> >> I added some debugs and simply dummy_hcd dummy_timer() is woken up on
> >> enqueuing in_urb and then is looping crazy on a previous URB (some older
> >> URB, coming from before port100 driver probe started). The dummy_timer()
> >> loop never reaches the second "in_urb" to process it, I think.
> > 
> > Is there any way you can track down what's happening in that crazy loop?  
> > That is, what driver was responsible for the previous URB?
> > 
> > We have seen this sort of thing before, where a driver submits an URB 
> > for a gadget which has disconnected.  The URB fails with -EPROTO status 
> > but the URB's completion handler does an automatic resubmit.  That can 
> > lead to a very tight loop with dummy-hcd, and it could easily prevent 
> > some other important processing from occurring.  The simple solution is 
> > to prevent the driver from resubmitting when the completion status is 
> > -EPROTO.
> 
> Hi Alan,
> 
> Thanks for the reply.
> 
> The URB which causes crazy loop is the port100 driver second URB, the
> one called ack or in_urb.
> 
> The flow is:
> 1. probe()
> 2. port100_get_command_type_mask()
> 3. port100_send_cmd_async()
> 4. port100_send_frame_async()
> 5. usb_submit_urb(dev->out_urb)
>    The call succeeds, the dummy_hcd picks it up and immediately ends the
> timer-loop with -EPROTO

So that URB completes immediately.

> The completion here does not resubmit another/same URB. I checked this
> carefully and I hope I did not miss anything.

Yeah, I see the same thing.

> 6. port100_submit_urb_for_ack() which sends the in_urb:
>    usb_submit_urb(dev->in_urb)
> ... wait for completion
> ... dummy_hcd loops on this URB around line 2000:
> if (status == -EINPROGRESS)
>   continue

Do I understand this correctly?  You're saying that dummy-hcd executes 
the following jump at line 1975:

		/* incomplete transfer? */
		if (status == -EINPROGRESS)
			continue;

which goes back up to the loop head on line 1831:

	list_for_each_entry_safe(urbp, tmp, &dum_hcd->urbp_list, urbp_list) {

Is that right?  I don't see why this should cause any problem.  It won't 
loop back to the same URB; it will make its way through the list.  
(Unless the list has somehow gotten corrupted...)  dum_hcd->urbp_list 
should be short (perhaps 32 entries at most), so the loop should reach 
the end of the list fairly quickly.

Now, doing all this 1000 times per second could use up a significant 
portion of the available time.  Do you think that's the reason for the 
problem?  It seems pretty unlikely.

Alan Stern
