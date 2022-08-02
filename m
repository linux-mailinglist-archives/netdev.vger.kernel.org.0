Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7A587F06
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiHBPhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHBPhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8012621
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 08:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83994B819F0
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 15:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC961C433D7;
        Tue,  2 Aug 2022 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659454653;
        bh=AIRPFLaTVHkJcspt3rHtcIRnTUm18pFbcHW5y6nhGeE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=huuV/xG0ipp+bnY6x01c8HzFWopsxR81YRWoBFLuP2RH9yGhtzTpGawE1IxkOzpaw
         6HN0ZcqOGcnGMYtHAXZvYwxovL340VyCjBte34R372vZCt1HlJ50qY4B8kw9asqBRG
         GnD7jk4xrJR/wmT66t/85w6UGgSjWquSwbcAOV6uNbteehvcWGUzzWbEPHAoOcgV7C
         JFy2rBAE9+LcGqqwra/Bke/h7SW9P95ar7+fFPyl64TLvm1EROU9mJ9nty1hryOhR1
         eBpKCtBAartkjHW/RfJeYtwPXbAOpLhY3xvljbiVaKbHpK+f5NAiSDwBiEbOs93jfc
         T2u0oY895kBXw==
Date:   Tue, 2 Aug 2022 08:37:31 -0700
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
Message-ID: <20220802083731.22291c3b@kernel.org>
In-Reply-To: <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
        <20220801124239.067573de@kernel.org>
        <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
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

On Tue, 2 Aug 2022 12:03:32 +0000 Maxim Mikityanskiy wrote:
> > For cases like this where we don't actually hold onto the object, just
> > take a peek at the address of it we can save a handful of LoC by using
> > rcu_access_pointer().   
> 
> The documentation of rcu_access_pointer says it shouldn't be used on
> the update side, because we lose lockdep protection:
> 
> --cut--
> 
> Although rcu_access_pointer() may also be used in cases
> where update-side locks prevent the value of the pointer from changing,
> you should instead use rcu_dereference_protected() for this use case.

I think what this is trying to say is to not use the
rcu_access_pointer() as a hack against lockdep:


	lock(writer_lock);
	/* no need for rcu_dereference() because we have writer lock */
	ptr = rcu_access_pointer(obj->ptr);
	ptr->something = 1;
	unlock(writer_lock);

It's still perfectly fine to use access_pointer as intended on 
the write side, which is just checking the value of the pointer, 
not deferencing it:

	lock(writer_lock);
	if (rcu_access_pointer(obj->ptr) == target)
		so_something(obj);
	unlock(writer_lock);
