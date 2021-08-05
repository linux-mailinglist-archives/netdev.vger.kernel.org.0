Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32453E168E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbhHEOKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241528AbhHEOKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B7C6115C;
        Thu,  5 Aug 2021 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628172634;
        bh=4Z8VLYE1y+qrw4nB+ZeNB5E//il2UDJee+54t1t6L3M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iC7IEickWHwjAAFswvREI2gTQeqaraD/XvxwvEpDm5qVTuabYMXsFUFnIAY6ChOR0
         2zrM9iv/5+FyftsgL5Rga2rGmqr4T8OriJXQNF7xezhk0Bo4YXJUiIAE3rcIS3883b
         mqtsZZA+simi6M5vKD5o+IkPDc4+VxMxAlD59GsMug9kOPfE9fPM4TZ0WYIzvHsQii
         D0tAOrY1xfdH/gAYifgJiRRinoOPN9HJXIoUaG4Ve357/wdsHlgmYY8xihe3YjxveR
         FgMS1NLKPJx0wNEBKpHi+O0m69UbchLygxlwyPeVRNPog/I55+1PI98O2TYa5U/NSL
         MHgJU9zwK455w==
Received: by mail-wm1-f52.google.com with SMTP id n11so3448197wmd.2;
        Thu, 05 Aug 2021 07:10:34 -0700 (PDT)
X-Gm-Message-State: AOAM530N1pi/xhzulDM5w6IP+A7CqOXp7NP7U+RdvJ6paemYZp5fPgLD
        QVzUEZRyxITE3N2UZPUOgVanrkh9g8kLrVAb9nM=
X-Google-Smtp-Source: ABdhPJzQAohMHdz06THhaEA3LYpi23YUJBlheSpLquqgE8XMGV3KzgrnrXQ9QP/jhMoXa5Q40db60tm7XH+NvM1nTNM=
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr15233076wmm.120.1628172633125;
 Thu, 05 Aug 2021 07:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210805082253.3654591-1-arnd@kernel.org> <20210805133258.zvhn5kznjt7taqyu@skbuf>
In-Reply-To: <20210805133258.zvhn5kznjt7taqyu@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 16:10:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2xrkSky0B0YZjBuooJy4QpQS2cCDb_ipYSgY78GzeEKw@mail.gmail.com>
Message-ID: <CAK8P3a2xrkSky0B0YZjBuooJy4QpQS2cCDb_ipYSgY78GzeEKw@mail.gmail.com>
Subject: Re: [PATCH net-next v4] ethernet: fix PTP_1588_CLOCK dependencies
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <snelson@pensando.io>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        drivers@pensando.io, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>, Karen Xie <kxie@chelsio.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 3:32 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> >  # Users should depend on NET_SWITCHDEV, HAS_IOMEM, BRIDGE
> >  config MSCC_OCELOT_SWITCH_LIB
> > +     depends on PTP_1588_CLOCK_OPTIONAL
>
> No, don't make the MSCC_OCELOT_SWITCH_LIB depend on anything please,
> since it is always "select"-ed, it shouldn't have dependencies, see
> the comment above. If you want, add this to the comment: "Users should
> depend on (...), PTP_1588_CLOCK_OPTIONAL".
>

Changed now, but I only saw your message after I had already sent out v5 of
the patch. I'll hold off on sending v6 for the moment, in case someone else
notices something odd.

I generally prefer having the extra dependencies like this, because it documents
what the requirement is, and causes a config-time warning before the kernel
runs into a link failure when someone else gets the dependency wrong later.
I don't feel too strongly about it though, and I don't expect adding a comment
would help much either here, so I'm leaving it without that line.

       Arnd
