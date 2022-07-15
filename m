Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB6B575BEA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 08:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiGOG6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 02:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGOG6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 02:58:19 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F385545F3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 23:58:18 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id q7so4682759lji.12
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 23:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lessconfused.com; s=lessconfused;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJwazGQZJW/uLVik//axHOH23W4pKtSA8Q3XriyhUmc=;
        b=aqTX5lyeo4zyOGbJuWS5PtHeQ51cfrngS7PkLm7m/+0HuBKQ/6W8/f6IgIv74WR8AE
         ZNePrO60SD/ZtXxyb3aROTEjXizmcOMAJRoI31uqS9mqZqg63SpmjqHDjV3BoyfxTvFZ
         e+qYfxrvZv3wBPKGcysWj1ibjttxnHpmovkQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJwazGQZJW/uLVik//axHOH23W4pKtSA8Q3XriyhUmc=;
        b=WM1He2JJuezjpOeDUsjWFdd3nEhCDZKj87VGIPCFOI1Hzd485FP+p6EOHA0EVqQgOY
         wQUQvnLm/R6NVIIl3XQRcrRjwMQm6y6g/uhcJWlyhsjubtRO5PgmN8dg0AN2hTCKjbve
         lAB2Xeo1sLsT+4yBu+yCqNs6WVxXvpcVdlcSd3zts94CM9yVHQNBQOIBkBwr9oCi+lwG
         SiGU7yQsxCENumBOR5wNEVl/jkRmNbJ1xUbkqKOO71Bv4AFc++S96hCAUURQRocD/EL4
         8HOYIxIaB8dZ5CNQtZsrqW6pv66aHihFm+TMhlIFMzWWEv8Yit/N24TNJq0lSW8DYl/e
         uGBQ==
X-Gm-Message-State: AJIora+H6L2Ea6GpQR2aUmmHAKrrQu03u9uIhYyDNcinhhvseSSgYWRj
        EXPJ146zaebw406PXvQYNRbJ4SKvz8Hq/TEiua1DBA==
X-Google-Smtp-Source: AGRyM1sa5jZmcE2eFhomUSTWVzfgAAUu2l+24idODbu3F3KQ3MUjG1kstqYjoDAdosvLrZc4+kMIQVhMcdzT23yE02M=
X-Received: by 2002:a2e:b88b:0:b0:25d:a15a:bba9 with SMTP id
 r11-20020a2eb88b000000b0025da15abba9mr1507486ljp.357.1657868296471; Thu, 14
 Jul 2022 23:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220707101423.90106-1-jbrunet@baylibre.com> <CACdvmAjz9EzeapjATa0aOnRURYgS7NSZRE=uUAuc4X+2otG5EA@mail.gmail.com>
In-Reply-To: <CACdvmAjz9EzeapjATa0aOnRURYgS7NSZRE=uUAuc4X+2otG5EA@mail.gmail.com>
From:   Da Xue <da@lessconfused.com>
Date:   Fri, 15 Jul 2022 02:58:04 -0400
Message-ID: <CACdvmAjjgnLzipU7-A+RFjiqh3ijBaJ9gGcRzCHF_NxYevGu9w@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Erico Nunes <nunes.erico@gmail.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Qi Duan <qi.duan@amlogic.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 13, 2022 at 5:24 AM Da Xue <da@lessconfused.com> wrote:
>
> On Thu, Jul 7, 2022 at 6:14 AM Jerome Brunet <jbrunet@baylibre.com> wrote:
> >
> > For some reason, poking MAC_CTRL_REG a second time, even with the same
> > value, causes problem on a dwmac 3.70a.
> >
> > This problem happens on all the Amlogic SoCs, on link up, when the RMII
> > 10/100 internal interface is used. The problem does not happen on boards
> > using the external RGMII 10/100/1000 interface. Initially we suspected the
> > PHY to be the problem but after a lot of testing, the problem seems to be
> > coming from the MAC controller.
> >
> > > meson8b-dwmac c9410000.ethernet: IRQ eth_wake_irq not found
> > > meson8b-dwmac c9410000.ethernet: IRQ eth_lpi not found
> > > meson8b-dwmac c9410000.ethernet: PTP uses main clock
> > > meson8b-dwmac c9410000.ethernet: User ID: 0x11, Synopsys ID: 0x37
> > > meson8b-dwmac c9410000.ethernet:      DWMAC1000
> > > meson8b-dwmac c9410000.ethernet: DMA HW capability register supported
> > > meson8b-dwmac c9410000.ethernet: RX Checksum Offload Engine supported
> > > meson8b-dwmac c9410000.ethernet: COE Type 2
> > > meson8b-dwmac c9410000.ethernet: TX Checksum insertion supported
> > > meson8b-dwmac c9410000.ethernet: Wake-Up On Lan supported
> > > meson8b-dwmac c9410000.ethernet: Normal descriptors
> > > meson8b-dwmac c9410000.ethernet: Ring mode enabled
> > > meson8b-dwmac c9410000.ethernet: Enable RX Mitigation via HW Watchdog Timer
> >
> > The problem is not systematic. Its occurence is very random from 1/50 to
> > 1/2. It is fairly easy to detect by setting the kernel to boot over NFS and
> > possibly setting it to reboot automatically when reaching the prompt.
> >
> > When problem happens, the link is reported up by the PHY but no packet are
> > actually going out. DHCP requests eventually times out and the kernel reset
> > the interface. It may take several attempts but it will eventually work.
> >
> > > meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> > > Sending DHCP requests ...... timed out!
> > > meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> > > IP-Config: Retrying forever (NFS root)...
> > > meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> > > meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> > > meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> > > meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> > > meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> > > meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> > > Sending DHCP requests ...... timed out!
> > > meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> > > IP-Config: Retrying forever (NFS root)...
> > > [...] 5 retries ...
> > > IP-Config: Retrying forever (NFS root)...
> > > meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> > > meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> > > meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> > > meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> > > meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> > > meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> > > Sending DHCP requests ., OK
> > > IP-Config: Got DHCP answer from 10.1.1.1, my address is 10.1.3.229
> >
> > Of course the same problem happens when not using NFS and it fairly
> > difficult for IoT products to detect this situation and recover.
> >
> > The call to stmmac_mac_set() should be no-op in our case, the bits it sets
> > have already been set by an earlier call to stmmac_mac_set(). However
> > removing this call solves the problem. We have no idea why or what is the
> > actual problem.
> >
> > Even weirder, keeping the call to stmmac_mac_set() but inserting a
> > udelay(1) between writel() and stmmac_mac_set() solves the problem too.
> >
> > Suggested-by: Qi Duan <qi.duan@amlogic.com>
> > Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> > ---
> >
> >  Hi,
> >
> >  There is no intention to get this patch merged as it is.
> >  It is sent with the hope to get a better understanding of the issue
> >  and more testing.
> >
> >  The discussion on this issue initially started on this thread
> >  https://lore.kernel.org/all/CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com/
> >
> >  The patches previously proposed in this thread have not solved the
> >  problem.
> >
> >  The line removed in this patch should be a no-op when it comes to the
> >  value of MAC_CTRL_REG. So the change should make not a difference but
> >  it does. Testing result have been very good so far so there must be an
> >  unexpected consequence on the HW. I hope that someone with more
> >  knowledge on this controller will be able to shine some light on this.
> >
> >  Cheers
> >  Jerome
> >
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index d1a7cf4567bc..3dca3cc61f39 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -1072,7 +1072,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
> >
> >         writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
> >
> > -       stmmac_mac_set(priv, priv->ioaddr, true);
> >         if (phy && priv->dma_cap.eee) {
> >                 priv->eee_active = phy_init_eee(phy, 1) >= 0;
> >                 priv->eee_enabled = stmmac_eee_init(priv);
> > --
> > 2.36.1
> >
>
> We had a problem with GXL (S805X/S905X) where the ethernet interface
> would sometimes not come up. Before the 5.10 LTS, it was just a matter
> of bringing down and up (ip link set) the interface to fix the issue.
> With 5.15, 5.18, and 5.19, we would get "meson8b-dwmac
> c9410000.ethernet eth0: Reset adapter." No amount of link down ups can
> fix it anymore.

I realized that I did not add the ethernet reset in the device tree
that u-boot was passing to Linux. Sorry about the noise on this.

>
> When we get the "meson8b-dwmac c9410000.ethernet eth0: Reset
> adapter.", it affects traffic on the network switch. I have a ping
> going from two different devices on a GS108PP PoE network switch and
> it would go through the roof. When I remove the GXL board, everything
> comes back to normal.

Given that the reset fixes the ethernet issues, the hardware still
could be causing this but it is no longer long enough to notice.

>
> We would get randomized corruption when ethernet is brought up
> (successfully or not) about half the time. If it boots up without a
> problem, it remains super stable. I would run benchmarks for CPU, 3D,
> and ethernet for days without that glitch ever appearing. It seems to
> be determined at startup.

This is gone with ethernet reset in the device tree and the no
double-poke register change Jerome provided.

Best,
Da
