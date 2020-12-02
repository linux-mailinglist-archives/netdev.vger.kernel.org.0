Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC12CC0C9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgLBP0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgLBP0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:26:38 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC24C0613CF;
        Wed,  2 Dec 2020 07:25:52 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so1161949pjg.1;
        Wed, 02 Dec 2020 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HonYG6K8yyEAJPcRbmBUz568mb+2cYoZIgvfVgtc6Zg=;
        b=OvkzNTF4jQ8jb8tj1Lr+NmzMd10zopaokeXK6ucA/bRT7iwayNa8vS5zqSyyM9+qPJ
         8S8n594EBorUAtvsqGg3x6h+9xyFLgHD/5G7An498N6ZR5SKeUQc7X4YMI/EUngzcEYP
         62VJFCg5cSuNEMRbOiZtq+9c5BzrUH520J2y9OmdW8MAg7cjFWCe7l4slXD3fFLGWE1A
         tsbFp8VYdGVu+Z/FYTKPnTxmBv1Srz3FXsmZTo5fhRSPXZX3ts+rXM+vmu5EFXrrNh+t
         tAMrPQYJ1X0/E7/0xv4unh8gLcbzsaPB68NCubz2yKzS/r4touBoEfxidouXKpGUgvgu
         S36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HonYG6K8yyEAJPcRbmBUz568mb+2cYoZIgvfVgtc6Zg=;
        b=TFiSQNUS7h//5ZJOBTUd+4CJXVugdYLC0dVbm+XEeBRa3Jk7p8GWz/54zo6rDUFdH8
         jqJvBUas0tH2CE2ILUnVqGB0ewG6LRF46BdtnEpfTkE2zzwvjJXH6JhlR+W35DZlormp
         ygGz8se8J89eYnPBDvbRqaFqSfDqLJZFPsjvj4YiQRG/Fj3umYqpd3MoGkfV3QrGtCA6
         yET/MicANDpQRp4PyjZ4YFA3cMiEmx17k+6WGDJLyMfIWxI5dFRwLO3x+AGMlSqiIhyZ
         JaX5mRHxpkpqNeh0+GtlPpxZkR4me81DDO+MvcwEYyzin/9ZY6NHCU6b4tfJ0Ne2Lg9w
         4uow==
X-Gm-Message-State: AOAM530K/fEglbUGR1BiuzihrsjBFRLiYPOQUzAI7DSZAJDENBbqG2Sp
        pjyKOl+4Yu3498miIJj4EEkEgIiPudEGcGM/8zU=
X-Google-Smtp-Source: ABdhPJyWQpzogN+4iXbx6NzzPM0UtTIFyEPLB0aK5OHxn0Cv+wiR/HGQidspaW9QiFGO2TXiu/tt3dz18FZP5dad6oM=
X-Received: by 2002:a17:90a:fcc:: with SMTP id 70mr367368pjz.168.1606922751841;
 Wed, 02 Dec 2020 07:25:51 -0800 (PST)
MIME-Version: 1.0
References: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
 <cover.1606555939.git.xuanzhuo@linux.alibaba.com> <e82f4697438cd63edbf271ebe1918db8261b7c09.1606555939.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <e82f4697438cd63edbf271ebe1918db8261b7c09.1606555939.git.xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Dec 2020 16:25:40 +0100
Message-ID: <CAJ8uoz3CcSVQTD-k4xzBF_atKooCyrSOkLSOwgNRgEpXdVMNZg@mail.gmail.com>
Subject: Re: [PATCH bpf V3 1/2] xsk: replace datagram_poll by sock_poll_wait
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP SOCKETS (AF_XDP)" <netdev@vger.kernel.org>,
        "open list:XDP SOCKETS (AF_XDP)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 1, 2020 at 3:00 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
> based on the traditional socket information (eg: sk_wmem_alloc), but
> this does not apply to xsk. So this patch uses sock_poll_wait instead of
> datagram_poll, and the mask is calculated by xsk_poll.
>

Could you please add a Fixes label here as this is a bug fix? It will
help the persons backporting this. Here is the line that goes just
above your Sign-off-by.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")

Thanks: Magnus

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index b7b039b..9bbfd8a 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -471,11 +471,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>  static __poll_t xsk_poll(struct file *file, struct socket *sock,
>                              struct poll_table_struct *wait)
>  {
> -       __poll_t mask = datagram_poll(file, sock, wait);
> +       __poll_t mask = 0;
>         struct sock *sk = sock->sk;
>         struct xdp_sock *xs = xdp_sk(sk);
>         struct xsk_buff_pool *pool;
>
> +       sock_poll_wait(file, sock, wait);
> +
>         if (unlikely(!xsk_is_bound(xs)))
>                 return mask;
>
> --
> 1.8.3.1
>
