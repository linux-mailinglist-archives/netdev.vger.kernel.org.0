Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECB713762F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgAJSj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:39:27 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40232 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgAJSj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:39:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id u1so3134022ljk.7;
        Fri, 10 Jan 2020 10:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8BBayz11KI8jrry4YeUfuKszWxU2ZCu2ty4ubcQMKc=;
        b=ucfkJtRQxca15g7uqz6oTV8SD3ZikcZi0pHSGqUO9AYRBpJYz4tenZeFI78S/CG/hr
         pgCk2VgUvv1XPQ41sYwGyWHwRPgwFC9q4XZsTIDESoILDtXPhVB/V70niekIIPDRQs0l
         lbZZwDv9mzMPYndptc1XLP3n5yIZa3xjvs87z0C2P1HoeNGRfHCXhtbEuXLAM36HILbz
         LHxwWj3u2qBoHXMfrKWAPFq61IuSmZOcAbCSksVbFJkJezxZhFyRmyyEZ+pPJfNi53Ub
         nhHQv4Mjr3KFo2JiKu2NdwV3rFMj8DkxpzHR/LIgCSMLmNqtpgKjrdaSCNGhtCpgbD8O
         uvFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8BBayz11KI8jrry4YeUfuKszWxU2ZCu2ty4ubcQMKc=;
        b=lQ4wZO+TLsVhY8G5bf/vrGxf8fP2sYkjb1Z71pFQoYWkrVZ3xg1c6Jwe3V/hCWfY+i
         6VnRi7Mc58XQU0U5mqUWpqJFD2VXuVnb1/6kPJVdsnXkF1UX/Fmx9Ay/FWbGmvd985yR
         J8tQYnjbGj6SZ77j9ff93yfZEewyE6w4h0zWwzyCfOYVx1oUul49RGR9E6hihg+8nZT9
         3hHEww2yHWPTjVN64DPDyfdsvcGOEf9VHpGOML5+lCr7zPXdQtwT0yUCm11YkftOTQ7Y
         WGNrwNNj6GXS4V1+rpzKg6AMOHzxoT55qMLtc/06gWKRxboZ6ACLv4e71SGMwEjpLUYt
         TIzQ==
X-Gm-Message-State: APjAAAUQiBavuxxcqs5fi/glTcDorp4K3DxXD/bz7mSOCvSQ3QhZE1Gf
        Pt2PG+fpfiy7EgDgqQ5wdsFY4RIAzGnQbvjCSNA=
X-Google-Smtp-Source: APXvYqxGo2q3u3oNVdCae+dyEq31/bbKT2GgpClN+7idaT2rzmOpoFdU9QWCGxCKfyK5xCB6L4CZ4raKXpdSF87Ios8=
X-Received: by 2002:a2e:990e:: with SMTP id v14mr3442515lji.23.1578681564719;
 Fri, 10 Jan 2020 10:39:24 -0800 (PST)
MIME-Version: 1.0
References: <20200110181916.271446-1-andriin@fb.com>
In-Reply-To: <20200110181916.271446-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Jan 2020 10:39:13 -0800
Message-ID: <CAADnVQLzN_N4fuGG2f73D1NtAV3YM1q6-Fea-6c4hVT-dYDH-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: poison kernel-only integer types
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 10:19 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> It's been a recurring issue with types like u32 slipping into libbpf source
> code accidentally. This is not detected during builds inside kernel source
> tree, but becomes a compilation error in libbpf's Github repo. Libbpf is
> supposed to use only __{s,u}{8,16,32,64} typedefs, so poison {s,u}{8,16,32,64}
> explicitly in every .c file. Doing that in a bit more centralized way, e.g.,
> inside libbpf_internal.h breaks selftests, which are both using kernel u32 and
> libbpf_internal.h.
>
> This patch also fixes a new u32 occurence in libbpf.c, added recently.
>
> Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
