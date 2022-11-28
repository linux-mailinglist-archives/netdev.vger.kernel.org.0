Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C7E63AA13
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiK1NwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiK1NwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:52:07 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5AA20183
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:52:05 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id pps4280044C55Sk06ps4Bh; Mon, 28 Nov 2022 14:52:04 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ozeYF-001tsE-NU; Mon, 28 Nov 2022 14:52:03 +0100
Date:   Mon, 28 Nov 2022 14:52:03 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     linux-um@lists.infradead.org, Taras Chornyi <tchornyi@marvell.com>,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: Build regressions/improvements in v6.1-rc7
In-Reply-To: <20221128134525.3580246-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2211281451020.453065@ramsan.of.borg>
References: <CAHk-=wgUZwX8Sbb8Zvm7FxWVfX6CGuE7x+E16VKoqL7Ok9vv7g@mail.gmail.com> <20221128134525.3580246-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022, Geert Uytterhoeven wrote:
> JFYI, when comparing v6.1-rc7[1] to v6.1-rc6[3], the summaries are:
>  - build errors: +6/-0

   + /kisskb/src/arch/um/include/asm/processor-generic.h: error: called object is not a function or function pointer: 94:18 => 94:19, 94:18

um-x86_64-gcc12/um-all{mod,yes}config (in kfd_cpumask_to_apic_id(), seen
before with um-x86_64/um-all{mod,yes}config)

   + /kisskb/src/drivers/infiniband/sw/rdmavt/qp.c: error: 'struct cpuinfo_um' has no member named 'x86_cache_size':  => 88:22
   + /kisskb/src/drivers/infiniband/sw/rdmavt/qp.c: error: control reaches end of non-void function [-Werror=return-type]:  => 89:1
   + /kisskb/src/drivers/infiniband/sw/rdmavt/qp.c: error: implicit declaration of function '__copy_user_nocache' [-Werror=implicit-function-declaration]:  => 100:2

um-x86_64/um-all{mod,yes}config (seen before on v6.1-rc4)

   + /kisskb/src/drivers/net/ethernet/marvell/prestera/prestera_flower.c: error: 'rule' is used uninitialized [-Werror=uninitialized]:  => 480:34
   + /kisskb/src/drivers/spi/spi-stm32-qspi.c: error: 'op' is used uninitialized [-Werror=uninitialized]:  => 523:27, 564:27

um-x86_64-gcc12/um-all{mod,yes}config

The latter looks completely bogus to me, unless there's a bug in the UML
implementation of memcpy() and memset(), which are used to initialize
"op".

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/b7b275e60bcd5f89771e865a8239325f86d9927d/ (all 152 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/eb7081409f94a9a8608593d0fb63a1aa3d6f95d8/ (149 out of 152 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
