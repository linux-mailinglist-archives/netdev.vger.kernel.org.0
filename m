Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EC126CBF2
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgIPUhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgIPRKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:10:15 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62574C061223;
        Wed, 16 Sep 2020 10:08:25 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id g96so1070143ybi.12;
        Wed, 16 Sep 2020 10:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7ptBkp4xdHHe4seAGHtrtcjPEqw5vfXo8/OjJOz+4vo=;
        b=tyUNudrabayD3JwPEmQY4XYb0Z9um6wyD1MuAVIUGdE2zXPnviLL06emxcGClGBFsC
         O/TaIxxK1iR/HUrbYWAxV1qIZsydniT4HHKNs8cGb2DIRgngIolIhLzN92SpM6JLhpfs
         7v8jHz8Rh+N60BTTLdUj5s+tMkeiA8gujqUEv9Khx+yc4+ES8z33Z84M2khAEENA6ox+
         Uz3GBBYSlUKMgS6peddac3bMQcAoT9pbafdY6WfHTOZruGOobTj/2s5aCiz/Iitl7T7c
         1O7oGjG2yWDi/iaRrVvJ+08xrQ30ZAMuJZVUdSoXZUHc6RKX+E4pREep6h65hBJk2G1x
         PG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7ptBkp4xdHHe4seAGHtrtcjPEqw5vfXo8/OjJOz+4vo=;
        b=l39KEyTW8su38UbkZYY2BLO8KqHGYvP/nf1mb+X0n8mjod4orKU2GSSrI8tAaHQJrR
         t3zn1YGUv47fQsy/YLMjmwOa7ykQwYGiNIgp4ZQL1ZcZKGc7k6AmFANNG9ctOWno9QPy
         X4+vFkspd9pLxKs64ug9BlGk/aO8sZseL7qv2yB3CF3hEUiVL/KF70lHFWTxDNYLHY9f
         q9T4+D6PDH9zbxrw+icCXVv/BYrBXNj0xfOeSKtmPXsX7+tHOsqqhOAYtHpHP+Vvfp5S
         YOUoDoGuR7o2D+3zJOcKtBLLZMcH/bXEV0lLS3PXSVwF/IaoKAO2HvLXoKc1hUiOTUoB
         0cIQ==
X-Gm-Message-State: AOAM531lfidvezxhSBWTMpPXDukSubeHYrOnG1TOIk8mvR4ap5/M6mB1
        9Ez/VBu2eXziwe3XBJ2xL2ViwEougmysU1T1w9Y=
X-Google-Smtp-Source: ABdhPJxmcqGA5X1/GtJsWgz5/0S5cv1fNPTsbWnNm703TSNTsYGTekLKYo4nvUaIK9ZB3yTlZeGClthDD0+1eMf1DN4=
X-Received: by 2002:a25:33c4:: with SMTP id z187mr21570384ybz.27.1600276104518;
 Wed, 16 Sep 2020 10:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017005805.98230.16775816864129373411.stgit@toke.dk>
In-Reply-To: <160017005805.98230.16775816864129373411.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 10:08:13 -0700
Message-ID: <CAEf4BzaE7PzKw8nEesraKZRmK9oDSV-Ei=8v1fRH3Mf22zHgsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: change logging calls from verbose()
 to bpf_log() and use log pointer
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> In preparation for moving code around, change a bunch of references to
> env->log (and the verbose() logging helper) to use bpf_log() and a direct
> pointer to struct bpf_verifier_log. While we're touching the function
> signature, mark the 'prog' argument to bpf_check_type_match() as const.
>
> Also enhance the bpf_verifier_log_needed() check to handle NULL pointers
> for the log struct so we can re-use the code with logging disabled.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Ok, let's get this out of the way :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h          |    2 +-
>  include/linux/bpf_verifier.h |    5 +++-
>  kernel/bpf/btf.c             |    6 +++--
>  kernel/bpf/verifier.c        |   48 +++++++++++++++++++++---------------=
------
>  4 files changed, 31 insertions(+), 30 deletions(-)
>

[...]
