Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0499C348DF1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCYK0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCYK0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:26:23 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC51FC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:26:22 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so1418184otn.10
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 03:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oOSO3gtp1KeT2tdcKr9tnUm5Fcr5uXjV2hxN+UXFQDY=;
        b=nr2lmisAHr8h6q7zUYEZhJQHtSMhfspaQY+TSWLBrJqMr9L5/nJT8KzvLtwHYDm74Z
         Cj7r9qBZzhGpRzfQdag/c2uFqBFlGxop8dPBZUgrVxH3tdMu7R053yQDiprk2QqCc/Ju
         KKajz+KXAQeAWIu6AJ5ykeCWoCYB0dHcWTdNlch7Seh6IRIIVUSWxjPDV788TTfKPyfJ
         o9hPXk5fcCDhckvYaHsQGLCe/zhvgforeo78BClMgZ8Hsvut5gtEKi/gtNYLD6yNgaeN
         LiN21WFHVaw2FN6Y4u4+7A852vSYXkwzBbn3y0RcNzI0UCiJOgBc7JUSK2Pi/en8LKI6
         iM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=oOSO3gtp1KeT2tdcKr9tnUm5Fcr5uXjV2hxN+UXFQDY=;
        b=EIB62L4qxuDNw2FjqN0eMyy48q8iVB9lpj+VTuLd4d/MIDM5+aXQ4DN1KOr51SLsKC
         bD7asfk4D1B+o81u2nqpWuz3AM0dxrrCjPqMVuk3RYaoCs7G+LIL0LP/nPB1xL9lnnLp
         A3mNdVYryHhE+Vy+xGnHezTl851G2ATtqD8BUgjA7S2WdIZ+879zt/VPQXh0pWXrqFN1
         RoK4ak4yQRmc57AGGhtvywmU/I8uHZRcD8T5HhM9ANqDBB0+uZT+N5yTvYFO7TVWqNr7
         RJ1q0kTWKGj0gP8qKRkYz4aCNnhssYco2rRJJ/mAJ5R+/j7q2/awvOuFNjsdRl12BW9A
         CgTw==
X-Gm-Message-State: AOAM533EyWfADpOSN4p3lEjF2Y3qtbjpEc8WgQ4n0rToe6GRe72QK90j
        vNywalYAF8Dggh5PnN+G1+E=
X-Google-Smtp-Source: ABdhPJzJHdnkAjFYliWkZBoeyJ2ZteQxE3iMSus5nXUEiN8sQSP9RwWf0olY5BEjXjI62vdFxSrpvA==
X-Received: by 2002:a05:6830:15c5:: with SMTP id j5mr6891422otr.274.1616667981978;
        Thu, 25 Mar 2021 03:26:21 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m19sm1185020oop.6.2021.03.25.03.26.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 03:26:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 25 Mar 2021 03:26:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64
 calcalation
Message-ID: <20210325102620.GA121097@roeck-us.net>
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
 <20210325102307.GA163632@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325102307.GA163632@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 03:23:07AM -0700, Guenter Roeck wrote:
> On Tue, Mar 23, 2021 at 04:02:29PM +0800, Yangbo Lu wrote:
> > Current calculation for diff of TMR_ADD register value may have
> > 64-bit overflow in this code line, when long type scaled_ppm is
> > large.
> > 
> > adj *= scaled_ppm;
> > 
> > This patch is to resolve it by using mul_u64_u64_div_u64().
> > 
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > Acked-by: Richard Cochran <richardcochran@gmail.com>
> > ---
> >  drivers/ptp/ptp_qoriq.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
> > index 68beb1bd07c0..f7f220700cb5 100644
> > --- a/drivers/ptp/ptp_qoriq.c
> > +++ b/drivers/ptp/ptp_qoriq.c
> > @@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> >  	tmr_add = ptp_qoriq->tmr_add;
> >  	adj = tmr_add;
> >  
> > -	/* calculate diff as adj*(scaled_ppm/65536)/1000000
> > -	 * and round() to the nearest integer
> > +	/*
> > +	 * Calculate diff and round() to the nearest integer
> > +	 *
> > +	 * diff = adj * (ppb / 1000000000)
> > +	 *      = adj * scaled_ppm / 65536000000
> >  	 */
> > -	adj *= scaled_ppm;
> > -	diff = div_u64(adj, 8000000);
> > -	diff = (diff >> 13) + ((diff >> 12) & 1);
> > +	diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);
> 
> mul_u64_u64_div_u64() is not exported. As result, every build with
> CONFIG_PTP_1588_CLOCK_QORIQ=m (ie every allmodconfig build) fails with:
> 
> ERROR: modpost: "mul_u64_u64_div_u64" [drivers/ptp/ptp-qoriq.ko] undefined!
> 
> or a similar error.
> 
Ah, never mind. I see this is fixed in mainline (export added).
I see the problem in pending-fixes and in next-20210325.

Sorry for the noise.

Guenter
