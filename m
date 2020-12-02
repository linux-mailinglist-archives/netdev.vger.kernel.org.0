Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075202CB2FA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgLBCzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:55:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgLBCzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 21:55:50 -0500
Date:   Tue, 1 Dec 2020 18:55:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606877708;
        bh=gnuyHfZmSA0ZkxwooTnVJl7oRNOkSdP6K7yegmAuHPo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=SV0b+Pzsf1R8xu8jF3GmXQmvZF36bjU5ixvj/gQBAwr7+cc63JWEKFczqX6A5aBmF
         dVy45yewNIDq3qfv0zPZChRRW19qNR0gv36jxEpcPJWrQhGKZpLbVwq3qh/wGQo618
         pJSQzdVHlYKacnhaAzRF2lPEQitxP6nfJhgS5nzA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
Message-ID: <20201201185506.77c4b3df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <817a4346-efb7-cfe5-0678-d1b60d06627d@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
        <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
        <20201201120302.474d4c9b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <817a4346-efb7-cfe5-0678-d1b60d06627d@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 13:48:36 -0700 Jeffrey Hugo wrote:
> On 12/1/2020 1:03 PM, Jakub Kicinski wrote:
> > On Tue, 1 Dec 2020 12:40:50 -0700 Jeffrey Hugo wrote:  
> >> On 12/1/2020 12:29 PM, Jakub Kicinski wrote:  
> >>> On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:  
> >>>> This patch series adds support for UCI driver. UCI driver enables userspace
> >>>> clients to communicate to external MHI devices like modem and WLAN. UCI driver
> >>>> probe creates standard character device file nodes for userspace clients to
> >>>> perform open, read, write, poll and release file operations. These file
> >>>> operations call MHI core layer APIs to perform data transfer using MHI bus
> >>>> to communicate with MHI device. Patch is tested using arm64 based platform.  
> >>>
> >>> Wait, I thought this was for modems.
> >>>
> >>> Why do WLAN devices need to communicate with user space?
> >>>      
> >>
> >> Why does it matter what type of device it is?  Are modems somehow unique
> >> in that they are the only type of device that userspace is allowed to
> >> interact with?  
> > 
> > Yes modems are traditionally highly weird and require some serial
> > device dance I don't even know about.
> > 
> > We have proper interfaces in Linux for configuring WiFi which work
> > across vendors. Having char device access to WiFi would be a step
> > back.  
> 
> So a WLAN device is only ever allowed to do Wi-Fi?  It can't also have 
> GPS functionality for example?

No, but it's also not true that the only way to implement GPS is by
opening a full on command/packet interface between fat proprietary
firmware and custom user space (which may or may not be proprietary 
as well).

> >> However, I'll bite.  Once such usecase would be QMI.  QMI is a generic
> >> messaging protocol, and is not strictly limited to the unique operations
> >> of a modem.
> >>
> >> Another usecase would be Sahara - a custom file transfer protocol used
> >> for uploading firmware images, and downloading crashdumps.  
> > 
> > Thanks, I was asking for use cases, not which proprietary vendor
> > protocol you can implement over it.
> > 
> > None of the use cases you mention here should require a direct FW -
> > user space backdoor for WLAN.  
> 
> Uploading runtime firmware, with variations based on the runtime mode. 
> Flashing the onboard flash based on cryptographic keys.  Accessing 
> configuration data.  Accessing device logs.  Configuring device logs. 
> Synchronizing the device time reference to Linux local or remote time 
> sources.  Enabling debugging/performance hardware.  Getting software 
> diagnostic events.  Configuring redundancy hardware per workload. 
> Uploading new cryptographic keys.  Invalidating cryptographic keys. 
> Uploading factory test data and running factory tests.
> 
> Need more?

This conversation is going nowhere. Are you trying to say that creating
a common Linux API for those features is impossible and each vendor
should be allowed to add their own proprietary way?

This has been proven incorrect again and again, and Wi-Fi is a good
example.

You can do whatever you want for GPS etc. but don't come nowhere near
networking with this attitude please.
