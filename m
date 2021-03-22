Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74129343EBD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCVLBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhCVLBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:01:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A281FC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:01:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ce10so20469062ejb.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 04:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2VNAcL0bmn6wDd3zfPUuqlULxat0uBMCKD1hBB/rr9g=;
        b=lr1v0U+HjgDrs8dKsWEozadN+Vf4O8KNcQiWA0XFBFxIkYNbBnIFS0ol2IazzZrtuS
         7Ni1lHbTL8vMlwbaYyeHtp2zdJf9iEb33+QYisLHIJxyV7z2cxOzRRF6jZCCDMVK2yhR
         Z0qf8tj8lF7qMjTzgPIeNAo1F4p2kvGZqWUKLKLmE2sQELNy/L3nCtH3MYlrEEXqjNU5
         bNj6enmIpqpPAmUaNbOGb9WNu5X4dF15EbS+JvurJgeOVNsCNkdLWqNAdhei1K1a3DSq
         iUmnjqm6eGIcIyAYfbMmUnQzZV5dXQ87Sh+LS/MIFP+T6iizFrbnLnhS8tahnNS4bI63
         6fXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2VNAcL0bmn6wDd3zfPUuqlULxat0uBMCKD1hBB/rr9g=;
        b=rneoNBt/T6AQVGO092vlgGcuWGlKh22eVQ8Z/csK5kLgHb4L9KLD+dFL2K1+H6b3PO
         +fNKUGtHr8HhNL2lrLLDdV1Cy0xSSOMnK81CxM48aeCK4d35vIb2D/jxKUXEihpqoICZ
         X2MnbBv+nptTw3ID4/Ai0vpkWLabHNfHJJm1lISb8MY/KQe9u0wCDrCPdpzqQ113fvVj
         bxRTXfCsc+reIbJJPYmuDU4AAOU0xGgwHuL7Cu/Bu9zWPKBIJ15Bz+zQzJDJ3FVs/Fe9
         3lNfxoDMpGwqrDniaLWPXqQNvyj/iqzofLloDFjjvEkH6BgRBdvwXHw91AOsmL2nbzrK
         KXmQ==
X-Gm-Message-State: AOAM532l261MW0zRnPM+v0i7V79nYBZ8iLQgvvpYWbB/RqzlHZuFaeP6
        9O3+u1CN93aUBPoWazgk1Pe4lcYXWXY=
X-Google-Smtp-Source: ABdhPJz3PCWmpEefByiSFjnkypDiHTHjHzGLyBiX24ep/oSvTQgiSlTuqks0mCd+PQzVUdm4y2ajuA==
X-Received: by 2002:a17:906:2b0a:: with SMTP id a10mr18733497ejg.513.1616410888237;
        Mon, 22 Mar 2021 04:01:28 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 90sm11479793edf.31.2021.03.22.04.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:01:27 -0700 (PDT)
Date:   Mon, 22 Mar 2021 13:01:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        yoshfuji@linux-ipv6.org, michael@walle.cc
Subject: Re: [PATCH net-next] net: ipconfig: avoid use-after-free in
 ic_close_devs
Message-ID: <20210322110126.p3yzgkaojjngnciv@skbuf>
References: <20210210235703.1882205-1-olteanv@gmail.com>
 <20210322105733.20080-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322105733.20080-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

On Mon, Mar 22, 2021 at 11:57:33AM +0100, Heiko Thiery wrote:
> Hi Vladimir and all,
> 
> > Due to the fact that ic_dev->dev is kept open in ic_close_dev, I had
> > thought that ic_dev will not be freed either. But that is not the case,
> > but instead "everybody dies" when ipconfig cleans up, and just the
> > net_device behind ic_dev->dev remains allocated but not ic_dev itself.
> > 
> > This is a problem because in ic_close_devs, for every net device that
> > we're about to close, we compare it against the list of lower interfaces
> > of ic_dev, to figure out whether we should close it or not. But since
> > ic_dev itself is subject to freeing, this means that at some point in
> > the middle of the list of ipconfig interfaces, ic_dev will have been
> > freed, and we would be still attempting to iterate through its list of
> > lower interfaces while checking whether to bring down the remaining
> > ipconfig interfaces.
> > 
> > There are multiple ways to avoid the use-after-free: we could delay
> > freeing ic_dev until the very end (outside the while loop). Or an even
> > simpler one: we can observe that we don't need ic_dev when iterating
> > through its lowers, only ic_dev->dev, structure which isn't ever freed.
> > So, by keeping ic_dev->dev in a variable assigned prior to freeing
> > ic_dev, we can avoid all use-after-free issues.
> > 
> > Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/ipv4/ipconfig.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> > index f9ab1fb219ec..47db1bfdaaa0 100644
> > --- a/net/ipv4/ipconfig.c
> > +++ b/net/ipv4/ipconfig.c
> > @@ -309,6 +309,7 @@ static int __init ic_open_devs(void)
> >   */
> >  static void __init ic_close_devs(void)
> >  {
> > +	struct net_device *selected_dev = ic_dev->dev;
> 
> This will causes a kernel panic when ic_dev is not valid.
> 
> See log output here: https://lavalab.kontron.com/scheduler/job/12453
> 
> >  	struct ic_device *d, *next;
> >  	struct net_device *dev;
> >  
> > @@ -322,7 +323,7 @@ static void __init ic_close_devs(void)
> >  		next = d->next;
> >  		dev = d->dev;
> >  
> > -		netdev_for_each_lower_dev(ic_dev->dev, lower_dev, iter) {
> > +		netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
> >  			if (dev == lower_dev) {
> >  				bring_down = false;
> >  				break;
> > -- 
> > 2.25.1
> 
> 
> I can fix my issue with this:
> 
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index 47db1bfdaaa0..6f1df4336153 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -309,7 +309,6 @@ static int __init ic_open_devs(void)
>   */
>  static void __init ic_close_devs(void)
>  {
> -       struct net_device *selected_dev = ic_dev->dev;
>         struct ic_device *d, *next;
>         struct net_device *dev;
>  
> @@ -323,10 +322,13 @@ static void __init ic_close_devs(void)
>                 next = d->next;
>                 dev = d->dev;
>  
> -               netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
> -                       if (dev == lower_dev) {
> -                               bring_down = false;
> -                               break;
> +               if (ic_dev) {
> +                       struct net_device *selected_dev = ic_dev->dev;
> +                       netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
> +                               if (dev == lower_dev) {
> +                                       bring_down = false;
> +                                       break;
> +                               }
>                         }
>                 }
>                 if (bring_down) {
> 
> 
> What do you think? Is this valid?
> 
> Thank you.
> -- 
> Heiko

I guess you're the right person to give me a Reviewed-by/Tested-by here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210322002637.3412657-1-olteanv@gmail.com/
