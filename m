Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73F3978F5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhFARV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 13:21:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:40888 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhFARVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 13:21:54 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lo83g-000GKb-Tq; Tue, 01 Jun 2021 19:20:04 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lo83g-000LRJ-Ku; Tue, 01 Jun 2021 19:20:04 +0200
Subject: Re: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
To:     Yanfei Xu <yanfei.xu@windriver.com>, ast@kernel.org,
        zlim.lnx@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
 <20210601150625.37419-2-yanfei.xu@windriver.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
Date:   Tue, 1 Jun 2021 19:20:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210601150625.37419-2-yanfei.xu@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26188/Tue Jun  1 13:07:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 5:06 PM, Yanfei Xu wrote:
> It's no need to trigger IPI for keeping pipeline fresh in bpf case.

This needs a more concrete explanation/analysis on "why it is safe" to do so
rather than just saying that it is not needed.

> Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
> ---
>   arch/arm64/net/bpf_jit_comp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index f7b194878a99..5311f8be4ba4 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -974,7 +974,7 @@ static int validate_code(struct jit_ctx *ctx)
>   
>   static inline void bpf_flush_icache(void *start, void *end)
>   {
> -	flush_icache_range((unsigned long)start, (unsigned long)end);
> +	__flush_icache_range((unsigned long)start, (unsigned long)end);
>   }
>   
>   struct arm64_jit_data {
> 

