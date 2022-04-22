Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9926650C0F5
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiDVVLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiDVVLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:11:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8270B36C924
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE9AC61D4F
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 19:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60C3C385A4;
        Fri, 22 Apr 2022 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650657395;
        bh=EnbL+pFKQkK+jHPfkyfBk2Gg32ydsAob/y5+8BvD10c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RZLvzD1DThNfUKgCXWmuZZJYwrlljTvGbeDzghybTzHsZm/lUeSOZnA+uKOml5uCz
         M2PthXyz/opKHfyq5vx+wJ+Wx7nj2F46fI9R8PuTNdnKXGShxTWqlVFxnWKP6zbAtF
         mPmfcGrGe1udrxoyDeCseorWVBrezrM9dd9wxJAKCGEdisDA68gNxrLNfUE+K/QvFc
         elQgqp8tk5B6I5RoZ70w9GqZFy08NtMPez4zqG6q3p1usOJsYeooO7xdATdc4kbu3p
         150pNdAYTHaQ16qF6T4mnP/QSxB2oCUOiEYOkOBnnToGxzMDxbwRJlVFFMIJCVnPhR
         VaFeS5tNm4QIg==
Date:   Fri, 22 Apr 2022 12:56:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment
 net->core_stats
Message-ID: <20220422125632.3636444b@kernel.org>
In-Reply-To: <YmFjdOp+R5gVGZ7p@linutronix.de>
References: <YmFjdOp+R5gVGZ7p@linutronix.de>
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

On Thu, 21 Apr 2022 16:00:20 +0200 Sebastian Andrzej Siewior wrote:
> @@ -3851,7 +3851,7 @@ static inline struct net_device_core_stats *dev_core_stats(struct net_device *de

I think this needs to return __percpu now?
Double check sparse is happy for v2, pls.

>  	struct net_device_core_stats __percpu *p = READ_ONCE(dev->core_stats);
>  
>  	if (likely(p))
> -		return this_cpu_ptr(p);
> +		return p;

