Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1304C543B59
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiFHSUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiFHSUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:20:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A71E2DEE;
        Wed,  8 Jun 2022 11:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AF28B82991;
        Wed,  8 Jun 2022 18:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BE5C385A5;
        Wed,  8 Jun 2022 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654712415;
        bh=BUWGuywNHkaCDQ8pgh0VMb6Aq1LPMmddJGqt/zmBRgc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YCah+PueDKgwfNOWXcjcTQQDxtQUpvl8d5r4re5UgYnytsCMyXVgQXqkSvERMPs2A
         I1rlM6IGON8cFEXwkczBZcq6Gpu2N1zSGsOtRNV/t1ouHl1V3+K6V6yUCzEHZp5M8B
         194IEzYPhcp9iksUVmLJ5Lukgp8S+Y0xa8Wr3ZlCAkXwd+PDxYpZpGSY/2W0HKiOm5
         6WpyXu2RzUb5mjAqAx5vWNsoojEd9YUGGrC+IE2jYqzD/C69OwyZ2Elf0FP0x47lNG
         NSMl1v/BI8fegL4bMjEADVjkoGif6EhhlLQJDPBoRttWnbLnO+k7gRPVXnJAk66uXR
         q7Kbw2Gohis5w==
Received: by mail-yb1-f169.google.com with SMTP id r82so37830141ybc.13;
        Wed, 08 Jun 2022 11:20:15 -0700 (PDT)
X-Gm-Message-State: AOAM531jihGsiPxHjDyAK2qu4pdR3ixSUqt7s0I2q89oo6/BRKr53s0w
        8/0LVd2XQvnavyGgeUfhmTW5Opm6dcfPlZVvAlM=
X-Google-Smtp-Source: ABdhPJycIGSKO1BWbMab4Gr73BuZG3S8DS1FzEmzvpaWStCmCEswnc3obpq/OgVaJT/eSIY6l0zC85LUiAgu9IVu2Mc=
X-Received: by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr35700307ybx.472.1654712414321; Wed, 08
 Jun 2022 11:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220607090206.19830-1-arnd@kernel.org> <20220608110116.12e5c2e6@kernel.org>
In-Reply-To: <20220608110116.12e5c2e6@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 8 Jun 2022 20:19:55 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2+Y=dpFUSb+_u3sCdJ0kpkEF5JgAFP0T6CSDjrTFAusQ@mail.gmail.com>
Message-ID: <CAK8P3a2+Y=dpFUSb+_u3sCdJ0kpkEF5JgAFP0T6CSDjrTFAusQ@mail.gmail.com>
Subject: Re: [PATCH] au1000_eth: stop using virt_to_bus()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 8:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue,  7 Jun 2022 11:01:46 +0200 Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The conversion to the dma-mapping API in linux-2.6.11 was incomplete
> > and left a virt_to_bus() call around. There have been a number of
> > fixes for DMA mapping API abuse in this driver, but this one always
> > slipped through.
> >
> > Change it to just use the existing dma_addr_t pointer, and make it
> > use the correct types throughout the driver to make it easier to
> > understand the virtual vs dma address spaces.
> >
> > Cc: Manuel Lauss <manuel.lauss@gmail.com>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi Arnd, this can go via net-next, right? The changes are simple
> enough, we can try to slip them into -rc2 if necessary.

It's probably fine either way. I hope to get the CONFIG_VIRT_TO_BUS
removal into v5.20, and if the final patch of that series comes before
this one, there will be a trivial bisection problem on mips/au1000, so
having it merged now would help.

        Arnd
