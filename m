Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2743650E5
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhDTDds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 23:33:47 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66580C06174A;
        Mon, 19 Apr 2021 20:33:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k17so3756004edr.7;
        Mon, 19 Apr 2021 20:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lfSWPoNQHoy2n1intU3LcdvNNV3gtVsZpBy2B8GfaFk=;
        b=aZUbYjCAjxOn2sQ1zudu3xjH2eve7n4UhLosKL3z5XtkdP9W6MtXSK5QpRnxIQidBo
         VqJcudb4C9ipBzJ7djiokHvrZPuCucgfndCx5HurEqyLgmhWY0zjqifgrpEzE85NMQCG
         7f2eV9qjWgqat+1+6mfc3xMni/cIPvENQTbsJCQbSHigRyvgnoTa5rOj5VZHkPBVFkpB
         fFPrBFdA4ku77RGUk+c45omhWi+NfcXdA49L+1uGm229KdZWa7hXpxeQBcJyqRQOi+WP
         2NUmk6fYIWqGVGSs9D9OAwFt0kNmPDV+R/BOHmh87ZYKRG4Q1T4+jCWofJTRtPayeZe8
         1rYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lfSWPoNQHoy2n1intU3LcdvNNV3gtVsZpBy2B8GfaFk=;
        b=ppGTdfnizllBKjtC5VGpglmdgVD9ALydAM1wl2u0Lv5sUPXwkaYRGNFDqYyjfoS/kF
         e7VP574s3od6z50t3pzaVJmvilkyS2vLXPNVjiilQxZX1mWN93Fzswd5Gca27ZrqKguv
         DqhTcszT9feJvTNBhsH+GHF8yML5MbKCbeTWbpUP0y5Isc/1Nzvrb0p6OD28QF8RlZr0
         orArvKkRjz8o0CM/jO2yQKTTpJYpr4aae96HfnpkOCkVBPn9WNrOiOFAs67AARTrenAw
         QY5YDUzp5pH4o3WM9TLrbg7O+XJACifcjcs2RT091YD12+BzYXLe7m1B9puRKsJU4JDY
         /Q1Q==
X-Gm-Message-State: AOAM532InPuRRHE+U8/Ib2VddlAng8mSueZtDynB+UyaUOBfgZQFS8eS
        OTDo0cB4ixWfWKkNUSZl9+0gVGCPX/nVwDaE5gg=
X-Google-Smtp-Source: ABdhPJzAzpucWx4ETz4/sy2d0XTjM8gyFLIRFAHt/G9Pw9nZgXyCsdewIbOaT+9q9+VwvrhA7uws6Ut8jEG29a5pazk=
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr29372685edt.187.1618889593171;
 Mon, 19 Apr 2021 20:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210417132329.6886-1-aford173@gmail.com> <20210419.154545.1437529237095871426.davem@davemloft.net>
In-Reply-To: <20210419.154545.1437529237095871426.davem@davemloft.net>
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 19 Apr 2021 22:33:00 -0500
Message-ID: <CAHCN7x+T78s+dDbVErG_wKH409cmn76B8aPioJuSJ8aApj37XQ@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 5:45 PM David Miller <davem@davemloft.net> wrote:
>
> From: Adam Ford <aford173@gmail.com>
> Date: Sat, 17 Apr 2021 08:23:29 -0500
>
> > The call to clk_disable_unprepare() can happen before priv is
> > initialized. This means moving clk_disable_unprepare out of
> > out_release into a new label.
> >
> > Fixes: 8ef7adc6beb2("net: ethernet: ravb: Enable optional refclk")
> > Signed-off-by: Adam Ford <aford173@gmail.com>
> Thjis does not apply cleanly, please rebbase and resubmit.

Which branch should I use as the rebase?  I used net-next because
that's where the bug is, but I know it changes frequently.

>
> Please fix the formatting of your Fixes tag while you are at it, thank you.

no problem.  Sorry about that

adam
