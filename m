Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71701439EBF
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhJYS46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:56:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52097 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S232161AbhJYS4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:56:52 -0400
Received: (qmail 1268304 invoked by uid 1000); 25 Oct 2021 14:54:26 -0400
Date:   Mon, 25 Oct 2021 14:54:26 -0400
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
Message-ID: <20211025185426.GF1258186@rowland.harvard.edu>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
 <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
 <20211020220503.GB1140001@rowland.harvard.edu>
 <7d26fa0f-3a45-cefc-fd83-e8979ba6107c@canonical.com>
 <20211025162200.GC1258186@rowland.harvard.edu>
 <1927ec9b-d1d0-9c70-992b-925ddfbba79a@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1927ec9b-d1d0-9c70-992b-925ddfbba79a@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 07:13:59PM +0200, Krzysztof Kozlowski wrote:
> On 25/10/2021 18:22, Alan Stern wrote:
> > On Mon, Oct 25, 2021 at 04:57:23PM +0200, Krzysztof Kozlowski wrote:
> >> The URB which causes crazy loop is the port100 driver second URB, the
> >> one called ack or in_urb.
> >>
> >> The flow is:
> >> 1. probe()
> >> 2. port100_get_command_type_mask()
> >> 3. port100_send_cmd_async()
> >> 4. port100_send_frame_async()
> >> 5. usb_submit_urb(dev->out_urb)
> >>    The call succeeds, the dummy_hcd picks it up and immediately ends the
> >> timer-loop with -EPROTO
> > 
> > So that URB completes immediately.
> > 
> >> The completion here does not resubmit another/same URB. I checked this
> >> carefully and I hope I did not miss anything.
> > 
> > Yeah, I see the same thing.
> > 
> >> 6. port100_submit_urb_for_ack() which sends the in_urb:
> >>    usb_submit_urb(dev->in_urb)
> >> ... wait for completion
> >> ... dummy_hcd loops on this URB around line 2000:
> >> if (status == -EINPROGRESS)
> >>   continue
> > 
> > Do I understand this correctly?  You're saying that dummy-hcd executes 
> > the following jump at line 1975:
> > 
> > 		/* incomplete transfer? */
> > 		if (status == -EINPROGRESS)
> > 			continue;
> > 
> > which goes back up to the loop head on line 1831:
> > 
> > 	list_for_each_entry_safe(urbp, tmp, &dum_hcd->urbp_list, urbp_list) {
> > 
> > Is that right?
> 
> Yes, exactly. The loop continues, iterating over list finishes thus the
> loops and dummy timer function exits. Then immediately it is being
> rescheduled by something (I don't know by what yet).

There's a timer (dum_hcd->timer) which fires every millisecond.  If 
syzbot creates a lot of dummy-hcd instances then each instance will have 
its own timer, which could use up a large part of the available CPU 
time.  But you say this isn't the real problem...

> To remind - the syzbot reproducer must run at least two threads
> (spawning USB gadgets so creating separate dummy devices) at the same
> time. However only one of dummy HCD devices seems to timer-loop
> endlessly... but this might not be important, e.g. maybe it's how syzbot
> reproducer works.
> 
> >  I don't see why this should cause any problem.  It won't 
> > loop back to the same URB; it will make its way through the list.  
> > (Unless the list has somehow gotten corrupted...)  dum_hcd->urbp_list 
> > should be short (perhaps 32 entries at most), so the loop should reach 
> > the end of the list fairly quickly.
> 
> The list has actually only one element - only this one URB coming from
> port100 device (which I was always calling second URB/ack, in_urb).

Okay, good.

> > Now, doing all this 1000 times per second could use up a significant 
> > portion of the available time.  Do you think that's the reason for the 
> > problem?  It seems pretty unlikely.
> 
> No, this timer-looping itself is not a problem. Problem is that this URB
> never reaches some final state, e.g. -EPROTO.

The -EPROTO completion should happen very quickly once the gadget driver 
unregisters or disconnects itself.  This is because the call to 
find_endpoint at line 1856 should return NULL:

		ep = find_endpoint(dum, address);
		if (!ep) {
			/* set_configuration() disagreement */
			dev_dbg(dummy_dev(dum_hcd),
				"no ep configured for urb %p\n",
				urb);
			status = -EPROTO;
			goto return_urb;
		}

The NULL return should be caused by the !is_active test at the 
beginning of find_endpoint:

static struct dummy_ep *find_endpoint(struct dummy *dum, u8 address)
{
	int		i;

	if (!is_active((dum->gadget.speed == USB_SPEED_SUPER ?
			dum->ss_hcd : dum->hs_hcd)))
		return NULL;

is_active is defined as a macro:

#define is_active(dum_hcd)	((dum_hcd->port_status & \
		(USB_PORT_STAT_CONNECTION | USB_PORT_STAT_ENABLE | \
			USB_PORT_STAT_SUSPEND)) \
		== (USB_PORT_STAT_CONNECTION | USB_PORT_STAT_ENABLE))

and a disconnection should turn off the USB_PORT_STAT_CONNECTION bit, as 
follows:

	usb_gadget_unregister_driver calls usb_gadget_remove_driver
		(in drivers/usb/gadget/udc/core.c),

	which calls usb_gadget_disconnect,

	which calls dummy_pullup with value = 0,

	which sets dum->pullup to 0 and calls set_link_state,

	which calls set_link_state_by_speed,

	which turns off the USB_PORT_STATE_CONNECTION bit in 
		dum_hcd->port_status because dum->pullup is 0.

You can try tracing through this sequence of events to see if they're 
not taking place as intended.

> In normal operation, e.g. when reproducer did not hit the issue, both
> URBs from port100 (the first out_urb and second in_urb) complete with
> -EPROTO. In the case leading to hang ("task kworker/0:0:5 blocked for
> more than 143 seconds"), the in_urb does not complete therefore the
> port100 driver waits.

Those "... blocked for more than 143 seconds" errors occur when some 
task or interrupt loop is using up all the CPU time, preventing normal 
processes from running.  In this case the culprit has got to be the 
timer routine and loop in dummy_hcd.  However, the loop should terminate 
once the gadget driver unregisters itself, as described above.

> Whether this intensive timer-loop is important (processing the same URB
> and continuing), I don't know.

Yes, that's how dummy_hcd gets its work done.

Alan Stern
