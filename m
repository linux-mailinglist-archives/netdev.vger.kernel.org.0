Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA1552FE9D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 19:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiEURog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 13:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiEURoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 13:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E69C5D5F6;
        Sat, 21 May 2022 10:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4017F60C85;
        Sat, 21 May 2022 17:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29773C385A5;
        Sat, 21 May 2022 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653155072;
        bh=EO84JGczgpntqsBiE0PFKKUwtkIBC7vQT45PS1nrYTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mLf/GRtnZ3q1ciVMuzDkYnEOKTsDT2jfwFJXyiuutQp8dgnkLSAC+iqUKGoddB38U
         eNtiepYn+un7FTXa4fS+9fUCbQRWSC4uQZp7J5AsFGqxplizWSjG824CwOEi4IAViT
         V8Q8rSPKq2THHVLB0DQhc6CuWzygK3Pllx91p4JRconHLosADsY2jespf42KWlWxnG
         kYda1VOAsx28iaQfIdjkqflGklVkLc47XuInXCyEOnksXin+L2PQqm4dWZr8KNAagF
         vVA0cZohdBxcoqO/yOR7IxARweX4iEqPGvLppqn31NPcPEuHk/gsgkfUTq7C1es5vO
         CFajLlyyvFlBA==
Date:   Sat, 21 May 2022 10:44:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fs_enet: sync rx dma buffer before reading
Message-ID: <20220521104430.1212bed5@kernel.org>
In-Reply-To: <d8cc1123-30d2-d65b-84b1-2ffee0d50aab@csgroup.eu>
References: <20220519192443.28681-1-mans@mansr.com>
        <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu>
        <yw1xmtfc9yaj.fsf@mansr.com>
        <b11dcb32-5915-c1c8-9f0e-3cfc57b55792@csgroup.eu>
        <20220520104347.2b1b658a@kernel.org>
        <d8cc1123-30d2-d65b-84b1-2ffee0d50aab@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 May 2022 06:44:41 +0000 Christophe Leroy wrote:
> > Hm, I think the patch is necessary, sorry if you're also saying that
> > and I'm misinterpreting.  
> 
> Well, I say the contrary.
> 
> On the mainline the patch may be applied as is, it won't harm.
> 
> However, it is gets applied to kernel 4.9 (based on the fixes: tag), it 
> will break the driver for at least powerpc 8xx.

I see, we should make a note of that in the commit message so it doesn't
get sucked into stable.

> > Without the dma_sync_single_for_cpu() if swiotlb is used the data
> > will not be copied back into the original buffer if there is no sync.  
> 
> I don't know how SWIOTLB works or even what it is, does any of the 
> microcontrollers embedding freescale ethernet uses that at all ?

AFAIU SWIOTLB basically forces the use of bounce buffers even if the
device can reach the entire DRAM. I think some people also use it for
added security? IDK. I mostly use it to check if I'm using the DMA API
"right" :)
