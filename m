Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31146982F3
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBOSKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8DE1041B
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 063AEB82345
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 18:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B53C433EF;
        Wed, 15 Feb 2023 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676484635;
        bh=oLnOXqLSFDT4EmFEhXrt+DFI45CaVjhpH2cicIgB24M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSKG0Thvf3oxk72gIy6HU4trvacmCFqQPGj4H3wb3Wxsr/76F9zZ4PHqN6s/Ut0ce
         tb6jdKNLmeY7fDcPfbTBt5qyNbCC8o7ibBk7zMtw4opbPUSwvqorZ93vQjPhjZEz/5
         0drDIhhWBSIDUvF2NtDnxASTVad+mFmknVmoFBoe1sr6MPAxyWTpEem1g8emBQCQjH
         047Rns44fUtl8HFpFyeFtDmIoA7JFOnxSWX1lkQQ7sybUTo097sCYyHz9ZkLuIpReO
         B1uSCo1FIdT2zLGGIaMnE0byVY41hDMaMTFf90HkqRQLAtNpFQZJf7gudUBG3micBN
         zs3M2SuA8ZYwg==
Date:   Wed, 15 Feb 2023 10:10:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemb@google.com>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [RFC] net: skbuff: let struct skb_ext live inside the head
Message-ID: <20230215101034.2c3cd1d6@kernel.org>
In-Reply-To: <CA+FuTSfjCvMAD9hf1JGOrSa57NZQ01n01-up3DF_bsf52N9MJw@mail.gmail.com>
References: <20230215034444.482178-1-kuba@kernel.org>
        <20230215094332.GB9908@breakpoint.cc>
        <CA+FuTSfjCvMAD9hf1JGOrSa57NZQ01n01-up3DF_bsf52N9MJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 09:37:09 -0500 Willem de Bruijn wrote:
> How much data does psp need? The google version [1] embeds structs
> psp_skb, which may include a 256b key. If on tx the key is looked up
> from skb->sk, then on rx the only truly required field is the 32-bit
> SPI, to match a decrypted packet's session key to the socket. With a
> pointer hack on the lowest bits of skb->extensions such a tiny
> extension could perhaps be embedded in the pointer field itself.
> 
> https://github.com/google/psp/blob/linux-v5.15-psp-v1.0/include/net/psp_defs.h

So.. the most I could compress it to without sacrificing any security
was:

struct psp_skb_ext {
	u32 spi;
	u16 generation;
	u8 version;
};

I took the liberty to cut the generation down to 16 bits. The version
is not necessary if we assume all machines and flow run a single
version. But then why is the auth-only version even in the spec :(

In any case, you're right that this would fit into the pointer with
minor clever encoding. It felt even more hacky than extending shinfo
TBH.

I'd be curious to hear other opinions!
