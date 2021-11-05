Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B394144657B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhKEPMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 11:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhKEPMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 11:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A3E660F36;
        Fri,  5 Nov 2021 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636124980;
        bh=y22Owe3WsOyK/XyUDi4v5MjW8f8Cqs3vQzTjwWumqwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ryd+zHE7ncWjFfazijXbytqlPP7euhlaAXbEN8UU+CvwAcwQ1UbN/1W33jZhPOmxJ
         bW9/jwjaVMqXW+bodI1nMZioXnSuawGLlyaWyJlWcq1E6VKd/APgCFk2M/Xh6A/ME1
         EsaTuUeXBoh8ak2zTgD4EeB1D/V5OoGIkX7pTnKb7b4LpfrFzFIJwcTte5jhccit30
         a+ToWYFsFzMxxsm4MMSia1YtE3PlR6p+NwrBdASu6sH2fydwXYWQ2evLGJABbK5m+v
         94KGNXvfT9kSgaP2uzrO7WmsiZvo41pPSLXaNLSqHkZUU8owI+laLJGzIdiFHN7eqm
         w4pAWO6qZMpcg==
Date:   Fri, 5 Nov 2021 08:09:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Message-ID: <20211105080939.2508a51e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211105142833.nv56zd5bqrkyjepd@skbuf>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
        <20211104133204.19757-8-martin.kaistra@linutronix.de>
        <20211104174251.GB32548@hoboy.vegasvil.org>
        <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
        <20211105141319.GA16456@hoboy.vegasvil.org>
        <20211105142833.nv56zd5bqrkyjepd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Nov 2021 16:28:33 +0200 Vladimir Oltean wrote:
> On Fri, Nov 05, 2021 at 07:13:19AM -0700, Richard Cochran wrote:
> > On Fri, Nov 05, 2021 at 02:38:01PM +0100, Martin Kaistra wrote:  
> > > Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) from
> > > this list, what about HWTSTAMP_FILTER_ALL?  
> > 
> > AKK means time stamp every received frame, so your driver should
> > return an error in this case as well.  
> 
> What is the expected convention exactly? There are other drivers that
> downgrade the user application's request to what they support, and at
> least ptp4l does not error out, it just prints a warning.

Which is sad because that's one of the best documented parts of our API:

  Desired behavior is passed into the kernel and to a specific device by
  calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
  ifr_data points to a struct hwtstamp_config. The tx_type and
  rx_filter are hints to the driver what it is expected to do. If
  the requested fine-grained filtering for incoming packets is not
  supported, the driver may time stamp more than just the requested types
  of packets.

  Drivers are free to use a more permissive configuration than the requested
  configuration. It is expected that drivers should only implement directly the
  most generic mode that can be supported. For example if the hardware can
  support HWTSTAMP_FILTER_V2_EVENT, then it should generally always upscale
  HWTSTAMP_FILTER_V2_L2_SYNC_MESSAGE, and so forth, as HWTSTAMP_FILTER_V2_EVENT
  is more generic (and more useful to applications).

  A driver which supports hardware time stamping shall update the struct
  with the actual, possibly more permissive configuration. If the
  requested packets cannot be time stamped, then nothing should be
  changed and ERANGE shall be returned (in contrast to EINVAL, which
  indicates that SIOCSHWTSTAMP is not supported at all).

https://www.kernel.org/doc/html/latest/networking/timestamping.html#hardware-timestamping-configuration-siocshwtstamp-and-siocghwtstamp
