Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C371CA4DD
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHHMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbgEHHMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:12:10 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8483C05BD43;
        Fri,  8 May 2020 00:12:09 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id g16so489188qtp.11;
        Fri, 08 May 2020 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WT8dz7lOh/SMir2tdDotI3JRi9SKgaJFh8CCLOK2p14=;
        b=WcNavMyxO3Mk9BoeN2PBmT3sie1iK9pvecFYWrBWDGJsOnmAIIVREK8+HLk/y+6/Mz
         9QyqwRruohhAlsmXSwILe7LpKvI6tZaeU8KRfEutWhqw1l1AA3WSCAmRj2aWAMZIc7BO
         eyVwB2FkCpRp3m85Oh0JeKVX89XeR4u8CxKcBkHAQghk5D7SjMpAVxiDFM0h03snhSfb
         P6KLRsbO+ludyu3zxYS0t0LAqfO4urxX9MswrxMJyBe887fQik40irwbBzYNgcCD7EPN
         i1nB06F5oN/2ULXBKAGTZq2bY8kP/tI3lZT5wGVO5Ci3QYYL71rmWLquK1GDJEelL/9i
         xEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WT8dz7lOh/SMir2tdDotI3JRi9SKgaJFh8CCLOK2p14=;
        b=UxZy9DA6kp0HWIFrvZWTV30ICEQ0UWyNYbbp0UBvL7s1S5K6U0xzChhE20bn3Wt6sg
         pDRfET9gzVVjel5NfRH7PQkmXgwjt/uyPpMlrTkEkHGOS10lrTOj4vtAnCcYW1P2SLK3
         5Y7YtrBut9Gs7lQrNOajfR1d2MEdCep14bcmaM+VBJ7CZBBwktwjTZcSNgOsm8u8oVMf
         bqmhfmisswhB3hXhiY6RGEcS+Fqq2uWTlMty6OSh17FN1nuWjHkyGcxp1mfCy1lqmbnr
         cMLjzhCH/vbQLbqMuKC8PEZbKe7KsxKruG9UuWJ8d+jNQsspbBZoqhveeOcjWxYtFTHL
         2T7Q==
X-Gm-Message-State: AGi0PuZhYxQQhVg7F5sn31dh7HR85h9dLu/KR+sFFuA8i4T0PVLBsB3u
        5t/eqtn+1FPEHpMP3unGRtmdQzsTGSt1R4EE1YU=
X-Google-Smtp-Source: APiQypIfu9u/Lc+W4qYjRKAPm2hXU/HeHXuHYx++wXVUFF8CTwwgiS9VfwTOSCshvz9lOhItnpEjrfpsibom5FWpqVU=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr1456847qtd.117.1588921929065;
 Fri, 08 May 2020 00:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200508063954.256593-1-irogers@google.com>
In-Reply-To: <20200508063954.256593-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 00:11:58 -0700
Message-ID: <CAEf4BzYT5FfDt2oqctHC6dXNmwg5gaaNcFu1StObuYk-jKocLQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: fix undefined behavior in hash_bits
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

On Thu, May 7, 2020 at 11:40 PM Ian Rogers <irogers@google.com> wrote:
>
> If bits is 0, the case when the map is empty, then the >> is the size of
> the register which is undefined behavior - on x86 it is the same as a
> shift by 0. Fix by handling the 0 case explicitly.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

No need. The only case when bits can be 0 is when hashmap is
completely empty (no elements have ever been added yet). In that case,
it doesn't matter what value hash_bits() returns,
hashmap__for_each_key_entry/hashmap__for_each_key_entry_safe will
behave correctly, because map->buckets will be NULL.

>  tools/lib/bpf/hashmap.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index d5ef212a55ba..781db653d16c 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -19,6 +19,8 @@
>  static inline size_t hash_bits(size_t h, int bits)
>  {
>         /* shuffle bits and return requested number of upper bits */
> +       if (bits == 0)
> +               return 0;
>         return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
>  }
>
> --
> 2.26.2.645.ge9eca65c58-goog
>
