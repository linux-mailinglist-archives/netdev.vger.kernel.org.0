Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C6D6B6241
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 01:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCLAFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 19:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLAFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 19:05:02 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03AF56168;
        Sat, 11 Mar 2023 16:05:01 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id cy23so35003005edb.12;
        Sat, 11 Mar 2023 16:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678579500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7P7zwDp7HMR5PUtcSmRw8AB12ZCYbb55I22hOywNM8=;
        b=PMGn8TBesyfVr05fRjGiiu2D7RcLQmHfhpkhB8aym8raTft6/nrPUtO/h0mroIp121
         sspWKjqoMhCbQPTIqj07R+80yOAbh4AiL37rYvUxErS/PcSDseh88gtL1SPUiM6CXp3T
         yIwbYNJ/CJYHWYcbX1MLR75UjCdfCg0FfctPyMHWF2HyRdC6cAu+e/kooFZMUX3MVQJz
         /QrJaw4jg3aqnz9MnakRSIbQd0rki0gDKRV6ev2roEuamBZhD9DrgS8Uxgm8ochb4AJh
         sSrchTy7yCePBDohiKLeVgbLei9p6gIed4e8sBdb8l7N4GhOTR7Ic2YxlqxQazdcButU
         iCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678579500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7P7zwDp7HMR5PUtcSmRw8AB12ZCYbb55I22hOywNM8=;
        b=mm5S4mLcVVRoXziQXBy14+XJLzabb/wBptC48f5SaDRQW3fD+/d91HvCu1Cojpt0GJ
         wZ780kvTpy/hCALDF8IQYPjAzNW1sd/BbOun44eiiD5t5c7cwQVnLNG91ssoBDCos80x
         N7wFRFfOSLGrNNEzuAXx5Adh1bhrpn/yEGuxmgPTX2LLrsZ/1JcmTaqzigvVDNmyzxHQ
         xrmWK/5MqLglPRiigYLa9L4Cj9llOR4iFcb1y5lMUyL1Eki133jcbwS/j6A2DB9ff9A4
         XHR/r5W2blLqQ/1m5DcXprFOaF8oTIhR18+s6BFSqWUQsIncPOc/3eB7/RbxYSkTPvXj
         WcWQ==
X-Gm-Message-State: AO0yUKWYJ4ruReo6A5lx3OAUsf+E3zyMoGiuTJDsqKMs4o6/ZhekMpLx
        4iY8fjpzACaXmszdNK2HHZBHqUk3rZwfQL6JdHY=
X-Google-Smtp-Source: AK7set8BvyM+5fym01sUZFlbeND2YFgWPbx1VKzjrL69YplPXzzK2ysFFnGVALKXB8ad0X1vLINYmqWPImrmjvCgxNI=
X-Received: by 2002:a17:907:7d8c:b0:8f5:2e0e:6def with SMTP id
 oz12-20020a1709077d8c00b008f52e0e6defmr4348283ejc.0.1678579500114; Sat, 11
 Mar 2023 16:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20230311163614.92296-1-kerneljasonxing@gmail.com> <20230311091409.4f125e53@hermes.local>
In-Reply-To: <20230311091409.4f125e53@hermes.local>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sun, 12 Mar 2023 08:04:23 +0800
Message-ID: <CAL+tcoAUGyDS=khx7W8V79wck2HAFa2JFsY4-182ASy5m9w+Pw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
To:     stephen@networkplumber.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kuniyu@amazon.com,
        liuhangbin@gmail.com, xiangxia.m.yue@gmail.com, jiri@nvidia.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 1:14=E2=80=AFAM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Sun, 12 Mar 2023 00:36:14 +0800
> Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> > -     for (;;) {
> > +     for (; is_continue;) {
>
>
> Easier to read this as a
>         while (is_continue) {
>
> but what is wrong with using break; instead?

If we hit the budget limit and 'break;' immediately, we may miss the
collection when we also hit the time limit. That's why I would like to
know if we hit both of them.

Thank,
Jason
