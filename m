Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E825553C44C
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 07:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbiFCFeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 01:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240737AbiFCFeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 01:34:09 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA13638DBF;
        Thu,  2 Jun 2022 22:34:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a2so10970668lfc.2;
        Thu, 02 Jun 2022 22:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KF5yq6Enx4Bdz3Avcm29+ohVRRzQl9wm8VtLxXbcBX4=;
        b=cRTNqE6jJImVaKeCqWv+jepE5wEhrLx3ue0PRddNVpBoagJiFrAttnxaoZ2rLka0rg
         zHfldgd630eYlv+XewYFN6JbIpJl2Ai9EPfsWAbI3ALVuQkqs59uAh7rpbObuBzQ+df3
         yn6L9qUp1cdwU7u39uPEY+6WFEe7pKcMJDCR5bZolHTB7OYI+Lc7sma8CJlBE0SQL6JX
         eD8IKUIStNsuiCtAe3OzsKQ4XhD0iwl8yYnpqGtBrtH/2755DM3RZREaugOidxVsl5vO
         QnWjgo4vrclRYZ/vJorWoeRqxc6YkavgfZMnIypwhgMWHyGZ1eOz175MNESsedSCV0jK
         Y80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KF5yq6Enx4Bdz3Avcm29+ohVRRzQl9wm8VtLxXbcBX4=;
        b=w+XwfeJnKArWQlB6TUI3Rfe3XOpLQCQciVL6JyoYYI1W+HH/iYspb+J7VQoW0hwwld
         2pxcwaKG8Qva3Q9CbVmW103DciXsV7lMO6Tg1ye/4n5gkjk7346RCpW/xebvWa7W+baM
         An1WSK0VIHKOtHKrDmdmHmQ8VBZ62hzRB2zUrYiqrjBei1t8/Imx0RYgWzO4wJAzyCLC
         LyMHSTe2cWwl9OSWynLySmNzkqeES8Oz/Nu/0jJmKWsJ9uFwyIGAcrSEsFX6jfBOkc5/
         XaFqCwOMKXTFIYZpyhRrrQJezEwl1MQmWxZZEkLBr3sp8h8RrcXhw+3ZhXoDgzU2rYSx
         wFGQ==
X-Gm-Message-State: AOAM531QTp0PL+crni4SgRG7iyG5t8NrqQW95ky+yFRBCqb9nGXoRXYN
        o4+9spBUHdxR+v4yS6qParRgPKWlzOV4agooy5Q=
X-Google-Smtp-Source: ABdhPJwcwdFuF48uAq0fBO/eVCBfRn47mZewR6RwVVhmRUEIr/whLE3znAmW+Q829Ifac3cF9ZxCpZIOfi05BZ+3l5g=
X-Received: by 2002:a05:6512:1398:b0:448:bda0:99f2 with SMTP id
 p24-20020a056512139800b00448bda099f2mr52603360lfa.681.1654234446024; Thu, 02
 Jun 2022 22:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220603041701.2799595-1-irogers@google.com> <CAC1LvL12oxCojWBxqCj=g+cC=UbAHoQ6kT4TQXSi1j78L5zn3g@mail.gmail.com>
In-Reply-To: <CAC1LvL12oxCojWBxqCj=g+cC=UbAHoQ6kT4TQXSi1j78L5zn3g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 22:33:54 -0700
Message-ID: <CAEf4BzYvxvidSPa1ewWMm7rWHP=eSfu9vXz0rkbPWpBB5HpuRA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yuze Chi <chiyuze@google.com>
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

On Thu, Jun 2, 2022 at 9:31 PM Zvi Effron <zeffron@riotgames.com> wrote:
>
> On Thu, Jun 2, 2022 at 9:17 PM Ian Rogers <irogers@google.com> wrote:
> >
> > From: Yuze Chi <chiyuze@google.com>
> >
> > There is a missing not. Consider a power of 2 number like 4096:
> >
> > x && (x & (x - 1))
> > 4096 && (4096 & (4096 - 1))
> > 4096 && (4096 & 4095)
> > 4096 && 0
> > 0
> >
> > with the not this is:
> > x && !(x & (x - 1))
> > 4096 && !(4096 & (4096 - 1))
> > 4096 && !(4096 & 4095)
> > 4096 && !0
> > 4096 && 1
> > 1
> >
> > Reported-by: Yuze Chi <chiyuze@google.com>
> > Signed-off-by: Yuze Chi <chiyuze@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 3f4f18684bd3..fd0414ea00df 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
> >
> >  static bool is_pow_of_2(size_t x)
> >  {
> > -       return x && (x & (x - 1));
> > +       return x && !(x & (x - 1));

ugh... *facepalm*

>
> No idea if anyone cares about the consistency, but in linker.c (same directory)
> the same static function is defined using == 0 at the end instead of using the
> not operator.
>
> Aside from the consistency issue, personally I find the == 0 version a little
> bit easier to read and understand because it's a bit less dense (and a "!" next
> to a "(" is an easy character to overlook).
>

I agree, even more so, logical not used with arbitrary integer (not a
pointer or bool) is a mental stumbling block for me, so much so that I
avoid doing !strcmp(), for example.

But in this case, I'm not sure why I copy/pasted is_pow_of_2() instead
of moving the one from linker.c into libbpf_internal.h as static
inline. Let's do that instead?

> >  }
> >
> >  static size_t adjust_ringbuf_sz(size_t sz)
> > --
> > 2.36.1.255.ge46751e96f-goog
> >
