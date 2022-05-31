Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B187153943B
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345866AbiEaPrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbiEaPrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:47:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663802601;
        Tue, 31 May 2022 08:47:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C99B8119A;
        Tue, 31 May 2022 15:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62864C385A9;
        Tue, 31 May 2022 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654012025;
        bh=YImjX7tnq5yEXBJYEKKMWsOcxx5Ng1oCvYpBACKL/8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kiZERfjowG6otrWW53RhAh557Go68b6AQ9BLkqcTxX/rnmV15j+ejWhOZOzKJ+2yW
         XTI5jF+phz1DI4fHAeKwIAfM4P+DUD6bH14EOg0Zbefaq+ilDdYVTyerWNsSoVkfTi
         G+FoOy6KWmL7dsrQTdEfefH/i8QKzzWcDnwDAA3VJfsOMHbIvBP4gDbCrt4uTtv2zE
         /7L7x9iA7RwcM9rJMhESUh+FR9Zk6GoPQxG91JyhVwohYG05wXeGQKGS8ViGacVmRb
         kD6+N/Ojm9jmgZ3XBcSNGinqEZeetEYq3tKLcnq93M0HUFleREJeCgZOiGSWCHa3r7
         WB43ggHhhhHAw==
Date:   Tue, 31 May 2022 08:47:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
Message-ID: <20220531084704.480133fa@kernel.org>
In-Reply-To: <1654011382-2453-1-git-send-email-chen45464546@163.com>
References: <20220531081412.22db88cc@kernel.org>
        <1654011382-2453-1-git-send-email-chen45464546@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 23:36:22 +0800 Chen Lin wrote:
> At 2022-05-31 22:14:12, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >On Tue, 31 May 2022 22:41:12 +0800 Chen Lin wrote:  
> >> The sample code above cannot completely solve the current problem.
> >> For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE(32768),
> >> __page_frag_cache_refill will return a memory of only 32768 bytes, so 
> >> should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe more 
> >> work needs to be done  
> >
> >Right, but I can think of two drivers off the top of my head which will
> >allocate <=32k frags but none which will allocate more.  
> 
> In fact, it is rare to apply for more than one page, so is it necessary to 
> change it to support? 

I don't really care if it's supported TBH, but I dislike adding 
a branch to the fast path just to catch one or two esoteric bad 
callers.

Maybe you can wrap the check with some debug CONFIG_ so it won't
run on production builds?

> we can just warning and return, also it is easy to synchronize this simple 
> protective measures to lower Linux versions.
