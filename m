Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CD92D2157
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgLHDPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLHDPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:15:34 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC8C061749;
        Mon,  7 Dec 2020 19:14:53 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id w135so9264625ybg.13;
        Mon, 07 Dec 2020 19:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ekn60A31SGelEz2vp8jrpCctkA4cbgDSZHs8+qB+Ka4=;
        b=ttDw0AeY7mrvYySu2eaccCjpXsFDh0GQdX8E8AdZXTcnATjaj/hLwuX7/hxTLmdhvH
         0AK93oCIfym5664JIOH+yRh4BIBK9I2Q/9gu+X0ipw9mapfkZa1jXIkUzNMDw5Hp1BPw
         gdFph64RUPH6u8e/impuTw1SE4C0lbMRDSxAdtx9itkb+KGlMm6nM5uWy2JKXXBvLrY5
         T/XOQnEbyq9y+jlY+1TlEWKucfQ4Aic2Ol4+ORvvSFl0YUhF3G+7favEegVRqz3kCjiz
         6osoO0zU4YrX3R929mtPwzdTgx3fV2f4Zyn/9XtNBr3rf/RAcWu4dHPLffAXZZ/FD7KP
         O2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ekn60A31SGelEz2vp8jrpCctkA4cbgDSZHs8+qB+Ka4=;
        b=riKKzydV30heOdngUgmFusEfVvxyN0D9mUQUeZTLqMTw1ELaAJ6chC+9LDojUj9f3Q
         fcVOaGSo3WeHBUzvUro5qgRhaWhLErdMo1gO1fkiaoMCqjHY1gFTA+4LryMC2VBiOBl0
         sP9Sg9D5M8AoWaG/xmC+cgFHu8Uq1BIU9ngEpE4XVxipCCKeDn2pUwCVIENiiiS9UAbu
         WTyfaMdyUqSac5Fg3qbORNOkvXVwCz7Yez553y0lHGRq2cQbIKc6khj+SIiPMM0T+3U1
         GwtwDUKCL7dn64TYkNFnIfkp0jLMj61SSfnUiPnlH8wr0hoyv18b6eZAhZiVgAhbmA/E
         FdWQ==
X-Gm-Message-State: AOAM5321Pxh5oKW6gHzCGRz6P8ZIr1WlDz+MSkeiseKSsTApPGF1W7ky
        0IQFjBKcYG+ktzCVPMvq9/ul5WEu/G7vpwxBev6zB88noiA=
X-Google-Smtp-Source: ABdhPJx1zhVX0q7c1lIXOooLR8QPJ79/E+pDwzkRiAc4wMF8U/sEa43odhXLapBSeqjbHAAdFCWoy4dJ8brCsYlEY44=
X-Received: by 2002:a25:eb0f:: with SMTP id d15mr13395997ybs.425.1607397293136;
 Mon, 07 Dec 2020 19:14:53 -0800 (PST)
MIME-Version: 1.0
References: <20201207052057.397223-1-saeed@kernel.org>
In-Reply-To: <20201207052057.397223-1-saeed@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 19:14:42 -0800
Message-ID: <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 6, 2020 at 9:21 PM <saeed@kernel.org> wrote:
>
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> While playing with BTF for modules, i noticed that executing the command:
> $ bpftool btf dump id <module's btf id>
>
> Fails due to lack of information in the BTF data.
>
> Maybe I am missing a step but actually adding the support for this is
> very simple.

yes, bpftool takes -B <path> argument for specifying base BTF. So if
you added -B /sys/kernel/btf/vmlinux, it should have worked. I've
added auto-detection logic for the case of `btf dump file
/sys/kernel/btf/<module>` (see [0]), and we can also add it for when
ID corresponds to a module BTF. But I think it's simplest to re-use
the logic and just open /sys/kernel/btf/vmlinux, instead of adding
narrowly-focused libbpf API for that.

>
> To completely parse modules BTF data, we need the vmlinux BTF as their
> "base btf", which can be easily found by iterating through the btf ids and
> looking for btf.name == "vmlinux".
>
> I am not sure why this hasn't been added by the original patchset

because I never though of dumping module BTF by id, given there is
nicely named /sys/kernel/btf/<module> :)

> "Integrate kernel module BTF support", as adding the support for
> this is very trivial. Unless i am missing something, CCing Andrii..
>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> CC: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/btf.c      | 57 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/btf.h      |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 60 insertions(+)
>

[...]
