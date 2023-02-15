Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE5E69823C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjBORfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBORfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:35:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3933A84F
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13446CE2331
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9461DC433D2;
        Wed, 15 Feb 2023 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676482507;
        bh=enNaZd9AgStIojhoFtdmMESry47u3a45OS5N9q1nlE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LjpAkbT0rnHnPZTdOngtamOanMUNayDx1nQj5l8qSbAixN0NGUbyNSZ0+6DYv/Lx7
         RvPbzgt254s1iY1lKQCS1IliWKLirvjvFv7YFQpt1uBp3r/GqaF1KRTKg0A6rrwipR
         sesCjnI6kvqKFQlcX2wYXe7nVQ3uxOxTqHCO9X3Qz5OHoWYi6zWcXPYdZ4QcbWvty8
         BzRND89nLQUWe8nyF0Kjt5iUFcQsWwtH7XnnHuYGenzX9+06/L4CnNdhnFZ5e+2go5
         xwsrXajpEo/cfZNVigMwzF73nZDEEfCP6FCju+cqENDZKsgO0uvEumt1aJP2hfeE8F
         kMm26d0VFenug==
Date:   Wed, 15 Feb 2023 09:35:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, fw@strlen.de,
        saeedm@nvidia.com, leon@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, roid@nvidia.com, ozsh@nvidia.com,
        paulb@nvidia.com
Subject: Re: [PATCH net-next 3/3] net: create and use NAPI version of
 tc_skb_ext_alloc()
Message-ID: <20230215093505.4b27c8ea@kernel.org>
In-Reply-To: <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com>
References: <20230215034355.481925-1-kuba@kernel.org>
        <20230215034355.481925-4-kuba@kernel.org>
        <CAM0EoMnkcvHpbJY-Tqo8CngN4Y_hnYoeaYCMW+OVXcNVAbwzug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Feb 2023 11:50:55 -0500 Jamal Hadi Salim wrote:
> Dumb question: Would this work with a consumer of the metadata past
> RPS stage? didnt look closely but assumed per cpu skb_ext because of
> the napi context - which will require a per cpu pointer to fetch it
> later.

The cache is just for allocation, specifically for the case where
driver allocates the skb and it's quickly coalesced by GRO.
The lifetime of the allocated object is not changed.
