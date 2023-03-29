Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F086CF2C9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjC2TKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjC2TKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:10:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5530A1738;
        Wed, 29 Mar 2023 12:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E438761E03;
        Wed, 29 Mar 2023 19:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C17C433D2;
        Wed, 29 Mar 2023 19:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680117000;
        bh=5Hn7+0ZK5/XQHEYNsy9dx1DtIonq3QdM74Uz2skPZUo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G3+zepOxNynVPmZaS4hNvO6/zX6qVBKnwlSn82n/o7wGoKWCGri1RnaljtckLw9yf
         khL99+7AzWfnOVDyqJir/5uVpC3nLrhk9Cks/iaJeVzda43j+Z1iF+X/b5Kf2CnTW9
         /RzWoIrJYR6h+6+EhkLACxZAx98eAlqly1VxTR8Sl69XuoBPghd4D+ikQgRmCDT2tm
         z7pjBCV5+ANFdkXUv/Wla5tK/KM47HP+D25KsWK8q4srvaQhn/Hq3KRvd16fCaILZW
         WoCs0ECx/Qg9DfpJJ3Cjtm0py1nDTtKp3WfcnkC0wTG7F3zqZM7zuUhyFaHNO+MCbS
         /taF+JQ7RQiEg==
Date:   Wed, 29 Mar 2023 12:09:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: traceability of wifi packet drops
Message-ID: <20230329120959.5f9eef1c@kernel.org>
In-Reply-To: <37311ab0f31d719a65858de31cec7a840cf8fe40.camel@sipsolutions.net>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
        <20230327180950.79e064da@kernel.org>
        <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
        <20230328155826.38e9e077@kernel.org>
        <8304ec7e430815edf3b79141c90272e36683e085.camel@sipsolutions.net>
        <20230329110205.1202eb60@kernel.org>
        <37311ab0f31d719a65858de31cec7a840cf8fe40.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 20:57:26 +0200 Johannes Berg wrote:
> On Wed, 2023-03-29 at 11:02 -0700, Jakub Kicinski wrote:
> > But it's just a thought, all of the approaches seem acceptable.  
> 
> I _think_ I like the one I prototyped this morning better, I'm not sure
> I like the subsystem == existing reason part _that_ much. It ultimately
> doesn't matter much, it just feels odd that you'd be allowed to have a,
> I don't know picking a random example, SKB_DROP_REASON_DUP_FRAG with a
> fine-grained higher bits value?
> 
> Not that we'll ever be starved for space ...

Ack, for most drop_reasons having higher order bits would make no sense.

> > Quick code change perhaps illustrates it best:
> >   
> 
> Yeah, that ends up really looking very similar :-)
> 
> Then again thinking about the implementation, we'd not be able to use a
> simple array for the sub-reasons, or at least that'd waste a bunch of
> space, since there are already quite a few 'main' reasons and we'd
> want/need to add the mac80211 ones (with sub-reason) at the end. So that
> makes a big array for the sub-reasons that's very sparsely populated (*)
> Extending with a high 'subsystem' like I did this morning is more
> compact here.
> 
> (*) or put the sub-reasons pointer/num with the 'main' reasons into the
> drop_reasons[] array but that would take the same additional space

Yup, the only difference is that the collector side is simpler if the
subsystem is a valid drop reason. For those who don't expect to care
about subsystem drop details the aggregate stats are still (bpftrace
notation):

	@stats[reason & 0xffff] = count();

With the higher bits we have to add a layer of stats to the collection?

	$grp = reason >> 24;
	if ($grp != 0)
		@groups[$grp] = count();
	else
		@stats[reason] = count();

That said, I'm probably over-thinking because most will do:

	@stats[reason] = count();

... which works the same regardless.

> So ... which one do _you_ like better? I think I somewhat prefer the one
> with adding a high bits subsystem, but I can relatively easily rejigger
> my changes from this morning to implement the semantics you had here
> too.

No preference. You're coding it up so you're in the best position 
to pick :)
