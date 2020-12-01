Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D312CACF6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730484AbgLAUDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLAUDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 15:03:51 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8CF20870;
        Tue,  1 Dec 2020 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606852990;
        bh=R/5sRgPj5z1/r8MnP/GGJtHNIk5Okfj54rbhBybQYYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wm8LtrmndYrzGaYf94/+DlonpVKgx26OfaHM5v73wfNsCOQcjVEkodC3l2irf6GTt
         /xu0gsPSCcAg9p8W4Q8qMd6t8rhCEkJZV+mngqny1Xa3SEQ/HodVl9xmcv1W04ZvUr
         p2iwEij3JSC6fxxR8j2DgtsSSngTvn5Lh+UsBwB0=
Date:   Tue, 1 Dec 2020 12:03:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
Message-ID: <20201201120302.474d4c9b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
        <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 12:40:50 -0700 Jeffrey Hugo wrote:
> On 12/1/2020 12:29 PM, Jakub Kicinski wrote:
> > On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:  
> >> This patch series adds support for UCI driver. UCI driver enables userspace
> >> clients to communicate to external MHI devices like modem and WLAN. UCI driver
> >> probe creates standard character device file nodes for userspace clients to
> >> perform open, read, write, poll and release file operations. These file
> >> operations call MHI core layer APIs to perform data transfer using MHI bus
> >> to communicate with MHI device. Patch is tested using arm64 based platform.  
> > 
> > Wait, I thought this was for modems.
> > 
> > Why do WLAN devices need to communicate with user space?
> >   
> 
> Why does it matter what type of device it is?  Are modems somehow unique 
> in that they are the only type of device that userspace is allowed to 
> interact with?

Yes modems are traditionally highly weird and require some serial
device dance I don't even know about.

We have proper interfaces in Linux for configuring WiFi which work
across vendors. Having char device access to WiFi would be a step 
back.

> However, I'll bite.  Once such usecase would be QMI.  QMI is a generic 
> messaging protocol, and is not strictly limited to the unique operations 
> of a modem.
> 
> Another usecase would be Sahara - a custom file transfer protocol used 
> for uploading firmware images, and downloading crashdumps.

Thanks, I was asking for use cases, not which proprietary vendor
protocol you can implement over it.

None of the use cases you mention here should require a direct FW -
user space backdoor for WLAN.

> Off the top of my head, this driver is useful for modems, wlan, and AI 
> accelerators.

And other Qualcomm products are available as well :/

Kernel is supposed to create abstract interfaces for user space to
utilize. I will never understand why kernel is expected to be in
business of shipping this sort of vendor backdoors :/
