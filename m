Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9117A49FCE0
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349580AbiA1PdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:33:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:36489 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1343568AbiA1PdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:33:13 -0500
Received: (qmail 206926 invoked by uid 1000); 28 Jan 2022 10:33:12 -0500
Date:   Fri, 28 Jan 2022 10:33:12 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfQMuOYF8SdoykZJ@rowland.harvard.edu>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
 <YfLPvF6pmcL1UG2f@rowland.harvard.edu>
 <YfPTCmMDlXD1UHx9@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfPTCmMDlXD1UHx9@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:27:06PM +0100, Oleksij Rempel wrote:
> On Thu, Jan 27, 2022 at 12:00:44PM -0500, Alan Stern wrote:
> > On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> > > On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > > > To provide generic way to detect USB issues or HW issues on different
> > > > levels we need to make use of devlink.
> > > 
> > > Please make this generic to all USB devices, usbnet is not special here
> > > at all.
> > 
> > Even more basic question: How is the kernel supposed to tell the 
> > difference between a USB issue and a HW issue?  That is, by what 
> > criterion do you decide which category a particular issue falls under?
> 
> In case of networking device, from user space perspective, we have a
> communication issue with some external device over the Ethernet.
> So, depending on the health state of following chain:
> cpu->hcd->USB cable->ethernet_controller->ethernet_cable-<...
> 
> We need to decide what to do, and what can be done automatically by
> device itself,

"Device"?  Do you mean "driver"?  I wouldn't expect the device to do 
much of anything by itself.

>  for example Mars rover :) The user space should get as
> much information as possible what's going on in the system, to decide
> the proper measures to fix or mitigate the problem.

I disagree.  What you're talking about is a debugging facility.  
Normally users do not want to get that much information.  Particularly 
since most of it is usually useless.

>  System designers
> usually (hopefully) find out during testing what URB status and IP
> uplink status for that hardware means and how to fix that.

System designers generally have much different requirements from 
ordinary users.

But let's go back to the chain you mentioned:

	cpu->hcd->USB cable->ethernet_controller->ethernet_cable-> ...

In general there is no way to tell at what stage something went wrong.  
For example, if the kernel does not receive a response to an URB, the 
program could be in the CPU, the HCD, the USB cable, or the ethernet 
controller, with no way to tell where it really is.  (And that's 
assuming the problem is a hardware failure, not a software bug!)

All we can do in the real world is record error responses.  At the 
moment we don't have any unified way of reporting them to userspace, 
partly because nobody has asked for it and partly because error 
responses don't always mean that something has failed.  (For example, 
they might mean that the system has asked to a device to perform an 
action it doesn't support, or they might mean the user has suddenly 
unplugged a USB cable.)

Greg's suggestion that you try it out and see how much signal you get 
among all the noise is a good idea.

Alan Stern
