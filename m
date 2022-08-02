Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633A3587F0E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiHBPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiHBPib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:38:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A58F1276F
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 08:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFB56B819F1
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 15:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C624C43470;
        Tue,  2 Aug 2022 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659454707;
        bh=fIzCJ/A8a6vH6/x7cNhJl398mBXjZu6wrbWG9gXcteI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dCL8WEVJftCZFzvalMiYtPY/3iawj0EAS5cGjCpsgqCr0m0MhT2QWTSijn3DlQqAD
         ZwyLo+7ZeSzBrH1u+E260VGDQA/dd/tUpRDC5dPV2ds8D1e3arbnO2o9GNAMpH2G21
         on6zDgdbSSwH8iGrOmhlr4xx4cCv8EWfngOGQDdnbCIBZCvajI/qfl1KCHvsyhQY6/
         osYVe0k0GFga1zgtN46O9SWu2kzRbKMi/BUNvbv6VqWXsfnPqcre/UwIeB09EE7OKf
         UmK7J45GdcS+a78WSu3AkT96zLpKNAZRDamqlCXTcWz8o2EMiVEvdNtRkYxTqpF84W
         AoT1KrEX1CgAQ==
Date:   Tue, 2 Aug 2022 08:38:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <20220802083826.162077f2@kernel.org>
In-Reply-To: <4a49be4bb85f99de60cfec4c57bce5f1a356416f.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
        <20220801124419.4aaffcac@kernel.org>
        <4a49be4bb85f99de60cfec4c57bce5f1a356416f.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 12:07:18 +0000 Maxim Mikityanskiy wrote:
> > Oops, looks like we also got some new sparse warnings from this:
> > 
> > 2 new warnings in drivers/net/bonding/bond_main.c
> > 1 new warning  in drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c  
> 
> Looks like neither me, nor our internal CI built these files - sorry!
> I'll fix these and look for the usages more carefully.
> 
> BTW, the bonding case misses even the READ_ONCE, so it's an existing
> bug, exposed by the transition to the proper RCU API in my patch.

Nice! You can slap a fixes tag on it, for accounting purposes, and stick
to net-next in the subject, tree doesn't matter right now.
