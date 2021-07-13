Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2473C6BB3
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhGMHuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbhGMHuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:50:10 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC20C0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:47:20 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id r16so28591280ljk.9
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fFjwfKPaDmTvA12xJ1cddKKruumFi9mppnHQwGZxxcc=;
        b=GI0hoCu82BxtDJ/N+ecMPikxFKcQ4Dg2sE4rTI5BOrfBNZFY35I/WV6yMghIbEPg64
         ScSue8E7gVirrqGBStRjkAW2dS4jVjxNBbyi1QgLUqmoDMvW61tvb43BSP5vUEtOl8kF
         8mF8dK3QSFUORHU7MPyQq6Aog2AGuS131Op6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fFjwfKPaDmTvA12xJ1cddKKruumFi9mppnHQwGZxxcc=;
        b=ZQLoIX2+NX4djKNE8BeG6RpWxUCWMbtaQrC6HREXKxwNjMLNiUMrjvPnROIq7k5RRh
         D3x/lxwsRhgtH6R17GvwAmoa3HdY+uXgq6DqXPKlPvVTz8kPhbhxSNSAUymv7Ead3sna
         aNpqoc/rWNMbKcFAfT76ObxDvOIiV2WADU01xnsnq3cqK7oLKin0d67Hi35frYoDegRW
         xUUfwhmj6/ISzrCfmow7ljSg93aySMTeDg6U8Km3ZZFkkQT0zlyb1+HBrkD5Kuz9Dd6G
         OfnJ/hVNTT8epQeGjQX6/nQeH0zNyIKVkAiznl40z9JXBpQqx0bx7/ZNVEywODaJ7XFd
         1llQ==
X-Gm-Message-State: AOAM531MqOrcSic9VAOt/JXI9qnZQZo1pYVrjFoG1Bz94b2CbrgIEmp3
        OyGelDgYgPMY/ljVqo+ay/Lw4A==
X-Google-Smtp-Source: ABdhPJwZDd8yEt28Nz9fni7h069Cdd5pMFXgrZ7QF6w9qE94Jnga/+xrqPLYnmZ8Ay1JeUSu83ts4w==
X-Received: by 2002:a2e:8883:: with SMTP id k3mr2982372lji.247.1626162439218;
        Tue, 13 Jul 2021 00:47:19 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id n19sm368381lji.68.2021.07.13.00.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 00:47:18 -0700 (PDT)
References: <20210712195546.423990-1-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v4 0/2] bpf, sockmap: fix potential memory leak
In-reply-to: <20210712195546.423990-1-john.fastabend@gmail.com>
Date:   Tue, 13 Jul 2021 09:47:17 +0200
Message-ID: <87y2aar6yi.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 09:55 PM CEST, John Fastabend wrote:
> While investigating a memleak in sockmap I found these two issues. Patch
> 1 found doing code review, I wasn't able to get KASAN to trigger a
> memleak here, but should be necessary. Patch 2 fixes proc stats so when
> we use sockstats for debugging we get correct values.
>
> The fix for observered memleak will come after these, but requires some
> more discussion and potentially patch revert so I'll try to get the set
> here going now.
>
> v4: fix both users of sk_psock_skb_ingress_enqueue and then fix the
>     inuse idx by moving init hook later after tcp/udp init calls.
> v3: move kfree into same function as kalloc
>
> John Fastabend (2):
>   bpf, sockmap: fix potential memory leak on unlikely error case
>   bpf, sockmap: sk_prot needs inuse_idx set for proc stats
>
>  net/core/skmsg.c    | 16 +++++++++++-----
>  net/core/sock_map.c | 11 ++++++++++-
>  2 files changed, 21 insertions(+), 6 deletions(-)

For the series:

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
