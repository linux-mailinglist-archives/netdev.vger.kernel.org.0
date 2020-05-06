Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC011C7C89
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgEFVgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729391AbgEFVgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:36:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8CDC061A0F;
        Wed,  6 May 2020 14:36:35 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o16so2535051qtb.13;
        Wed, 06 May 2020 14:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sLuNCU2JM/epZOTJGI+BJEI5qSqulxTn0n+nKtPntxY=;
        b=sQak3jbP3LldPznsXSiqinAFTq/1BN0yY6SzjCKuEsVT1MyrGLHPxcgCs6t9TH2Mgg
         jSlb9WYTP1Bn5tG7b4PdUvo0Wc/rywdiT4C5700AeCFMQDEqXvt3uBjMa7UdWKDrYZ1h
         ODAMrTb11R5oX/qtRcuBoZaKfkgRAScdSR11lRmQmIYOf3GdpvhQVJ/D8cxSmAaMmC3f
         34F5Fp0wp/hlJailM8yiVav93Ce4YWgrUzDX6uOK1jglli3PFHn1E2Xxd5o+qAlAcwTk
         vrDHuKKMP/j1MBr2A8WOXHAzuf8vv1AJzsaGM96Wbprudd38vk1mNKMn6gI4foICxv7s
         O9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sLuNCU2JM/epZOTJGI+BJEI5qSqulxTn0n+nKtPntxY=;
        b=cB83K9Y78mjiwHgaAswznyPOmoHZ2nGwf580ftvgzlGo14l3wTBESDyv9eFvYgCGZx
         9tZ5pVUZc9xvrkdIeuMiCinWSqMzuYCD9f3j8/KsFQp1IG9MigZBq+F9bBNHUOeJzkk4
         Y49OQbpTqD2uBqPHwshMS5rLa34Ai7ZmmUmaa2jCmxam3da+s2CijZfzrSQMXO4M6BT8
         x9F17iAaE7HgoXPM9BdkHKEOZL5Rym5DDoxFly33HR/SAL3UBx/e5fNz3SL2cDy40ZJu
         2TPOLXfj5CJNO3yvJVSwvK+Lf7YmjQGE8gF5jiTaXLWsHJpfKNkcl8+jhtQZiuDpbkRF
         XISA==
X-Gm-Message-State: AGi0PuaSVjozdrcgZcFQ16Birzpy1XcgkRUkNnadjnrRS+R52P1fkrl7
        C0bP/sqpI9P2CAgoUyEQJ29nE2P6FjLvFMLPkHM=
X-Google-Smtp-Source: APiQypJ23cVvg3sBAZTMMKR8v6RGmzYOYb19GQxmrT2w7HUNN0KTGaqSVZDx79d1hs/O6Q0HOsGVfxaFm/JLzThXot0=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr10321977qto.59.1588800994307;
 Wed, 06 May 2020 14:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200506205257.8964-1-irogers@google.com> <20200506205257.8964-3-irogers@google.com>
In-Reply-To: <20200506205257.8964-3-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 14:36:23 -0700
Message-ID: <CAEf4BzYJanGO+XrTBQoEzGoB_D6xQYYm9tT70+Kie4hyKCxhjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib/bpf hashmap: fixes to hashmap__clear
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 1:55 PM Ian Rogers <irogers@google.com> wrote:
>
> hashmap_find_entry assumes that if buckets is NULL then there are no
> entries. NULL the buckets in clear to ensure this.
> Free hashmap entries and not just the bucket array.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

This is already fixed in bpf-next ([0]). Seems to be 1-to-1 character
by character :)

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200429012111.277390-5-andriin@fb.com/

>  tools/lib/bpf/hashmap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> index 54c30c802070..1a1bca1ff5cd 100644
> --- a/tools/lib/bpf/hashmap.c
> +++ b/tools/lib/bpf/hashmap.c
> @@ -59,7 +59,13 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
>
>  void hashmap__clear(struct hashmap *map)
>  {
> +       struct hashmap_entry *cur, *tmp;
> +       size_t bkt;
> +
> +       hashmap__for_each_entry_safe(map, cur, tmp, bkt)
> +               free(cur);
>         free(map->buckets);
> +       map->buckets = NULL;
>         map->cap = map->cap_bits = map->sz = 0;
>  }
>
> --
> 2.26.2.526.g744177e7f7-goog
>
