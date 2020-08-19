Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3DC24A3E1
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgHSQUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHSQT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:19:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F474C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 09:19:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so11907848pfx.13
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 09:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8eAqA35Qf/4tjfc1n8A1JN4bhkmkwDvEPeJXv/FFPXk=;
        b=Lz62BD5N+YqUO3mnfinrxMsnZRq5vkVKPiAQnmveJrzNCwQEYt+dO/8zgsg8g8krfL
         6GECs0D573jH7IJtmPHEY+yGDVCzSeVf4/Vm5QPdfoqUFwCDx67jKUklUY1vQ6csJD03
         kBSm/F/sHohMEtI1ZQ3p31oIGrGHkx2manqDqaXXN6UTZpBfA1QK970+nz+XdiCJhRbA
         zltPeGhphcxLufkf9ygWTpoomyXl94/nrC1ccBYfcMrm0xvBo8VIhoVFo60hD+ZKdBO5
         B+g50PphLGtTOmHmoKqo4ZPbd4svMMOd5ILbQ8Dom5rj4Eq1sIxNh3C4PrMO3WUXQS35
         OOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8eAqA35Qf/4tjfc1n8A1JN4bhkmkwDvEPeJXv/FFPXk=;
        b=XB+q0em/VO+DMksmxxaEBQib4JCZnhD7nbzsVyVlc/uBbN7yxyKZW2DWx5RQrgjVBF
         xG3d+y5AgB3ur8WF3zOE2xv+r0A+bfA82ZITAlqfJJF8lVSDR+fMuVO5WJ3uU6/mI0m+
         uwKywFnUavbiwbp3EWDadKc84vOBSEe0Nnya4WiilnQgMQEzpdl3egMV/uTSFzGzy7IY
         nKKGZUcCR8MAHOp9AaLaGjYEmFWFrgvcCjZkjRrK66s3J+HKQtkDJX92sEbDteriBUoh
         XSma5tZUo6Qtq4qgIsOT2AH0E/DpM5McVA2Gp5nZzVtdcUeWRQM92P1FCeTsHvi2lFt2
         MxkQ==
X-Gm-Message-State: AOAM532won4kDU4CrTBDXGsBopXXb0NhBO1042me2nWkE+PGXta6QKYG
        5FkWoeX4CcDpno6evD03egU=
X-Google-Smtp-Source: ABdhPJzN5fX5ooauqrGHsG6rfKdG60N1JGqemwfItKIhE1tuRIzCUgvS9vA104FxDVFbFYuFOamiGg==
X-Received: by 2002:a65:468f:: with SMTP id h15mr17344517pgr.189.1597853995538;
        Wed, 19 Aug 2020 09:19:55 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id na14sm3213373pjb.6.2020.08.19.09.19.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Aug 2020 09:19:54 -0700 (PDT)
Date:   Wed, 19 Aug 2020 09:19:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH NET] net: atlantic: Use readx_poll_timeout() for large
 timeout
Message-ID: <20200819161953.GA179916@roeck-us.net>
References: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 06:14:39PM +0200, Sebastian Andrzej Siewior wrote:
> Commit
>    8dcf2ad39fdb2 ("net: atlantic: add hwmon getter for MAC temperature")
> 
> implemented a read callback with an udelay(10000U). This fails to
> compile on ARM because the delay is >1ms. I doubt that it is needed to
> spin for 10ms even if possible on x86.
> 
> >From looking at the code, the context appears to be preemptible so using
> usleep() should work and avoid busy spinning.
> 
> Use readx_poll_timeout() in the poll loop.
> 
> Cc: Mark Starovoytov <mstarovoitov@marvell.com>
> Cc: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Fixes: 8dcf2ad39fdb2 ("net: atlantic: add hwmon getter for MAC temperature")
Acked-by: Guenter Roeck <linux@roeck-us.net>

As in: This patch does not cause any additional trouble and will fix the
observed compile failure. However, the submitter of 8dcf2ad39fdb2 might
consider adding a mutex either into hw_atl_b0_get_mac_temp() or into
the calling code.

Thanks,
Guenter

> ---
> 
> Could someone with hardware please verify it? It compiles, yes.
> 
>  drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> index 16a944707ba90..8941ac4df9e37 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
> @@ -1631,8 +1631,8 @@ static int hw_atl_b0_get_mac_temp(struct aq_hw_s *self, u32 *temp)
>  		hw_atl_ts_reset_set(self, 0);
>  	}
>  
> -	err = readx_poll_timeout_atomic(hw_atl_b0_ts_ready_and_latch_high_get,
> -					self, val, val == 1, 10000U, 500000U);
> +	err = readx_poll_timeout(hw_atl_b0_ts_ready_and_latch_high_get, self,
> +				 val, val == 1, 10000U, 500000U);
>  	if (err)
>  		return err;
>  
> -- 
> 2.28.0
> 
