Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E505ECB0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGCTTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:19:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35675 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCTTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:19:41 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so3459924qke.2;
        Wed, 03 Jul 2019 12:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hNl5ZX5J27jMosmQSFv4tnQm5p4tErR59+V8oVIIhu4=;
        b=NF1Rbl9cJ+V1ZXDlYniJXzMUjgm2PhmXRm/p1wcPGvPRdVH9CYsXlZdhZEYDie/wgl
         bl25GxEXzeWrTbSgBmLY2vErEJcyVUc3RAywupYjYoHuyn4JfOEa84b3sZNJ1ZQTPTnA
         VUfJ2gWAa2BhAeCQdAv8WOQegWpH06zs7t4yiPELDbgV/scoPNKmw8Osk3e9JjOL0YG0
         t1UekSE6L5DlSCq+48tOcuv2v7OwhTjbAsfVMGcSRuKnD4s1RRXMsPyJck7gE4skQi2c
         BYBrHY5c9DBZr5Epyb0/E3I1PkO1+WMFMSyK+xj0PZdAx664BtSdH68N7oS68kct9Nla
         +YTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNl5ZX5J27jMosmQSFv4tnQm5p4tErR59+V8oVIIhu4=;
        b=AykP3A4xmvGoV44q4ZD9gflboZ7Zv2DmUGrbCD4iZL1AQoxM+lrRoEhuy+NCnBPB3p
         GZv2PvK5sBr0duU5CpOjVy1DEQZ6ODuCR0fAWKRy29BWyo0Y0fe5OGS5Y5oD1ZoeZy1T
         RcNTI8vnbmkPS/nuc9l409dveRKJ1Oq3MQjW1aMlwdVWmzGqjzAGu0Vw4qv2wow+GHNw
         g+P3Lf5O6xbYMq7sJvDp1uXddbGfI+pwOc40uzCr0BMkTheuOn48v8Az6XBA32l7/Syn
         ar/EesKIPg5n+jocsHsNRws2y1Mc9Q9YbRHtLxaT6tshfDyeObE2iU5ZDpOeYiknknuN
         X5Zg==
X-Gm-Message-State: APjAAAXMc2jcK5MP9FmOQCdrg8dVpCFJKRIEjRHBQku5HQV9sO9mBjLD
        wUqDqks1fQAbR4sx2VB+/BM9YFdqX2i+dKzpSX0=
X-Google-Smtp-Source: APXvYqxDKm2ISSLJUoq+4Zqo1iYVlVP4ojM6OFHjGb7Af9LIfSjkE2hYJB0B5Jng9utDM49ZtBy23HdtI8y+temgp08=
X-Received: by 2002:a37:660d:: with SMTP id a13mr4087545qkc.36.1562181580647;
 Wed, 03 Jul 2019 12:19:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190703190604.4173641-1-andriin@fb.com>
In-Reply-To: <20190703190604.4173641-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Jul 2019 12:19:29 -0700
Message-ID: <CAEf4BzZSxpDS7KNupKXz8d+RS0LSynK7ZMK-HqJoDBwzR1u0ew@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] capture integers in BTF type info for map defs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 12:06 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set implements an update to how BTF-defined maps are specified. The
> change is in how integer attributes, e.g., type, max_entries, map_flags, are
> specified: now they are captured as part of map definition struct's BTF type
> information (using array dimension), eliminating the need for compile-time
> data initialization and keeping all the metadata in one place.
>
> All existing selftests that were using BTF-defined maps are updated, along
> with some other selftests, that were switched to new syntax.
>
> v2->v3:
> - rename __int into __uint (Yonghong);
> v1->v2:
> - split bpf_helpers.h change from libbpf change (Song).
>
> Andrii Nakryiko (4):
>   libbpf: capture value in BTF type info for BTF-defined map defs
>   selftests/bpf: add __int and __type macro for BTF-defined maps
>   selftests/bpf: convert selftests using BTF-defined maps to new syntax
>   selftests/bpf: convert legacy BPF maps to BTF-defined ones


Forgot to add Song's:

Acked-by: Song Liu <songliubraving@fb.com>

Daniel, if there will be no more feedback, do you mind adding it
before landing? If not, I can submit new version with Acks added.

Thanks!
