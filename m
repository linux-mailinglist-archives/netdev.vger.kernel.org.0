Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F40B6C2880
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCUDRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCUDRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:17:32 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023FA1554D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:17:29 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id v48so9347678uad.6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679368649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJLTgHq4GE0ByOIY897y2f3H2ESZcFPxMIOdoATKc8o=;
        b=DYJvxp6AUVzE/KYLNrEmqmH2DiqEHRN3ruRg4g8g9bDCiWGxRwd8AmyifrOoW91XpR
         HKR/CmHhxuvAgpe82DRi6Nm3MI7TFxif1BlApE4O8m1P+Pcg5i3KrepqGYCBUkI8F9EP
         UcOTkLUeRs+gWIA0dLA6U/T4xmY/GI0SqAwrnNS4gySpOuRHCinu3N9kqL2l4v9rDCB8
         qSD2vSFKblcPMSkJtMYIwsFQn/Y0tjZ3tKDMezHNxXyUphfqm3qzECFwk5Qs7+pWLFBo
         hiPKhzrXvohyf7vk/qu0eSLW4Xrrt+VS8WGfJa2sMJFweO2uXmYezMwNgsnjDJhmh/CJ
         +L0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679368649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJLTgHq4GE0ByOIY897y2f3H2ESZcFPxMIOdoATKc8o=;
        b=cJta6+fAmiWeiHnzPTzq/goWpAv22dNVRdgaxn8h9++LgydDiU6jmTL4kxRKH2nyLz
         qwg0lY23nLCjOUTNNbWmdMtSBWdbVpi3f6wIFLh2HPmIkHX9VE7vAC3OG6wDWh8pPwMu
         eB5Sfq54NlYULvt/aQ0Y6Wp4EdDwqFGNZO4xhVIDXSuK5rgPiVJCdAqH2tP34EzWEr2U
         cCBFb1AedgzqFuc286afORd8i5TLmb4D1pL2+2i9FVco6mk9riPT+q6RQoagjRy/LrDC
         DvrG42kXX0yJZxMVWtzpyxj1Z4hDrh9MUt9Y+RIr+YOnDYZbEAa2ufgqMFb6WLzx65oI
         ohAA==
X-Gm-Message-State: AAQBX9e+OJpaAUyD7BMDNUwFG5lHjypkwlTH6w515f8ukhmQvunYCf0p
        moWL6uz1Q7XwOXisBq8NInTxEfw1egHN9mJ9WkNrMw==
X-Google-Smtp-Source: AKy350bBrfpoLkjUN/+qsGQGKiJfXU4K4GTt6aJO6puaKzgbINKDI4LULLYCI62O0lCRFxFATq3rkVekMUHywiQPwVI=
X-Received: by 2002:ab0:3890:0:b0:68a:6c1e:1aab with SMTP id
 z16-20020ab03890000000b0068a6c1e1aabmr311920uav.2.1679368648950; Mon, 20 Mar
 2023 20:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230321024946.GA21870@ubuntu>
In-Reply-To: <20230321024946.GA21870@ubuntu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 20 Mar 2023 20:17:15 -0700
Message-ID: <CANn89i+=-BTZyhg9f=Vyz0rws1Z-1O-F5TkESBjkZnKmHeKz1g@mail.gmail.com>
Subject: Re: [PATCH] net: Fix invalid ip_route_output_ports() call
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>, tudordana@google.com,
        netdev@vger.kernel.org, imv4bel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 7:49=E2=80=AFPM Hyunwoo Kim <v4bel@theori.io> wrote=
:
>
> If you pass the address of the struct flowi4 you declared as a
> local variable as the fl4 argument to ip_route_output_ports(),
> the subsequent call to xfrm_state_find() will read the local
> variable by AF_INET6 rather than AF_INET as per policy,
> which could cause it to go out of scope on the kernel stack.
>
> Reported-by: syzbot+ada7c035554bcee65580@syzkaller.appspotmail.com

I could not find this syzbot issue, can you provide a link, and a stack tra=
ce ?

> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> ---

I find this patch quite strange, to be honest.

It looks like some xfrm bug to me.

A stack trace would be helpful.

Thanks.
