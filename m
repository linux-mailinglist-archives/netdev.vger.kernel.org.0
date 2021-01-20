Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AC2FDF4D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404234AbhATXxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbhATWeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:34:18 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F5C061757;
        Wed, 20 Jan 2021 14:33:12 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id f11so292585ljm.8;
        Wed, 20 Jan 2021 14:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jCbfwcVyUoQ0JouA43kMZ4FNgMXXeNgl+mh24fuv/4I=;
        b=Wol5X43xwRtW1q3R9Gd0ykc2smF/Q9+4zknLG2pdR4qbKJFebCJj1eipefSdaON8up
         lcufxzBIjgonhZMkCaOJHkpQGjxxfxh1UMpHeIONOWDR/cXvJzbN1ZvGxlkGlffBQrEo
         sEQDPyNYKAAawU6+VhsKeboFZCkkkbaz9dNd7f8UcjEN08k+2NBNbFQwOdN6f20VDvMY
         b/OdKJdCIIRxsIGKYZ4DUmYfrye/xoODDvBoIszD6R3aK/EK2h/llymgJiuZrwWjxZHB
         mLk0hlbn2yD1g/d9kRB//kmtmj6ncaXt6czUbWeNJebVhCyZ5QIhNYmNPfWO1mgiscX4
         CO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jCbfwcVyUoQ0JouA43kMZ4FNgMXXeNgl+mh24fuv/4I=;
        b=SX5Ud9axTQfJpvg8JNZRoY6W3FEB2vF7H2Oy2vJ4MPBAeTo5hkrGRSwhr6d/WVK/nH
         XZ1YaEY5beQKoeyj8M/nODyCU1XcGCj0fXZBazEdCzrDK6cdH5gvkh5+6gp63+6bVKHl
         5Tlxfq51nGvp3NypzWY3Cb/PKJZgXo2i57EQhRDruuWFu7lm0pPE1680Juqtk8T58z5i
         ClY9fpR/n2an85kSaqzBDeHA1pZUZ+5DOaNogTU/X03mtkDufSOWigH1U8NhT8RFh22a
         GFcIUYA+syUZyGmZXRpkikp0UWpAguGjZO2MGgQc/UpfDnQMpxddx9OiwDphUbNH4V4y
         H2Zw==
X-Gm-Message-State: AOAM531tZLaErEBP8w7Yt7IokOqGKAmMBApvUsnOsQ8DMHz6fOcmYbsC
        QlgRkAqTtXxFLQo8zOCARp4OPiNej1a13pQf0OukiC7w
X-Google-Smtp-Source: ABdhPJzbMnC0+jKXktfQLHr83bXGwqIG9AgKvwz4EQvqqRyTCcrX9NwMTZ/f8NYw/LavJe/d4SX16NeKj6dsaVoWGYw=
X-Received: by 2002:a2e:878a:: with SMTP id n10mr5393789lji.236.1611181990782;
 Wed, 20 Jan 2021 14:33:10 -0800 (PST)
MIME-Version: 1.0
References: <20210115163501.805133-1-sdf@google.com>
In-Reply-To: <20210115163501.805133-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 14:32:59 -0800
Message-ID: <CAADnVQK0b6n_f4PM5eOT9oZxE6RmtaQneCZAHOJe5uosxO9S_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 0/3] bpf: misc performance improvements for
 cgroup hooks
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 8:35 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> First patch adds custom getsockopt for TCP_ZEROCOPY_RECEIVE
> to remove kmalloc and lock_sock overhead from the dat path.
>
> Second patch removes kzalloc/kfree from getsockopt for the common cases.
>
> Third patch switches cgroup_bpf_enabled to be per-attach to
> to add only overhead for the cgroup attach types used on the system.
>
> No visible user-side changes.
>
> v9:
> - include linux/tcp.h instead of netinet/tcp.h in sockopt_sk.c
> - note that v9 depends on the commit 4be34f3d0731 ("bpf: Don't leak
>   memory in bpf getsockopt when optlen == 0") from bpf tree

I've rebased bpf-next to include that fix from bpf and applied this set.
Thanks!
