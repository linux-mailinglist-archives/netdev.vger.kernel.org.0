Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A432857D1FF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiGUQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiGUQvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:51:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8048BA93;
        Thu, 21 Jul 2022 09:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23936B825DC;
        Thu, 21 Jul 2022 16:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645ABC3411E;
        Thu, 21 Jul 2022 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658422295;
        bh=9hfSjSU6ZEOEWK+4sagbygAVSU3WAbHmJYkaTJ7NNWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UMSv/3zccNh7CJYI+Vr63UmnZOWfZTvtgdrCMyw5flAvpN/345DvFqWoAHNDgp+x6
         UR/wflk5IpJy3+1Qj8DDFcNswghe6MHZu56pin7eOQblqKtSyiCU4YxgV0stK4Unlv
         U5G8Qktiq/2NnwrZuyHVPz6wJwHEx2AGK+bHyk0W/ZO10WZFEkuol1cZgpZ9rR7Wc4
         vMF6oUpRzcGj9cEhSC8LGLF9jn6+z2nOJZF+Hu3mCBJ/C53oVEYVUJ1CIpKgzCwrA8
         FyCPpZoSYsHMCxp5Z/0maq4raUACS6xzgb7Vg7s+5d1GrWVHJ+R+x5W6XaJCceS8Zn
         HB5AIW0hHsc6g==
Date:   Thu, 21 Jul 2022 09:51:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, llvm@lists.linux.dev
Subject: Re: [PATCH net-next 18/29] can: pch_can: do not report txerr and
 rxerr during bus-off
Message-ID: <20220721095134.47ac717e@kernel.org>
In-Reply-To: <Ytl8x20qmsKyYJpS@dev-arch.thelio-3990X>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
        <20220720081034.3277385-19-mkl@pengutronix.de>
        <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
        <20220721154725.ovcsfiio7e6hts2n@pengutronix.de>
        <CAMZ6RqLdYCqag_MDp7dj=u1SEjx1r=bs_xHG26w11_A_D_SumQ@mail.gmail.com>
        <Ytl8x20qmsKyYJpS@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 09:20:23 -0700 Nathan Chancellor wrote:
> > That said, I have one complaint: this type of warning is reported at
> > W=2 *but* W=2 output is heavily polluted, mostly due to a false
> > positive on linux/bits.h's GENMASK_INPUT_CHECK(). Under the current
> > situation, the relevant warings become invisible with all the
> > flooding.
> > I tried to send a patch to silence a huge chunk of the W=2 spam in [1]
> > but it got rejected. I am sorry but even with the best intent, I might
> > repeat a similar mistake in the future. The W=2 is just not usable.
> > 
> > [1] https://lore.kernel.org/all/20220426161658.437466-1-mailhol.vincent@wanadoo.fr/  
> 
> Yes, having -Wmaybe-uninitialized in W=2 is unfortunate because these
> types of mistakes will continue to happen. I have been fighting this for
> a while and so has Dan Carpenter, who started a thread about it a couple
> of months ago but it doesn't seem like it really went anywhere:
> 
> https://lore.kernel.org/20220506091338.GE4031@kadam/

FWIW it's reported by clang and was in fact reported in the netdev
patchwork:
https://patchwork.kernel.org/project/netdevbpf/patch/20220720081034.3277385-19-mkl@pengutronix.de/
DaveM must have not looked before pulling :S
