Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B269C48CFC3
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiAMAn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:43:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56106 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiAMAn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:43:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46CBC61BAA;
        Thu, 13 Jan 2022 00:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3633C36AF2;
        Thu, 13 Jan 2022 00:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642034636;
        bh=yAx1h+9noqod81ewSCFu8y3UVuCXM1L6HjeQ3KdgKUA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OKt+oK0K9iJai6rJsDjNn0MInVgSlkp6ZXfLxS+BTsebPfds4WcHNlAth7/CgGx5W
         +bYW0fMvtMSMLtAveq5orCuwNBQKy8RdOMzKGyFCzpE7qsIv36xXg1PVuhXb8hfcHo
         kfT+ePjG3UyqxW4Z+UPipSEHz6qSUGiD6hTlHkueFdcc5Y01rDfRPPS8vYFvufICih
         A3WbbOVixORPVKpfqZ3fteg7badtttzALhXLPc8VQ5afG6bS5Kiozh8MggJsFpJ+Jv
         5Pa2BFKSaJ41DPDJGk4yIFyRpmW3kwr1+SZA9Ob9AqVIBSFjMKIUKnbDBkydNTyftz
         ZDn3QnOlVtqpA==
Received: by mail-yb1-f174.google.com with SMTP id p187so10603240ybc.0;
        Wed, 12 Jan 2022 16:43:56 -0800 (PST)
X-Gm-Message-State: AOAM531h7AgVhrVrxWuZgrXRB0zfaoZ+jUTl7havyPj93NzEd4lIAYRJ
        bJAOtYaGCWNWk8UG+D576YFwTuk8FJ0oXLiId5Q=
X-Google-Smtp-Source: ABdhPJz6E0fvuhYb1SPPeYq4QlOc8xxdiKC17UxOjPy9v7eMtzN8L1pW7dz+dL/cgsDEa/+fHCYYFONeKg+R4BgBUeA=
X-Received: by 2002:a05:6902:1106:: with SMTP id o6mr3351822ybu.195.1642034635648;
 Wed, 12 Jan 2022 16:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
In-Reply-To: <20220113000650.514270-1-quic_twear@quicinc.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 12 Jan 2022 16:43:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7yCzyFy+onm2_bMHHh2Dq2xu+XRxQE+S7fLRCrVw0NFg@mail.gmail.com>
Message-ID: <CAPhsuW7yCzyFy+onm2_bMHHh2Dq2xu+XRxQE+S7fLRCrVw0NFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     Tyler Wear <quic_twear@quicinc.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 4:07 PM Tyler Wear <quic_twear@quicinc.com> wrote:
>
> Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
> Instead of adding generic function for just modifying the ds field,
> add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
> This allows other fields in the network and transport header to be
> modified in the future.
>
> Checksum API's also need to be added for completeness.
>
> It is not possible to use CGROUP_(SET|GET)SOCKOPT since
> the policy may change during runtime and would result
> in a large number of entries with wildcards.
>
> V4 patch fixes warnings and errors from checkpatch.

I don't think we need "V4 patch ..." part in the commit log.
To keep some history of patch, we can add these notes after
an "---" line, like:

Signed-off-by:
---
v4 patch ...
v3 patch ...
---
  net/core/filter.c | 12 ++++++++++++
...

With this format, git-am will remove the content between the
two "---" lines.

>
> The existing check for bpf_try_make_writable() should mean that
> skb_share_check() is not needed.
>
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>  net/core/filter.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6102f093d59a..f30d939cb4cf 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7299,6 +7299,18 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_sk_storage_delete_proto;
>         case BPF_FUNC_perf_event_output:
>                 return &bpf_skb_event_output_proto;
> +       case BPF_FUNC_skb_store_bytes:
> +               return &bpf_skb_store_bytes_proto;
> +       case BPF_FUNC_csum_update:
> +               return &bpf_csum_update_proto;
> +       case BPF_FUNC_csum_level:
> +               return &bpf_csum_level_proto;
> +       case BPF_FUNC_l3_csum_replace:
> +               return &bpf_l3_csum_replace_proto;
> +       case BPF_FUNC_l4_csum_replace:
> +               return &bpf_l4_csum_replace_proto;
> +       case BPF_FUNC_csum_diff:
> +               return &bpf_csum_diff_proto;
>  #ifdef CONFIG_SOCK_CGROUP_DATA
>         case BPF_FUNC_skb_cgroup_id:
>                 return &bpf_skb_cgroup_id_proto;
> --
> 2.25.1
>
