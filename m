Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108C16D711E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbjDEALC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjDEALA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:11:00 -0400
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69E4225
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:10:58 -0700 (PDT)
Message-ID: <eb07aa5a-e44c-67b7-e9c9-bd65602680ae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680653456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pI/qjDgoSqxgaYlHstx2idRdrUQGA4h8mGEgGSebTfw=;
        b=I1K9m/s/Oyz+3RDoZAXi/9rYjRSX4VvriFpuVN4zJj95t4RYGUqyD+uG1PMXGDLQN6gtCa
        xtCtaauyciyoBZT4kPeQmf4nOVfibAcelnFnlXPuVF9G+rPAqc9sk73pDv+cERNEdoMkta
        T7JjWbIPOpU9x9t2WdUzq/VEuEO/xZo=
Date:   Tue, 4 Apr 2023 17:10:49 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next 4/8] bpf: Teach verifier that certain helpers
 accept NULL pointer.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, davem@davemloft.net
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404045029.82870-5-alexei.starovoitov@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230404045029.82870-5-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/23 9:50 PM, Alexei Starovoitov wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1f2abf0f60e6..727c5269867d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4998,7 +4998,7 @@ const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto = {
>   	.func		= bpf_get_socket_ptr_cookie,
>   	.gpl_only	= false,
>   	.ret_type	= RET_INTEGER,
> -	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON | PTR_MAYBE_NULL,

I think the bpf_skc_to_* helpers (eg. bpf_skc_to_tcp_sock) also need similar 
change. They are available to tracing also. It can be a follow-up. The patch set 
lgtm.
