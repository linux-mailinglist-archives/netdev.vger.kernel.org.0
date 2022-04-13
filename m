Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9550024A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbiDMXKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiDMXKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:10:06 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6523F25C4C;
        Wed, 13 Apr 2022 16:07:42 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nelO9-000GnW-Aq; Thu, 14 Apr 2022 00:23:01 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nelO9-000JQH-0A; Thu, 14 Apr 2022 00:23:01 +0200
Subject: Re: [PATCH bpf v2 1/2] net: Enlarge offset check value from 0xffff to
 INT_MAX in bpf_skb_load_bytes
To:     Liu Jian <liujian56@huawei.com>, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, sdf@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220413062131.363740-1-liujian56@huawei.com>
 <20220413062131.363740-2-liujian56@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ce95013f-df4b-0cd5-c9e4-d3e3d41dce14@iogearbox.net>
Date:   Thu, 14 Apr 2022 00:23:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220413062131.363740-2-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26511/Wed Apr 13 10:22:45 2022)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 8:21 AM, Liu Jian wrote:
> The data length of skb frags + frag_list may be greater than 0xffff,
> and skb_header_pointer can not handle negative offset and negative len.
> So here INT_MAX is used to check the validity of offset and len.
> Add the same change to the related function skb_store_bytes.
> 
> Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---
> v1->v2: change nothing, only add Acked-by tag
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

While at it, lets also change skb_ensure_writable()'s write_len param to unsigned int
type. Both pskb_may_pull() and skb_clone_writable()'s length parameters are of type
unsigned int already.
