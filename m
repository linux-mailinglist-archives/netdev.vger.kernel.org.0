Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CF248D05A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 03:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiAMCO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 21:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiAMCOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 21:14:24 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2C7C06173F;
        Wed, 12 Jan 2022 18:14:24 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso16183697pjo.5;
        Wed, 12 Jan 2022 18:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7QL2gNNJlJxb4If1LXJwP17OE3QUsLZTPXhK4Kras7I=;
        b=NEUa9IwK+brG+aSh5xKJCnPuJ7GeO2Q3oofRaJR50U+gregBhM9JkvJvFC+fSd2MN7
         SeSKkcuZHhPifYdKjyoMOS6NnpOjBCy55IS+IBBSfEhDKvFWoar+lB0Q29khlEN4zThR
         pkYjQ1BpxqZcKViF5EXbMP7IGfrprMm5VCWupQBQ9xRddWdHuF368hK97YtNK1TSjJa0
         61E1cVDJPpWgoMhJEc27aVOSM11f3uRW5kjsLYK+hJaAkBsoItI6jzoLWXX/McJ6bs0W
         X0g6SQf7eWez0KhGM++P1nrdLEKVdnei3ldR122cMXg2jriC1ehju4zjN99gOn8MpIeZ
         7NLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7QL2gNNJlJxb4If1LXJwP17OE3QUsLZTPXhK4Kras7I=;
        b=6SYvRcAcDGHtkg92C/kNudPSfYmozsakmMm0UrdRus5oy9LjfbBnCgA3aoQkCwd42d
         YE3qXINZEmfBXlAHAgwzh8mGIOaSI9RnwC6sqyD9G9yuKEnQaELBXY8dt6s3Ot+qvOCO
         TUTuIdARCMHodCfzqhE8It9t+p0DGkTEyuZ39u6EVtaq0SgiGscfDO8qklXBdVy4vawP
         zdokcMmA7FpTfWxjXXqSmWuEufrWHD48u7LpL/vtJLSJPr8zRqGOEYTeHEhIi+wkMIF9
         q6ycRnf30HN7rNoGxeZHCCFMvGo5ExSWG/W5zFrKEUt+NxpXPT6M9X2kwY/szwP0buuk
         hqGw==
X-Gm-Message-State: AOAM531sq8S2sD5NEe1StQDpFze65BhDkfK+62+MMt1DDCsKJ355dbf0
        UZe37rMvsFZE6Z4F255KBB7CAcXagnu7tRBcFxSD2Ba5
X-Google-Smtp-Source: ABdhPJwDzt8NTj54JFQ+bcettYycl+FtKb7upt+xJJhnk7sLlN8F08tOU7UM3wSdZrhdC0wrCqW0FqjLKmbNyuZBZ88=
X-Received: by 2002:a63:1ca:: with SMTP id 193mr2063309pgb.497.1642040063948;
 Wed, 12 Jan 2022 18:14:23 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com>
In-Reply-To: <20220113000650.514270-1-quic_twear@quicinc.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jan 2022 18:14:12 -0800
Message-ID: <CAADnVQLQ=JTiJm6FTWR-ZJ5PDOpGzoFOS4uFE+bNbr=Z06hnUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 1/2] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     Tyler Wear <quic_twear@quicinc.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 5:15 PM Tyler Wear <quic_twear@quicinc.com> wrote:
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

This is wrong.
CGROUP_INET_EGRESS bpf prog cannot arbitrary change packet data.
The networking stack populated the IP header at that point.
If the prog changes it to something else it will be
confusing other layers of stack. neigh(L2) will be wrong, etc.
We can still change certain things in the packet, but not arbitrary bytes.

We cannot change the DS field directly in the packet either.
It can only be changed by changing its value in the socket.

TC layer is where packet modifications are allowed.
