Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0193881A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 12:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfFGKm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 06:42:56 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59484 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfFGKm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 06:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lj8DwDhTbmbeNcSNnHB80GkseCcsUA06K+/VjZ4a8a8=; b=vvrFYb31xcWsEJ5vf9iLUK8bV
        Gsz7hLE7NNjam9vFRdkBAa5QULeW/rXEZ53SsnX2vCRCd0cATC4d6aZ2XUVsefiIONaWqF62MEXon
        HrhTjIw1V8/d0bALhdPu45Z0BHeGfOgTOuplFdl3KWxq403DFeT6LdcPORB9YzWfq8zOrTuwhRyMq
        /78j8kfqRoTy0hWBiDYx6hKqREwClWp4BiJGbiY2Vu1VWtCxLIfzXnhY4r7GT6ILDPf+cBiSl7b6r
        A2xQ7aUrXmqzYZ1Wtz5mJ0+WUiD8qgMhXeEDFEjIUlVZlVQryGwvgjr3X3niaryN/YRjeoB139kTg
        +e3EoKBMw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38560)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hZCKi-0003gD-JQ; Fri, 07 Jun 2019 11:42:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hZCKh-0004Fy-EN; Fri, 07 Jun 2019 11:42:51 +0100
Date:   Fri, 7 Jun 2019 11:42:51 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: sfp: Stop SFP polling and interrupt
 handling during shutdown
Message-ID: <20190607104251.opqdsgjbyweb2rfg@shell.armlinux.org.uk>
References: <1559844377-17188-1-git-send-email-hancock@sedsystems.ca>
 <20190606180908.ctoxi7c4i2uothzn@shell.armlinux.org.uk>
 <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a329ee9-4292-44a2-90eb-a82ca3de03f3@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:57:22PM -0600, Robert Hancock wrote:
> The idea there was to deal with the case where GPIO interrupts were
> previously raised before shutdown and not yet handled by the threaded
> interrupt handler by the time shutdown is called. After shutdown on the
> SFP completes, the bus the GPIO stuff is on could potentially be shut
> down at any moment, so we really don't want to be digging into the GPIO
> states after that. Locking the mutex there ensures that we don't read a
> stale value for the shutdown flag in the interrupt handler, since AFAIK
> there's no other synchronization around that value.

There are two cases:

1) The interrupt is raised just as sfp_shutdown() is called but before
   the mutex is taken.  We will get the full processing in this case.

2) The interrupt is raised during the mutex-locked bit of sfp_shutdown()
   or after the mutex in sfp_shutdown() is released.  We will get the
   abbreviated processing.

This means that the mutex doesn't provide any protection against full
interrupt processing if it occurs just prior to or during the initial
execution of sfp_shutdown().

All that we need to ensure is that the state of sfp->shutdown is
visible by the time sfp_shutdown() returns, and that none of the
interrupt and worker functions are executing.  We have the worker
functions covered by the synchronous cancelling of them, but not the
interrupts, and as Florian points out, it's probably better to disable
the interrupts, and again, that can be done synchronously to ensure
that the handlers are not running.

If the workers and interrupt handlers are synchronously disabled, we
can be sure by the end of sfp_shutdown() that none of those paths are
executing, so the next time something attempts to trigger them, they
will see sfp->shutdown is set.

I'm not convinced that we even need sfp->shutdown if we have cancelled
the workers and disabled the interrupts.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
