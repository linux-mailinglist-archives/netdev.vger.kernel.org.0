Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CFD4639A0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhK3PSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244998AbhK3PQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:16:38 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD399C08E897
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:08:02 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e136so53415354ybc.4
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 07:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2skKMNgf13ma0Gw8CEfIcE4gBelJ5As1NMc9eHUE/c=;
        b=CjgMBJ1Swt1ZTWjUP7wtXeRh3mviebEOpMcpTlhfZ28h+H9KexmKQXxsGhMNR5Knkc
         tcNhTzsoAJTqgJoxVVUPmqHxz1HZirx7o5JqWh1NgtxDqZ6tU8TE2Adjt4HSqSiBo2lV
         62YvdEem9Jpto28eQvpU2HMeD/YgOK+tcUIurN24vM6gUqauVXLveoK9ho/SlCmh14w6
         ZeSz8zbVywKy3kYVxHzNI+hCo5oclgFvpH8WwIzV43/x2lvmonJmkAyk7gr8YRQ8zYnz
         9bNersWxfz40y0N0xKN4d5Z3Yqc0qKNXuHeThbHEy6PEvJAPeD/KWot2tYidOtoCsxQu
         GjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2skKMNgf13ma0Gw8CEfIcE4gBelJ5As1NMc9eHUE/c=;
        b=ZcLHABpewtjgWWsbD09nuFoAWF8tegbnfzJK4ZSmATPvorcEMMsBfv/ymQ2+RFct1x
         ez+JG8aFfo5WgzSSSaFyMqDKKEpNBEuhjimPxqWZmh0QH1sdYukoyiKPm+y8bPut2Frb
         56X6E5GzKL53ZesYZREymcJ73TYFy2ZM5HpjWJqjhZeXs5NdFl16nZm4hCMTyAKdLTAP
         D3mTfsSlrklazPp4JYbdCc8b9PGVQsRD9eqv2hRyuLYzVPxRZZ8bonOi5fD/UsBSB8G6
         oKQcHMBIrAcvMKiJy1kgvmxLgIIPM5n7vhpHlc4t0ARekh7/QjY3Kh6QwwFxVleOcj1d
         209g==
X-Gm-Message-State: AOAM530LqEd2YREd08M0sVyjc1K/Zl6HdlTGUp87RvX/XplC8NAdwZE5
        VrAqkaRdEdn4LGe4vs5wSUJPPmoRI/C2KC8eY7jf3oF63I6wYQ==
X-Google-Smtp-Source: ABdhPJyECRVxXhkFw1vi7g5sU1bcfkJ3h9femyhEPQ8mFWssonHsQH28MuFyqrzZqSlYRnC+p9QwsqSpM1gUkHkYLsU=
X-Received: by 2002:a25:cc8e:: with SMTP id l136mr40948197ybf.293.1638284881393;
 Tue, 30 Nov 2021 07:08:01 -0800 (PST)
MIME-Version: 1.0
References: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com> <20211130090952.4089393-1-dvyukov@google.com>
In-Reply-To: <20211130090952.4089393-1-dvyukov@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Nov 2021 07:07:50 -0800
Message-ID: <CANn89iLnk+cfKcBk-6oQhiKDYg=mYaYrp-S=k0M5WJCkgHm+bw@mail.gmail.com>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     eric.dumazet@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 1:09 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> Hi Eric, Jakub,
>
> How strongly do you want to make this work w/o KASAN?
> I am asking because KASAN will already memorize alloc/free stacks for every
> heap object (+ pids + 2 aux stacks with kasan_record_aux_stack()).
> So basically we just need to alloc struct list_head and won't need
> quarantine/quarantine_avail in ref_tracker_dir.
> If there are some refcount bugs, it may be due to a previous use-after-free,
> so debugging a refcount bug w/o KASAN may be waste of time.
>

No strong opinion, we could have the quarantine stuff enabled only if
KASAN is not compiled in.
I was trying to make something that could be used even in a production
environment, for seldom modified refcounts.
As this tracking is optional, we do not have to use it in very small
sections of code, where the inc/dec are happening in obviously correct
and not long living pairs.
