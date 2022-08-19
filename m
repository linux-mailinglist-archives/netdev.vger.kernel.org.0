Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF73599E00
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349252AbiHSPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348832AbiHSPRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:17:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBD0FAC5A;
        Fri, 19 Aug 2022 08:17:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y127so1630144pfy.5;
        Fri, 19 Aug 2022 08:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YFMuK07MAl90VNNqj+UWyRTdyy2yEe0aAWnn80xZ4hU=;
        b=JDgj3pb/g+V5bIF7JGajRHFNgtDvCci3zYOBCFl6+1bAAUorPTTOh5Vni++0pnHsRj
         nuKvseA1W73dEp5EAs8lERkOTnSBd9lug1/lzKbFPr3CDJgxJAeEszNNkMVhAO/WdZcY
         avTg4XnnJUZWxAIOg+Lg+V6LRDJOeBG/gAFp5NY4hr0JBcyIYOOfi4roW4bxNFBMuadu
         jMzLzjvxWku44ALsNamO1gEjzonca8nmEQ6FG98pbepvPnY6yzkXonDgKYLbubrYLAC2
         3AhAtGyXy3sS4QV+3foAXj4p/Qd1ZW44QnIn1q6ceAfjoPDMyxGSyJIAXSDVv0aljXen
         4DbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YFMuK07MAl90VNNqj+UWyRTdyy2yEe0aAWnn80xZ4hU=;
        b=PoZWbvjwm65Q5xoTO9ncGsvYrroy1SOiF0twCI02LAcnDBoYCy9zHJJWw2TNfAgjMd
         GBLEegXoRU50mwNSIKnbLI0ekQSaSFyzxpEjwuIUAiqau56/5PYJiolKn7yETHkn6aO/
         6kPmjkENv/gjwaY9yTuCfh+rMFAIlYzAqR73M8m6LsdiiZIf1VDChAGTnlKv6o50Mt1b
         kdXQJw/WmarHDRfHGmW9qOXR6BC2A6+L3Ja9OQBDk081KKjPMep9O+jU5ZyjhX5mKOzl
         TidmZvn6/BZyaZEvTk1KqPoR70BTCh3UDvNcy3goxeLUvKeiETnXl9gPFvL4BWTdkw5c
         1itg==
X-Gm-Message-State: ACgBeo1FDFRqXXntbkVeaf31DTTqOmb+O70VNGQDjPb2I2N3L+OzRkde
        bgOv2vh2jz1tk8LW9sdWn2r3wz8Tzu8FE3i+v6I=
X-Google-Smtp-Source: AA6agR4QSQZbufZFY6889DXKIezlLDRxvx5cv0TiWrF+yGykKS++cMBKb9rvD2W6HSATtKMwo534T9aYLo31DMRLLbA=
X-Received: by 2002:a63:2148:0:b0:427:17f6:7c05 with SMTP id
 s8-20020a632148000000b0042717f67c05mr6668275pgm.200.1660922235800; Fri, 19
 Aug 2022 08:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220816032846.2579217-1-imagedong@tencent.com> <20220818100946.6ad96b06@kernel.org>
In-Reply-To: <20220818100946.6ad96b06@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 19 Aug 2022 23:17:04 +0800
Message-ID: <CADxym3YCp3KyjOLWg_zj9scLjzN0SsyR99cTnp9b4i_pfxBxSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        ndesaulniers@google.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
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

On Fri, Aug 19, 2022 at 1:09 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Aug 2022 11:28:46 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
[...]
>
> Sorry for a late and possibly off-topic chime in, is the compiler
> splitting it because it thinks that skb_unref() is going to return
> true? I don't think that's the likely case, so maybe we're better
> off wrapping that skb_unref() in unlikely()?

I think your thought is totally right, considering the instruction
that I disassembled:

ffffffff819fea20 <kfree_skb_reason>:
ffffffff819fea20:       e8 cb 2c 40 00          call
ffffffff81e016f0 <__fentry__>
ffffffff819fea25:       48 85 ff                test   %rdi,%rdi
ffffffff819fea28:       74 25                   je
ffffffff819fea4f <kfree_skb_reason+0x2f>
ffffffff819fea2a:       8b 87 d4 00 00 00       mov    0xd4(%rdi),%eax
/* this is just the instruction that compiled from skb_unref()  */
ffffffff819fea30:       83 f8 01                cmp    $0x1,%eax
ffffffff819fea33:       75 0b                   jne
ffffffff819fea40 <kfree_skb_reason+0x20>
ffffffff819fea35:       55                      push   %rbp
ffffffff819fea36:       48 89 e5                mov    %rsp,%rbp
ffffffff819fea39:       e8 42 ff ff ff          call
ffffffff819fe980 <kfree_skb_reason.part.0>
ffffffff819fea3e:       5d                      pop    %rbp
ffffffff819fea3f:       c3                      ret
ffffffff819fea40:       f0 ff 8f d4 00 00 00    lock decl 0xd4(%rdi)
ffffffff819fea47:       0f 88 e5 44 27 00       js
ffffffff81c72f32 <__noinstr_text_end+0x255d>
ffffffff819fea4d:       74 e6                   je
ffffffff819fea35 <kfree_skb_reason+0x15>
ffffffff819fea4f:       c3                      ret

The compiler just splits the code after skb_unref() to another.
After I warp the skb_unref() in unlinkly(), this function is not
splitted any more.

Yeah, I think we can make skb_unref() wrapped by unlikely()
by the way.

Thanks!
Menglong Dong
