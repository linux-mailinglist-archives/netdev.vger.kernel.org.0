Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E053A335B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFJSlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhFJSlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:41:05 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585AEC0617A8;
        Thu, 10 Jun 2021 11:39:08 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a1so4707955lfr.12;
        Thu, 10 Jun 2021 11:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nE5V0361lJGgCdwlFos44U3eitBmblPsO6nM+FoDnC8=;
        b=USIhsgIapgtE4uiwFOmNcEABgHo/lqw4uiqARcpo2NCn4Xki2YfXyOzg2SS6yaRuLD
         qDTpS2jb88LuPHe0UoRIs0iWrmcq8jjorzlHhe2swD7lHGpaWeOnZMHYXiyozj4+cOXY
         ySEMFBdFGBu9kKz5ppCUuWRsYkp9VIe4/SEVy5aiGQjYa3RLOYYDQYO83cTWZHgFkDrT
         OXxR5EYjRdsITS3o6m6QS4ixg8DHwu4lpQclIx7kWmKQjWpZku0v7t7cRFvcwGnzT1PC
         cX5gKpmQBVb6iwLKq2mOOBxO7qixVD7BetJua5t7WITZy4qGuFISiq7lLEmtv9e4Jah+
         Th1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nE5V0361lJGgCdwlFos44U3eitBmblPsO6nM+FoDnC8=;
        b=phR325uc0A/ZQr4R483jYy0g9A3osCmxZ186eHDsdkgrSCuM92lddL8OU9PQ53YIdk
         85fjcUHF2xWenDDfspkJU6s07qb1djI1e3KAtt3UZGJoRDu1Owuh8IZ01O93ClAJ7F2a
         eTq8HirKRCV/sdSmB3s4RbMMILb7nape6l5SXQilkGNX0PEKd2eP62TkulpnTSmX/N4k
         raLAIQ8jdT+n9xDJ/kuItKNumzxpHzlRSS3/fAA2k6RLLp7x5aN+0ICwyZaoVABxqSCJ
         Gk30j5vB5Y+zaIG1xvJbIPyOoqCTVQ8vrNlBkiVDNhYBCm4T1OeRYXzhHXTcbROc+eAf
         G+SA==
X-Gm-Message-State: AOAM5331+LIJzillCBrYSPfTj3lde4b6ocIPKUnDBNgly9qiEBhhh04W
        82YcAm7EsmJKwUJjoqbGFXF5Zk7XCBi/UDiIFok=
X-Google-Smtp-Source: ABdhPJzx0sLcryTM/UgXpz0Bq1YgTXvSzvpPqDE9jLakOHemD8iucRorJiHPQAsAG3o092yxlpdfJs6G+OcKPmxuX6c=
X-Received: by 2002:ac2:5551:: with SMTP id l17mr132123lfk.534.1623350346588;
 Thu, 10 Jun 2021 11:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210609103326.278782-1-toke@redhat.com> <20210609103326.278782-3-toke@redhat.com>
In-Reply-To: <20210609103326.278782-3-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Jun 2021 11:38:55 -0700
Message-ID: <CAADnVQJrETg1NsqBv2HE06tra=q5K8f1US8tGuHqc_FDMKR6XQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: allow RCU-protected lookups to happen
 from bh context
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 7:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> XDP programs are called from a NAPI poll context, which means the RCU
> reference liveness is ensured by local_bh_disable(). Add
> rcu_read_lock_bh_held() as a condition to the RCU checks for map lookups =
so
> lockdep understands that the dereferences are safe from inside *either* a=
n
> rcu_read_lock() section *or* a local_bh_disable() section. This is done i=
n
> preparation for removing the redundant rcu_read_lock()s from the drivers.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  kernel/bpf/hashtab.c  | 21 ++++++++++++++-------
>  kernel/bpf/helpers.c  |  6 +++---
>  kernel/bpf/lpm_trie.c |  6 ++++--
>  3 files changed, 21 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 6f6681b07364..72c58cc516a3 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -596,7 +596,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *m=
ap, void *key)
>         struct htab_elem *l;
>         u32 hash, key_size;
>
> -       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held()=
);
> +       WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held()=
 &&
> +                    !rcu_read_lock_bh_held());

It's not clear to me whether rcu_read_lock_held() is still needed.
All comments sound like rcu_read_lock_bh_held() is a superset of rcu
that includes bh.
But reading rcu source code it looks like RCU_BH is its own rcu flavor...
which is confusing.
