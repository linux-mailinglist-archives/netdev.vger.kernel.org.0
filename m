Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DCC4DDADB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236838AbiCRNty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiCRNtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:49:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCCFD554A;
        Fri, 18 Mar 2022 06:48:34 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVCxm-0001Kk-1p; Fri, 18 Mar 2022 14:48:18 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVCxl-000JG2-ER; Fri, 18 Mar 2022 14:48:17 +0100
Subject: Re: [PATCH bpf-next v2] net: Enlarge offset check value from 0xffff
 to 0x7fffffff in bpf_skb_load_bytes
To:     Liu Jian <liujian56@huawei.com>, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, sdf@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220318011245.43678-1-liujian56@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d3aa0c80-f73a-3325-e39b-e2e880043acc@iogearbox.net>
Date:   Fri, 18 Mar 2022 14:48:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220318011245.43678-1-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26485/Fri Mar 18 09:26:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 2:12 AM, Liu Jian wrote:
> The data length of skb frags + frag_list may be greater than 0xffff,
> and skb_header_pointer can not handle negative offset and negative len.
> So here 0x7ffffff is used to check the validity of offset and len.
> 
> Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: sorry for this, change 0x7ffffffff to 0x7fffffff
>   net/core/filter.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9eb785842258..17865b896f7d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1722,7 +1722,7 @@ BPF_CALL_4(bpf_skb_load_bytes, const struct sk_buff *, skb, u32, offset,
>   {
>   	void *ptr;
>   
> -	if (unlikely(offset > 0xffff))
> +	if (unlikely(offset > 0x7fffffff || len > 0x7fffffff))
>   		goto err_clear;

What are those magic numbers (and why not < 0 check)? Also, it's ugly you're adding
these for skb_load_bytes but not skb_store_bytes, both are used in combination from
tc BPF side. Can we come up with something better that works for both?

Given you had to change this between v1 -> v2 from 0x7ffffffff to 0x7fffffff, please
also add BPF selftests with corner cases so this gets properly tested.

>   	ptr = skb_header_pointer(skb, offset, len, to);
> 

Thanks,
Daniel
