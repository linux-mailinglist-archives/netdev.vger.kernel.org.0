Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6382489DFF
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbiAJRFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbiAJRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2ECDC06173F;
        Mon, 10 Jan 2022 09:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529AE6133E;
        Mon, 10 Jan 2022 17:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C0EC36AE5;
        Mon, 10 Jan 2022 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641834319;
        bh=UdWl8wuXbg1UuKvjSdkNKobDow52EvDCA/OGcUygQ/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJ/yRtAPWqZqjqWTSZ71bZIPdXqhZ8DKLpL9knwVx9Ug11TfhQsKEoUjAryftb85P
         f1DXOl4Y8ESsSLSYUCCpIpL/TwliJNnl9+kPC8rTN9owRqd4KVyQlAZKCo34ekNNiQ
         NymiGFChxwnQ8rc+PN1TzpZd3WH9nMq3JTgrCkxSztrtd8o+INWtNqzgTHmkMyWLg6
         tdXPvorVIGwGQzSdACUW52BV0r97eXx+26IP5sFuIxalbNp1gJgh+gLklNcrNCKpFY
         e2z1EVdEOjsjkXA5JMHXgbypDV+yh9NxR/cr1XYWVvQSFuBXt6abCGSrw3rLeD4Mfr
         osfV4HyLqJHOg==
Date:   Tue, 11 Jan 2022 00:57:50 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tong Tiangen <tongtiangen@huawei.com>
Subject: Re: [PATCH riscv-next] riscv: bpf: Fix eBPF's exception tables
Message-ID: <Ydxljv2Q4YNDYRTx@xhacker>
References: <20220110165208.1826-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220110165208.1826-1-jszhang@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 12:52:08AM +0800, Jisheng Zhang wrote:
> eBPF's exception tables needs to be modified to relative synchronously.
> 
> Suggested-by: Tong Tiangen <tongtiangen@huawei.com>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  arch/riscv/net/bpf_jit_comp64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
> index 69bab7e28f91..44c97535bc15 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -498,7 +498,7 @@ static int add_exception_handler(const struct bpf_insn *insn,
>  	offset = pc - (long)&ex->insn;
>  	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
>  		return -ERANGE;
> -	ex->insn = pc;
> +	ex->insn = offset;

Hi Palmer,

Tong pointed out this issue but there was something wrong with my email
forwarding address, so I didn't get his reply. Today, I searched on
lore.kernel.org just found his reply, sorry for inconvenience.

Thanks

>  
>  	/*
>  	 * Since the extable follows the program, the fixup offset is always
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
