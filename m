Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629716BC20D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbjCPADR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbjCPADF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:03:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F638ABE5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:02:37 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id cy23so1023912edb.12
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678924952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1zt0861gO8gyP57O4E8vGinkLoXOj1+rMxre6Q9XLs=;
        b=NBZ4LUhBaw8x4mbgHMgd4pqi/+UeRUKcr9UgV5iQj9NhRn5HH9XKklEnGlY/g56lzd
         a1sPKQYcN5tS0AU5KumUj1duyrmJW9QjK+59ifmcbQfBcfafhJDTVTP8mf3Xz1Yny/GO
         rrMe6N5JlBa5+LttR6lcOy04sei+6Mzp1ZrIw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1zt0861gO8gyP57O4E8vGinkLoXOj1+rMxre6Q9XLs=;
        b=XXyv74xNzFsSrTvTROjX/cXROXdexMqHKvRFtw280UzZXBaO5wKTgmBDQyqlmX6Mol
         Z1Zp1l6RLp0mW3HSMb9tGfgWOQtUTFwbttDMfGAkJfHZTUZVmviFFMA/UEh2nCytwd98
         ZE5Rk4ayj0Q1ZXP7MEO8WESngq5eqEQztqhCOip99CuaCVe213IkprLLv8y49QdV3xKD
         jZaMGOBXOa655KYUCiZ6v97YzFOK2gde9dp9wPYZhMYXkNHCZpLrIj0GMrGPr53nw1qK
         qwNBv5VYsO1gi4RkYjUIyViMEpEscdP4de1WjvsNQtxTfpKyv0WgI79qP6egA161XSQ3
         xVQg==
X-Gm-Message-State: AO0yUKURHJco3yYZSe2owtk8ShrPKnZiBA6pVg8+/BDpKGsIIpZyJ82H
        7nsEsTj9729OWT1nAVQ5GnczymuJSGPmiHSsNbKQxQ==
X-Google-Smtp-Source: AK7set+N1Vq+2ndNOmcIN0MtSEXh4oweeB7ssMF/ZB1ISPqmIs/7l1PMgg0OTA7htPTaoVO1COF3VQ==
X-Received: by 2002:a17:906:a3d2:b0:8b2:3eb6:8661 with SMTP id ca18-20020a170906a3d200b008b23eb68661mr7725535ejb.8.1678924952094;
        Wed, 15 Mar 2023 17:02:32 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id og49-20020a1709071df100b0090953b9da51sm3095505ejc.194.2023.03.15.17.02.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:02:31 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id w9so1177736edc.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:02:30 -0700 (PDT)
X-Received: by 2002:a17:907:72c1:b0:8e5:1a7b:8ab2 with SMTP id
 du1-20020a17090772c100b008e51a7b8ab2mr4901874ejc.4.1678924950436; Wed, 15 Mar
 2023 17:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
 <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
 <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com> <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com>
In-Reply-To: <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 17:02:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com>
Message-ID: <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 4:56=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> container_of_const() does not detect this bug at compile time, does it ?
>
> struct sk_buff *skb =3D ...;
>
> struct inet_sk *inet =3D inet_sk(skb);

You didn't actually test it, did you?

I get about 40 lines of error messages about how broken that is, starting w=
ith

   ./include/linux/build_bug.h:78:41: error: static assertion failed:
"pointer type mismatch in container_of()"

exactly because yes, 'container_of()' is very pissy indeed about bogus
conversions.

You can only convert a named member into a containing structure, and
'inet_sk' does not contain a member named 'sk' that is of type 'struct
skb_buff'.

            Linus
