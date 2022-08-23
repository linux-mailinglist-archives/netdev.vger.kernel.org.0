Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE46D59EFA1
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiHWXXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiHWXXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:23:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C24D895E3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 16:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E35C5CE2049
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 23:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C0BC433C1;
        Tue, 23 Aug 2022 23:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661296980;
        bh=LP1XVIKMUulWV8jrChoFwZ1vXqm8uX8Dgevyzd6rOFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGzaaW19VZlh30mmP/BwAYqxtpW5dWiaBc97gE3QuWZKFFDXrvK5PwtMFnArJ9bMH
         3IuzIs4ikuXjn+fY5oIodsdYdvOn7U9BCk+yZ4buKQzsVHEuJMN4yQezm1A9rag3KW
         Ioa7tu8B5+Z64j9AbMoS/a0xJfVJKA0LAUdjawEv7qJt8AtMvCwBAPq7MVlbyU9QRB
         oxuWwhEuFdgZhec3Vvgvb1DwnJ4gT+7j1l34QvE3V/FZSvN8dVJXCBMcRDEx+3qfPE
         7VVD3j/gG2MCnatgUeM5hWqBThxsIrdsF1lghqD8GuvwUfvI8GcEDHsRzqQZZ3XrGV
         NA12nwsTSphQA==
Date:   Tue, 23 Aug 2022 16:22:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Qi Duan <qi.duan@amlogic.com>, Da Xue <da@lessconfused.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: Re: [PATCH net] net: stmmac: work around sporadic tx issue on
 link-up
Message-ID: <20220823162259.36401af0@kernel.org>
In-Reply-To: <72755b6b-f071-1c54-c2fd-5ea0376effe1@gmail.com>
References: <72755b6b-f071-1c54-c2fd-5ea0376effe1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Aug 2022 17:20:37 +0200 Heiner Kallweit wrote:
> This is a follow-up to the discussion in [0]. It seems to me that
> at least the IP version used on Amlogic SoC's sometimes has a problem
> if register MAC_CTRL_REG is written whilst the chip is still processing
> a previous write. But that's just a guess.
> Adding a delay between two writes to this register helps, but we can
> also simply omit the offending second write. This patch uses the second
> approach and is based on a suggestion from Qi Duan.
> Benefit of this approach is that we can save few register writes, also
> on not affected chip versions.
> 
> This patch doesn't apply cleanly before the commit marked as fixed.
> There's nothing wrong with this commit.

I don't think this is right, please do your best to identify where
the bug was actually introduced and put that in the Fixes tag.

IIRC this is not the first time you've made this choice so let's
sort this out, we can bring it up with Greg if you would like,
I don't see it clarified in the docs.

My understanding and experience doing backports for my employer is 
that cutting off the Fixes tag at the place patch application fails 
is very counter productive. Better to go too far back and let 
the person maintaining the tree decide if the backport is needed.

> [0] https://www.spinics.net/lists/netdev/msg831526.html
> 
> Fixes: 11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")
