Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBB55BC1D2
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 05:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiISDos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 23:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiISDoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 23:44:44 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187029FCB
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 20:44:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a41so27607821edf.4
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 20:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=8wzd/IsQMAz4yliZb1FsJ3OfMRVNZc5tTLnz3lR7QHQ=;
        b=EuFCJAkszMPKPtxQSyMQ0NoboaeVB7t96eFw9rPXwH9oSHUro5o77bxEeYAtANDzyR
         I9BMOm4HMiosCb0pcsiSHEAZo2qSCtvZawUq0/zPNIdwAvDvQAPS+8+0uFrWbUJgoTtd
         ExLo8MeQP7GyQ+rW2rlFvIPPT75kqxCAKPhOGjeDjYZZFhuAOfywggSn5a+jZu6mJGBr
         cWVHHoToy9UWA6nPxBqZcAZLzmJoxjkbRc1yLhwZYNZgNQEBRnr86m6GI/e/+J8MoRAT
         suDLw8ILYZpcoPAOh+pvz4Lu/zfiYh6RXQKy+jZAxuRvjXsVxLmt63JqorCueNp9TEEJ
         9kQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8wzd/IsQMAz4yliZb1FsJ3OfMRVNZc5tTLnz3lR7QHQ=;
        b=0EJHbArbK0VZaPO4QCguuRd8DACwp/ou1rAVoes0voZK4YKubCCLU+RXMiFuqkQWhL
         MQbBhIK1Afz16wsZvjnZHTEfuHkN6cAebDbz88QFV6KfhJx0kTSGyAnzb41z9cFi4N04
         PgLhCyLd2r1XoOZeyN/u4rT9d0MR8wh+XSOQ5C9h8QNAeKYfBNHhdYHwvBOS4GS2m2Vy
         KySZUWOyMcem862656kmpSUGQcnanQilAIQdBJJ1vTrCoTxjAnIkhsTsuRC0EOKWmxtq
         mAnPd/xTwujVxO7WmOIUOd173VA/DfQnU6BFALLR2as7e5nMRrd4jMpGl5mJYo+el4QI
         1GFQ==
X-Gm-Message-State: ACrzQf2q8OiuLqdBS6AUgEY2v6nPGs8nEKb3F+pNltt2e4QltWLphpsT
        OyDtRYWsd8EfyuLVFyBVxUlAyWfmerHL90ZjP+bsAw==
X-Google-Smtp-Source: AMsMyM67X4fHgNHGRzRNZ0AalOVh8oZlYNRkDoycvf7zBAcHx4qOwSpxEraLAwYUCmYCoDnGs0xLR1B5pb/N312tK3I=
X-Received: by 2002:aa7:cc8a:0:b0:446:7668:2969 with SMTP id
 p10-20020aa7cc8a000000b0044676682969mr13821510edt.206.1663559079248; Sun, 18
 Sep 2022 20:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220701012647.2007122-1-saravanak@google.com> <YwS5J3effuHQJRZ5@kroah.com>
In-Reply-To: <YwS5J3effuHQJRZ5@kroah.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Sun, 18 Sep 2022 20:44:27 -0700
Message-ID: <CAOesGMivJ5Q-jdeGKw32yhjmNiYctHjpEAnoMMRghYqWD2m2tw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fix console probe delay when stdout-path isn't set
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Al Cooper <alcooperx@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Russell King <linux@armlinux.org.uk>,
        Vineet Gupta <vgupta@kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Taichi Sugaya <sugaya.taichi@socionext.com>,
        Takao Orito <orito.takao@socionext.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pali Rohar <pali@kernel.org>,
        Andreas Farber <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hammer Hsieh <hammerh0314@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Timur Tabi <timur@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh@kernel.org>,
        sascha hauer <sha@pengutronix.de>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org,
        linux-rpi-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-actions@lists.infradead.org,
        linux-unisoc@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 8:37 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 30, 2022 at 06:26:38PM -0700, Saravana Kannan wrote:
> > These patches are on top of driver-core-next.
> >
> > Even if stdout-path isn't set in DT, this patch should take console
> > probe times back to how they were before the deferred_probe_timeout
> > clean up series[1].
>
> Now dropped from my queue due to lack of a response to other reviewer's
> questions.

What happened to this patch? I have a 10 second timeout on console
probe on my SiFive Unmatched, and I don't see this flag being set for
the serial driver. In fact, I don't see it anywhere in-tree. I can't
seem to locate another patchset from Saravana around this though, so
I'm not sure where to look for a missing piece for the sifive serial
driver.

This is the second boot time regression (this one not fatal, unlike
the Layerscape PCIe one) from the fw_devlink patchset.

Greg, can you revert the whole set for 6.0, please? It's obviously
nowhere near tested enough to go in and I expect we'll see a bunch of
-stable fixups due to this if we let it remain in.

This seems to be one of the worst releases I've encountered in recent
years on my hardware here due to this patchset. :-(


-Olof
