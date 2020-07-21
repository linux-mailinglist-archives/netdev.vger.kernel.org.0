Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5AC228185
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgGUOBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbgGUOBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:01:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12230C061794;
        Tue, 21 Jul 2020 07:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=oTgZRI0XTu+KKf9fJAsHbk4XxWkP+3+hZL933Fd82/8=; b=b0oozE+birNetBzfoYgQHxGVGy
        ZO/qzInVOC3h4VIIGMH/QOrEBklKfJvle7+UZ5VP7SlvSIAiGtF1T55eeojMweHh5TpGfylkQuRud
        trTMxJDln34y/fLAl+IqbSSLScmTGt8umCAI0TR7R0i4p82u9Kl2SQwTHndRMvehSAkOkBman/x5T
        oCQjnXVNv9FdiAw9mZfxR727UsViizJB8mKXOGAU9EMN8b2rmtkOUWN/TF7SphLuUOmT7WeiXwhCX
        UsVkT0AdUzzY/MJTpC8z+l8Uvv2NhvgPzdltrtJyJU/OC5jOC0TOMJw4Frh86pmbpus6z00Ohpmgq
        qel0geGw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxspL-0007ME-IB; Tue, 21 Jul 2020 14:01:03 +0000
Subject: Re: [PATCH bpf-next] bpf, netns: Fix build without CONFIG_INET
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20200721100716.720477-1-jakub@cloudflare.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1140c2d9-f0a4-97da-5f3f-23190e6bc6b9@infradead.org>
Date:   Tue, 21 Jul 2020 07:00:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721100716.720477-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/20 3:07 AM, Jakub Sitnicki wrote:
> When CONFIG_NET is set but CONFIG_INET isn't, build fails with:
> 
>   ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_unneed':
>   kernel/bpf/net_namespace.c:32: undefined reference to `bpf_sk_lookup_enabled'
>   ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_need':
>   kernel/bpf/net_namespace.c:43: undefined reference to `bpf_sk_lookup_enabled'
> 
> This is because without CONFIG_INET bpf_sk_lookup_enabled symbol is not
> available. Wrap references to bpf_sk_lookup_enabled with preprocessor
> conditionals.
> 
> Fixes: 1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  kernel/bpf/net_namespace.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> index 4e1bcaa2c3cb..71405edd667c 100644
> --- a/kernel/bpf/net_namespace.c
> +++ b/kernel/bpf/net_namespace.c
> @@ -28,9 +28,11 @@ DEFINE_MUTEX(netns_bpf_mutex);
>  static void netns_bpf_attach_type_unneed(enum netns_bpf_attach_type type)
>  {
>  	switch (type) {
> +#ifdef CONFIG_INET
>  	case NETNS_BPF_SK_LOOKUP:
>  		static_branch_dec(&bpf_sk_lookup_enabled);
>  		break;
> +#endif
>  	default:
>  		break;
>  	}
> @@ -39,9 +41,11 @@ static void netns_bpf_attach_type_unneed(enum netns_bpf_attach_type type)
>  static void netns_bpf_attach_type_need(enum netns_bpf_attach_type type)
>  {
>  	switch (type) {
> +#ifdef CONFIG_INET
>  	case NETNS_BPF_SK_LOOKUP:
>  		static_branch_inc(&bpf_sk_lookup_enabled);
>  		break;
> +#endif
>  	default:
>  		break;
>  	}
> 


-- 
~Randy
