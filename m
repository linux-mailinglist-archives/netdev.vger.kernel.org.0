Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73DEC48985
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfFQRAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:00:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40887 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQRAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:00:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so6008709pfp.7;
        Mon, 17 Jun 2019 10:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PWC+RbxtlMDHshNLSaHRZ424esMvY5x7T2f733VpE/M=;
        b=upDVNYelb9DUB/83bN9uWmEr9jt871fNfLI5T0ZdvUdJ8DAnQ0qnF7Ja6X7Wn2suj9
         4hdqCuD943g4PL1FC6ClHYljI0bF8vlkLKWNDxSKBL+Gc9pvvmxf4pd1E5Q5IeqsqbVg
         nnSivwFlG5JzpTJg1nbsQhx5LBL3ISkYVSW/p6HkRyj5KwP77B8k9CFtBJcucttxH8eb
         dNU1nSookMwuKeNmC5kjQiB/bMx+1u1YKbphgCOXU8qlfwDzLxZpsoOWmv/gMecdMHa9
         yC+MJyyxc6R/+OT5Rj1m+svVQ4vaJuM/9ZtwZSlCw32+gEpBya/yIcDoD1xM910hiYcn
         pLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PWC+RbxtlMDHshNLSaHRZ424esMvY5x7T2f733VpE/M=;
        b=jfSMMeJdq4fPeEpme1ayyv7JlVvFrmyPt25lZexAN0+D5zrrqz93MkOARbI3zT2y44
         fxoTeeH7AjzzdVf0aHJI3iUig4i/QLDPzG2F4YhRLCGsjOHreA80BdJ/YvlQ+G/DKDMY
         agECWO8wUgXGrY9u5Ubh8P4B1sH7jAB7ut9xOFLr7BLHfClvQN5GZOsHcVQapi1QrgtM
         iu5tpYt9N6LdS2AwTFzOgX7BbCO9Ed8UhUv9kpdjlzru0j3FVlzHoSNPNhXo8MCkuUbq
         /CXY6g5WqrDBXbcgzZvYWowlUS4rcJtDCWMR3UBeblJkeL0iobsQZnuvKaY3NrvJjZFb
         hLwA==
X-Gm-Message-State: APjAAAUgSertC24rigTu/NlCvUKqW+KG59PdJfAx2j2bzgAGCKihEuiA
        ZrsLTwA+nqo25oxJSuganXU=
X-Google-Smtp-Source: APXvYqw6wt+Opahah8Vn7nUIT5LdVOYWnQNKWZfnggSuwHfRwOO3nFjPPvZvbDGLoocfMFVJhjaLFg==
X-Received: by 2002:a17:90a:cb97:: with SMTP id a23mr26512512pju.67.1560790830866;
        Mon, 17 Jun 2019 10:00:30 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id d123sm15587217pfc.144.2019.06.17.10.00.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:00:29 -0700 (PDT)
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>, netdev@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, edumazet@google.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, jbaron@akamai.com,
        cpaasch@apple.com, David.Laight@aculab.com, ycheng@google.com
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e1c4c9b6-3668-106a-69ef-7ef6c016a5f6@gmail.com>
Date:   Mon, 17 Jun 2019 10:00:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/19 1:09 AM, Ard Biesheuvel wrote:
> Using a bare block cipher in non-crypto code is almost always a bad idea,
> not only for security reasons (and we've seen some examples of this in
> the kernel in the past), but also for performance reasons.
> 
> In the TCP fastopen case, we call into the bare AES block cipher one or
> two times (depending on whether the connection is IPv4 or IPv6). On most
> systems, this results in a call chain such as
> 
>   crypto_cipher_encrypt_one(ctx, dst, src)
>     crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm), ...);
>       aesni_encrypt
>         kernel_fpu_begin();
>         aesni_enc(ctx, dst, src); // asm routine
>         kernel_fpu_end();
> 
> It is highly unlikely that the use of special AES instructions has a
> benefit in this case, especially since we are doing the above twice
> for IPv6 connections, instead of using a transform which can process
> the entire input in one go.
> 
> We could switch to the cbcmac(aes) shash, which would at least get
> rid of the duplicated overhead in *some* cases (i.e., today, only
> arm64 has an accelerated implementation of cbcmac(aes), while x86 will
> end up using the generic cbcmac template wrapping the AES-NI cipher,
> which basically ends up doing exactly the above). However, in the given
> context, it makes more sense to use a light-weight MAC algorithm that
> is more suitable for the purpose at hand, such as SipHash.
> 
> Since the output size of SipHash already matches our chosen value for
> TCP_FASTOPEN_COOKIE_SIZE, and given that it accepts arbitrary input
> sizes, this greatly simplifies the code as well.
> 
> NOTE: Server farms backing a single server IP for load balancing purposes
>       and sharing a single fastopen key will be adversely affected by
>       this change unless all systems in the pool receive their kernel
>       upgrades at the same time.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---

All our fastopen packetdrill tests pass (after I changed all the cookie values in them)

Signed-off-by: Eric Dumazet <edumazet@google.com>


