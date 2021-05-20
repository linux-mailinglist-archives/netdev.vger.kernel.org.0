Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C9D38B24C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhETOzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhETOzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 10:55:54 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DA1C061574;
        Thu, 20 May 2021 07:54:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id n2so25757687ejy.7;
        Thu, 20 May 2021 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=178KFEaQr/yffNtspook3gOoLrCMMR2ylsFm3IdllnY=;
        b=NaB8bTkhMXKWmMbzTYKEWrsXC/Y+DAxmeu9gSFG2LbR/gFkpZjrgzCD4Yav7RwyI3O
         Oi0bAp1uhFv/hPnE8qzaYtoB3STslwvtvp+3/fDz0YDICri/CYyTEr6/QLOGKfg6cjre
         2StDHpQZrzRrhJqxhlBSpSjJ8pP0FUKTx9woekSZCXWgMcQjPCnSrCzw+64QBU3xuWLy
         z4ppqSr83cqev/SxHqDMdwR/ZOdgTJn3tnzB8krLp3rgH5zHOgWu25L18YOGSb/l91Qz
         fYzj351iznHhmEIPZvlzYAzAJs78ZFZEchyzLKndvulY3qZMe5sXY/JxjYSFuulRafjL
         Hsjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=178KFEaQr/yffNtspook3gOoLrCMMR2ylsFm3IdllnY=;
        b=uCxRfHbJTpF8z4mEktQgS+Srsvpjp1UhlH4m0wJEjvlacpMMuyvI+MXTnjLDHFOb6L
         X4L+UU2ZZiI2ERsaybF125ak2lsHpErEXY1gg2CzbtITO4M0NbZwM4K2qiW6ETweGxvH
         NFwKHUs8wGW2lcHIBybj7MEGrbO7hGJEs8R4rvrAoCFTnEHOPirP7DnWwqzl0AHWrn4N
         un9SPaYNNBhuBHIlIeqCJh7gyihFmDSeowHW+gRZgS2hFcDqtPgn8LaXMS67VX0nnXkO
         pKNOvWFPFcTqDmt5M5CM/dx7AB6+5X9rz1Cb/l78f/DSrN6DzRNIGxLDQi3tTHpKmNpr
         VYtw==
X-Gm-Message-State: AOAM533i9ASjVdTR7CHE8bHZDfu98GDTjOGpYxwrPhjZWJGB8PfeCESP
        OMh0w9rlB+UPnjNIDf3ZMuI=
X-Google-Smtp-Source: ABdhPJzQjI/ka99Z3nsFu6D8+w9ESbu7aLCnstWM8nMIQiRCPivir3+dcrrDYqn9nT+A03T8skldig==
X-Received: by 2002:a17:906:8389:: with SMTP id p9mr5277604ejx.106.1621522471301;
        Thu, 20 May 2021 07:54:31 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k5sm1931401edk.46.2021.05.20.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:54:31 -0700 (PDT)
Date:   Thu, 20 May 2021 17:54:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-spi@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: sja1105: adapt to a SPI controller
 with a limited max transfer size
Message-ID: <20210520145429.yhcaqrhwcl7luazf@skbuf>
References: <20210520135031.2969183-1-olteanv@gmail.com>
 <20210520135615.GB3962@sirena.org.uk>
 <20210520140609.mriocqfabkcflsls@skbuf>
 <20210520142947.GC3962@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520142947.GC3962@sirena.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:29:47PM +0100, Mark Brown wrote:
> On Thu, May 20, 2021 at 05:06:09PM +0300, Vladimir Oltean wrote:
> > On Thu, May 20, 2021 at 02:56:15PM +0100, Mark Brown wrote:
> > > On Thu, May 20, 2021 at 04:50:31PM +0300, Vladimir Oltean wrote:
> 
> > > > Only that certain SPI controllers, such as the spi-sc18is602 I2C-to-SPI
> > > > bridge, cannot keep the chip select asserted for that long.
> > > > The spi_max_transfer_size() and spi_max_message_size() functions are how
> > > > the controller can impose its hardware limitations upon the SPI
> > > > peripheral driver.
> 
> > > You should respect both, frankly I don't see any advantage to using
> > > cs_change for something like this - just do a bunch of async SPI
> > > transfers and you'll get the same effect in terms of being able to keep
> > > the queue for the controller primed with more robust support since it's
> > > not stressing edge cases.  cs_change is more for doing things that are
> > > just very non-standard.
> 
> > Sorry, I don't really understand your comment: in which way would it be
> > more robust for my use case to use spi_async()?
> 
> Your description sounds like the driver is just stitching a bunch of
> messages together into a single big message with lots of cs_changes with
> the goal of improving performance which is really not using the API at
> all idiomatically.  That's at best asking for trouble (it'll certainly
> work with fewer controllers), it may even be less performant as you're
> less likely to get the benefit of framework enhancements.

Stitching a bunch of s/messages/transfers/, but yes, that is more or
less correct. I think cs_change is pretty well handled with the SPI
drivers I've had the pleasure so far. The spi-sc18is602.c driver has had
no changes in this area since its introduction in 2012 and it worked out
of the box (well, except for the maximum buffer length limit, which I
was expecting even before I had my hands on the hardware, since it is
explained here:
https://www.kernel.org/doc/html/latest/spi/spi-sc18is602.html).
SPI controllers that don't treat cs_change properly can always be
patched, although there is a sizable user base for this feature at the
moment from what I can see, so the semantics are pretty clear to me (and
the sja1105 is in line with them).

> > The cs_change logic was already there prior to this patch, I am just
> > reiterating how it works. Given the way in which it works (which I think
> 
> It seems like you could avoid this issue and most likely other future
> issues by making the way the driver uses the API more normal.

Does this piece of advice mean "don't use cs_change"? Why does it exist
then? I'm confused. Is it because the max_*_size properties are not well
defined in its presence? Isn't that a problem with the self-consistency
of the SPI API then?

> > is correct), the most natural way to limit the buffer length is to look
> > for the max transfer len.
> 
> No, you really do need to pay attention to both - what makes you think
> it is safe to just ignore one of them?

I think the sja1105 is safe to just ignore the maximum message length
because "it knows what it's doing" (famous last words). The only real
question is "what does .max_message_size count when its containing
spi_transfers have cs_change set?", and while I can perfectly understand
why you'd like to avoid that question, I think my interpretation is the
sane one (it just counts the pieces with continuous CS), and I don't see
the problems that this interpretation can cause down the line.

If you want to, I can just resend the spi-sc18is602 patch without
master->max_message_size implemented, and voila, I'm not ignoring it any
longer :)
https://patchwork.kernel.org/project/spi-devel-general/patch/20210520131238.2903024-3-olteanv@gmail.com/
