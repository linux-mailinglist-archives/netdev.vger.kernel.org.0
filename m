Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C52351AC7
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhDASDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236544AbhDAR57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 13:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 218C66138B;
        Thu,  1 Apr 2021 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617295267;
        bh=Q4nUlg0ojVJGwCUl3O+CfLyq7kNu0aIIv7SoaXSZg80=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NZhkX8UDJ9Uq+jntCBvwepPQ9I4QMYXsXPLrVzQdBZa4v1Uv+J3AuuY2WUfkxbYko
         fhUV5IpKYGqOPmvgw0c8c3/Ran1B0/QSd2/6BFCSrMnjVKQX84CAQ3jECoJXnURnpr
         j0QL0VR3aDRxlYgtxagS681yDlXLATRtN6lNjlAmEwbriZfrGuSeFYqvpxfxYLgVXI
         7cSG6FUCdk9JUj1N6PX2MaRa0gzcf6JB86ZAp4ewyoMrJKoM2r8HCG9rjg7jN0M+rv
         EYH816XXgsIbw+FarFG5UC5yEEy/AqeiuYv1PnUKM3rwwRcvFt/YnWWDcaK4/2sFGS
         01CDXMWbkz/fg==
Received: by mail-lj1-f173.google.com with SMTP id u4so2938400ljo.6;
        Thu, 01 Apr 2021 09:41:07 -0700 (PDT)
X-Gm-Message-State: AOAM531ANvbcCnW+19oeL/JUppbP2al9iIiVv9rpb/GP6DkmGLE8AsBz
        eeiH4M5can2LuV65KR/fyAIXEtdYXPEkcWR5qp8=
X-Google-Smtp-Source: ABdhPJwMkQWLebv25U3vuHVMSmx0mnJPw54Z+BzLX41dITc/Gb9WjRJZ9BCfKBDwUBT1V5Hf8glA1bnl0LZTAcRUONs=
X-Received: by 2002:a2e:bba1:: with SMTP id y33mr6001094lje.506.1617295265496;
 Thu, 01 Apr 2021 09:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
In-Reply-To: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 1 Apr 2021 09:40:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
Message-ID: <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 1:57 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen.
>
> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
>
> bpf-next: ~2.2Mpps
> bpf-next + cpumap skb-list: ~3.15Mpps
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  kernel/bpf/cpumap.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 0cf2791d5099..b33114ce2e2b 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -257,6 +257,7 @@ static int cpu_map_kthread_run(void *data)
>                 void *frames[CPUMAP_BATCH];
>                 void *skbs[CPUMAP_BATCH];
>                 int i, n, m, nframes;
> +               LIST_HEAD(list);
>
>                 /* Release CPU reschedule checks */
>                 if (__ptr_ring_empty(rcpu->queue)) {
> @@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
>                 for (i = 0; i < nframes; i++) {
>                         struct xdp_frame *xdpf = frames[i];
>                         struct sk_buff *skb = skbs[i];
> -                       int ret;
>
>                         skb = __xdp_build_skb_from_frame(xdpf, skb,
>                                                          xdpf->dev_rx);
> @@ -314,11 +314,10 @@ static int cpu_map_kthread_run(void *data)
>                                 continue;
>                         }
>
> -                       /* Inject into network stack */
> -                       ret = netif_receive_skb_core(skb);
> -                       if (ret == NET_RX_DROP)
> -                               drops++;

I guess we stop tracking "drops" with this patch?

Thanks,
Song

> +                       list_add_tail(&skb->list, &list);
>                 }
> +               netif_receive_skb_list(&list);
> +
>                 /* Feedback loop via tracepoint */
>                 trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);
>
> --
> 2.30.2
>
