Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F3A41C9F8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345799AbhI2QTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344020AbhI2QTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 12:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D10C961353;
        Wed, 29 Sep 2021 16:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632932289;
        bh=S79irzCLmLoJh10SJfq3xLHcqmeiQCHBKW/lpibZeMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BV5dpfjjsRh40sZ4XGQS9X8JtH2bEOtQKcU9Ad7mgyAuJ7aesYKqHesSXtiuZoeOC
         qC5O9+PbQWg3gHA8/h52PRYAP1f1bcnKroIs5gW4EVVmtJTv2iVvmzE9K9WmcfxMa2
         faluT3+ZfHuM7ocAMObsykSeG2tK5C4q7v/Tm34ZdtzDJxb8mDPth8hvy90VF9/Frg
         kRw/ivDWzyLinnl6V3JlNaURxyxd7aQAvfjWN9eNl3M5Aprs7+Zndh9XfdJ8YyIPkh
         cWuAL7dYxq5pqYgpvClvdM7PshzwHXMrToEQ2fUEtctDPEqRfCXdxzoPm85DXQ08Tb
         8A+pEzjq69Qeg==
Date:   Wed, 29 Sep 2021 17:18:04 +0100
From:   Will Deacon <will@kernel.org>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/4] bpf: define bpf_jit_alloc_exec_limit for
 arm64 JIT
Message-ID: <20210929161804.GF22029@willie-the-truck>
References: <20210924095542.33697-1-lmb@cloudflare.com>
 <20210924095542.33697-3-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924095542.33697-3-lmb@cloudflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 10:55:40AM +0100, Lorenz Bauer wrote:
> Expose the maximum amount of useable memory from the arm64 JIT.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  arch/arm64/net/bpf_jit_comp.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 41c23f474ea6..803e7773fa86 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -1136,6 +1136,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>  	return prog;
>  }
>  
> +u64 bpf_jit_alloc_exec_limit(void)
> +{
> +	return BPF_JIT_REGION_SIZE;
> +}

Looks like this won't result in a functional change, as we happen to return
SZ_128M anyway thanks to the way in which the modules area is constructed.

But making this explicit is definitely better, so:

Acked-by: Will Deacon <will@kernel.org>

(I'm assuming this will go via the bpf tree, but please shout if I should
take it via arm64 instead)

Will
