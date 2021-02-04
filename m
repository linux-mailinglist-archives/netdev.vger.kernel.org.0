Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9C830EC8D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhBDGiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhBDGiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 01:38:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A71D364E31;
        Thu,  4 Feb 2021 06:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612420640;
        bh=rr0vW6pTGISMmHI5KV2Xij6A6QnUmMJXU/yXHNMHaTg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a8QTW6B1BdT927mVxoUAfqMknKsQh9IFm/Gk0tIjjaPf2MwC1LGAE2DsgXCAGlPG0
         uEDFAfZa9Ga1244a3GnNDSDBpPnIqkPukD/EQA9Eh2Dr0kqeo5cYHkofz3+/UcHjrG
         wwlXplF0ouex5MOFj/4NYQyOpXt+/v3q1C4yEAFlIEod+f8ZqAl76/+5zG+M/A/51m
         B0Ko1O9EymxKFuIRYuefBu8dENER7axR7MWbKO+UskfGAjdNRGTXTmV1XRE3FaWHC3
         aQLqGAmCo692dUfdFO6yTKYWj18tXdarido4jn/6symddi04oKm+Qc23Jm9Fn8JryK
         Zn3DjKnKwjPWg==
Received: by mail-lj1-f174.google.com with SMTP id e18so2027187lja.12;
        Wed, 03 Feb 2021 22:37:19 -0800 (PST)
X-Gm-Message-State: AOAM532GqBiNjg+rAbzs7CFsh7aFs/DKEGjvBIIGdv5uiT+N0XTHEOaN
        Z5wSihwTqAN3pZZBKWMxOQQLNgKnOByKai8MXMo=
X-Google-Smtp-Source: ABdhPJwo9zhXhvDT8N8/k7FD3R/AhDgLztW4q8Ex7mixrFf5PJL7/7kSQ7x6AmuS/dy9dnJpOsCRP8qWg/KrQBDHYDw=
X-Received: by 2002:a2e:918f:: with SMTP id f15mr3800925ljg.357.1612420637815;
 Wed, 03 Feb 2021 22:37:17 -0800 (PST)
MIME-Version: 1.0
References: <20210203074127.8616-1-ciara.loftus@intel.com> <20210203074127.8616-2-ciara.loftus@intel.com>
In-Reply-To: <20210203074127.8616-2-ciara.loftus@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 3 Feb 2021 22:37:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7Bat9oWw_3_TRgUzc7y61kUtTDYT9-4r2ZaOW7WTZ59g@mail.gmail.com>
Message-ID: <CAPhsuW7Bat9oWw_3_TRgUzc7y61kUtTDYT9-4r2ZaOW7WTZ59g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/6] xsk: add tracepoints for packet drops
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 3, 2021 at 12:13 AM Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> This commit introduces tracing infrastructure for AF_XDP sockets
> (xsks) and a new trace event called 'xsk_packet_drop'. This trace
> event is triggered when a packet cannot be processed by the socket
> due to one of the following issues:
> (1) packet exceeds the maximum permitted size.
> (2) invalid fill descriptor address.
> (3) invalid tx descriptor field.
>
> The trace provides information about the error to the user. For
> example the size vs permitted size is provided for (1). For (2)
> and (3) the relevant descriptor fields are printed. This information
> should help a user troubleshoot packet drops by providing this extra
> level of detail which is not available through use of simple counters.
>
> The tracepoint can be enabled/disabled by toggling
> /sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  MAINTAINERS                       |  1 +
>  include/linux/bpf_trace.h         |  1 +
>  include/trace/events/xsk.h        | 73 +++++++++++++++++++++++++++++++
>  include/uapi/linux/if_xdp.h       |  6 +++
>  kernel/bpf/core.c                 |  1 +
>  net/xdp/xsk.c                     |  7 ++-
>  net/xdp/xsk_buff_pool.c           |  3 ++
>  net/xdp/xsk_queue.h               |  4 ++
>  tools/include/uapi/linux/if_xdp.h |  6 +++
>  9 files changed, 101 insertions(+), 1 deletion(-)
>  create mode 100644 include/trace/events/xsk.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1df56a32d2df..efe6662d4198 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19440,6 +19440,7 @@ S:      Maintained
>  F:     Documentation/networking/af_xdp.rst
>  F:     include/net/xdp_sock*
>  F:     include/net/xsk_buff_pool.h
> +F:     include/trace/events/xsk.h
>  F:     include/uapi/linux/if_xdp.h
>  F:     include/uapi/linux/xdp_diag.h
>  F:     include/net/netns/xdp.h
> diff --git a/include/linux/bpf_trace.h b/include/linux/bpf_trace.h
> index ddf896abcfb6..477d29b6c2c1 100644
> --- a/include/linux/bpf_trace.h
> +++ b/include/linux/bpf_trace.h
> @@ -3,5 +3,6 @@
>  #define __LINUX_BPF_TRACE_H__
>
>  #include <trace/events/xdp.h>
> +#include <trace/events/xsk.h>
>
>  #endif /* __LINUX_BPF_TRACE_H__ */
> diff --git a/include/trace/events/xsk.h b/include/trace/events/xsk.h
> new file mode 100644
> index 000000000000..e2984fad372c
> --- /dev/null
> +++ b/include/trace/events/xsk.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2021 Intel Corporation. */
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM xsk
> +
> +#if !defined(_TRACE_XSK_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_XSK_H
> +
> +#include <linux/if_xdp.h>
> +#include <linux/tracepoint.h>
> +
> +#define print_reason(reason) \
> +       __print_symbolic(reason, \
> +                       { XSK_TRACE_DROP_PKT_TOO_BIG, "packet too big" }, \
> +                       { XSK_TRACE_DROP_INVALID_FILLADDR, "invalid fill addr" }, \
> +                       { XSK_TRACE_DROP_INVALID_TXD, "invalid tx desc" })
> +
> +#define print_val1(reason) \
> +       __print_symbolic(reason, \
> +                       { XSK_TRACE_DROP_PKT_TOO_BIG, "len" }, \
> +                       { XSK_TRACE_DROP_INVALID_FILLADDR, "addr" }, \
> +                       { XSK_TRACE_DROP_INVALID_TXD, "addr" })
> +
> +#define print_val2(reason) \
> +       __print_symbolic(reason, \
> +                       { XSK_TRACE_DROP_PKT_TOO_BIG, "max" }, \
> +                       { XSK_TRACE_DROP_INVALID_FILLADDR, "not_used" }, \
> +                       { XSK_TRACE_DROP_INVALID_TXD, "len" })
> +
> +#define print_val3(reason) \
> +       __print_symbolic(reason, \
> +                       { XSK_TRACE_DROP_PKT_TOO_BIG, "not_used" }, \
> +                       { XSK_TRACE_DROP_INVALID_FILLADDR, "not_used" }, \
> +                       { XSK_TRACE_DROP_INVALID_TXD, "options" })
> +
> +
> +

nit: 3 empty lines.

> +TRACE_EVENT(xsk_packet_drop,
> +
> +       TP_PROTO(char *name, u16 queue_id, u32 reason, u64 val1, u64 val2, u64 val3),
> +
> +       TP_ARGS(name, queue_id, reason, val1, val2, val3),
> +
> +       TP_STRUCT__entry(
> +               __field(char *, name)
> +               __field(u16, queue_id)
> +               __field(u32, reason)
> +               __field(u64, val1)
> +               __field(u32, val2)
> +               __field(u32, val3)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->name = name;
> +               __entry->queue_id = queue_id;
> +               __entry->reason = reason;
> +               __entry->val1 = val1;
> +               __entry->val2 = val2;
> +               __entry->val3 = val3;
> +       ),
> +
> +       TP_printk("netdev: %s qid %u reason: %s: %s %llu %s %u %s %u",
> +                 __entry->name, __entry->queue_id, print_reason(__entry->reason),
> +                 print_val1(__entry->reason), __entry->val1,
> +                 print_val2(__entry->reason), __entry->val2,
> +                 print_val3(__entry->reason), __entry->val3
> +       )
> +);
> +
> +#endif /* _TRACE_XSK_H */
> +
> +#include <trace/define_trace.h>
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index a78a8096f4ce..d7eb031d2465 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -108,4 +108,10 @@ struct xdp_desc {
>
>  /* UMEM descriptor is __u64 */
>
> +enum xdp_trace_reasons {

xdp_trace_reasons above, vs. XSK_TRACE_ below. Is this intentional?

> +       XSK_TRACE_DROP_PKT_TOO_BIG,
> +       XSK_TRACE_DROP_INVALID_FILLADDR,
> +       XSK_TRACE_DROP_INVALID_TXD,
> +};
> +

[...]
