Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A013E040A
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhHDPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238324AbhHDPVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 11:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E35A60295;
        Wed,  4 Aug 2021 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628090482;
        bh=ResC44EGJwfafk1EP1TTehAscV+PxNhFSYCS7gE+NbQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o+YAX3nM7ZsbINM78zsss9kmETucTr8eDJ9XhnmF7IP3KkvYQ3LrpWozYDakmvuqB
         S3yXsaByYojvDBAEfD7SKPIP+AuODwWjLhiTquQFwiOYruaq+Aj16RfopXAKd/j3yl
         RXJXhPIV3Is/ghDJpWSSwzmKI+TGdMME/TRcZ0n4xX/H3NHR930cx13Cv6BCSqEYcw
         +RiNUYvXiT6ChCAgwC2XvaSnGKXemw3kK1vZIaIY4Td6Lwk8kP7TEapAuLnWfphqcC
         6JxTuPdxgDJFPMbZFGzPWN9rtKMofElwX6pQKmmJR81MfSWbtCsJFt9oVLYPr/Vuc5
         9251zhWAfSnvA==
Received: by mail-wm1-f44.google.com with SMTP id a192-20020a1c7fc90000b0290253b32e8796so3895239wmd.0;
        Wed, 04 Aug 2021 08:21:22 -0700 (PDT)
X-Gm-Message-State: AOAM531Q3BKJvxRkSlaX9PBzSZFoXB5qBlFQjOyIINDnW2EGIV31x8N9
        AMVVGA3PFXgjrnQpPj0Sg0NjYPl+S5EAdY4GszI=
X-Google-Smtp-Source: ABdhPJyhsDZiH6C0oIXqOf2mYVpZRorsqoPP39EpX0oNA364INwgFOyHPCUYK+yr5luDHjm6eIbPPD+iF8pKEjFkMH0=
X-Received: by 2002:a05:600c:3b08:: with SMTP id m8mr10383643wms.84.1628090481196;
 Wed, 04 Aug 2021 08:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210804121318.337276-1-arnd@kernel.org> <20210804142814.GB1645@hoboy.vegasvil.org>
In-Reply-To: <20210804142814.GB1645@hoboy.vegasvil.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 4 Aug 2021 17:21:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1EBwd+DvqnQSHL03zqaoRz_bhxj6TGw2ivpWLDT7jorw@mail.gmail.com>
Message-ID: <CAK8P3a1EBwd+DvqnQSHL03zqaoRz_bhxj6TGw2ivpWLDT7jorw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Simon Horman <simon.horman@netronome.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 4:28 PM Richard Cochran <richardcochran@gmail.com> wrote:
> > @@ -87,8 +87,8 @@ config E1000E_HWTS
> >  config IGB
> >       tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
> >       depends on PCI
> > -     imply PTP_1588_CLOCK
> > -     select I2C
> > +     depends on PTP_1588_CLOCK_OPTIONAL
> > +     depends on I2C
>
> This little i2c bit sneaks in, but I guess you considered any possible
> trouble with it?

Good catch!

I did need this with v2, as it was causing a circular dependency against
(IIRC) CONFIG_MLXSW_I2C, but I'm fairly sure it's not needed any
more after everything else uses 'depends on' now.

I'm happy to resend a v4 without that change, as it doesn't belong in here,
or we just leave it because it is correct after all, depending on what the Intel
ethernet people prefer.

> Acked-by: Richard Cochran <richardcochran@gmail.com>

Thanks,

      Arnd
