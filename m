Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40C6BA73F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjCOFlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjCOFlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:41:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C994347E;
        Tue, 14 Mar 2023 22:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1045C61AED;
        Wed, 15 Mar 2023 05:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789DDC433EF;
        Wed, 15 Mar 2023 05:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678858866;
        bh=FXai2qLa/oxwiLINWHjW+akZur4pSld/3ZcuGMVc30Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQuoLTKrYJs2COu6Qkxi1TsG3DVOypXfLjk4NYc9xP5LQTgot2jL8VGx0RsYCzHRQ
         ebQeuI5EgWlygrnWeOQB8I+P2YHGOQPFObBwd3FgMEgZlDmRzde7PThKvm8bgpbTo/
         GOFLLGd1Y+Iknth/r6bhfJbsiA97l9Y4xnTkUHZaaUmPeHQK6wzcg09dmFMDDUtwqj
         ouUhe9wMN8pgYJ3pWB3AxSqMZ/42vYJ3V9FfTxJVWl1E40Q9N/NG17vohokSOftUzv
         D6S+aNeaDZk1Nz2T+tRVQaZSm8Ngl3TDZhlMADtHe+XUxQH1SAkAMj9CpqH3svmnNy
         wL4hubqX9Jf7g==
Date:   Tue, 14 Mar 2023 22:41:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org
Subject: Re: [PATCH v3 20/38] net: handle HAS_IOPORT dependencies
Message-ID: <20230314224104.71db5ab4@kernel.org>
In-Reply-To: <20230314121216.413434-21-schnelle@linux.ibm.com>
References: <20230314121216.413434-1-schnelle@linux.ibm.com>
        <20230314121216.413434-21-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 13:11:58 +0100 Niklas Schnelle wrote:
> In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers requiring them. For the DEFXX driver there use of I/O
> ports is optional and we only need to fence those paths.can It also
> turns out that with HAS_IOPORT handled explicitly HAMRADIO does not need
> the !S390 dependency and successfully builds the bpqether driver.

Acked-by: Jakub Kicinski <kuba@kernel.org>
