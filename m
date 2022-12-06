Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1E464436F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiLFMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiLFMuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:50:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B969DFA8;
        Tue,  6 Dec 2022 04:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 261B1B815A6;
        Tue,  6 Dec 2022 12:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966D2C433C1;
        Tue,  6 Dec 2022 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670331013;
        bh=5fkVXllCSjBZuVo8Uv46ZK/hvRL1/H1PEhU3z7MLu9U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Pl0mLg6/LiKcbhhSy0QHR1e32ydRmRC+61dwkYzb/s06blHeIrSqAXDAOUctG6l6C
         0Z5tCluonCZ66PUPkB3+flY/v5c7MLvc4CQ3JR45gOtJdw5g8PGq3lQMqY7acWIcFt
         wRrkj0B/xseEs/Y5odZNwPgYoFP7D0li3cLTAy1DbRzNnQVOzCHZBOXJY6OCok8GBf
         HO51IJjrXBsZtjXmzw1O/u5j+iEwVXknWuJWqRCD0JoaRvlYOHAmvljkDgSlXCwt+4
         bZ0VQ68sTh91wcjEYe9MZ9mcajrf55N8sUL4OtWWOd1QM74NANjuiU1nJ8jnj780wg
         xkjBZkpxi9Nlg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7A6E982E386; Tue,  6 Dec 2022 13:50:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
In-Reply-To: <Y451ENAK7BQQDJc/@zx2c4.com>
References: <20221205181534.612702-1-Jason@zx2c4.com>
 <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
 <Y451ENAK7BQQDJc/@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Dec 2022 13:50:10 +0100
Message-ID: <87lenku265.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> On Mon, Dec 05, 2022 at 11:21:51PM +0100, Daniel Borkmann wrote:
>> On 12/5/22 7:15 PM, Jason A. Donenfeld wrote:
>> > Since BPF's bpf_user_rnd_u32() was introduced, there have been three
>> > significant developments in the RNG: 1) get_random_u32() returns the
>> > same types of bytes as /dev/urandom, eliminating the distinction between
>> > "kernel random bytes" and "userspace random bytes", 2) get_random_u32()
>> > operates mostly locklessly over percpu state, 3) get_random_u32() has
>> > become quite fast.
>> 
>> Wrt "quite fast", do you have a comparison between the two? Asking as its
>> often used in networking worst case on per packet basis (e.g. via XDP), would
>> be useful to state concrete numbers for the two on a given machine.
>
> Median of 25 cycles vs median of 38, on my Tiger Lake machine. So a
> little slower, but too small of a difference to matter.

Assuming a 3Ghz CPU clock (so 3 cycles per nanosecond), that's an
additional overhead of ~4.3 ns. When processing 10 Gbps at line rate
with small packets, the per-packet processing budget is 67.2 ns, so
those extra 4.3 ns will eat up ~6.4% of the budget.

So in other words, "too small a difference to matter" is definitely not
true in general. It really depends on the use case; if someone is using
this to, say, draw per-packet random numbers to compute a drop frequency
on ingress, that extra processing time will most likely result in a
quite measurable drop in performance.

-Toke
