Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D718D6982B4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjBORwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBORwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:52:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19EB2FCC7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B47AB82322
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE32C433EF;
        Wed, 15 Feb 2023 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676483522;
        bh=R0rqCVhrGDEfg+Lv+6sIuDbeY/4ut4k3a94bR424Lfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DbNQ1A4BA70S+T8IeDO7A0Pqh45OXcb63ZM11aZf3nSmigFmOtn49vJwV42OeTLAU
         5wtgAiUqxakDhsi0MmIqe2nsKTRqh9/r5ohfTvze58kCDytWlhi/h28FWtK7w0l3im
         BY+7LQnDGceL5MZUJjSe9U+sloinbkd0+k5WjWIizNVoMfFQFQYzfuMomE6DJugsrM
         1qq+xf7ADSUSWVY+EKJv7E5cG7W5H2HGeMYupE28TGow0EQY74tLjWb5a4vRYOkqU6
         hhXadzrM5sjkxaIYessg+0QzmOwwtWmFmXz14I9nZ8P2YSHX4dJwsNeoKakeMhPVXy
         IoApzXnytM52w==
Date:   Wed, 15 Feb 2023 09:52:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <willemb@google.com>, <fw@strlen.de>
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Message-ID: <20230215095200.0d2e3b7e@kernel.org>
In-Reply-To: <f2a30934-a0fe-ae1e-0897-2bb7dc572270@intel.com>
References: <20230215034355.481925-1-kuba@kernel.org>
        <20230215034355.481925-3-kuba@kernel.org>
        <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
        <f2a30934-a0fe-ae1e-0897-2bb7dc572270@intel.com>
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

On Wed, 15 Feb 2023 17:17:53 +0100 Alexander Lobakin wrote:
> > On 15/02/2023 03:43, Jakub Kicinski wrote:  
> >> On the driver -> GRO path we can avoid thrashing the kmemcache
> >> by holding onto one skb_ext.  
> > 
> > Hmm, will one be enough if we're doing GRO_NORMAL batching?
> > As for e.g. UDP traffic up to 8 skbs (by default) can have
> >  overlapping lifetimes.
> >   
> I thought of an array of %NAPI_SKB_CACHE_SIZE to be honest. From what
> I've ever tested, no cache (for any netstack-related object) is enough
> if it can't serve one full NAPI poll :D

I was hoping to leave sizing of the cache until we have some data from
a production network (or at least representative packet traces).

NAPI_SKB_CACHE_SIZE kinda assumes we're not doing much GRO, right?
And the current patch feeds the cache exclusively from GRO...

> + agree with Paolo re napi_reuse_skb(), it's used only in the NAPI
> context and recycles a lot o'stuff already, we can speed it up safely here.

LMK what's your opinion on touching the other potential spots, too.
(in Paolo's subthread).
