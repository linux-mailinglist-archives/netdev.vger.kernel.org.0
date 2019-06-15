Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEDA4728B
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 01:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFOXf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 19:35:26 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43578 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFOXf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 19:35:26 -0400
Received: by mail-lf1-f67.google.com with SMTP id j29so4043633lfk.10;
        Sat, 15 Jun 2019 16:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KS7GuZ58mSVlo/UODgh9jqmMf1OWtYb0tsfUawgjzv0=;
        b=kTa6Q1QCI0Z4J8clCy8W10U1qXnkVuz4ZUetAJzr9tOFDdUCtJgf1TZvTXaOhVifST
         XIO+44juUdU6UM3Mb0q9iPoE6toh8N+AsYNnqw9IyIoT6y0V87VKoU4goEzWN1bpVhNp
         +ySQbBGvUV8CCVqPll0dIzv7wHSa3AuMh3wcWoatXGrSTAmRXcTokhzqydb+P07Xbgq+
         3yw3x1yJ2xzAsnZ1Izsn93GmVkb9nIhI07WF6/h1ebntwXzvqu3dlnCF3eTwCKenZxPJ
         yE0RXe0ipeSn8rIG1kx1J4gprdRloCCF7/oivl6GgJRalrTlElOtwD3OnLnnNYeDVGyu
         7eMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KS7GuZ58mSVlo/UODgh9jqmMf1OWtYb0tsfUawgjzv0=;
        b=rBVtBRwOvtsRsR9Jeat9XuP7YTrYJGLpiWFQ/Br9FPVBTt2pJvorDNgSs/8m/5peU9
         KwaDkU6++VvjoHip8UxKrbyCZxGB6THEklyUTjg/z+6KA3y8EeeFx62IqKUspUB0ruZj
         vFlAqmDUm0zLbBlR+SDfIMhNMzE5xTIZgawhMCEguUGD7RcGvygZJyjvbinruiyMFpL/
         zYOCHzgPvmYN0M6rnywVCq51srxVQt0DNZr1J8mhuEOHcireqcwuwc4nBjUvAWHfatQ8
         kKCm0MMyz0SXUe02l4TbCnQ9gjo4otK/xyNRGyNlDRD2O07QF4lWbd93jgIt86tVWVNn
         PeaQ==
X-Gm-Message-State: APjAAAWErvZ/3VDjGSgT/FdjMA6GP9q/6ZgRe738xYFX77DlilLQhUEb
        aGsaza+V3hbcIFXZ2PYUhZT/AIdWs7U8o5cdX30=
X-Google-Smtp-Source: APXvYqzW2dUVula1K7et209n0mipZpMAmmBz3Lu+mizcU6RAUMBmVfosL1aqmHc0+Sggr7kEypD567DCGrb8gToZpIU=
X-Received: by 2002:ac2:4252:: with SMTP id m18mr26605642lfl.100.1560641724078;
 Sat, 15 Jun 2019 16:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190611215304.28831-1-mmullins@fb.com>
In-Reply-To: <20190611215304.28831-1-mmullins@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 15 Jun 2019 16:35:12 -0700
Message-ID: <CAADnVQ+tPkiuYHPAE28OP3BDRgM+JY5DpTLiFP1iUn9fXhCjYQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: fix nested bpf tracepoints with per-cpu data
To:     Matt Mullins <mmullins@fb.com>
Cc:     Andrew Hall <hall@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 2:54 PM Matt Mullins <mmullins@fb.com> wrote:
>
> BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
> they do not increment bpf_prog_active while executing.
>
> This enables three levels of nesting, to support
>   - a kprobe or raw tp or perf event,
>   - another one of the above that irq context happens to call, and
>   - another one in nmi context
> (at most one of which may be a kprobe or perf event).
>
> Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
> Signed-off-by: Matt Mullins <mmullins@fb.com>

Applied. Thanks
