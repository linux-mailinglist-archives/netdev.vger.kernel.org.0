Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0585C2FCEF7
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbhATLPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731697AbhATKPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:15:30 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C2C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 02:14:50 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id v19so5658012ooj.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 02:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9idl7djP/gcI8ZRUI+MwR5AMr2tzGw5NapcssCm1Rg=;
        b=TKhbts8e8cd00QY6PS+y8hDHsMmA9IzKZTKBwRsNhAfa10jseWGltBvLM3xMiGrG9M
         wM3xzExSL2RYGgpLnVRfk46oGIlYv2jmWD2tp2mj3xrJQpqkYBhPTN3QsGppio6R3TIy
         zvNiJ0LQQQzQ/GB/CVCkG2dqhZl7fwCRIaccw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9idl7djP/gcI8ZRUI+MwR5AMr2tzGw5NapcssCm1Rg=;
        b=VvO/athviDAgnXDl25gRN2fwewa/KUqgQMSwZP7sPGDKPdc8YFzkqR18+hTQFNf5oU
         bAkoRZxosgnFkY98UXH+uQ1YtWoX3mxV4bkJS0WfM/WnL3udmqyZ3JoU/i4JE0uoY0JB
         rzbtd3GUPAn0u5ilmquRbWeCkuJCD4mZM5EuHLchbVmeD7NzIiK8i+/cDfzW3NWepIuN
         WJ8eH/A0qkQYRFqtJbzWD5qiSgBHrLkN0IkOKVoDVvDoHGtbT+Fq98AZEp7OAWxQZ9Y7
         gBu/EcKOZqsU8e4vOiqBnV0VLap/us7rlA6lUokJ9kl1Q2mcHhmqKIK9BDU/aExSaeuG
         3xjg==
X-Gm-Message-State: AOAM5321pKtxRuNCmQ7zgo+983RFRQehjha87gnA9hh+m1yElWTFem50
        B+8LDWzC8j02FLOb5Mi/Q837PbfW4CDnFqG7nthHtw==
X-Google-Smtp-Source: ABdhPJwuOe+XYU4kFMWEkXZOeE1U7B1ket2TemK2p5GwmQD2tBc5oAh4mJjqvg6ivlHpO7gzbE6TQs1AdNgEZs0T6D0=
X-Received: by 2002:a4a:e9f2:: with SMTP id w18mr4805688ooc.88.1611137689604;
 Wed, 20 Jan 2021 02:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20210120030502.617185-1-marex@denx.de>
In-Reply-To: <20210120030502.617185-1-marex@denx.de>
From:   Paul Barker <pbarker@konsulko.com>
Date:   Wed, 20 Jan 2021 10:14:40 +0000
Message-ID: <CAM9ZRVtWpc-VV7Or_sQXufq5c0-0ZfV1Tf2EYRLgo0Hc0digaA@mail.gmail.com>
Subject: Re: [PATCH net-next V2] net: dsa: microchip: Adjust reset release
 timing to match reference reset circuit
To:     Marek Vasut <marex@denx.de>
Cc:     Networking <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 at 03:05, Marek Vasut <marex@denx.de> wrote:
>
> KSZ8794CNX datasheet section 8.0 RESET CIRCUIT describes recommended
> circuit for interfacing with CPU/FPGA reset consisting of 10k pullup
> resistor and 10uF capacitor to ground. This circuit takes ~100 ms to
> rise enough to release the reset.
>
> For maximum supply voltage VDDIO=3.3V VIH=2.0V R=10kR C=10uF that is
>                     VDDIO - VIH
>   t = R * C * -ln( ------------- ) = 10000*0.00001*-(-0.93)=0.093 s
>                        VDDIO
> so we need ~95 ms for the reset to really de-assert, and then the
> original 100us for the switch itself to come out of reset. Simply
> msleep() for 100 ms which fits the constraint with a bit of extra
> space.

This makes sense if someone is using that device and following the
reference circuit exactly. Working with the ksz9477 I can tell you
that the reference reset circuit in figure 7.2 of the datasheet
doesn't work with a VDDIO of 1.8V. And hardware engineers like to take
some liberties anyway...

But 100ms is reasonable in general. It will allow for the expected
rise time of a wide range of possible reset circuit designs and isn't
so long that it will have a major impact on start-up time.

So it looks good to me.

Reviewed-by: Paul Barker <pbarker@konsulko.com>

-- 
Paul Barker
Konsulko Group
