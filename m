Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB02D01ED
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgLFIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgLFIdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 03:33:47 -0500
Date:   Sun, 6 Dec 2020 10:33:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607243586;
        bh=YxOwelJbt6Ldd1JmN1BBjPbwh7esl4+nGtdlpwDrHv8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=VOqQuGPtUIIFyk+tnfst7FxjYZXe6qfKsID0qvnciJueai74WkaNSocZQEHXvuGdC
         zSsWvHpoDNcf2NtCn9NfzpTEySj3LKWMWaEdXXI0D71QAwMsGJv+ry34PQSWrhutxf
         Qoot7kuGh2FMwJUyQSDjiwVmoYQ6HaE+5Id4989C7Fhra/v2lGluif4S4iL5Jpxd8O
         4zEsE1f0HvbRMfJ1Mq/UWR/4kipbVvELNcU4+T7VIeeWe1v83KZbh3nLumIfwLARZz
         yVY3VZIao0O0/nMRx9qrTFLGKT0XY2EGXpLPU2+FSZ1unmHPOYkqKQsbZ7NbVJfuNC
         WlMK3qPSlC/Bg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeffrey Hugo <jhugo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v13 0/4] userspace MHI client interface driver
Message-ID: <20201206083302.GA691268@unreal>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <20201201112901.7f13e26c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <c6359962-a378-ed03-0fab-c2f6c8a1b8eb@codeaurora.org>
 <20201201120302.474d4c9b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <817a4346-efb7-cfe5-0678-d1b60d06627d@codeaurora.org>
 <20201201185506.77c4b3df@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <f22eaead-fd25-8b20-7ca1-ae3f535347d4@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22eaead-fd25-8b20-7ca1-ae3f535347d4@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 09:59:53PM -0700, Jeffrey Hugo wrote:
> On 12/1/2020 7:55 PM, Jakub Kicinski wrote:
> > On Tue, 1 Dec 2020 13:48:36 -0700 Jeffrey Hugo wrote:
> > > On 12/1/2020 1:03 PM, Jakub Kicinski wrote:
> > > > On Tue, 1 Dec 2020 12:40:50 -0700 Jeffrey Hugo wrote:
> > > > > On 12/1/2020 12:29 PM, Jakub Kicinski wrote:
> > > > > > On Fri, 27 Nov 2020 19:26:02 -0800 Hemant Kumar wrote:
> > > > > > > This patch series adds support for UCI driver. UCI driver enables userspace
> > > > > > > clients to communicate to external MHI devices like modem and WLAN. UCI driver
> > > > > > > probe creates standard character device file nodes for userspace clients to
> > > > > > > perform open, read, write, poll and release file operations. These file
> > > > > > > operations call MHI core layer APIs to perform data transfer using MHI bus
> > > > > > > to communicate with MHI device. Patch is tested using arm64 based platform.
> > > > > >
> > > > > > Wait, I thought this was for modems.
> > > > > >
> > > > > > Why do WLAN devices need to communicate with user space?
> > > > >
> > > > > Why does it matter what type of device it is?  Are modems somehow unique
> > > > > in that they are the only type of device that userspace is allowed to
> > > > > interact with?
> > > >
> > > > Yes modems are traditionally highly weird and require some serial
> > > > device dance I don't even know about.
> > > >
> > > > We have proper interfaces in Linux for configuring WiFi which work
> > > > across vendors. Having char device access to WiFi would be a step
> > > > back.
> > >
> > > So a WLAN device is only ever allowed to do Wi-Fi?  It can't also have
> > > GPS functionality for example?
> >
> > No, but it's also not true that the only way to implement GPS is by
> > opening a full on command/packet interface between fat proprietary
> > firmware and custom user space (which may or may not be proprietary
> > as well).
>
> Funny, that exactly what the GPS "API" in the kernel is, although a bit
> limited to the specifics on the standardized GPS "sentences" and not
> covering implementation specific configuration.
>
> >
> > > > > However, I'll bite.  Once such usecase would be QMI.  QMI is a generic
> > > > > messaging protocol, and is not strictly limited to the unique operations
> > > > > of a modem.
> > > > >
> > > > > Another usecase would be Sahara - a custom file transfer protocol used
> > > > > for uploading firmware images, and downloading crashdumps.
> > > >
> > > > Thanks, I was asking for use cases, not which proprietary vendor
> > > > protocol you can implement over it.
> > > >
> > > > None of the use cases you mention here should require a direct FW -
> > > > user space backdoor for WLAN.
> > >
> > > Uploading runtime firmware, with variations based on the runtime mode.
> > > Flashing the onboard flash based on cryptographic keys.  Accessing
> > > configuration data.  Accessing device logs.  Configuring device logs.
> > > Synchronizing the device time reference to Linux local or remote time
> > > sources.  Enabling debugging/performance hardware.  Getting software
> > > diagnostic events.  Configuring redundancy hardware per workload.
> > > Uploading new cryptographic keys.  Invalidating cryptographic keys.
> > > Uploading factory test data and running factory tests.
> > >
> > > Need more?
> >
> > This conversation is going nowhere. Are you trying to say that creating
> > a common Linux API for those features is impossible and each vendor
> > should be allowed to add their own proprietary way?
> >
> > This has been proven incorrect again and again, and Wi-Fi is a good
> > example.
> >
> > You can do whatever you want for GPS etc. but don't come nowhere near
> > networking with this attitude please.
> >
>
> No I'm saying (and Bjorn/Mani by the looks of things), that there is
> commonality in the core features - IP traffic, Wi-Fi, etc but then there are
> vendor specific things which are either things you don't actually want in
> the kernel, don't want the kernel doing, or have little commonality between
> vendors such that attempting to unify them gains you little to nothing.
>
> Over in the networking space, I can see where standardization is plenty
> useful.
>
> I can't speak for other vendors, but a "modem" or a "wlan" device from
> Qualcomm is not something that just provides one service.  They tend to
> provide dozens of different functionalities, some of those are
> "standardized" like wi-fi where common wi-fi interfaces are used. Others are
> unique to Qualcomm.
>
> The point is "wlan device" is a superset of "wi-fi".  You seem to be
> equating them to be the same in a "shoot first, ask questions later" manner.
>
> This series provides a way for userspace to talk to remote MHI "widgets" for
> usecases not covered elsewhere.  Those "widgets" just happen to commonly
> provide modem/wlan services, but ones that don't are not excluded.
>
> Regarding not coming near networking, I'd like to remind you it was you that
> decided to come over here to the non-networking area and try to make this
> about networking.

Like it or not, but Jakub is absolutely right with his claim that
providing user-visible interfaces without any standardization is proven
as wrong.

Thanks

>
> --
> Jeffrey Hugo
> Qualcomm Technologies, Inc. is a member of the
> Code Aurora Forum, a Linux Foundation Collaborative Project.
