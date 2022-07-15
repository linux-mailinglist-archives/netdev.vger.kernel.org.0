Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847B5575E53
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiGOJSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiGOJSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:18:13 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542F864FD
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:18:11 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31dfe25bd49so4131527b3.2
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3C0wIojyulqJOc3gqPPTvNhV+eA7FObSuZqLBbdRPM=;
        b=pOogBYE+C6kqGGUAfEUij9yax6uLLM1R/aVT53WeTPmxIYZFWu6IWa2WPjga4I/MNH
         P4HlXB3K/l4UpcvdlOrtecwmGdwA2MUh+2OePYYn/Y4ea/EqxDJTYaOotoyfIrPOLdc/
         oWWQkFZjgD51+iObnDFwo/7bUIIxqTYnXHAaj7DZCOvVXkBaTSsH0VdaSwZs/hlpXC4K
         7lBmLHoy1pLi9k98lUEObNmpfiFwWxKnovSOb+FuADITS42NiyabI8TSYOyGDR+tW7bA
         68YbPJQAYaPmkx1mQmtYnngXnbMQL2FG7jqtw239GNfsJLCBbIsYP4Jsd8SAnBbFR4Am
         YHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3C0wIojyulqJOc3gqPPTvNhV+eA7FObSuZqLBbdRPM=;
        b=ofZ7eO5tYq3Qznrk1mdxxIOPZbxqSv08G7U7ibMcQO4cyb6wAsB3+KhkYOO3SHnob/
         8vRiwnXqMtiVoX9X64pNz6gNup53v5Udy0380THJU8xMpZSwBHv1lzhVikLmjbB5LBzT
         K45bQkcffRiImvBFAXhNpa9+7DcUsPnftQ8M7LPSnLvaRxmgS2p9kh9dNbiU7w8pBxiD
         Hsckzq8CNkOTlXDGTmJ29u7zSC4RP0H0CJfKlEiWz4sg8lmErilWI0xnDuNi5EEvW8kH
         6C9nPxSV++7LL0TjVYmZMoKBnaUwyEeel5MDDXyBNCJ+Z4vf//UhoH5uWThGQ5HRDj+P
         kikw==
X-Gm-Message-State: AJIora8oIV8k2HBAUXagghafmKU25XTn36UbvvWPwTbLybvuT4ex+XMl
        HMjsbiipgBK+y38V5R5NGYcirtsgm/WywMHxhHhARw==
X-Google-Smtp-Source: AGRyM1vG8/RlhJDU4+yZQLBM+ZndwV5DjU4EYfGa6tSpfbbGXItXheAJxeNNY805A4KiKuOF3zqWH6FVEA50bsNrh9Y=
X-Received: by 2002:a81:5045:0:b0:31c:9f67:a611 with SMTP id
 e66-20020a815045000000b0031c9f67a611mr15041103ywb.55.1657876690309; Fri, 15
 Jul 2022 02:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220715032233.230507-1-shaozhengchao@huawei.com> <20220714213025.448faf8c@kernel.org>
In-Reply-To: <20220714213025.448faf8c@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Jul 2022 11:17:59 +0200
Message-ID: <CANn89iLS6rhm_N6g-x0JQC8s2Kx2yVO7+r89BdBZNrzr9473WQ@mail.gmail.com>
Subject: Re: [PATCH v3,bpf-next] bpf: Don't redirect packets with invalid pkt_len
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, martin.lau@linux.dev,
        song@kernel.org, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Ahern <dsahern@kernel.org>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>, Hao Luo <haoluo@google.com>,
        jolsa@kernel.org, weiyongjun1@huawei.com,
        YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 6:30 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 15 Jul 2022 11:22:33 +0800 Zhengchao Shao wrote:
> > +#ifdef CONFIG_DEBUG_NET
> > +     if (unlikely(!skb->len)) {
> > +             pr_err("%s\n", __func__);
> > +             skb_dump(KERN_ERR, skb, false);
> > +             WARN_ON_ONCE(1);
> > +     }
>
> Is there a reason to open code WARN_ONCE() like that?
>
> #ifdef CONFIG_DEBUG_NET
>         if (WARN_ONCE(!skb->len, "%s\n", __func__))
>                 skb_dump(KERN_ERR, skb, false);
>
> or
>
>         if (IS_ENABLED(CONFIG_DEBUG_NET) &&
>             WARN_ONCE(!skb->len, "%s\n", __func__))
>                 skb_dump(KERN_ERR, skb, false);


Also the skb_dump() needs to be done once.

DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
