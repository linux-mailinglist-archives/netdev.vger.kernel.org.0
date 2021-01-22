Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736972FFF6D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbhAVJot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbhAVJlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:41:03 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F58C0613D6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:40:17 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n2so9791396iom.7
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j/8AMFI2hyfL+MbywCIfVyY8g5M1eDaVQ4W1unFATlg=;
        b=iEwN/rWtohJuD6xj6j4fleW4+lNdJjx21JDwWwlny+4CMMEfYEqTkm8J3lpn3N0NDw
         PNWHEhJ0czIKLivilnBSufic9Dzc/P5cyEYSRYoPNz8U8B6nojUXLQZpD+C3GNLn1pd6
         CcuVWzMdKfJdJ/OFevr0uWPe6XCxvtD9CENmn11G1nVgF0/+JjR4nB91RurGjn7ePRdT
         ItpLHXOh34r44wuiBvMtGj/0yK82mCWfyktzjn14n5syNDbNE17a6mZOIG13kaLS87fv
         s76JYClQFuPxE/9rkfncKhGXrlbZ3d+o99IGUeak4qJXeYUVI78FetnpuZa3/9m+Ezh2
         /M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j/8AMFI2hyfL+MbywCIfVyY8g5M1eDaVQ4W1unFATlg=;
        b=A/Gs2MQloQnvH2D5xmIlpYPpc8WFtGDiK8O6z0qhxCDVN/nABJMLEtR0u/T7IIOWCZ
         etinT7jr3OffyDiwr/4PYhMteIIv7SgglhoNGCYvPNDr7SC62gmyTEpTCIgbaKPSJkzy
         f/gRU6b60SxoQK+8WMuDbBye+Mfx+DjurJZvvUCrIAaPrVnqE4MTQFSrBQA15FPGkeM4
         0E+uCMtzJErmK3sLwjVrilDfOm3Q84ZViQ0Qb4o8jrBQK8MxAZH25VU5QbEG4woF1tGo
         TWOn1+yM3eMTcAdM8eDUh7NwDq3oHkgCWKIFXJeEudYnJ6Xlah7AKOoqbClIANxJp9Rb
         jo6A==
X-Gm-Message-State: AOAM530A4r9H467J4vYD5pDYd/9+6YG1PAKr6dM0xjU+pWGYHTTQk9J7
        EC27DB1xoE/FswmXNTsijCp3fcfkpN3+YIRzqw5K5w==
X-Google-Smtp-Source: ABdhPJxJ/ohJLKvwlQtieV7o/jIMPZASEESUkCsU5nU6igg0Y0qiPw36IFBqGLempNqqP0UZ7hvUHpfyisY7o2c3ZMw=
X-Received: by 2002:a05:6e02:13ea:: with SMTP id w10mr3288074ilj.68.1611308416585;
 Fri, 22 Jan 2021 01:40:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611304190.git.lukas@wunner.de> <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
In-Reply-To: <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jan 2021 10:40:05 +0100
Message-ID: <CANn89iK3CC3fapmQpwwbVkGs4-+fmJF+nj0pmBHJ9fy6poWseg@mail.gmail.com>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress handling
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 9:55 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> sch_handle_egress() returns either the skb or NULL to signal to its
> caller __dev_queue_xmit() whether a packet should continue to be
> processed.
>
> The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> NULL pointer deref right at its top.
>
> But the compiler doesn't know that.  So if sch_handle_egress() signals
> success by returning the skb, the "if (!skb) goto out;" statement
> results in a gratuitous NULL pointer check in the Assembler output.
>
> Avoid by telling the compiler that __dev_queue_xmit() is never passed a
> NULL skb.  This also eliminates another gratuitous NULL pointer check in
> __dev_queue_xmit()
>   qdisc_pkt_len_init()
>     skb_header_pointer()
>       __skb_header_pointer()
>
> The speedup is barely measurable:
> Before: 1877 1875 1878 1874 1882 1873 Mb/sec
> After:  1877 1877 1880 1883 1888 1886 Mb/sec
>
> However we're about to add a netfilter egress hook to __dev_queue_xmit()
> and without the micro-optimization, it will result in a performance
> degradation which is indeed measurable:
> With netfilter hook:               1853 1852 1850 1848 1849 1851 Mb/sec
> With netfilter hook + micro-optim: 1874 1877 1881 1875 1876 1876 Mb/sec
>
> The performance degradation is caused by a JNE instruction ("if (skb)")
> being flipped to a JE instruction ("if (!skb)") once the netfilter hook
> is added.  The micro-optimization removes the test and jump instructions
> altogether.
>
> Measurements were performed on a Core i7-3615QM.  Reproducer:
> ip link add dev foo type dummy
> ip link set dev foo up
> tc qdisc add dev foo clsact
> tc filter add dev foo egress bpf da bytecode '1,6 0 0 0,'
> modprobe pktgen
> echo "add_device foo" > /proc/net/pktgen/kpktgend_3
> samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i foo -n 400000000 -m "11:11:11:11:11:11" -d 1.1.1.1
>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> ---
>  net/core/dev.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 7afbb642e203..4c16b9932823 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4072,6 +4072,7 @@ struct netdev_queue *netdev_core_pick_tx(struct net_device *dev,
>   *      the BH enable code must have IRQs enabled so that it will not deadlock.
>   *          --BLG
>   */
> +__attribute__((nonnull(1)))
>  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>  {
>         struct net_device *dev = skb->dev;
> --
> 2.29.2
>

Interesting !

It is a bit sad the compilers do not automatically get this knowledge
from the very first instruction :

 struct net_device *dev = skb->dev;

I see this also makes qdisc_pkt_len_init() slightly faster because
this removes the if (!skb) test from __skb_header_pointer()

I guess we also could add this patch to benefit all
skb_header_pointer() callers :

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5f60c9e907c9d8eae1e85ae0329838383e3325df..db8774c50cc6ab99deaecdb1dfc31dc5306b9a37
100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3627,6 +3627,7 @@ __skb_header_pointer(const struct sk_buff *skb,
int offset,
        return buffer;
 }

+__attribute__((nonnull(1)))
 static inline void * __must_check
 skb_header_pointer(const struct sk_buff *skb, int offset, int len,
void *buffer)
 {
