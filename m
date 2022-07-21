Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9E957C451
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiGUGXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGUGXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:23:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FB113F9E
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 23:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F49BCE22D2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 06:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1920C3411E;
        Thu, 21 Jul 2022 06:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658384580;
        bh=ljq+KVb8aqRXpOcqnX8eQRNXKoE5wWsWhpaOgwbqhEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erBSOJhCcCpBZNGbAbAjtSuqzYprvRzj6vqUqqHjKMatTFKrUB4Tar3am68Pu51Jk
         MaZa7vBOWPBLle73ThHfx2jugL3p2t0S6iiaQHolp0roYSPfYTGRmfpAM9LdKc4/oX
         VOWRTbmCOvuoD+sy2FlNJaToAcaDU7Ig5fqR8JHVc5XcUXPm7E2iaBtgVvya52GjV3
         L98dH8NuxvqY4oW1bAg/2j0AyfqG9IzKy0yrLiCM66zYTsVh9kJE9QZQyH0cEDDeg4
         3jKh1G4TcaOah/FxUarFz1YcXLkEwvOQqQkASQf76klwLBcPzkNfNILYzcjOyueG9l
         A5HzklAlSyXzw==
Date:   Wed, 20 Jul 2022 23:22:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <20220720232258.22139059@kernel.org>
In-Reply-To: <YtjpaRtkOwX00azI@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
        <20220720151234.3873008-2-jiri@resnulli.us>
        <20220720174953.707bcfa9@kernel.org>
        <YtjpaRtkOwX00azI@nanopsycho>
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

On Thu, 21 Jul 2022 07:51:37 +0200 Jiri Pirko wrote:
> >Hm. I always assumed we'd just use the xa_lock(). Unmarking the
> >instance as registered takes that lock which provides a natural 
> >barrier for others trying to take a reference.  
> 
> I guess that the xa_lock() scheme could work, as far as I see it. But
> what's wrong with the rcu scheme? I actually find it quite neat. No need
> to have another odd iteration helpers. We just benefit of xa_array rcu
> internals to make sure devlink pointer is valid at the time we make a
> reference. Very clear.

Nothing strongly against the RCU scheme, TBH. Just didn't expect it.
I can concoct some argument like it's one extra sync primitive we
haven't had to think about in devlink so far, but really if you prefer
RCU, I don't mind.

I do like the idea of wrapping the iteration into our own helper, tho.
Contains the implementation details of the iteration nicely. I didn't
look in sufficient detail but I would have even considered rolling the
namespace check into it for dump.
