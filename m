Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E685515F8A
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383218AbiD3RbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383210AbiD3RbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:31:02 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2571F28E33
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:27:40 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r189so19632083ybr.6
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 10:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=grA9/hM0Ugp7j6w1mDRG6V54KySmRsQxOiqgW9gDLpo=;
        b=bwEM4A2tknHjQsDi1a7jfZV8iN91bk9oyq7Yv2KEm0fVIM2Vx0YbYF8qssmBe4CHSb
         /frtfvRjqLqTOdZGluhFa81a7luixAYlC89wlOQWmpPftihonA4GEy2fPlwFnzEQkzon
         ytweY82rWZnvlcfadNK9qstKTv2NIKnVY7ytSOhWdEmDD+pThZnCQmjPb6Zz+7xSwI4n
         f0F7Oo9hos9zvNzq3IlFFNOeca8JkN4mKgnW6TFisFFYoYnG9M9pLYAkgiEtD2TIKSN+
         UxnrCaFXPxU8lI2r33Km1hDlqOUn7K3+ZfySrW7uiO9ApWKfm29JIPGIJzI8OxNgPRcE
         eyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=grA9/hM0Ugp7j6w1mDRG6V54KySmRsQxOiqgW9gDLpo=;
        b=wWwD0dskL+Tc5/sUlDB4ipiAnLEHUP6O+8QpSywfcqYLMECO1VCgV5XFlETheYNdtB
         VTWqTbcMFxCq8CG3k38eS1y2vtwJ5TG6OuBg6TftNPj9my0oI68sMpbck/0gJH5eHcGR
         IELpYh8RwqUiCs00E33z6vy3Qbw8Y1w25ZJG5s6LUYcVu7Q1s04u9Jea7ptTPLUduRx7
         gYp1LW8LrDEbUi8i6D7nJtQTRTXiVKKGAjqGQiylR7uumGCLQ4JneMakx0+G2f939Rbh
         WMIWnj+Hc2eLiXdfc53VnSwZJUJIwh5RnX2UEKjtkqUHxeMG7CGUxlB5RNrHgIGmIhHa
         unwg==
X-Gm-Message-State: AOAM533P8k1qQCR9g6E+4NMh2fdrVwd5nr3F0KPZ0jwCqvikpFwqvVua
        v89rl49oiTUUVjAhUvW5epMUbCM2M4FObcyTY/s=
X-Google-Smtp-Source: ABdhPJw74D4Hzcf6zJTcgNika5eQ5eJEqBcQ9DfgbbSzv4olSPyPt29lB1eHgJPRehN05R1MNGtZC7QgZlHKiptRyAA=
X-Received: by 2002:a25:848d:0:b0:648:961b:5c2b with SMTP id
 v13-20020a25848d000000b00648961b5c2bmr4345685ybk.41.1651339659350; Sat, 30
 Apr 2022 10:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com> <878rrs6vf4.fsf@cloudflare.com>
In-Reply-To: <878rrs6vf4.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 30 Apr 2022 10:27:29 -0700
Message-ID: <CAM_iQpXFEYSpQbxxPKEC8v+dBA846nFqbPaLLfVMRiOziEEA=g@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 0/4] sockmap: some performance optimizations
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 2:33 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sun, Apr 10, 2022 at 09:10 AM -07, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patchset contains two optimizations for sockmap. The first one
> > eliminates a skb_clone() and the second one eliminates a memset(). After
> > this patchset, the throughput of UDP transmission via sockmap gets
> > improved by 61%.
>
> That's a pretty exact number ;-)
>
> Is this a measurement from metrics collected from a production
> enviroment, or were you using a synthetic benchmark?
>
> If it was the latter, would you be able to share the tooling?

Sure, actually my colleague Jiang modified Cloudflare's TCP
sockmap code for UDP, here is the link:
https://github.com/Jiang1155/cloudflare-blog/tree/skmap-udp

>
> I'm looking at extending the fio net engine with sockmap support, so
> that we can have a reference benchmark. It would be helpful to see which
> sockmap setup scenarios are worth focusing on.
>

Sounds a good idea.

Thanks.
