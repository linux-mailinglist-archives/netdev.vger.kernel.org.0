Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB23254C56
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgH0Rme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgH0Rmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:42:33 -0400
Received: from coco.lan (ip5f5ad5a8.dynamic.kabel-deutschland.de [95.90.213.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A2762087E;
        Thu, 27 Aug 2020 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598550152;
        bh=zyfUowNsWV1AH9t2Y/OhVrtMRfKaUwAivYAzLDicwBM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=07ZU3viQ9K4W/2j7rtUmnY13uTbszZo4JxebwRXpVTU0rbPDvX8crv4sulA5txXDE
         kYmlUOuNr9MdYmatsOfu9hXzg5jshHEN71HClrwf41F7Sbk0qcHLXN5PzjHJnVgRLn
         r0uWVOa7IlmgAj8HdF77sDzEoeitLX/MPi0J6RwU=
Date:   Thu, 27 Aug 2020 19:42:25 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Steve deRosier <derosier@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linuxarm@huawei.com,
        mauro.chehab@huawei.com, John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Maital Hahn <maitalm@ti.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Raz Bouganim <r-bouganim@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Johannes Berg <johannes.berg@intel.com>,
        Fuqian Huang <huangfq.daxian@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "wlcore: Adding suppoprt for IGTK key in wlcore
 driver"
Message-ID: <20200827194225.281eb7dc@coco.lan>
In-Reply-To: <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
References: <f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org>
        <CALLGbRL+duiHFd3w7hcD=u47k+JM5rLpOkMrRpW0aQm=oTfUnA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, 27 Aug 2020 08:48:30 -0700
Steve deRosier <derosier@gmail.com> escreveu:

> On Tue, Aug 25, 2020 at 10:49 PM Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org> wrote:
> >
> > This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
> > with it applied, WiFi stops working, and the Kernel starts printing
> > this message every second:
> >
> >    wlcore: PHY firmware version: Rev 8.2.0.0.242
> >    wlcore: firmware booted (Rev 8.9.0.0.79)
> >    wlcore: ERROR command execute failure 14  
> 
> Only if NO firmware for the device in question supports the `KEY_IGTK`
> value, then this revert is appropriate. Otherwise, it likely isn't.

Yeah, that's what I suspect too: some specific firmware is required
for KEY_IGTK to work.

>  My suspicion is that the feature that `KEY_IGTK` is enabling is
> specific to a newer firmware that Mauro hasn't upgraded to. What the
> OP should do is find the updated firmware and give it a try.

I didn't try checking if linux-firmware tree has a newer version on
it. I'm using Debian Bullseye on this device. So, I suspect that
it may have a relatively new firmware.

Btw, that's also the version that came together with Fedora 32:

	$ strings /lib/firmware/ti-connectivity/wl18xx-fw-4.bin |grep FRev
	FRev 8.9.0.0.79
	FRev 8.2.0.0.242

Looking at:
	https://git.ti.com/cgit/wilink8-wlan/wl18xx_fw/

It sounds that there's a newer version released this year:

	2020-05-28	Updated to FW 8.9.0.0.81
	2018-07-29	Updated to FW 8.9.0.0.79

However, it doesn't reached linux-firmware upstream yet:

	$ git log --pretty=oneline ti-connectivity/wl18xx-fw-4.bin
	3a5103fc3c29 wl18xx: update firmware file 8.9.0.0.79
	65b1c68c63f9 wl18xx: update firmware file 8.9.0.0.76
	dbb85a5154a5 wl18xx: update firmware file
	69a250dd556b wl18xx: update firmware file
	dbe3f134bb69 wl18xx: update firmware file, remove conf file
	dab4b79b3fbc wl18xx: add version 4 of the wl18xx firmware

> AND - since there's some firmware the feature doesn't work with, the
> driver should be fixed to detect the running firmware version and not
> do things that the firmware doesn't support.  AND the firmware writer
> should also make it so the firmware doesn't barf on bad input and
> instead rejects it politely.

Agreed. The main issue here seems to be that the current patch
assumes that this feature is available. A proper approach would 
be to check if this feature is available before trying to use it.

Now, I dunno if version 8.9.0.0.81 has what's required for it to
work - or if KEY_IGTK require some custom firmware version.

If it works with such version, one way would be to add a check
for this specific version, disabling KEY_IGTK otherwise.

Also, someone from TI should be sending the newer version to
be added at linux-firmware.

I'll try to do a test maybe tomorrow.

> But I will say I'm making an educated guess; while I have played with
> the TI devices in the past, it was years ago and I won't claim to be
> an expert. I also am unable to fix it myself at this time.
> 
> I'd just rather see it fixed properly instead of a knee-jerk reaction
> of reverting it simply because the OP doesn't have current firmware.

> And let's revisit the discussion of having a kernel splat because an
> unrelated piece of code fails yet the driver does exactly what it is
> supposed to do. We shouldn't be dumping registers and stack-trace when
> the code that crashed has nothing to do with the registers and
> stack-trace outputted. It is a false positive.  A simple printk WARN
> or ERROR should output notifying us that the chip firmware has crashed
> and why.  IMHO.

Thanks,
Mauro
