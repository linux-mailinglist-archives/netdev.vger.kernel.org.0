Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5646B5F5F71
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiJFDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiJFDTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:19:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A1BCE8;
        Wed,  5 Oct 2022 20:19:35 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id 13so1736148ejn.3;
        Wed, 05 Oct 2022 20:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gi46Dxvd3NKLvpnyhXruCNmArfyvHaSxBHBnMHTR9wM=;
        b=aGuHqvZM294GE4QMXynQ7OrMXZZm22xip6ChJmYgtC8mZDxjJaDWrTyKczptarfao0
         pJFYssm1fE/18CqeCWMHJx7EBKdgL5zrvnVQZMF0ozqFoKDDzyb9IRz2QzKKqqrC9RoZ
         F5HKYFTwt+luCNZ2g/AE7sb53735XIGKCx7A2nfuh5fRb8rRBEZo1E82Fp+mt4z4Dpe4
         nPGIpl4nIL81OK36AtjX9JpRU9ZXqGhCfL+6tUUbwOqXjTz4en3loIvT7mbpzyGAFoW/
         +74gPCj027BCt9L+LBY3YRsYvdJDcZfDSeJiiGxdNoqtn+AaLtjv5jVzTcJs8X/+fZdW
         sEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gi46Dxvd3NKLvpnyhXruCNmArfyvHaSxBHBnMHTR9wM=;
        b=5yXwC3G7PZfpjxBMF7Ok1le6hAejraQ7JOSNaHfEDm7ki4MOAgUcB50kAb5vI70qfy
         hPSTyZ44dE0mplB0kR4V3R+kpP7r873qojP4VoWSX2iyvAc2BUI3rbigydETT2vJh4pg
         8OKBiJW6RI5XHCL/H+2Ht4asVAe6CZwDP7iOduXlgK3wYv4LZu6azVFnlLOkOh+SjX5q
         XqWw87RzQPM5teT2Ed4IRO6h0YJIVnVgziiHQzz54O1UJ6z+1RxBdVjHVXJ0KRYJYxRE
         0Xz1X25/gGe2o7HHSLOePIaRJIsLo3xtA2peHM8ipaliwHyM/bAuFpblXJGRNeh9SWH4
         tinQ==
X-Gm-Message-State: ACrzQf1E18c+8WutqBTt6+rphEXlq1WUKqk0b9DH148Yqd4Bf7hO9dt0
        by0vmKoe+1GLeBwngd7RACWwW2dZz0DbjHp4DS0=
X-Google-Smtp-Source: AMsMyM6MSu1YUq1vWpow2HLZ02+u6ksA7nyRMpoot6cu/6NyVY7bjUAImYG2WBRXdUZRqcroWUo9UF5RKywacjaRaI0=
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id
 du1-20020a17090772c100b0078334ce87b9mr2185118ejc.115.1665026373985; Wed, 05
 Oct 2022 20:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-3-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-3-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 20:19:20 -0700
Message-ID: <CAEf4Bzak_v01v5Y6dNT_1KAcax_hvVqZM4o+d_w5OJSWeLJz2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] bpf: Implement BPF link handling for tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This work adds BPF links for tc. As a recap, a BPF link represents the attachment
> of a BPF program to a BPF hook point. The BPF link holds a single reference to
> keep BPF program alive. Moreover, hook points do not reference a BPF link, only
> the application's fd or pinning does. A BPF link holds meta-data specific to
> attachment and implements operations for link creation, (atomic) BPF program
> update, detachment and introspection.
>
> The motivation for BPF links for tc BPF programs is multi-fold, for example:
>
> - "It's especially important for applications that are deployed fleet-wide
>    and that don't "control" hosts they are deployed to. If such application
>    crashes and no one notices and does anything about that, BPF program will
>    keep running draining resources or even just, say, dropping packets. We
>    at FB had outages due to such permanent BPF attachment semantics. With
>    fd-based BPF link we are getting a framework, which allows safe, auto-
>    detachable behavior by default, unless application explicitly opts in by
>    pinning the BPF link." [0]
>
> -  From Cilium-side the tc BPF programs we attach to host-facing veth devices
>    and phys devices build the core datapath for Kubernetes Pods, and they
>    implement forwarding, load-balancing, policy, EDT-management, etc, within
>    BPF. Currently there is no concept of 'safe' ownership, e.g. we've recently
>    experienced hard-to-debug issues in a user's staging environment where
>    another Kubernetes application using tc BPF attached to the same prio/handle
>    of cls_bpf, wiping all Cilium-based BPF programs from underneath it. The
>    goal is to establish a clear/safe ownership model via links which cannot
>    accidentally be overridden. [1]
>
> BPF links for tc can co-exist with non-link attachments, and the semantics are
> in line also with XDP links: BPF links cannot replace other BPF links, BPF
> links cannot replace non-BPF links, non-BPF links cannot replace BPF links and
> lastly only non-BPF links can replace non-BPF links. In case of Cilium, this
> would solve mentioned issue of safe ownership model as 3rd party applications
> would not be able to accidentally wipe Cilium programs, even if they are not
> BPF link aware.
>
> Earlier attempts [2] have tried to integrate BPF links into core tc machinery
> to solve cls_bpf, which has been intrusive to the generic tc kernel API with
> extensions only specific to cls_bpf and suboptimal/complex since cls_bpf could
> be wiped from the qdisc also. Locking a tc BPF program in place this way, is
> getting into layering hacks given the two object models are vastly different.
> We chose to implement a prerequisite of the fd-based tc BPF attach API, so
> that the BPF link implementation fits in naturally similar to other link types
> which are fd-based and without the need for changing core tc internal APIs.
>
> BPF programs for tc can then be successively migrated from cls_bpf to the new
> tc BPF link without needing to change the program's source code, just the BPF
> loader mechanics for attaching.
>
>   [0] https://lore.kernel.org/bpf/CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com/
>   [1] https://lpc.events/event/16/contributions/1353/
>   [2] https://lore.kernel.org/bpf/20210604063116.234316-1-memxor@gmail.com/
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

have you considered supporting BPF cookie from the outset? It should
be trivial if you remove union from bpf_prog_array_item. If not, then
we should reject LINK_CREATE if bpf_cookie is non-zero.

>  include/linux/bpf.h            |   5 +-
>  include/net/xtc.h              |  14 ++++
>  include/uapi/linux/bpf.h       |   5 ++
>  kernel/bpf/net.c               | 116 ++++++++++++++++++++++++++++++---
>  kernel/bpf/syscall.c           |   3 +
>  tools/include/uapi/linux/bpf.h |   5 ++
>  6 files changed, 139 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 71e5f43db378..226a74f65704 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1473,7 +1473,10 @@ struct bpf_prog_array_item {
>         union {
>                 struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>                 u64 bpf_cookie;
> -               u32 bpf_priority;
> +               struct {
> +                       u32 bpf_priority;
> +                       u32 bpf_id;

this is link_id, is that right? should we name it as such?

> +               };
>         };
>  };
>

[...]

> diff --git a/kernel/bpf/net.c b/kernel/bpf/net.c
> index ab9a9dee615b..22b7a9b05483 100644
> --- a/kernel/bpf/net.c
> +++ b/kernel/bpf/net.c
> @@ -8,7 +8,7 @@
>  #include <net/xtc.h>
>
>  static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
> -                            struct bpf_prog *nprog, u32 prio, u32 flags)
> +                            u32 id, struct bpf_prog *nprog, u32 prio, u32 flags)

similarly here, id -> link_id or something like that, it's quite
confusing what kind of ID it is otherwise

>  {
>         struct bpf_prog_array_item *item, *tmp;
>         struct xtc_entry *entry, *peer;
> @@ -27,10 +27,13 @@ static int __xtc_prog_attach(struct net_device *dev, bool ingress, u32 limit,
>                 if (!oprog)
>                         break;
>                 if (item->bpf_priority == prio) {
> -                       if (flags & BPF_F_REPLACE) {
> +                       if (item->bpf_id == id &&
> +                           (flags & BPF_F_REPLACE)) {

[...]
