Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BC689213
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 16:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHKOyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 10:54:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38123 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHKOyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 10:54:54 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so66622733edo.5
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 07:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=whKjeeuzRR1C0VHKLCEEBRmCXyO9oAPJW1EVegs9n5Y=;
        b=nApUDYyVfbALIYW38EWX0WyMhOt71LzvXKxVarei7q+0Vdz3DaWXn5LAS7p63TUhct
         OUP38/vol6OO3efIGdQXaM7geP40wJ54ry+cn6tjSgNdS5erwPB3uX1dYeIZeoOPZgv/
         r4G8m2r95+W+rUOxuqcnI3kgYdRqpKXm22C97NscP1cYK2xKPbdfAsJACtS2AhJywmWa
         k16ofOM84bRVTBQDYlQpYCBgcpr3KDHHZJgR53lxjOgy6UbL/SpCrgODO0N5ns+ZK8E4
         TuPq316GQZD4mYgvOewUqT36VzQZKc9z1EX0iL8ijMDtNiSFjXf/jn+X8mx9vYgk+yGy
         AoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=whKjeeuzRR1C0VHKLCEEBRmCXyO9oAPJW1EVegs9n5Y=;
        b=C8BMM8ghoce04q3m3ZxxHqhxSoDElhdbVuq1MiL0HOnNvXivyVOQBoHO8Ob1vIB0kO
         +RzUj1iF2sXVKeRh98okZ1QcZ7ffIIiWjqEWlsw2CgROYzXwOSeN75BZNOMVQRchFy3F
         XdbsAcPsUc4Vqi8oo/cPp0C6HfeOb8F8wBgqT5w3TxaCbtYCPvhCS+U+VyT8qkhRduo3
         vXwWHRQktJp8iliblIGislMqUNLZMH5orImnrgo6nVFuGeR6WeAt++7i/eVrk6EbkYrl
         bcaunmw8sCKztzkcyGaT7fcWJsTTZeiqS46LgXdiCW000bfx3Lv5Kl8LcT2rM9uZdYLF
         VK0A==
X-Gm-Message-State: APjAAAVWVWUVGQrvl3e+339ULGK+LYETRbXQEFJtAtX/kym+IDpMggwI
        wvcjFEFrwb0gJkThAPGP4+jnvy/gH8e/L1ncOOU=
X-Google-Smtp-Source: APXvYqwAdXQXJ79ojPe82Rpyakj/ISlSmVhxJ5vQO6EZlT7MZC3VOJOWsYTlB83ynxfcmpRCdzpd9HKQAqA7iRWfX+M=
X-Received: by 2002:a17:907:2069:: with SMTP id qp9mr16187513ejb.90.1565535292378;
 Sun, 11 Aug 2019 07:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190811133707.GC13294@shell.armlinux.org.uk>
In-Reply-To: <20190811133707.GC13294@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 11 Aug 2019 17:54:41 +0300
Message-ID: <CA+h21hqkVoQWRweKKCFdvLLOLyP4gEtXQvJ9CO_J7i+YQW+TWw@mail.gmail.com>
Subject: Re: [BUG] fec mdio times out under system stress
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell, Fabio,

On Sun, 11 Aug 2019 at 16:42, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi Fabio,
>
> When I woke up this morning, I found that one of the Hummingboards
> had gone offline (as in, lost network link) during the night.
> Investigating, I find that the system had gone into OOM, and at
> that time, triggered an unrelated:
>
> [4111697.698776] fec 2188000.ethernet eth0: MDIO read timeout
> [4111697.712996] MII_DATA: 0x6006796d
> [4111697.729415] MII_SPEED: 0x0000001a
> [4111697.745232] IEVENT: 0x00000000
> [4111697.745242] IMASK: 0x0a8000aa
> [4111698.002233] Atheros 8035 ethernet 2188000.ethernet-1:00: PHY state change RUNNING -> HALTED
> [4111698.009882] fec 2188000.ethernet eth0: Link is Down
>
> This is on a dual-core iMX6.
>
> It looks like the read actually completed (since MII_DATA contains
> the register data) but we somehow lost the interrupt (or maybe
> received the interrupt after wait_for_completion_timeout() timed
> out.)
>
> From what I can see, the OOM events happened on CPU1, CPU1 was
> allocated the FEC interrupt, and the PHY polling that suffered the
> MDIO timeout was on CPU0.
>
> Given that IEVENT is zero, it seems that CPU1 had read serviced the
> interrupt, but it is not clear how far through processing that it
> was - it may be that fec_enet_interrupt() had been delayed by the
> OOM condition.
>
> This seems rather fragile - as the system slowing down due to OOM
> triggers the network to completely collapse by phylib taking the
> PHY offline, making the system inaccessible except through the
> console.
>
> In my case, even serial console wasn't operational (except for
> magic sysrq).  Not sure what agetty was playing at... so the only
> way I could recover any information from the system was to connect
> the HDMI and plug in a USB keyboard.
>
> Any thoughts on how FEC MDIO accesses could be made more robust?
>

I think a better question is why is the FEC MDIO controller configured
to emit interrupts anyway (especially since the API built on top does
not benefit in any way from this)? Hubert (copied) sent an interesting
email very recently where he pointed out that this is one of the main
sources of jitter when reading the PTP clock on a Marvell switch
attached over MDIO.

> Maybe phylib should retry a number of times - but with read-sensitive
> registers, if the read has already completed successfully, and its
> just a problem with the FEC MDIO hardware, that could cause issues.
>
> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
-Vladimir
