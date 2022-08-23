Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BFF59EE14
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiHWVUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiHWVUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:20:38 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A47796AF;
        Tue, 23 Aug 2022 14:20:34 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQbK1-000EWz-VJ; Tue, 23 Aug 2022 23:20:30 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oQbK1-000VIH-Oo; Tue, 23 Aug 2022 23:20:29 +0200
Subject: Re: [PATCH v2 bpf] bpf: Fix a data-race around bpf_jit_limit.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220823181247.90349-1-kuniyu@amazon.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <311e4686-a514-b210-080b-849d8d0ad5d3@iogearbox.net>
Date:   Tue, 23 Aug 2022 23:20:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220823181247.90349-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26636/Tue Aug 23 09:52:45 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 8:12 PM, Kuniyuki Iwashima wrote:
> While reading bpf_jit_limit, it can be changed concurrently.
> Thus, we need to add READ_ONCE() to its reader.

For sake of a better/clearer commit message, please also provide data about the
WRITE_ONCE() pairing that this READ_ONCE() targets. This seems to be the case in
__do_proc_doulongvec_minmax() as far as I can see. For your 2nd sentence above
please also include load-tearing as main motivation for your fix.

> Fixes: ede95a63b5e8 ("bpf: add bpf_jit_limit knob to restrict unpriv allocations")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v2:
>    * Drop other 3 patches (No change for this patch)
> 
> v1: https://lore.kernel.org/bpf/20220818042339.82992-1-kuniyu@amazon.com/
> ---
>   kernel/bpf/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c1e10d088dbb..3d9eb3ae334c 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -971,7 +971,7 @@ pure_initcall(bpf_jit_charge_init);
>   
>   int bpf_jit_charge_modmem(u32 size)
>   {
> -	if (atomic_long_add_return(size, &bpf_jit_current) > bpf_jit_limit) {
> +	if (atomic_long_add_return(size, &bpf_jit_current) > READ_ONCE(bpf_jit_limit)) {
>   		if (!bpf_capable()) {
>   			atomic_long_sub(size, &bpf_jit_current);
>   			return -EPERM;
> 

