Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CBA18FB58
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCWRVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:21:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37525 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCWRVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:21:50 -0400
Received: by mail-io1-f65.google.com with SMTP id q9so15028997iod.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 10:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WDFGblKtfFTD55v6dhwLUZD7WlLp2lsgvuZkott4Dyw=;
        b=qhvxD0VpPFQZbOxUGhY91u4EttlKFCZjM9GpH0u8+OHQ1vBLQr4Pb8b2sViicTaN2d
         O7aNEDX76cjf1QVobLFezM4t5DScrndA0IDBPLYpFZRf4OrL9ifaXH6QdW923EbuGA2u
         lNE0vI2OCoXpZ3Oj2zUXBEFmjo/ri6LPrgLkSaK5TmgmhZAPa1j1EEE1QBCoD5CF3mX4
         qywcIvIzssAMymkasTJ0yPmONZHSD/ZJDzjQ1M3qGCwFW9YiNDDMHN14uvQ/iI/2RYOr
         Q/AIb+nnbkZE/P2PRCQUk4cEh9bYAGLuc76W6Nh0nmuQGcyHpvio1jRJjao4BYSXY1KX
         jsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WDFGblKtfFTD55v6dhwLUZD7WlLp2lsgvuZkott4Dyw=;
        b=XrfdNJEDDPtX1lY+kk8j27EPIp0ZbUuC3CFOiuVvBVkDdBtZBiOPtDmvhGh0ih5XlY
         QP8lGM0QbxBJV5vMiiex08GDaHgWNffVQJIQFIT4hZW6sSdF83OOBO8dZQk9KGuN5mDk
         SEkn0JUvhwMrG8FHGeDSDiA1f5gXzopnI3LVnuA2ua6KWE0jOddiJf/Um57mEEIbhost
         olwVnHhRR2vi80Vk1HJZC3JiD7lNhu2XZ1eBLLcZFmTewG2V8NND5ROCX49ep2dnKbpw
         zfBkbgBNxXK62DOOO9hyOmSWE5qJXFRkqtMniu/a/igFXt1zPvTzashhzJTOHPkJV6IC
         pOJA==
X-Gm-Message-State: ANhLgQ3vawoHTUhcorB5SOaivmH6252NP/9rz2pMBv7hVrSEb2Cifb8/
        9I6rH6KufwPwp+VXI/gxj8Gbf8GyJXsOecHzI5EVP1dh9WM=
X-Google-Smtp-Source: ADFU+vugbocRN2mrqF0qy51hOS6RkgMt7dyjbki96J4kz5hjre/qV7mHW4jPwR2oNLiA7+l0aTeQChfC5N1GIR1Vs+g=
X-Received: by 2002:a02:5ec2:: with SMTP id h185mr20732089jab.2.1584984107627;
 Mon, 23 Mar 2020 10:21:47 -0700 (PDT)
MIME-Version: 1.0
From:   Bobby Jones <rjones@gateworks.com>
Date:   Mon, 23 Mar 2020 10:21:36 -0700
Message-ID: <CALAE=UDvPU-MBX5B7NU1A7WPq1gofUnr8Rf+v81AxHLLcZhMvA@mail.gmail.com>
Subject: Toby MPCI - L201 cellular modem http hang after random MAC address assignment
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello net-dev,

I'm diagnosing a problem with the Toby MPCI-L201 cellular modem where
http operations hang. This is reproducible on the most recent kernel
by turning on the rndis_host driver and executing a wget or similar
http command. I found I was able to still ping but not transfer any
data. After bisecting I've found that commit
a5a18bdf7453d505783e40e47ebb84bfdd35f93b introduces this hang.

For reference the patch contents are:

>     rndis_host: Set valid random MAC on buggy devices
>
>     Some devices of the same type all export the same, random MAC address=
. This
>     behavior has been seen on the ZTE MF910, MF823 and MF831, and there a=
re
>     probably more devices out there. Fix this by generating a valid rando=
m MAC
>     address if we read a random MAC from device.
>
>     Also, changed the memcpy() to ether_addr_copy(), as pointed out by
>     checkpatch.
>
>     Suggested-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>     Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 524a47a28120..4f4f71b2966b 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -428,7 +428,11 @@ generic_rndis_bind(struct usbnet *dev, struct usb_in=
terface *intf, int flags)
>                 dev_err(&intf->dev, "rndis get ethaddr, %d\n", retval);
>                 goto halt_fail_and_release;
>         }
> -       memcpy(net->dev_addr, bp, ETH_ALEN);
> +
> +       if (bp[0] & 0x02)
> +               eth_hw_addr_random(net);
> +       else
> +               ether_addr_copy(net->dev_addr, bp);
>
>         /* set a nonzero filter to enable data transfers */
>         memset(u.set, 0, sizeof *u.set);

I know that there is some internal routing done by the modem firmware,
and I'm assuming that overwriting the MAC address breaks said routing.
Can anyone suggest what a proper fix would be?

Thanks,
Bobby
