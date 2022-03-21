Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9981E4E342E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiCUXRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiCUXRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4CE2EB570
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 16:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9A73B81A5F
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 23:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE23C340E8;
        Mon, 21 Mar 2022 23:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647903990;
        bh=Oyp/NXQdTSRzRupg87MCcUEjP/lJgq4tjvOmoJm+ADg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K3Fv8uGa8KRsCpnRQI6jbXJ9DNIgnGav5Go1gR7vggATIeoOh8U88C2aBx31t3OGV
         Z8C31hVDs1w+mTV3G5CArdB7LpotCnsmYnFbSOIvbZaXl9/K3gdSe35HORq39nOY++
         ZIKAHlgYGOGq9EK3tpreCFPCVQ+GOYVmiCZEjNs0dy1yzXm3Jmpr9yRZFqqT3MTiK3
         ZE9xkVg2svov4KlcNotG6pKS3h+E2m2fvbJlp2Wcy0YVHcBBXpdI/otA44ypXxMj/T
         5/GJM10wJgLkoLR3LWg3J5uyXl0a8DihrdniCo61wB1c6LbMSkAdi3/erTyVgDA9S7
         vlSMjAnYCIvUA==
Date:   Mon, 21 Mar 2022 16:06:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Krzysztof =?UTF-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Is drivers/net/wan/lmc dead?
Message-ID: <20220321160627.6003e4e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK8P3a12=qpMHn5daK3-E6PjWuSOYOyWp2u2XU0kfzZ8=EoRdA@mail.gmail.com>
References: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAK8P3a12=qpMHn5daK3-E6PjWuSOYOyWp2u2XU0kfzZ8=EoRdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 23:10:32 +0100 Arnd Bergmann wrote:
> On Mon, Mar 21, 2022 at 10:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > The driver for LAN Media WAN interfaces spews build warnings on
> > microblaze.
> >
> > CCing usual suspects and people mentioned as authors in the source code.
> >
> > As far as I can tell it has no maintainer.
> >
> > It has also received not received a single functional change that'd
> > indicate someone owns this HW since the beginning of the git era.
> >
> > Can we remove this driver or should we invest effort into fixing it?  
> 
> I have not seen the exact error, but I suspect the problem is that
> microblaze selects CONFIG_VIRT_TO_BUS without actually
> providing those interfaces. The easy workaround would be to
> have microblaze not select that symbol.

FWIW the warning is that virt_to_bus() discards the __iomem qualifier.
I think it's a macro on most platforms but not microblaze.
Anyway, some approximation of "VIRT_TO_BUS on mircoblaze is broken"
sounds right.

> Drivers using virt_to_bus() are inherently nonportable because
> they don't work on architectures that use an IOMMU or swiotlb,
> or that require cache maintenance for DMA operations.
> 
> $ git grep -wl virt_to_bus drivers/
> drivers/atm/ambassador.c
> drivers/atm/firestream.c
> drivers/atm/horizon.c
> drivers/atm/zatm.c
> drivers/block/swim3.c
> drivers/gpu/drm/mga/mga_dma.c
> drivers/net/appletalk/ltpc.c
> drivers/net/ethernet/amd/au1000_eth.c
> drivers/net/ethernet/amd/ni65.c
> drivers/net/ethernet/apple/bmac.c
> drivers/net/ethernet/apple/mace.c
> drivers/net/ethernet/dec/tulip/de4x5.c
> drivers/net/ethernet/i825xx/82596.c
> drivers/net/ethernet/i825xx/lasi_82596.c
> drivers/net/ethernet/i825xx/lib82596.c
> drivers/net/hamradio/dmascc.c
> drivers/net/wan/cosa.c
> drivers/net/wan/lmc/lmc_main.c
> drivers/net/wan/z85230.c
> drivers/scsi/3w-xxxx.c
> drivers/scsi/a2091.c
> drivers/scsi/a3000.c
> drivers/scsi/dpt_i2o.c
> drivers/scsi/gvp11.c
> drivers/scsi/mvme147.c
> drivers/scsi/qla1280.c
> drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
> drivers/vme/bridges/vme_ca91cx42.c
> 
> Among the drivers/net/wan/ drivers, I think lmc is actually
> one of the newer pieces of hardware, most of the other ones
> appear to even predate PCI.

You know what's even newer than lmc?  Me :S  This HW is so old
many of us have never interacted with these technologies directly.

How do we start getting rid of this stuff? Should we send out patches
to delete anything that's using virt_to_bus() under net|atm and see
which ones don't get shot down?
