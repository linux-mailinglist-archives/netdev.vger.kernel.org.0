Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3428E0A8
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgJNMnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 08:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbgJNMni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 08:43:38 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8447720848;
        Wed, 14 Oct 2020 12:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602679417;
        bh=jW0i/QQSQbgHdq+AcCmwrK02JHOb8iHkGsSyJ9m/xxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D56R7MepUimHoXTW8BAKEcxBCdmFAGZZt2vGgj8O0TSMzweDfN+v2d/7pi1G2qKXs
         EpH1ZWCUEhPzupaupQcWTnSQDXehpQ+tXteOJSA7dNuJNnf0OIJkbNasyMa/7KTgmH
         b9SjangPukrd+RMj2fT+KfjxZzl9V8ekOr+Fy5gA=
Received: by pali.im (Postfix)
        id 190F66EE; Wed, 14 Oct 2020 14:43:35 +0200 (CEST)
Date:   Wed, 14 Oct 2020 14:43:34 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
Message-ID: <20201014124334.lgx53qvtgkmfkepc@pali>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
 <20201012104648.985256-8-Jerome.Pouiller@silabs.com>
 <20201013201156.g27gynu5bhvaubul@pali>
 <2628294.9EgBEFZmRI@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2628294.9EgBEFZmRI@pc-42>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 14 October 2020 13:52:15 Jérôme Pouiller wrote:
> Hello Pali,
> 
> On Tuesday 13 October 2020 22:11:56 CEST Pali Rohár wrote:
> > Hello!
> > 
> > On Monday 12 October 2020 12:46:32 Jerome Pouiller wrote:
> > > +#define SDIO_VENDOR_ID_SILABS        0x0000
> > > +#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
> > > +static const struct sdio_device_id wfx_sdio_ids[] = {
> > > +     { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> > 
> > Please move ids into common include file include/linux/mmc/sdio_ids.h
> > where are all SDIO ids. Now all drivers have ids defined in that file.
> > 
> > > +     // FIXME: ignore VID/PID and only rely on device tree
> > > +     // { SDIO_DEVICE(SDIO_ANY_ID, SDIO_ANY_ID) },
> > 
> > What is the reason for ignoring vendor and device ids?
> 
> The device has a particularity, its VID/PID is 0000:1000 (as you can see
> above). This value is weird. The risk of collision with another device is
> high.

Those ids looks strange. You are from Silabs, can you check internally
in Silabs if ids are really correct? And which sdio vendor id you in
Silabs got assigned for your products?

I know that sdio devices with multiple functions may have different sdio
vendor/device id particular function and in common CIS (function 0).

Could not be a problem that on one place is vendor/device id correct and
on other place is that strange value?

I have sent following patch (now part of upstream kernel) which exports
these ids to userspace:
https://lore.kernel.org/linux-mmc/20200527110858.17504-2-pali@kernel.org/T/#u

Also for debugging ids and information about sdio cards, I sent another
patch which export additional data:
https://lore.kernel.org/linux-mmc/20200727133837.19086-1-pali@kernel.org/T/#u

Could you try them and look at /sys/class/mmc_host/ attribute outputs?

> So, maybe the device should be probed only if it appears in the DT. Since
> WF200 targets embedded platforms, I don't think it is a problem to rely on
> DT. You will find another FIXME further in the code about that:
> 
> +               dev_warn(&func->dev,
> +                        "device is not declared in DT, features will be limited\n");
> +               // FIXME: ignore VID/PID and only rely on device tree
> +               // return -ENODEV;
> 
> However, it wouldn't be usual way to manage SDIO devices (and it is the
> reason why the code is commented out).
> 
> Anyway, if we choose to rely on the DT, should we also check the VID/PID?
> 
> Personally, I am in favor to probe the device only if VID/PID match and if
> a DT node is found, even if it is not the usual way.

Normally all sdio devices are hotplugged in linux kernel based on sdio
device and vendor ids. And these ids are unique identifiers of sdio
devices. So should be enough for detection.

Months ago I have checked it and moved all SDIO device and vendor ids
into common include/linux/mmc/sdio_ids.h file. I would like to not have
this "mess" again, which was basically fully cleaned.

I'm adding linux-mmc mailing list and Ulf Hansson to loop.

Ulf, can you look at this "problem"? What do you think about those
"strange" sdio ids?
