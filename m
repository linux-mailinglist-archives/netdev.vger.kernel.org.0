Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA11421175
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhJDOe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:34:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41623 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S234384AbhJDOez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 10:34:55 -0400
Received: (qmail 584706 invoked by uid 1000); 4 Oct 2021 10:33:05 -0400
Date:   Mon, 4 Oct 2021 10:33:05 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Jason-ch Chen <jason-ch.chen@mediatek.com>,
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
Message-ID: <20211004143305.GA583555@rowland.harvard.edu>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
 <20210930151819.GC464826@rowland.harvard.edu>
 <3694347f29ed431e9f8f2c065b8df0a7@realtek.com>
 <5f56b21575dd4f64a3b46aac21151667@realtek.com>
 <20211001152226.GA505557@rowland.harvard.edu>
 <72573b91-11d7-55a0-0cd8-5afbc289b38c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72573b91-11d7-55a0-0cd8-5afbc289b38c@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 01:44:54PM +0200, Oliver Neukum wrote:
> 
> On 01.10.21 17:22, Alan Stern wrote:
> > On Fri, Oct 01, 2021 at 03:26:48AM +0000, Hayes Wang wrote:
> >>> Alan Stern <stern@rowland.harvard.edu>
> >>> [...]
> >>>> There has been some discussion about this in the past.
> >>>>
> >>>> In general, -EPROTO is almost always a non-recoverable error.
> >>> Excuse me. I am confused about the above description.
> >>> I got -EPROTO before, when I debugged another issue.
> >>> However, the bulk transfer still worked after I resubmitted
> >>> the transfer. I didn't do anything to recover it. That is why
> >>> I do resubmission for -EPROTO.
> >> I check the Linux driver and the xHCI spec.
> >> The driver gets -EPROTO for bulk transfer, when the host
> >> returns COMP_USB_TRANSACTION_ERROR.
> >> According to the spec of xHCI, USB TRANSACTION ERROR
> >> means the host did not receive a valid response from the
> >> device (Timeout, CRC, Bad PID, unexpected NYET, etc.).
> > That's right.  If the device and cable are working properly, this 
> > should never happen.  Or only extremely rarely (for example, caused 
> > by external electromagnetic interference).
> And the device. I am afraid the condition in your conditional statement
> is not as likely to be true as would be desirable for quite a lot setups.

But if the device isn't working, a simple retry is most unlikely to fix 
the problem.  Some form of active error recovery, such as a bus reset, 
will be necessary.  For a non-working cable, even a reset won't help -- 
the user would have to physically adjust or replace the cable.

> >> It seems to be reasonable why resubmission sometimes works.
> > Did you ever track down the reason why you got the -EPROTO error 
> > while debugging that other issue?  Can you reproduce it?
> 
> Is that really the issue though? We are seeing this issue with EPROTO.
> But wouldn't we see it with any recoverable error?

If you mean an error that can be fixed but only by doing something more 
than a simple retry, then yes.  However, the vast majority of USB 
drivers do not attempt anything more than a simple retry.  Relatively 
few of them (including usbhid and mass-storage) are more sophisticated 
in their error handling.

> AFAICT we are running into a situation without progress because drivers
> retry
> 
> * forever
> * immediately
> 
> If we broke any of these conditions the system would proceed and the
> hotplug event be eventually be processed. We may ask whether drivers should
> retry forever, but I don't see that you can blame it on error codes.

It's important to distinguish between:

    1.	errors that are transient and will disappear very quickly,
	meaning that a retry has a good chance of working, and

    2.	errors that are effectively permanent (or at least, long-lived)
	and therefore are highly unlikely to be fixed by retrying.

My point is that there is no reason to retry in case 2, and -EPROTO 
falls into this case (as do -EILSEQ and -ETIME).

Converting drivers to keep track of their retries, to avoid retrying 
forever, would be a fairly large change.  Even implementing delayed 
retries requires some significant work (as you can see in Hayes's recent 
patch -- and that was an easy case because the NAPI infrastructure was 
already present).  It's much simpler to avoid retrying entirely in 
situations where retries won't help.

And it's even simpler if the USB core would automatically prevent 
retries (by failing URB submissions after low-level protocol errors) in 
these situations.

Alan Stern
