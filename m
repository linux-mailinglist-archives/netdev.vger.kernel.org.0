Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF93E502F52
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348158AbiDOTel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242881AbiDOTek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:34:40 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170B88B6D6;
        Fri, 15 Apr 2022 12:32:11 -0700 (PDT)
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nfRfb-000D2p-TO; Fri, 15 Apr 2022 21:31:51 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nfRfb-000IWi-IE; Fri, 15 Apr 2022 21:31:51 +0200
Subject: Re: [PATCH bpf-next v3 1/3] net: Enlarge offset check value from
 0xffff to INT_MAX in bpf_skb_load_bytes
To:     Liu Jian <liujian56@huawei.com>, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, sdf@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, pabeni@redhat.com
References: <20220414135902.100914-1-liujian56@huawei.com>
 <20220414135902.100914-2-liujian56@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7229410f-590f-79f6-94e4-38904d9bead1@iogearbox.net>
Date:   Fri, 15 Apr 2022 21:31:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220414135902.100914-2-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26513/Fri Apr 15 10:22:35 2022)
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/22 3:59 PM, Liu Jian wrote:
> The data length of skb frags + frag_list may be greater than 0xffff,
> and skb_header_pointer can not handle negative offset and negative len.
> So here INT_MAX is used to check the validity of offset and len.
> Add the same change to the related function skb_store_bytes.
> 
> Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
> v2->v3: change nothing
>   net/core/filter.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 64470a727ef7..1571b6bc51ea 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1687,7 +1687,7 @@ BPF_CALL_5(bpf_skb_store_bytes, struct sk_buff *, skb, u32, offset,
>   
>   	if (unlikely(flags & ~(BPF_F_RECOMPUTE_CSUM | BPF_F_INVALIDATE_HASH)))
>   		return -EINVAL;
> -	if (unlikely(offset > 0xffff))
> +	if (unlikely(offset > INT_MAX || len > INT_MAX))

One more follow-up question, len param is checked by the verifier for the provided buffer.
Why is it needed here? Were you able to create e.g. map values of size larger than INT_MAX?
Please provide details. (Other than that, rest looks good.)

>   		return -EFAULT;
>   	if (unlikely(bpf_try_make_writable(skb, offset + len)))
>   		return -EFAULT;
> @@ -1722,7 +1722,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
>   {
>   	void *ptr;
>   
> -	if (unlikely(offset > 0xffff))
> +	if (unlikely(offset > INT_MAX || len > INT_MAX))
>   		goto err_clear;
>   
>   	ptr = skb_header_pointer(skb, offset, len, to);
> 

