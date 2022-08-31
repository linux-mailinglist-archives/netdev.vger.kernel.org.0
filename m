Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA35A8608
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiHaSsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiHaSsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:48:18 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0E5543FE
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:48:16 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 134so7180447vkz.11
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 11:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=dEU++UBToH866zrJEWnx3P4LrLN/LbOdcwtLNxqEBv8=;
        b=U9ZebKNx1Snn9CscuSDhl5p+6YnZ1po5Ug1VuOaTebdwd2Tp0Ky9d5YyfV73lbMfsu
         klznxiFzDFWfdcWTtHFNZ8VCCZW64v5k+4XeicE0IYnJyc5dawoFqjHC8yaRQSoSdiOv
         I0zAhUk7IXlXYMO8n39DJhY1BOKnLiTLbLcjFcswCIl1ItmgOh65lrXWRK0LSTcm3xrh
         7rXyHWFZgnvUU/dgiBactL0WsGoddNUOgExz4ILuuCn/5MLlTQjLhyc62Shbvb8kG307
         CoMu9pBa3U5vAlrM74NYE/nwRie61x2184yMCnrhC+q2+gr04p1s0PZmFglsRPJpFLJw
         aV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dEU++UBToH866zrJEWnx3P4LrLN/LbOdcwtLNxqEBv8=;
        b=xu4IB1uAFgjOs+8zkqmkhfWghzdRYueixmuFcRDkPqgmg2VDdGL4Fd7HV84BKkJ2dZ
         HqK0TkyFJgVBtDs0srHHoKA9N1lhy9YweJmh9LThMcmp4sWEkwuRv4wGajJFRJIu27Pf
         zwKlIc1pju4udKjGiGsuG+KfnW8YujMrroi10hOiUZQYUfmiioGJuD4yPm+CWzgAC3gi
         qN1qDPehmpoq39PtNglIp70cQZ2ecERS5Yft3CcVbQyRyBIR/KF/8zsezp/NhCmC5fC6
         WYoM4/3BGc6HUvqHKzhyeAYXG3sKkCvTPEwGNTNv+XRq/RYY2RqcDmm/u574A8Pg7r9N
         TU9A==
X-Gm-Message-State: ACgBeo3hAYU2YYd4Bz/mO/hWmGy1xKoT60zH2X44kmy8eCXbyS310lrS
        V1nB16lUWHT+X5VeQsl2bqwsPJvtnNjG/m+WXtSXEQ==
X-Google-Smtp-Source: AA6agR68Q5/Um9DP/1wUPBFcazbxzIYSZ5kyi8FKvBJcKGJb+rF5p9ThPfzNKgX5rtEjjZIhEC8egXy9zVolXnf3S5s=
X-Received: by 2002:a1f:1f49:0:b0:394:5a44:9a98 with SMTP id
 f70-20020a1f1f49000000b003945a449a98mr5452642vkf.32.1661971695746; Wed, 31
 Aug 2022 11:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220818170005.747015-1-dima@arista.com> <20220818170005.747015-9-dima@arista.com>
 <162ae93b-5589-fbde-c63b-749f21051784@gmail.com>
In-Reply-To: <162ae93b-5589-fbde-c63b-749f21051784@gmail.com>
From:   Dmitry Safonov <dima@arista.com>
Date:   Wed, 31 Aug 2022 19:48:02 +0100
Message-ID: <CAGrbwDTW4_uVD+YbsL=jnfTGKAaHGOmzNZmpkSRi4xotzyNASg@mail.gmail.com>
Subject: Re: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 15:45, Leonard Crestez wrote:
> On 8/18/22 19:59, Dmitry Safonov wrote:
[..]
>> +#define TCP_AO            38    /* (Add/Set MKT) */
>> +#define TCP_AO_DEL        39    /* (Delete MKT) */
>> +#define TCP_AO_MOD        40    /* (Modify MKT) */
>
> The TCP_AO_MOD sockopt doesn't actually modify and MKT, it only controls
> per-socket properties. It is equivalent to my TCP_AUTHOPT sockopt while
> TCP_AO is equivalent to TCP_AUTHOPT_KEY. My equivalent of TCP_AO_DEL
> sockopt is a flag inside tcp_authopt_key.

Fair point, the comment could be "Modify AO", rather than "Modify MKT".
On the other side, this can later support more per-key changes than in
the initial proposal: i.e., zero per-key counters. Password and rcv/snd
ids can't change to follow RFC text, but non-essentials may.
So, the comment to the command here is not really incorrect.

>> +struct tcp_ao { /* setsockopt(TCP_AO) */
>> +    struct __kernel_sockaddr_storage tcpa_addr;
>> +    char    tcpa_alg_name[64];
>> +    __u16    tcpa_flags;
>
> This field accept TCP_AO_CMDF_CURR and TCP_AO_CMDF_NEXT which means that
> you are combining key addition with key selection. Not clear it
> shouldn't just always be a separate sockopt?

I don't see any downside. A user can add a key and start using it immediately
with one syscall instead of two. It's not necessary, one can do it in
2 setsockopt()s if they want.

[..]
> I also have two fields called "recv_keyid" and "recv_rnextkeyid" which
> inform userspace about what the remote is sending, I'm not seeing an
> equivalent on your side.

Sounds like a good candidate for getsockopt() for logs/debugging.

> The specification around send_keyid in the RFC is conflicting:
> * User must be able to control it

I don't see where you read it, care to point it out?
I see choosing the current_key by marking the preferred key during
an establishment of a connection, but I don't see any "MUST control
current_key". We allow changing current_key, but that's actually
not something required by RFC, the only thing required is to respect
rnext_key that's asked by peer.

> * Implementation must respect rnextkeyid in incoming packet
>
> I solved this apparent conflict by adding a
> "TCP_AUTHOPT_FLAG_LOCK_KEYID" flag so that user can choose if it wants
> to control the sending key or let it be controlled from the other side.

That's exactly violating the above "Implementation must respect
rnextkeyid in incoming packet". See RFC5925 (7.5.2.e).

[..]
> Only two algorithms are defined in RFC5926 and you have to treat one of
> them as a special case. I remain convinced that generic support for
> arbitrary algorithms is undesirable; it's better for the algorithm to be
> specified as an enum.

On contrary, I see that as a really big feature. RFC5926 was published in 2010,
when sha1 was yet hard to break. These days sha1 is considered insecure.
I.e., the first link from Google:

> Starting with version 56, released this month, Google Chrome will mark all
> SHA-1-signed HTTPS certificates as unsafe. Other major browser vendors
> plan to do the same.
> "Hopefully these new efforts of Google of making a real-world attack possible
> will lead to vendors and infrastructure managers quickly removing SHA-1 from
> their products and configurations as, despite it being a deprecated algorithm,
> some vendors still sell products that do not support more modern hashing
> algorithms or charge an extra cost to do so," [..]

So, why limit a new TCP sign feature to already insecure algorithms?
One can already use any crypto algorithms for example, in tunnels.
And I don't see any benefit in defining new magic macros, only downside.

I prefer UAPI that takes crypto algo name as a string, rather than new
defined magic number from one of kernel headers.
IOW,
: strcpy(ao.tcpa_alg_name, "cmac(aes128)");
: setsockopt(sk, IPPROTO_TCP, opt, &ao, sizeof(ao));
is better than
: ao.tcp_alg = TCP_AO_CMAC_MAGIC_DEFINE;
: setsockopt(sk, IPPROTO_TCP, opt, &ao, sizeof(ao));

Neither I see a point in more patches adding new
#define TCP_AO_NEW_ALGO

BTW, I had some patches to add testing in fcnal-test.sh and covered
the following algorithms, that worked just fine (test changes not
included in v1):
hmac(sha1) cmac(aes128) hmac(rmd128) hmac(rmd160) hmac(sha512)
hmac(sha384) hmac(sha256) hmac(md5) hmac(sha224) hmac(sha3-512)

No point in artificially disabling them or introducing new magic #defines.

Thanks,
          Dmitry
