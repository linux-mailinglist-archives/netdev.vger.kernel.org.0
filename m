Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC5C94D7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfJBX3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:29:52 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39474 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfJBX3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:29:51 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so493679qki.6;
        Wed, 02 Oct 2019 16:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=px76N5Ygyt1+IaPaI8lPcGpZkxeisLsbA6YBoyUGZsk=;
        b=kpc6N+43kHEhQsTbxUhs1VlXqZ/4llzRMyDhVnOUlpAkjcuvRyrD3CjG/lbI3Dktgw
         O07IgARrj4egPxvsrn6bJTr8MOOXXRvvHr/KgSgTTj7jVJTabWuYFVCGDM4FpcUuItJN
         JnIh77eBrBBHgmYPtggm9jT6MSii32eedAhVNi/HJSZB+JO8kVEAF71uhfyJwA+X8M5v
         6HsZnHnSrMISDX/0znO1VAG3cE0gzxKSvyfQKEPccnHY8Qqny1wV3ZQbRbOAyGpnB7qw
         eaX5d1OLznV8uLf0exSpqJtE1Yzm0mb36buAWekadlwFTO5aj7YSRoFFJyxW5Ct+mRoI
         bIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=px76N5Ygyt1+IaPaI8lPcGpZkxeisLsbA6YBoyUGZsk=;
        b=a1TfU7kgwOv1pU5hRZIJOSqRDyGmZDxajH7QNPD436Xenl2eRtCssvk0yzspz1rb5U
         vPizF/zDpsfPDrgYNe5p9PEEIOPZDOe44NtSjlhwrIyd0QK803lGiK+LCY7sbZWyGTDw
         KRsHPQBPwEQd0PCqIwURD3YARF7MwCPp2RiJb/HAjtOfnp5e6MT5nIz2sHXmPJw82rLn
         dCI31Lgd1YzBQ7045M3b2IKqjW5TAp/oTkqHm6nrYdJlwzghinJyfM9uikno/LtdOzjB
         4+nNRkHMkxp7pcw0V62xLmhsAWZZy6IXNn6LN5YxbrjsFIIoisxIQQqFgsd5JUKrnh71
         qhVw==
X-Gm-Message-State: APjAAAWGplOT1sZ+QTCa9GPGZWKkG0we5zIezuRAKVSkn38Qt21JyShx
        Kmh1pemC1jKOsRQDm7ggle7Oh1BbgRDsSFU55XE=
X-Google-Smtp-Source: APXvYqyHFJy8nYfCoKUjZpUzSzmYzsMlShEropZlNJ4z2f11vlFDW5/mLSDeK/ebISRMUSZO8n1lT7SO8CF3/OUIM4o=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr1479110qkb.437.1570058990712;
 Wed, 02 Oct 2019 16:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191002173357.253643-1-sdf@google.com> <20191002173357.253643-2-sdf@google.com>
In-Reply-To: <20191002173357.253643-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Oct 2019 16:29:39 -0700
Message-ID: <CAEf4BzZuEChOL828F91wLxUr3h2yfAkZvhsyoSx18uSFSxOtqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 10:35 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Always use init_net flow dissector BPF program if it's attached and fall
> back to the per-net namespace one. Also, deny installing new programs if
> there is already one attached to the root namespace.
> Users can still detach their BPF programs, but can't attach any
> new ones (-EPERM).
>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  Documentation/bpf/prog_flow_dissector.rst |  3 +++
>  net/core/flow_dissector.c                 | 11 ++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> index a78bf036cadd..4d86780ab0f1 100644
> --- a/Documentation/bpf/prog_flow_dissector.rst
> +++ b/Documentation/bpf/prog_flow_dissector.rst
> @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
>  C-based implementation can export. Notable example is single VLAN (802.1Q)
>  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
>  for a set of information that's currently can be exported from the BPF context.
> +
> +When BPF flow dissector is attached to the root network namespace (machine-wide
> +policy), users can't override it in their child network namespaces.
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 7c09d87d3269..494e2016fe84 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
>         struct bpf_prog *attached;
>         struct net *net;
>
> +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> +               /* Can't override root flow dissector program */
> +               return -EPERM;
> +       }

This is racy, shouldn't this be checked after grabbing a lock below?

> +
>         net = current->nsproxy->net_ns;
>         mutex_lock(&flow_dissector_mutex);
>         attached = rcu_dereference_protected(net->flow_dissector_prog,
> @@ -910,7 +915,11 @@ bool __skb_flow_dissect(const struct net *net,
>         WARN_ON_ONCE(!net);
>         if (net) {
>                 rcu_read_lock();
> -               attached = rcu_dereference(net->flow_dissector_prog);
> +               attached =
> +                       rcu_dereference(init_net.flow_dissector_prog);
> +
> +               if (!attached)
> +                       attached = rcu_dereference(net->flow_dissector_prog);
>
>                 if (attached) {
>                         struct bpf_flow_keys flow_keys;
> --
> 2.23.0.444.g18eeb5a265-goog
>
