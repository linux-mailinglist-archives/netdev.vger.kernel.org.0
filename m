Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB494CCCB4
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 05:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbiCDE5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 23:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiCDE5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 23:57:40 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C755F24F;
        Thu,  3 Mar 2022 20:56:53 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id kt27so15169293ejb.0;
        Thu, 03 Mar 2022 20:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+YG6PyMN5lqIoue4o1YYMq3iasC+Fhw1iQpSQooE+M=;
        b=UvE9UrA4K4VIMHua6297VjO/RNOAypHTISR3IARdr+JhiU1pIJBN+AV1hnQ0KkcDc3
         sY5NfvAiwpzpYCrfvjDleTuPsFno/TsC3WWNVOJ5oQl/W1wQy8Ucs5teJl4Zf1m/H8cD
         6IfHkwGbJ7l1JfyC5z8+3cHDirngiPabxFift/wKu5nlUri8q2IEHAwKOgH00Zs+NZSs
         dWDWvcmLXqwFptqgIcTS45ppDRkN4bH+J1aHQbU74uOlTPi03vf3uL7XpQ1ms30kzuXk
         a0v4fIVtrhqQNvAVMQRs6FAwrIU2QuNwQbbovqH36a75teN3Hs8HT7CyJt2g2uI01oT3
         RRBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+YG6PyMN5lqIoue4o1YYMq3iasC+Fhw1iQpSQooE+M=;
        b=6iq2QI25/ilRXCoiOnPawILy4q3tXwZB8KpDO2Zp7GDeZg33tYTut53VJcSni5kqMG
         v7pXOrbaTIe+TjR6sby+hh9FdAYEtEdRQHc2igjYjYlhTi9+Eri7YDC9LCSBqpcItuq4
         5l6ZFv2CxbljkQB5dqPi7CILxYtmLF8O2wLCwahOjB1WHLfEBja+A6TQomsvoiZ3De5A
         qNFjwrSGXQ7XczKKhK4eeAkz//lvWNsfCvvYdgJLgpgEeqDihThVfBEuqnf6e11m7Ccn
         n2e9q1k9pV8JtMPpLQz41pcp/oLsjDW1n2HxlRSnh3peMhV8zfw1/cHTCcf28jyX8QsY
         a5pA==
X-Gm-Message-State: AOAM533n2+v21pYHqAQAC5oebrdMGaS6OYUs4GmgTlQATXqQXgddimih
        9eQynNvQ9hmT2h1to94SCJH5oDVFXMGaMOytQRXYcGxzxAo=
X-Google-Smtp-Source: ABdhPJzYFik4UTuG/N9R7FFgV784My9WYDvWq32+ekF04YhITVM5mdFwok2VYzSwuukuJnsZ9Sw6m6zqRHkvXw9tPGE=
X-Received: by 2002:a17:906:4cd2:b0:6c8:7a90:9c7 with SMTP id
 q18-20020a1709064cd200b006c87a9009c7mr29669407ejt.439.1646369812115; Thu, 03
 Mar 2022 20:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20220303174707.40431-1-imagedong@tencent.com> <20220303174707.40431-2-imagedong@tencent.com>
 <20220303202539.17ac1dd5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303202539.17ac1dd5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 4 Mar 2022 12:56:40 +0800
Message-ID: <CADxym3ZC1kXYF2_YnY3xKYnRGzPimHnahR5eoAr4fkawkm5aSA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] net: dev: use kfree_skb_reason() for sch_handle_egress()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>, flyingpeng@tencent.com,
        Mengen Sun <mengensun@tencent.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 12:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  4 Mar 2022 01:47:01 +0800 menglong8.dong@gmail.com wrote:
> > Replace kfree_skb() used in sch_handle_egress() with kfree_skb_reason().
> > The drop reason SKB_DROP_REASON_QDISC_EGRESS is introduced. Considering
> > the code path of qdisc egerss, we make it distinct with the drop reason
> > of SKB_DROP_REASON_QDISC_DROP in the next commit.
>
> I don't think this has much to do with Qdiscs, this is the TC
> egress hook, it's more for filtering. Classful Qdisc like HTB
> will run its own classification. I think.
>
> Maybe TC_EGRESS?

You are right, I think I misunderstanded the concept of qdisc and tc before.
and seems all 'QDISC' here should be 'TC'? which means:

QDISC_EGRESS -> TC_EGRESS
QDISC_DROP -> TC_DROP
QDISC_INGRESS -> TC_INGRESS
