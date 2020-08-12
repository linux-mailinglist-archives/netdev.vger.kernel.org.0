Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB05242E52
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 19:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgHLR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 13:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbgHLR5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 13:57:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D2C061383;
        Wed, 12 Aug 2020 10:57:31 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y18so2718972ilp.10;
        Wed, 12 Aug 2020 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JyibkVSiizY9YOvoSVEYhcABEVmlRGhf5ooTxC+oeU=;
        b=DKoq/9auKpsQBGVG0od4nJPaSxjlCJn9QC5gFmfDHEQXROhaXPlKH9qxdS7cmEqjbd
         dY2eoc8E4rzxiOSvs6DCui+4EeosVC2pHgHgg5r9eHau2oKIQiHNBDwCQRVWBlfm6hJr
         SaLQ84D51Sh2A8Gf7HlvvC0Mbm3TPFEz3WbkU3UjrOMPHY68t28T04/y2wu0tLl+Lq3D
         DcbcCDvI9EQUqgQHwou6ZNM63hemUegS7MqmZVjJIQ8xWgS/qOQiE5tHJWsBGzLdLIWf
         bsL5q0XCKqSDtEylhKyduvqPIuFvlpwPkPQtU19YmYcLALAfRNYRQZreCkjRQbGad3Rr
         1Qhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JyibkVSiizY9YOvoSVEYhcABEVmlRGhf5ooTxC+oeU=;
        b=DSEGtV4mThrMzVysFxfh3nILVStZ6UlS/8P1LcFgMQ6anuWagkKIijuy3NNzsasEfC
         PQMF1hCyRYgwuZGgYWGDk6df4PVABGk9zsbabXy2DxJLvtatQ73duLpHVuS6rHf+9dWh
         NmSfJjJfusyBYDcnKCeCqPNtfea0vX56nmB+RXmrlJ3GytSqB/SQ8E7IJrpdvvtaChUX
         KK8Bs5Ns1mdbMhYR/WdIgeYUwRFDqKNugarFA1Z1NtnpFAvI6IuyXAa0C/sv5t1WUxqG
         oyGBuNRWSKQxw7nwaqWCzub9o8kMikwLFD9PGPxY6kRbQMKBKFkkPukIspcmZADZRYuu
         5dNg==
X-Gm-Message-State: AOAM533KZlCCM4ggtq2apv9a0OXIzE2Iyvl3ypZg+UjlKLmAQcznVK6E
        jJpGhhTzMDVTnSNCwMb2FXiahcA0envgS2Menv0=
X-Google-Smtp-Source: ABdhPJycyiElaJpaN408tnwxcoSZaS8zir3jT6LbvqGvRn8QEylA02sgqrGW0m3mbSSPrR72M1OjcoTze+HbjPn0pdA=
X-Received: by 2002:a05:6e02:f94:: with SMTP id v20mr838937ilo.268.1597255050359;
 Wed, 12 Aug 2020 10:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <a139c6e194974321822b4ef3d469aefe@huawei.com>
In-Reply-To: <a139c6e194974321822b4ef3d469aefe@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 12 Aug 2020 10:57:19 -0700
Message-ID: <CAM_iQpXhXK3SfRmy+qLTVhQ3s0-=n6TjC8RmG3XYLr-BAenQPA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix potential memory leak in proto_register()
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "zhang.lin16@zte.com.cn" <zhang.lin16@zte.com.cn>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 2:21 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> Hi all:
> David Miller <davem@davemloft.net> wrote:
> >From: Cong Wang <xiyou.wangcong@gmail.com>
> >Date: Tue, 11 Aug 2020 16:02:51 -0700
> >
> >>> @@ -3406,6 +3406,16 @@ static void sock_inuse_add(struct net *net,
> >>> int val)  }  #endif
> >>>
> >>> +static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot) {
> >>> +       if (!twsk_prot)
> >>> +               return;
> >>> +       kfree(twsk_prot->twsk_slab_name);
> >>> +       twsk_prot->twsk_slab_name = NULL;
> >>> +       kmem_cache_destroy(twsk_prot->twsk_slab);
> >>
> >> Hmm, are you sure you can free the kmem cache name before
> >> kmem_cache_destroy()? To me, it seems kmem_cache_destroy() frees the
> >> name via slab_kmem_cache_release() via kfree_const().
> >> With your patch, we have a double-free on the name?
> >>
> >> Or am I missing anything?
> >
> >Yep, there is a double free here.
> >
> >Please fix this.
>
> Many thanks for both of you to point this issue out. But I'am not really understand, could you please explain it more?
> As far as I can see, the double free path is:
> 1. kfree(twsk_prot->twsk_slab_name)
> 2. kmem_cache_destroy
>         --> shutdown_memcg_caches
>                 --> shutdown_cache
>                         --> slab_kmem_cache_release
>                                 --> kfree_const(s->name)
> But twsk_prot->twsk_slab_name is allocated from kasprintf via kmalloc_track_caller while twsk_prot->twsk_slab->name is allocated
> via kstrdup_const. So I think twsk_prot->twsk_slab_name and twsk_prot->twsk_slab->name point to different memory, and there is no double free.
>

You are right. Since it is duplicated, then there is no need to keep
->twsk_slab_name, we can just use twsk_slab->name. I will send
a patch to get rid of it.

> Or am I missing anything?
>
> By the way, req_prot_cleanup() do the same things, i.e. free the slab_name before involve kmem_cache_destroy(). If there is a double
> free, so as here?

Ditto. Can be just removed.

Thanks.
