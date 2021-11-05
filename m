Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F61445FCB
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 07:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhKEGl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 02:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbhKEGl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 02:41:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7920C061714;
        Thu,  4 Nov 2021 23:39:16 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r4so28899884edi.5;
        Thu, 04 Nov 2021 23:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=88ty7n3GLW4LpESkkrw+h5VZNGe5tXzthKbejd1J1AU=;
        b=PxHJBW244D1q978km3IaliWf7OBWzGyCc+owmZorV5kadxyUFdcSL5FNpfBZj32cmK
         xDA8wVVupVQchdNYhOajoDmKGXih9T7WaAFSqZDW9Sg9gNuaCHdEqlExnjpaZsj+fAtY
         HbNMJ+iwoReJ9IbKCGIP9dio63cq2PuUEcqSjERXpRtsn+WYI9YdJ7Nsfeq3KaG3NmtF
         xhOHiWCQ3USI/l2czPQ+IsppITKGnPXZz1hhtNGSQe5+yeVW2RHmwoRUQAREO7m8v9YA
         XxyWTt4hj+KI3VEC08qzq+otUy8cfrfjcoSDvzac0Im6KaW8Lptrga0o/cxX8ZHbs0kN
         n0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=88ty7n3GLW4LpESkkrw+h5VZNGe5tXzthKbejd1J1AU=;
        b=kRU+ib7RnzDVAvbGgcL3BT/NLXSq1JzVnwIx8XgIQz8iADvZwc825JfIcvvb5WmAVm
         WMsWdVBFr8xNwIc42lLbo34xbpAwksM7z7PSsp473781paMEMXSFU4/qH9E4qcl4nVSy
         f9h4O3vkI+KOOMOT0n7NRbHp9tiPc+nJwSh6t6o7zKvAife547CgTFdgJmGirEayTT5i
         xWpMSvq/xnmdP7z8JSMMVllFdFW7D4fUhgtGJmn8CJCT745IMkXCjQSggIBsyKiRhrf5
         HiRzNdBOhjTwPEWvRLoGvUocwntytfFMMzUtaUO3newGgyeK2YmL6uO/+jDiLsO9hik8
         sxJA==
X-Gm-Message-State: AOAM533ixJo+NmlDY+i7SbOqELYjLqcQPT9NLWrmFQRfyHzNokzmYIT+
        T8cm9zkddzjtxCico2+QEJw=
X-Google-Smtp-Source: ABdhPJwAe5GbP8kvHZ9zmOaQbGwgBez74W00MivWtunluypavqRv7KUqdf5dNrTIq7ddFjzWdg2S/Q==
X-Received: by 2002:a17:906:794f:: with SMTP id l15mr965742ejo.324.1636094355056;
        Thu, 04 Nov 2021 23:39:15 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:fafc:6a7c:c046:18f4? ([2a04:241e:501:3800:fafc:6a7c:c046:18f4])
        by smtp.gmail.com with ESMTPSA id sc27sm3296290ejc.125.2021.11.04.23.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 23:39:14 -0700 (PDT)
Subject: Re: [PATCH v2 06/25] tcp: authopt: Compute packet signatures
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
 <816d5018-6cc5-78c4-4c13-f92927ad23f7@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <6beb9ff4-34ec-5685-ab9d-decd382ab7cc@gmail.com>
Date:   Fri, 5 Nov 2021 08:39:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <816d5018-6cc5-78c4-4c13-f92927ad23f7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/21 3:53 AM, Dmitry Safonov wrote:
> On 11/1/21 16:34, Leonard Crestez wrote:
> [..]
>> +static int skb_shash_frags(struct shash_desc *desc,
>> +			   struct sk_buff *skb)
>> +{
>> +	struct sk_buff *frag_iter;
>> +	int err, i;
>> +
>> +	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
>> +		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
>> +		u32 p_off, p_len, copied;
>> +		struct page *p;
>> +		u8 *vaddr;
>> +
>> +		skb_frag_foreach_page(f, skb_frag_off(f), skb_frag_size(f),
>> +				      p, p_off, p_len, copied) {
>> +			vaddr = kmap_atomic(p);
>> +			err = crypto_shash_update(desc, vaddr + p_off, p_len);
>> +			kunmap_atomic(vaddr);
>> +			if (err)
>> +				return err;
>> +		}
>> +	}
>> +
>> +	skb_walk_frags(skb, frag_iter) {
>> +		err = skb_shash_frags(desc, frag_iter);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> This seems quite sub-optimal: IIUC, shash should only be used for small
> amount of hashing. That's why tcp-md5 uses ahash with scatterlists.

There is indeed no good reason to prefer shash over ahash. Despite the 
"async" in the name it's possible to use it in atomic context.

> Which drives me to the question: why not reuse tcp_md5sig_pool code?
> 
> And it seems that you can avoid TCP_AUTHOPT_ALG_* enum and just supply
> to crypto the string from socket option (like xfrm does).
> 
> Here is my idea:
> https://lore.kernel.org/all/20211105014953.972946-6-dima@arista.com/T/#u

Making the md5 pool more generic and reusing it can work.

This "pool" mechanism is really just a workaround for the crypto API not 
supporting the allocation of a hash in softirq context. It would make a 
lot sense for this functionality to be part of the crypto layer itself.

Looking at your generic tcp_sig_crypto there is nothing actually 
specific to TCP in there: it's just an ahash and a scratch buffer per-cpu.

I don't understand the interest in using arbitrary crypto algorithms 
beyond RFC5926, this series is already complex enough. Other than 
increasing the complexity of crypto allocation there are various stack 
allocations which would need to be up to the maximum size of a TCP options.

--
Regards,
Leonard
