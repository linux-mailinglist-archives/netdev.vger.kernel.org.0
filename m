Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EC3622118
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiKIA5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiKIA5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:57:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAB165E50;
        Tue,  8 Nov 2022 16:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC812CE1C63;
        Wed,  9 Nov 2022 00:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFD4C4315A;
        Wed,  9 Nov 2022 00:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667955421;
        bh=flGL+TpD5Fkefv73Yw46fTR11p1n4+4sQ9Bh2y+Qbuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rrWa39DU6eGd3rgo9CoktQV2aveHwtrShL0tMQ+sKjKnI6D7K4PqzTv65vKl4G7pe
         rKLvfsvOGchvy0R+cDb66BS/pLuSMFLktMuqEGNeIGwMi8UqE6T6CUiwgKOdictGNJ
         sxubUQmerBlp+GqbRQT8vf6AGkR/FCjGvQpNLOtbOef0WW9C13fw9h8/61bZoy3etu
         1Xkj+njdLKiQdU1Jt2Sg0Qb5uq54z5FlOwhGhUKqnEYNy0AvwdkjieMFlSM+aupNJa
         lD70ZrGUEg/mLLJoKE0QXSDghWo22q2B2n3hu3RSjRLVtsLMhDrbzGC57thjl1874E
         w7FKQQ3jSDnuw==
Date:   Tue, 8 Nov 2022 16:56:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     kernel-team@fb.com, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
Message-ID: <20221108165659.59d6f6b1@kernel.org>
In-Reply-To: <20221107175240.2725952-2-shr@devkernel.io>
References: <20221107175240.2725952-1-shr@devkernel.io>
        <20221107175240.2725952-2-shr@devkernel.io>
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

On Mon,  7 Nov 2022 09:52:39 -0800 Stefan Roesch wrote:
> This adds the napi busy polling support in io_uring.c. It adds a new
> napi_list to the io_ring_ctx structure. This list contains the list of
> napi_id's that are currently enabled for busy polling. The list is
> synchronized by the new napi_lock spin lock. The current default napi
> busy polling time is stored in napi_busy_poll_to. If napi busy polling
> is not enabled, the value is 0.
> 
> The busy poll timeout is also stored as part of the io_wait_queue. This
> is necessary as for sq polling the poll interval needs to be adjusted
> and the napi callback allows only to pass in one value.
> 
> Testing has shown that the round-trip times are reduced to 38us from
> 55us by enabling napi busy polling with a busy poll timeout of 100us.

What's the test, exactly? What's the network latency? Did you busy poll
on both ends?

I reckon we should either find a real application or not include any
numbers. Most of the quoted win likely comes from skipping IRQ
coalescing. Which can just be set lowered if latency of 30usec is 
a win in itself..

Would it be possible to try to integrate this with Jonathan's WIP
zero-copy work? I presume he has explicit NAPI/queue <> io_uring
instance mapping which is exactly the kind of use case we should 
make a first-class citizen here.

> +	spin_lock(&ctx->napi_lock);
> +	list_for_each_entry(ne, &ctx->napi_list, list) {
> +		if (ne->napi_id == napi_id) {
> +			ne->timeout = jiffies + NAPI_TIMEOUT;

What's the NAPI_TIMEOUT thing? I don't see it mentioned in 
the commit msg.

> +	list_for_each_entry_safe(ne, n, napi_list, list) {
> +		napi_busy_loop(ne->napi_id, NULL, NULL, true, BUSY_POLL_BUDGET);

You can't opt the user into prefer busy poll without the user asking
for it. Default to false and add an explicit knob like patch 2.

>  		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>  	}
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	else if (!list_empty(&local_napi_list)) {
> +		iowq.busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
> +	}
> +#endif

You don't have to break the normal bracket placement for an ifdef:

	if (something) {
		boring_code();

#ifdef CONFIG_WANT_CHEESE
	} else if (is_gouda) {
		/* mmm */
		nom_nom();
#endif
	}
