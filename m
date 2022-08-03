Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B5D588EEA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbiHCOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiHCOuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:50:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D9339BB2
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 07:50:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53F49B822CC
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 14:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6EAC433D6;
        Wed,  3 Aug 2022 14:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659538199;
        bh=9HajuyeZMAVt8YkNTuz3ll5J8L1I3zvbE201xxDhrN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b3Uh1ClBayeNsJnsFYTRvlB3x8790ozCBMYViMTrQj9+/UPoJqpjSeP8NcZlui8Nq
         863gdFf2I1GiCn6KSitqhJJ/XihxtzIDb9QcLmEeqZTFj9LyXL1zOupP8cyyeGYtBd
         Nl67PjWx2jb7YyUO516SNIPIIdfdcsoUOjsWZU0zj7z0qk+dY5DkuTUVJkNg9KUZLk
         uOHHdUCC5WCss+EcATcgoIFks4f/ax1M9k3NNzROc3iDFLDDj25/wvGxd+UkpSmqdv
         RpI34ZM2ldKi2M3nsVDCd0M/PSBhei0cTIwJKrkVHLXaxVuxBL7EffICullkEFeW7w
         CLPxN/ZJwKLSA==
Date:   Wed, 3 Aug 2022 07:49:57 -0700
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
        Boris Pismenny <borisp@nvidia.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <20220803074957.33783ad4@kernel.org>
In-Reply-To: <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
        <20220801124239.067573de@kernel.org>
        <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
        <20220802083731.22291c3b@kernel.org>
        <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
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

On Wed, 3 Aug 2022 09:33:48 +0000 Maxim Mikityanskiy wrote:
> > > The documentation of rcu_access_pointer says it shouldn't be used on
> > > the update side, because we lose lockdep protection:
> > > 
> > > --cut--
> > > 
> > > Although rcu_access_pointer() may also be used in cases
> > > where update-side locks prevent the value of the pointer from changing,
> > > you should instead use rcu_dereference_protected() for this use case.  
> > 
> > I think what this is trying to say is to not use the
> > rcu_access_pointer() as a hack against lockdep:  
> 
> Well, maybe we understand it in different ways. This is how I parsed it
> (the whole comment):
> 
> 1. rcu_access_pointer is not for the read side. So, it's either for the
> write side or for usage outside all locks.
> 
> 2. It's not for dereferencing. So, it's for reading the pointer's value
> on the write side or outside all locks.
> 
> 3. Although it can be used on the write side, rcu_dereference_protected
> should be used. So, it's for reading the pointer's value outside all
> locks.

Using rcu_deref* when we don't dereference the pointer does not compute
for me, but it's not a big deal. 

Let me CC Paul for clarification of the docs, as it may also be
confusing to others and therefore worth rewording. But our case is 
not that important so unless Paul chimes in clearly indicating one
interpretation is right - either way is fine by me for v2.
