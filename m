Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3963FB67C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbhH3MxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbhH3MxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 08:53:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB81CC061575;
        Mon, 30 Aug 2021 05:52:19 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d5so3630762pjx.2;
        Mon, 30 Aug 2021 05:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sdDllw5G7qeL7kIot/RD3R2XhOAWjGkmvfZfITDTPks=;
        b=oMXbfiWNgIUtEjxM5hCIObiZIWupovBeVJOEE9wCpju7EFPyE1zFINImGGI/X0Evze
         nkO5xU8vW5mjjuLhSq5BjTDU6FOU4VedjiQcBf/QjsfCPq5fWzwz5MSCGTIlymVOLfUb
         yA7jF9WNVe8TRIh+fGEK+iKLtzawb/rnST7DZbJJw7nHScnd1zDh4ryX8X/81xW/Bira
         xLgHFCOvQo25RMz9loJxdxCQ2pW5+/sj+A/MaiSPAa1kd69xPQGcLBxxE1ud06E4to8j
         Ll/kC1I2iY/gNHM0+STESxC2a2O65/Ytc60ZoGn0IcIQFmQ3tu0+LmGQFtQNDSQ3sQMB
         8mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sdDllw5G7qeL7kIot/RD3R2XhOAWjGkmvfZfITDTPks=;
        b=kXQfRLrXZNgxc4mVjKeY1F+pUxJDoJeoh19lFwEI6yiyFTZ1SmDytPuSVSac8kGunF
         dYNIoJD47E4LDFjKTLBdTvMD1a71h3AC5N3FrrYpHP/g+O9AOhpZiLod7yB22m3BuGwj
         u5P8gkU3KU6RxNG1HfE3O3faKzFsZT2gUfYi8GjtiX3+IW1p+Qf/E1puZS7Pwvo8mX4h
         D5dbfyRQp5UHE5xKrVc12VFN2q8sVGV/5vL0JYXyWRRBBMRrFoFRvMUdyXBtqxmKIzjU
         ptKZos/8iRNcOoVpVECf/ZQX8//V6xfTG8xWkrJ/qQW3S24dTVDIz54Z9FEsXcg4OQDB
         LK7Q==
X-Gm-Message-State: AOAM530rTH2Gfm1O/6MlbA0UZ+xzE3gVwSxkZt5e7zeM9/kHDVIuP/+Q
        OjxaCazzFIUFWyTar/IMfV8kB/5q62cj4ReFjP4=
X-Google-Smtp-Source: ABdhPJx2vf7b1GYktJIKteBWEeunAFfeaVKyb1TvSafjojn1ApQ9WmAoYf7tReLfHNxwFje34LE25SB/fAEOQoN6a3U=
X-Received: by 2002:a17:90a:d78d:: with SMTP id z13mr25490712pju.228.1630327939410;
 Mon, 30 Aug 2021 05:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-3-verdre@v0yd.nl>
In-Reply-To: <20210830123704.221494-3-verdre@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 30 Aug 2021 15:51:43 +0300
Message-ID: <CAHp75Vf-ekdTh=86nR7wqufFPmEb5bve0hf1Oq_k_OAJCkNvWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mwifiex: Try waking the firmware until we get an interrupt
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 3:39 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
>
> It seems that the firmware of the 88W8897 card sometimes ignores or
> misses when we try to wake it up by reading the firmware status
> register. This leads to the firmware wakeup timeout expiring and the
> driver resetting the card because we assume the firmware has hung up or
> crashed (unfortunately that's not unlikely with this card).
>
> Turns out that most of the time the firmware actually didn't hang up,
> but simply "missed" our wakeup request and doesn't send us an AWAKE

didn't

> event.
>
> Trying again to read the firmware status register after a short timeout
> usually makes the firmware wake we up as expected, so add a small retry

wake up

> loop to mwifiex_pm_wakeup_card() that looks at the interrupt status to
> check whether the card woke up.
>
> The number of tries and timeout lengths for this were determined
> experimentally: The firmware usually takes about 500 us to wake up
> after we attempt to read the status register. In some cases where the
> firmware is very busy (for example while doing a bluetooth scan) it
> might even miss our requests for multiple milliseconds, which is why
> after 15 tries the waiting time gets increased to 10 ms. The maximum
> number of tries it took to wake the firmware when testing this was
> around 20, so a maximum number of 50 tries should give us plenty of
> safety margin.
>
> A good reproducer for this issue is letting the firmware sleep and wake
> up in very short intervals, for example by pinging an device on the

a device

> network every 0.1 seconds.

...

> +       /* Access the fw_status register to wake up the device.
> +        * Since the 88W8897 firmware sometimes appears to ignore or miss
> +        * that wakeup request, we continue trying until we receive an
> +        * interrupt from the card.
> +        */
> +       do {
> +               if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_R=
EADY_PCIE)) {
> +                       mwifiex_dbg(adapter, ERROR,
> +                                   "Writing fw_status register failed\n"=
);
> +                       return -1;
> +               }
> +
> +               n_tries++;
> +
> +               if (n_tries <=3D 15)
> +                       usleep_range(400, 700);
> +               else
> +                       msleep(10);
> +       } while (n_tries <=3D 50 && READ_ONCE(adapter->int_status) =3D=3D=
 0);

NIH read_poll_timeout() from iopoll.h.

--=20
With Best Regards,
Andy Shevchenko
