Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70B6E4FF6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjDQSM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjDQSM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:12:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0BD6A6E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 176FB62930
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14D7C433D2;
        Mon, 17 Apr 2023 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681755125;
        bh=OqR+bOLipS8nPBR2XQAsqxxSNFxvqQXb2guWnAGoPkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LRNvj1+l3fUEZjDLrxR4H5tMsonaW1HvP2TH7Kx2rqebpxbwm7Rwjl8y8nH5BbWHa
         o9KleFX3Z6VKHWItMdwiIK8OMOX+XNS8HEqIcMurkqRuL3m3fXetVHADfEpLA2SZrq
         l18Sgm8Er/WNVnmTClO2vKkw/c2TEDwLqTfiX+0gEpMqWhKgacgY2LiYmWkyt9Qt8w
         hG0VQJtZI/435dkezgjV8E4bES8wpzV+L7GiicSgjsCF6PeHgGpebEPb7RxoLH66mW
         80nl4MjO++khUPIOYZ3kYVw9WdwkygB0uizpIJdflFI8SxWCTVSD2Sp0UZZa3PUCQS
         IbQUex8Ki790w==
Date:   Mon, 17 Apr 2023 11:12:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <20230417111204.08f19827@kernel.org>
In-Reply-To: <ZDqHmCX7D4aXOQzl@lore-desk>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
        <20230414184653.21b4303d@kernel.org>
        <ZDqHmCX7D4aXOQzl@lore-desk>
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

On Sat, 15 Apr 2023 13:16:40 +0200 Lorenzo Bianconi wrote:
> > What about high order? If we use bulk API for high order one day, 
> > will @slow_high_order not count calls like @slow does? So we should
> > bump the new counter for high order, too.  
> 
> yes, right. AFAIU "slow_high_order" and "slow" just count number of
> pages returned to the pool consumer and not the number of pages
> allocated to the pool (as you said, since we do not use bulking
> for high_order allocation there is no difference at the moment).
> What I would like to track is the number of allocated pages
> (of any order) so I guess we can just increment "pages" counter in
> __page_pool_alloc_page_order() as well. Agree?

Yup, that sounds better.

> > Which makes it very similar to pages_state_hold_cnt, just 64bit...  
> 
> do you prefer to use pages_state_hold_cnt instead of adding a new
> pages counter?

No strong preference either way. It's a tradeoff between saving 4B 
and making the code a little more complex. Perhaps we should stick 
to simplicity and add the counter like you did. Nothing stops us from
optimizing later.
