Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF49A4ED1C7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 04:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiCaChg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 22:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCaChc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 22:37:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD408BF04;
        Wed, 30 Mar 2022 19:35:44 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KTS6g14k7zgYBd;
        Thu, 31 Mar 2022 10:34:03 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 10:35:41 +0800
Subject: Re: [PATCH net] net/tls: fix slab-out-of-bounds bug in
 decrypt_internal
To:     Jakub Kicinski <kuba@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <vakul.garg@nxp.com>,
        <davejwatson@fb.com>, <linux-kernel@vger.kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        <linux-crypto@vger.kernel.org>
References: <20220330085009.1011614-1-william.xuanziyang@huawei.com>
 <20220330093925.2d8ee6ca@kernel.org> <20220330132406.633c2da8@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <d7f55e84-ae87-ffd1-a488-a7bf6e65f3b1@huawei.com>
Date:   Thu, 31 Mar 2022 10:35:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20220330132406.633c2da8@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 30 Mar 2022 09:39:25 -0700 Jakub Kicinski wrote:
>> On Wed, 30 Mar 2022 16:50:09 +0800 Ziyang Xuan wrote:
>>> The memory size of tls_ctx->rx.iv for AES128-CCM is 12 setting in
>>> tls_set_sw_offload(). The return value of crypto_aead_ivsize()
>>> for "ccm(aes)" is 16. So memcpy() require 16 bytes from 12 bytes
>>> memory space will trigger slab-out-of-bounds bug as following:
>>>
>>> ==================================================================
>>> BUG: KASAN: slab-out-of-bounds in decrypt_internal+0x385/0xc40 [tls]
>>> Read of size 16 at addr ffff888114e84e60 by task tls/10911
>>>
>>> Call Trace:
>>>  <TASK>
>>>  dump_stack_lvl+0x34/0x44
>>>  print_report.cold+0x5e/0x5db
>>>  ? decrypt_internal+0x385/0xc40 [tls]
>>>  kasan_report+0xab/0x120
>>>  ? decrypt_internal+0x385/0xc40 [tls]
>>>  kasan_check_range+0xf9/0x1e0
>>>  memcpy+0x20/0x60
>>>  decrypt_internal+0x385/0xc40 [tls]
>>>  ? tls_get_rec+0x2e0/0x2e0 [tls]
>>>  ? process_rx_list+0x1a5/0x420 [tls]
>>>  ? tls_setup_from_iter.constprop.0+0x2e0/0x2e0 [tls]
>>>  decrypt_skb_update+0x9d/0x400 [tls]
>>>  tls_sw_recvmsg+0x3c8/0xb50 [tls]
>>>
>>> Allocated by task 10911:
>>>  kasan_save_stack+0x1e/0x40
>>>  __kasan_kmalloc+0x81/0xa0
>>>  tls_set_sw_offload+0x2eb/0xa20 [tls]
>>>  tls_setsockopt+0x68c/0x700 [tls]
>>>  __sys_setsockopt+0xfe/0x1b0  
>>
>> Interesting, are you running on non-x86 platform or with some crypto
>> accelerator? I wonder why we're not hitting it with KASAN and the
>> selftest we have.
> 
> I take that back, I can repro on x86 and 5.17, not sure why we're only
> discovering this now.
> 
> Noob question for crypto folks, ivsize for AES CCM is reported 
> as 16, but the real nonce size is 13 for TLS (q == 2, n == 13
> using NIST's variable names AFAICT). Are we required to zero out 
> the rest of the buffer?
> 
> In particular I think I've seen transient crypto failures with
> SM4 CCM in the past and zeroing the tail of the iv buffer seems
> to make the tests pass reliably.
> 
>>> Reserve MAX_IV_SIZE memory space for iv to be compatible with all
>>> ciphers. And do iv and salt copy like done in tls_do_encryption().
>>>
>>> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>> ---
>>>  net/tls/tls_sw.c | 10 +++-------
>>>  1 file changed, 3 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
>>> index 0024a692f0f8..6b858f995b23 100644
>>> --- a/net/tls/tls_sw.c
>>> +++ b/net/tls/tls_sw.c
>>> @@ -1456,7 +1456,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>>>  	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
>>>  	mem_size = aead_size + (nsg * sizeof(struct scatterlist));
>>>  	mem_size = mem_size + prot->aad_size;
>>> -	mem_size = mem_size + crypto_aead_ivsize(ctx->aead_recv);
>>> +	mem_size = mem_size + MAX_IV_SIZE;  
>>
>> This change is not strictly required for the patch, right?
>> Can we drop it, and perhaps send as an optimization separately later?
>>
Yes, it is not required for the problem.

>>>  	/* Allocate a single block of memory which contains
>>>  	 * aead_req || sgin[] || sgout[] || aad || iv.
>>> @@ -1493,12 +1493,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>>>  		kfree(mem);
>>>  		return err;
>>>  	}
>>> -	if (prot->version == TLS_1_3_VERSION ||
>>> -	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
>>> -		memcpy(iv + iv_offset, tls_ctx->rx.iv,
>>> -		       crypto_aead_ivsize(ctx->aead_recv));
>>> -	else
>>> -		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
>>> +	memcpy(iv + iv_offset, tls_ctx->rx.iv,
>>> +	       prot->iv_size + prot->salt_size);  
>>
>> If the IV really is 16B then we're passing 4 bytes of uninitialized
>> data at the end of the buffer, right?
>>
>>>  	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
> 
> FWIW this is the fix I tested:
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 0024a692f0f8..dbc6bce01898 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1473,6 +1473,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>  	aad = (u8 *)(sgout + n_sgout);
>  	iv = aad + prot->aad_size;
>  
> +	/* Prepare IV */
> +	memset(iv, 0, crypto_aead_ivsize(ctx->aead_recv));
>  	/* For CCM based ciphers, first byte of nonce+iv is a constant */
>  	switch (prot->cipher_type) {
>  	case TLS_CIPHER_AES_CCM_128:
> @@ -1485,21 +1487,20 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>  		break;
>  	}
>  
> -	/* Prepare IV */
> -	err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
> -			    iv + iv_offset + prot->salt_size,
> -			    prot->iv_size);
> -	if (err < 0) {
> -		kfree(mem);
> -		return err;
> -	}
>  	if (prot->version == TLS_1_3_VERSION ||
> -	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
> +	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
>  		memcpy(iv + iv_offset, tls_ctx->rx.iv,
> -		       crypto_aead_ivsize(ctx->aead_recv));
> -	else
> +		       prot->iv_size + prot->salt_size);
> +	} else {
> +		err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
> +				    iv + iv_offset + prot->salt_size,
> +				    prot->iv_size);
> +		if (err < 0) {
> +			kfree(mem);
> +			return err;
> +		}
>  		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
> -
> +	}
I am thinking about is skb_copy_bits() necessary in non-TLS_1_3_VERSION
and non-TLS_CIPHER_CHACHA20_POLY1305 scenarios?

If the inital iv+salt negotiated configuration for tx/rx offload is right
and reliable, what is the reason why we have to extract the iv value from
received skb instead if using the negotiated iv value? Does it can be
modified or just follow spec that versions below TLS_1_3_VERSION?

Without skb_copy_bits(), tls selftest all passed.

Forgive my noob question.

>  	xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
>  
>  	/* Prepare AAD */
> 
