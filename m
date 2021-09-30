Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCDA41DD33
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245484AbhI3PUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:20:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41995 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S245377AbhI3PUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 11:20:03 -0400
Received: (qmail 472189 invoked by uid 1000); 30 Sep 2021 11:18:19 -0400
Date:   Thu, 30 Sep 2021 11:18:19 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Jason-ch Chen <jason-ch.chen@mediatek.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
Message-ID: <20210930151819.GC464826@rowland.harvard.edu>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:30:17AM +0200, Oliver Neukum wrote:
> 
> On 29.09.21 11:52, Jason-ch Chen wrote:
> > On Wed, 2021-09-29 at 08:14 +0000, Hayes Wang wrote:
> >>
> > Hi Hayes,
> >
> > Sometimes Rx submits rapidly and the USB kernel driver of opensource
> > cannot receive any disconnect event due to CPU heavy loading, which
> > finally causes a system crash.
> > Do you have any suggestions to modify the r8152 driver to prevent this
> > situation happened?
> >
> > Regards,
> > Jason
> >
> Hi,
> 
> Hayes proposed a solution. Basically you solve this the way HID or WDM do it
> delaying resubmission. This makes me wonder whether this problem is specific
> to any driver. If it is not, as I would argue, do we have a deficiency
> in our API?
> 
> Should we have something like: usb_submit_delayed_urb() ?

There has been some discussion about this in the past.

In general, -EPROTO is almost always a non-recoverable error.  In 
usually occurs when a USB cable has been unplugged, before the 
upstream hub has notified the kernel about the unplug event.  It also 
can occur when the device's firmware has crashed.

I do tend to think there is a deficiency in our API, and that it 
should be fixed by making the core logically disable an endpoint 
(clear the ep->enabled flag) whenever an URB for that endpoint 
completes with -EPROTO, -EILSEQ, or -ETIME status.  (In retrospect, 
using three distinct status codes for these errors was a mistake.)  
Then we wouldn't have to go through this piecemeal approach, 
modifying individual drivers to make them give up whenever they get 
one of these errors.

But then we'd have also have to make sure drivers have a way to 
logically re-enable endpoints, for the unlikely case that the error 
can be recovered from.  Certainly set-config, set-interface, and 
clear-halt should do this.  Anything else?

Alan Stern
