Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673C819117C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgCXNns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:43:48 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36503 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgCXNnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:43:47 -0400
Received: by mail-pj1-f67.google.com with SMTP id nu11so1450116pjb.1;
        Tue, 24 Mar 2020 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cjMyCzFsndemlyXlxtjlf/CkB3QYu9IZUo9Mhtw3Nmg=;
        b=KOV9yBr7ujPbdeR9f3fS+ehTTG+yIcvyBqiigdgScE+Ndkyq1DIdwP8dtj2w8qImhZ
         LPL9LZHmcCBFLxUPvajrUN+WSejIUDgFx19nqDQhE6TOv4QPGXRkrU0ZMq/MPeNBcPED
         raxWg+VAe0FmpKvveQXxLVXCuR1UJtjKCNVVhEjfd7MxMidcAoAAYwZDUagXTaJ20g+i
         ryKndtZuBZQJJI0NUo+NabyEm5UFkp3xRpReQ8c1IyLCbJgFaRJpjzD9lR5RXT6np+cM
         MAYulg4b97cbH3U2ncnEa3JIzqQciN/5XcDQVZOjrwyv6j9t0xrfH5nytTgUFdpvBoJM
         i26g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cjMyCzFsndemlyXlxtjlf/CkB3QYu9IZUo9Mhtw3Nmg=;
        b=L9a1pmeCGN8UjcPas2QnOurLyd2j0tVsisCueRjFfDH94CvSC6lxSBShtd6JXdN280
         fRcBxinMKNvIDMR/mm35NeX8UK9l7Ychlkc15CT5umkTpgC4CAktUbH9ZdnmeL7MYRNJ
         8FQIA8L8t8+SwxYQbxxdM0+5x9yRpXNPzlZvc2RCgNQu1l2ccLY60qEKyaHcjOJ/MKn5
         iFNuiSYv6dRYu5pNd1NEYp5UzPjR/JDeHUIDrCOuEMpobRGY1SoPV4PpxOqJFHKQt+kO
         r3eI2dMXlaZxKjtwjZP2si7ofeWMrhYwgMEsr4+VbCPkrKrE1o95723I5L4coNWad095
         9jgQ==
X-Gm-Message-State: ANhLgQ3ZeiQXJF0WTu+VPrxU0DVKrtIOhH03lLXhH164P3nCKW4f24n7
        IwkF1o6s0fH/hTjjIkyeRMg=
X-Google-Smtp-Source: ADFU+vsX0OYFc61qBOPMU/7kig1YoHQyRX11hH+EoJSBKWHEWq+GYvLPqREgpsscs+jJ2yekiJq2Ag==
X-Received: by 2002:a17:90a:bf91:: with SMTP id d17mr5639971pjs.131.1585057425685;
        Tue, 24 Mar 2020 06:43:45 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id n30sm8361446pgc.36.2020.03.24.06.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:43:45 -0700 (PDT)
Date:   Tue, 24 Mar 2020 06:43:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 08/11] net: ethernet: ti: cpts: move rx
 timestamp processing to ptp worker only
Message-ID: <20200324134343.GD18149@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-9-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320194244.4703-9-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:42:41PM +0200, Grygorii Strashko wrote:
> Once CPTS IRQ will be enabled the CPTS irq handler may compete with netif
> RX sofirq path and so RX timestamp might not be ready at the moment packet
> is processed. As result, packet has to be deferred and processed later.

This change is not necessary.  The Rx path can simply take a spinlock,
check the event list and the HW queue.
 
> This patch moves RX timestamp processing tx timestamp processing to PTP
> worker always the same way as it's been done for TX timestamps.

There is no advantage to delaying Rx time stamp delivery.  In fact, it
can degrade synchronization performance.  The only reason the
implementation delays Tx time stamps delivery is because there is no
other way.

Thanks,
Richard
