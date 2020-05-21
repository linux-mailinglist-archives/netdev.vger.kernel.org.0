Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC21DD9F4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 00:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgEUWKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 18:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgEUWKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 18:10:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22966C061A0E;
        Thu, 21 May 2020 15:10:45 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w3so3380544qkb.6;
        Thu, 21 May 2020 15:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fm4JD807X5RrjTwsFUI7w3BEzpMypViAerLd/aB5r74=;
        b=J8AydxJvTfOLj4SnXaGjYeBAkg2KcbONigWAqFhy28XWe0yoJSm2mqXTvJxPUdz4vn
         8csb1VJ846w+CN438dl2Kd9l3C73W6h4oKEYXoALOVTin7KbZ/YDlKFLF0AAA4nbJqFp
         LB1X3Hn5mhIhPavMozO/KMXf6gthpTGbRdfqH9PzmVymTuezcrONofpWVb61Js8EVDpD
         4pbUlvLX2ye6Sf9Rnhp+0IxPOYwwYikWR57bi9J2cXHzgLs31qHiq+XRCvC7s0Ay6mem
         07lgQH3Sz3f5gduyy8vQZYJru94h9wd40ax2jSnBP3+ZJ7hlV7fwe7o5DnnsyqeeIJkb
         nEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fm4JD807X5RrjTwsFUI7w3BEzpMypViAerLd/aB5r74=;
        b=trLDoQZA3ADhbuMd/2smbQqDKd6ueP+2G3POiGSfGX2JdjCZfSuatsz9tV2Dw9B+Bk
         b5p1YZannR2PD3UYNYgoyVEtQqCv+jEK8EPEY5ZRbru4Rbcasb158P1l4x5BulXjwP99
         hjreG0e8S8WwJVHukC5Rlp1t+qA2jHUrVhOIehvC9D/dcmOGOldKCW6AJGP2Y7C00gyy
         fNf97w2se4zGwSXgDJyr46+9emYWA5X1TruYKl0mypf322cbb82SGba1jnbH2IUc3pGz
         UwLQBMqBmDXEP6q+g+EfQQXG9LezKLhakrGALpOJ/6GTVa9voJ0wlJh2exyyTYTR4ZDb
         +t4A==
X-Gm-Message-State: AOAM533DeMymvj67KXQkeH7FUGUoQFiXRJ+YZy717iqOTIR0UnsbDCfl
        Qj5bqCaoKvpOaxXxoEMv0xhGy90AYwYX+14yfic=
X-Google-Smtp-Source: ABdhPJxJhqPjBqLqBOYnkHGHiDuGjV6UrwgRBFuNPFyvTMaKJ10aWTqgfPPDhtmPKaNroLARywp1EK7gtepHBmRPz9I=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr11755356qkj.92.1590099044250;
 Thu, 21 May 2020 15:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200521152301.2587579-1-hch@lst.de> <20200521152301.2587579-12-hch@lst.de>
In-Reply-To: <20200521152301.2587579-12-hch@lst.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 15:10:33 -0700
Message-ID: <CAEf4BzZWW_8jKWmbth6=i2+JVx9JKKa7o6vBSQwswRd2sNLEkQ@mail.gmail.com>
Subject: Re: [PATCH 11/23] bpf: factor out a bpf_trace_copy_string helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-mm@kvack.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 8:25 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Split out a helper to do the fault free access to the string pointer
> to get it out of a crazy indentation level.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/trace/bpf_trace.c | 42 +++++++++++++++++++++++-----------------
>  1 file changed, 24 insertions(+), 18 deletions(-)
>

[...]
