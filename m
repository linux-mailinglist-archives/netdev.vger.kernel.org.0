Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE89316F01
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhBJSoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:44:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhBJSmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 919AD64E16;
        Wed, 10 Feb 2021 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612982490;
        bh=XgP03GM5rkGUCwpgxJpGaI0tT3DNsJVXchGDzh6j1hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MEFkVIa6UfYMXfntzDOMuVFmJrM7E5ceftlVeGUdxE41afIlXmWt7/kcRx73hl83J
         wYYuJNInXpScSjwW4bBQhpPW7Hp2KGIb/B0DG1ouWcjpA8NUDwRBXLe614zWDOea1P
         jmUquVg0xO4R6ubhx+c5h5cVOlhjL8zXvtnlDs9CZ918TRTgzdnfUeHlWX/3yQGmxD
         f75dTDNFKEefws7zXFbXqq6k2Kh8LA32G/JPOCQI1W5iWvB/bH3No5rhfYMbvhqsQy
         fp0Jrfn6WhtKH38ZVuH/9i4CiHf6a5Bn+JbvB/Kgpv72JXErDsYpJWOFxV0tPT8kg+
         9cjpt4Pnx3thg==
Date:   Wed, 10 Feb 2021 10:41:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210210062531.GA13668@work>
References: <YBfi573Bdfxy0GBt@kroah.com>
        <20210201121322.GC108653@thinkpad>
        <20210202042208.GB840@work>
        <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
        <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
        <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
        <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210210062531.GA13668@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 11:55:31 +0530 Manivannan Sadhasivam wrote:
> On Tue, Feb 09, 2021 at 08:17:44AM -0800, Jakub Kicinski wrote:
> > On Tue, 9 Feb 2021 10:20:30 +0100 Aleksander Morgado wrote:  
> > > This may be a stupid suggestion, but would the integration look less a
> > > backdoor if it would have been named "mhi_wwan" and it exposed already
> > > all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
> > > QMI?  
> > 
> > What's DIAG? Who's going to remember that this is a backdoor driver 
> > a year from now when Qualcomm sends a one liner patches which just 
> > adds a single ID to open another channel?  
> 
> I really appreciate your feedback on this driver eventhough I'm not
> inclined with you calling this driver a "backdoor interface". But can
> you please propose a solution on how to make this driver a good one as
> per your thoughts?
> 
> I really don't know what bothers you even if the userspace tools making
> use of these chardevs are available openly (you can do the audit and see
> if anything wrong we are doing).

What bothers me is maintaining shim drivers which just shuttle opaque
messages between user space and firmware. One of which definitely is,
and the other may well be, proprietary. This is an open source project,
users are supposed to be able to meaningfully change the behavior of
the system.

What bothers me is that we have 3 WWAN vendors all doing their own
thing and no common Linux API for WWAN. It may have been fine 10 years
ago, but WWAN is increasingly complex and important.

> And exposing the raw access to the
> hardware is not a new thing in kernel. There are several existing
> subsystems/drivers does this as pointed out by Bjorn. Moreover we don't
> have in-kernel APIs for the functionalities exposed by this driver and
> creating one is not feasible as explained by many.
> 
> So please let us know the path forward on this series. We are open to
> any suggestions but you haven't provided one till now.

Well. You sure know how to aggravate people. I said clearly that you
can move forward on purpose build drivers (e.g. for WWAN). There is no
way forward on this common shim driver as far as I'm concerned.
