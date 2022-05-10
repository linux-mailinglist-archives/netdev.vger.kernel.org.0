Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7197A5223D9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348775AbiEJS15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349053AbiEJS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:27:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D5C179094
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:23:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g6so34645324ejw.1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I6+6daxf9DBR/wq5NboOShmKyA8J0iaTzHPVTMkgH10=;
        b=QHCsBsCmgpbSZbkfqS1Oo1MUQeuhlP1ZsLgzzMnXdAdig3V1zAvrj5IKC7nbum8dEY
         peXnK6zU/RodBxXQ4H3AQrDQdldz0aOJKB0erOEm9K95Tw69V2izzp5jd0jPewdxCHR+
         ZzsEDjnTue1e20m7A4AngmpfO54XUJd2CWRSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I6+6daxf9DBR/wq5NboOShmKyA8J0iaTzHPVTMkgH10=;
        b=A6L4qD/gTSKYEIOiORp4Wh1KLftrcyPPdDukkMGm0eSc/ztxV4MpfbpEZjldVuSWW1
         MQ1d10XiychUwetyz7Q293q3mcOxjZPqSdNhytapY6WLMszuVBlHnRUNDUC8J3vm8XT4
         DLcUELnBkkEmTVIRGOdyL6wVmekhjY75SoVci/5e8eiKuOv4A5hZ2hvW03ZpMQREQmjp
         GKx1bljaBX7JJGFZa0kE7xfuodRGsCP/BCaILY5IGdo5DMtz1qUBItt7peNv9AL0LjfI
         eUu1+X5qAepsYHmD5Yvik0wedg1xplG66aY/d9JV+TIXBCjYpMy8vKb3Z7NIQHDKw73B
         ELhQ==
X-Gm-Message-State: AOAM5329+VTh0k9YxcWXFeGOmSiNXv4+4YXpPuV34Gd60Ez2+fxhbRw3
        /hIveMFk+2KQlEPaHPN4fv37L3kLnsDRj7cufHE=
X-Google-Smtp-Source: ABdhPJw3EonQ0GdudHEdFpPPDpAUaRMTr+o/i0BYoDPK/02HTAoAtXGjLFPn2dMD3dBnrjGKK3TTHw==
X-Received: by 2002:a17:907:162b:b0:6fa:94f3:15d6 with SMTP id hb43-20020a170907162b00b006fa94f315d6mr6530166ejc.330.1652207008206;
        Tue, 10 May 2022 11:23:28 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id h20-20020a1709070b1400b006f8c8e43a45sm28036ejl.103.2022.05.10.11.23.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 11:23:27 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id b19so24948050wrh.11
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 11:23:27 -0700 (PDT)
X-Received: by 2002:adf:dfc8:0:b0:20a:d256:5b5c with SMTP id
 q8-20020adfdfc8000000b0020ad2565b5cmr19494972wrn.97.1652207007228; Tue, 10
 May 2022 11:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220510082351-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 10 May 2022 11:23:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
Message-ID: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 5:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> A last minute fixup of the transitional ID numbers.
> Important to get these right - if users start to depend on the
> wrong ones they are very hard to fix.

Hmm. I've pulled this, but those numbers aren't exactly "new".

They've been that way since 5.14, so what makes you think people
haven't already started depending on them?

And - once again - I want to complain about the "Link:" in that commit.

It points to a completely useless patch submission. It doesn't point
to anything useful at all.

I think it's a disease that likely comes from "b4", and people decided
that "hey, I can use the -l parameter to add that Link: field", and it
looks better that way.

And then they add it all the time, whether it makes any sense or not.

I've mainly noticed it with the -tip tree, but maybe that's just
because I've happened to look at it.

I really hate those worthless links that basically add zero actual
information to the commit.

The "Link" field is for _useful_ links. Not "let's add a link just
because we can".

                           Linus
