Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AC13E0FF6
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239163AbhHEIMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235877AbhHEIME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 04:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B333B61078;
        Thu,  5 Aug 2021 08:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628151110;
        bh=UDVn/n+b4ifejuAldecYtpvLiHWebHyZJ2ot8Xm7zJM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b0bBXsXf0pUJWq2yllF1qZMuHrpPG6LxjhBUeAXyLYJku3Z6bBbvtPXEfZzdzAY/1
         /3YLTx8JEPhzLoUwkA7bWclJaxsmLuIymRpiuTqfpoXMvKPl3biKRKD2lWLFd6WeDf
         k5W2c6SUTDZB8SBm2mO+YoeD7VaRpvGBFsCKhbhADb/EkGnNC1eIb5vdTOmJpYPDI6
         HUT7D1p3WilK3XMdUX0GTesFeeU96OW+WuEUGz5YQC099XO3dRC1PNVGeqM8K/ardt
         5+2K6ni6aRV6MPBEZ3bfov5VvVNfNqndnt41eLT7yX/bE96MvHJBivgiTiIPHs26x1
         lNqBUVsEAr/pg==
Received: by mail-wr1-f45.google.com with SMTP id l18so5343241wrv.5;
        Thu, 05 Aug 2021 01:11:50 -0700 (PDT)
X-Gm-Message-State: AOAM5316JnSntH5P0ByQmEcYMyIDAnXUzmfZ981Wmg7T0U38VTC6Ip0I
        4v6HsPfX7yLZ6PtoWimy2kiQCeSv1i0EawFlk2M=
X-Google-Smtp-Source: ABdhPJygsRjjgl2ODlzfwGyOxtVwMsKnmyPUzAx8U1eXjyLXcuOHPt8tpnA6IimrkOf9W8kenBTfPfIKmG6jzhpGARQ=
X-Received: by 2002:adf:e107:: with SMTP id t7mr3674023wrz.165.1628151109296;
 Thu, 05 Aug 2021 01:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210804121318.337276-1-arnd@kernel.org> <CO1PR11MB5089A77D5388203C4AA2F9E4D6F19@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB5089A77D5388203C4AA2F9E4D6F19@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 10:11:33 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2ZTmtkU9StyWMG=TwODxqAVEN_AFyGdyerr9C5vUMaVA@mail.gmail.com>
Message-ID: <CAK8P3a2ZTmtkU9StyWMG=TwODxqAVEN_AFyGdyerr9C5vUMaVA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethernet: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 10:52 PM Keller, Jacob E
<jacob.e.keller@intel.com> wrote:

> > diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> > b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> > index af84f72bf08e..4e18b64dceb9 100644
> > --- a/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> > +++ b/drivers/net/ethernet/oki-semi/pch_gbe/Kconfig
> > @@ -6,6 +6,7 @@
> >  config PCH_GBE
> >       tristate "OKI SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
> >       depends on PCI && (X86_32 || COMPILE_TEST)
> > +     depends on PTP_1588_CLOCK
> >       select MII
> >       select PTP_1588_CLOCK_PCH
> >       select NET_PTP_CLASSIFY
>
> I did notice this one driver which now directly depends on PTP_1558_CLOCK, but I
> suspect that's because it actually doesn't work if you disable PTP?

Yes, it's the 'select PTP_1588_CLOCK_PCH' and 'select NET_PTP_CLASSIFY'
that actually need it.

      Arnd
