Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32705EC57A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiI0OHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiI0OHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:07:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BC69E890;
        Tue, 27 Sep 2022 07:07:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FAE4B81BE3;
        Tue, 27 Sep 2022 14:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E108BC433D6;
        Tue, 27 Sep 2022 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664287624;
        bh=FHPwFJeY9xWzW2Uk+ZnQDGf3FYmwkr51wCUPbEMEj3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LtB0EZLRO4gsesP4oqdp9LWO1rEq6ilefO8qkDxElaPVeV0KPLwOvEYoLabyouJSb
         zxK6QQKtBbsWcAszvfSsGBAt+ryT6J8lGt2nnwWN0u1LqYEZnF374bhUcyfP97tqVW
         ed05mxqIfbMLK70xty2z78o61uGM1qmC4DBBM2uvsrw+S8he8LOleVF0RuWbY/9X0x
         QyS1Irs5V+1jv2LawotH9adV7k3v5filWe1mgz/jT9jIj3LP7+5+M3+hOOHxnEYYB4
         VbdW+YeMIK3V27ug/p9SKnRwY6XjqDNgbI0m95gcFKDoi4FK79j82hzk9K9us1lypI
         IEqOR4FG+/EKw==
Date:   Tue, 27 Sep 2022 07:07:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][next] net: ethernet: rmnet: Replace zero-length array
 with DECLARE_FLEX_ARRAY() helper
Message-ID: <20220927070702.1c2da2b8@kernel.org>
In-Reply-To: <202209261920.3A2EA07D4@keescook>
References: <YzIei3tLO1IWtMjs@work>
        <202209261502.7DB9C7119@keescook>
        <20220926172604.71a20b7d@kernel.org>
        <202209261920.3A2EA07D4@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 19:22:30 -0700 Kees Cook wrote:
> > Not directly related to this patch, but I just had to look at pahole
> > output for sk_buff and the struct_group() stuff makes is really painful
> > to read :/ Offsets for the members are relative to the "group" and they
> > are all repeated.
> > 
> > Is there any chance you could fix that? Before we sprinkle more pixie
> > dust around, perhaps?  
> 
> Unfortunately I don't see a way around it until we can make changes to
> the C language spec, and that's measured in decades. :(

I think BPF folks have had some success adding C extensions, like
tagging. Some form of attribute would really look so much better than
this DECLARE_FLEX_ARRAY() macro indirection. Maybe it's just me :(

> Perhaps we could add some kind of heuristic to pahole to "hide" one of
> the internal struct_group() copies, and to hide the empty flexible-array
> wrapper structs? (pahole already can't tell the difference between a
> 0-length array and a flexible-array.) Would that be workable?

That'd be my knee-jerk fix, too. Or at least render the offsets for 
the anonymous side of the union as absolute rather than relative.
