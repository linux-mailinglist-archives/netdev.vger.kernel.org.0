Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FC322C37
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhBWO2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhBWO2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:28:09 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F25C06174A;
        Tue, 23 Feb 2021 06:27:29 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o6so2012142pjf.5;
        Tue, 23 Feb 2021 06:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3iZSwnKzPYQQG7Iy7lq52a5tBvSjAgaxWW6X97nL+Dc=;
        b=SMWfomH1bBU1+vvLVEYUgw4rc91OCFMZPGgQmNdrvjX/s4aVemTKD0a75pbe3zoIxV
         kphe991YlBaT98O35BZdJdRwKdLa/NkzpemciiAgcUqj6EYKMDIE8i8BPZw32Z/bgQA5
         WXXODhTp/fSchyMlarTk3q0aP/+/yrFvtKf0CkSiiBU4LAAGsUujPCmiTpahX4volinz
         X4YzKwNFDikcsLWG/qAwnyraECVK8fIi6tFxJM212aFHmuuN3SVUA6gzER0VNgbA/B9c
         5MORmJsoE0Yd2ntLhjxSCUrD5oKE0w3YaoTFLxJzO7uTGBKTsjtnlHcw6sUTeMee/Lj6
         /19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3iZSwnKzPYQQG7Iy7lq52a5tBvSjAgaxWW6X97nL+Dc=;
        b=TrmMoSQp2hMYKk7aZsVUkrLGAmL8a2BAEUbNBwtdDE/k0VijfXdL0lSECsvemjTSh8
         1yUkPRn4n/SN6ZZjRKhfDJDBIYC8x2BwVQBQR9iDHmIizZ9ycFu/BjMbyC3uMOVioWD7
         cQjuYecasBwOuZprRhvKSX3zadBH77N0yKv4A3mGwQJHLVA+0bNvVsmGDx9KfshiVeq9
         rcODmeHzxtg7H/kCgukBrs3XUsMB24T6iqF2nh/7S46aWDOvvkvBVfixRFXFr9om/LbO
         qvKo2mk4+2WTVnARGY00hZm7uKrjWMBLxn+POGlyt6o8Oi6AYgGVOMOsVujhBgYX35BU
         PFzA==
X-Gm-Message-State: AOAM530mSRz+9yP/hWgZSXsiTipymBEZdAVAapb9j5AwlNXZbgnWYnOu
        OZqBEHBtHz9gErBKD6drzeys5ijK6ME=
X-Google-Smtp-Source: ABdhPJy+YrzZKwd5+F/mUlLKc1buAG2GYo3psN+zgLKKgZCaQodKOmaaXPOfQkTbTyqMVe6xmSm/bg==
X-Received: by 2002:a17:902:6ac7:b029:e4:28f8:b463 with SMTP id i7-20020a1709026ac7b02900e428f8b463mr546771plt.62.1614090448923;
        Tue, 23 Feb 2021 06:27:28 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h3sm21489224pgm.67.2021.02.23.06.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 06:27:28 -0800 (PST)
Date:   Tue, 23 Feb 2021 06:27:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
Message-ID: <20210223142726.GA4711@hoboy.vegasvil.org>
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 09:00:32AM +0100, Heiko Thiery wrote:
> HI Jakub,
> 
> Am Di., 23. Feb. 2021 um 04:00 Uhr schrieb Jakub Kicinski <kuba@kernel.org>:
> > Why is the PTP interface registered when it can't be accessed?
> >
> > Perhaps the driver should unregister the PTP clock when it's brought
> > down?

I don't see any reason why a clock should stop ticking just because
the interface is down.  This is a poor driver design, but sadly it
gets copied and even defended.

> Good question, but I do not know what happens e.g. with linuxptp when
> the device that was opened before will be gone.

If a network interface goes down, ptp4l will notice via rtnl and close
the interface.  Then it re-opens the sockets on rtnl up.  However, the
file descriptor representing the dynamic posix clock stays opened.

Thanks,
Richard
