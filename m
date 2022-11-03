Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745C3617E37
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 14:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiKCNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 09:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiKCNml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 09:42:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D7D18B32;
        Thu,  3 Nov 2022 06:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0B0E61EA2;
        Thu,  3 Nov 2022 13:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE18BC433C1;
        Thu,  3 Nov 2022 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667482925;
        bh=3jsKADiAmNuQIC30OLz8RxCZAyyfOwsw/u8r+UDv2c4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lcr6RBe4JVFUAhdQlwdsSe/GbSv48SgYQ3QilGiO5ItT7LOV08u8eKlDvaUuKF9eU
         kWcljStfa42fHZ15BPHRXPQK3V5RVHRetc53f8BWVwOVcEuYw7bEoVZ2qL1SBHZ5e0
         NaO3gPU0QkGOrnIudOdnUvz5NNzQiWMGxpZcJQj1FXfDMEFuMzEWP5OTva0ubr4QmO
         oIdHeC1f657NHdB2kuHRZMBG1qc8kEpqSIPFHUkp8sGpCe0kxCtFrrzfzXUss2Vn+t
         c6AX02t7z23ZpSz6YPmb+ZMzVdrHax8NvMrjikGktTcG/ZJKgoP7IjOWAT/Q79Usl1
         /N+UH4CUVBY+w==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>, olsajiri@gmail.com,
        ast@kernel.org, daniel@iogearbox.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, peterz@infradead.org, toke@redhat.com,
        David.Laight@aculab.com, rostedt@goodmis.org
Subject: Re: [PATCH 0/2] bpf: Yet another approach to fix the BPF dispatcher
 thing
In-Reply-To: <20221103120012.717020618@infradead.org>
References: <20221103120012.717020618@infradead.org>
Date:   Thu, 03 Nov 2022 14:42:01 +0100
Message-ID: <875yfwrw7q.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> Hi!
>
> Even thought the __attribute__((patchable_function_entry())) solution to =
the
> BPF dispatcher woes works, it turns out to not be supported by the whole =
range
> of ageing compilers we support. Specifically this attribute seems to be G=
CC-8
> and later.
>
> This is another approach -- using static_call() to rewrite the dispatcher
> function. I've compile tested this on:
>
>   x86_64  (inline static-call support)
>   i386    (out-of-line static-call support)
>   aargh64 (no static-call support)
>
> A previous version was tested and found working by Bjorn.
>
> It is split in two patches; first reverting the current approach and then
> introducing the new for ease of review.

Took it for a spin on x86_64/KVM. For the series:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
