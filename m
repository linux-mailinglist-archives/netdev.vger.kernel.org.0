Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835229F7DC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgJ2WZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:25:03 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530F3C0613CF;
        Thu, 29 Oct 2020 15:25:02 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id b138so3497266yba.5;
        Thu, 29 Oct 2020 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uj2l+dvKbdMwpYX4cQk7PUdaO5o8LISaAemCD5aYDG0=;
        b=vT0MhveRj9Tkq/mDcJDowdsvH7avpHwh8ZMEgVeybkMT092bZmYC2iwZRk63HkK5EY
         2dk78LiD9V6xm5Cesc8PMAYf+dOlhh4Ze7tl9zAXdHKKzWwoTBriOAJhIQs8x0o6a/mM
         ZaAIhgrnythaEa1ee34rB56Lz5tX2DLTUdkdsq+iztMPHVFX95+t+Io0IhaQNqSUnUmS
         NPsHntF7VyshbMW28egSaURO2pIRd6kw/MVG0zbuo/a5QdXI7HEHv6gUqQ5tFxAwZ84M
         cMCgx522u3ZiEKCCpYmRqb5ZWEifC3m513GAScFjDuPBDcHhZCdeVgqgfuK1KBRAo2Wd
         UX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uj2l+dvKbdMwpYX4cQk7PUdaO5o8LISaAemCD5aYDG0=;
        b=RaXzIUYYVDDh1M5fauOk0gMxMezwyn/x7NIxLXpOvFeDeWdqww9jj0LsE8yCjusxtY
         z+d6ffa9KTgUTWmDhZiuB/zE43g3SKbZeRNK+oD7Alfy5Josx1fGqmTuBgyR/tfYoQsy
         Ky4SZ907H8rss/XigJq8voVe0nUD50ilSqmDmt9N/7mi3KV88phfgrlK1Xir0h/pfAWo
         aVwNJy28ChsUBdIpnAFV9rDOXJZi1qWaTUdDFuTC+m+2CZliOHC5uj4BKm6gsAn8+BFt
         9+RU92K1tgoxU4f0a15FvqywOG7XPhVV00lO0R3hWf9nl6fJDic3afKNa3cf68lzBBfW
         IhTg==
X-Gm-Message-State: AOAM530vUmwfUzxP1MaR0JNOpQW6MBAuMFKIrecDOpdidX76hWvWLOP1
        Miur4pHtQkCIRV57WVSXsln7ufQmyrYUSjNdzy0=
X-Google-Smtp-Source: ABdhPJwecE56Lli3ZfpQZNfHAVVekkfObaWGruxtsKcfg067aF2G4yUaiE+cidRARDox/ovjv9wyLMj+u6ubgfdAsCM=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr9434780ybe.403.1604010301511;
 Thu, 29 Oct 2020 15:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201029220919.481279-1-irogers@google.com>
In-Reply-To: <20201029220919.481279-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 15:24:50 -0700
Message-ID: <CAEf4BzaRZ60zajtDDkKA+0UwXCsT4HZpJ=f12_GzrEa+rkPfcQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: Avoid undefined behavior in hash_bits
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 3:10 PM Ian Rogers <irogers@google.com> wrote:
>
> If bits is 0, the case when the map is empty, then the >> is the size of
> the register which is undefined behavior - on x86 it is the same as a
> shift by 0.
> Avoid calling hash_bits with bits == 0 by adding additional empty
> hashmap tests.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>,
> Suggested-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

I didn't realize you'd need to add three extra checks. If that's the
case, let's just add `if (!bits) return 0;` to hash_bits() and be done
with it. Please keep
hashmap__for_each_key_entry_safe/hashmap__for_each_key_entry changes,
they are ok regardless.

>  tools/lib/bpf/hashmap.c | 12 ++++++++++--
>  tools/lib/bpf/hashmap.h | 12 ++++++------
>  2 files changed, 16 insertions(+), 8 deletions(-)
>

[...]
