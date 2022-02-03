Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E78B4A87A4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351866AbiBCPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiBCPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:25:14 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE1DC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 07:25:14 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v186so10105864ybg.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=II2uX2TC8/q/FMysoeH1gApUzEllrKx34ctrc+7SPHw=;
        b=DPecq+TAr+gfDxIRCMfGmlYuGmbb4PymDKvOE2v7q2xNApb3i3o0B5NXCH9EEAQjaX
         hAANeeTPs1vGTJGnLTz3TJNRSgtu/KDXwcnhlc6zETKX25u2PXxycxXOcDLinGlR3bvR
         piIb75yT/ZpZiTPrsnAPooJOvMkMmImzBKVEw5OM8c3vrTrDU4xFwxogA6EnA71/VU0u
         st8FmUyWndkreew/W8X13lEA6n00oXIzBTkdC083j9Q7I4pyB76lePUYkx4jAEuiKyIw
         gIr7gTRxLR8H+l/5sMip0Apsh5ZCGsh8lz4etMzD1kvrzjjdDa7CS2oaMwkYiS+B5CoO
         6EGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=II2uX2TC8/q/FMysoeH1gApUzEllrKx34ctrc+7SPHw=;
        b=7t+6KqEpKa6EcIBHEtvkegONRVLsSi0H5JQ/lrdj9rk2UsGLoFa7Og35rCJvQ7Z+1U
         dht+wvCNNsq4UNaaUB3Mgc0zjaHgsVgLdfUZFR6L4dZ9lBvgYTknkylP0jHzoTR7HhIN
         bPyJHp0YTFVQYZPWlb5Y1Eq0utf5Ebcl8wrPnnpx+LPe2VhByQpPSacyEg3H6xVIYNVy
         xktZn96c6QbqyaHSZ7/fIoVMbI20zVOdE2I4qHrWpWfeAecMasOL5fR+IvBUuV61+TAw
         jdp0hinZxFhJSrFNfyaPQ3R7+WdoNkpjm6O2uuQd6pDp7kuMTdEx6T95IOT30LFltums
         PCRA==
X-Gm-Message-State: AOAM532EPc+ZzCsxJIcH6zCvwXGsC4f3Lmxo7Tvxu6n7Z98WUpX6OlkK
        zsJP+tVcvmEw0jKxhV+FZltXdoh2gK875iD3Xagc4w==
X-Google-Smtp-Source: ABdhPJxVbx9SMkPwosOy+FuBF2hqI7K/9+TUpSxBfGHhOWLUgHYvap28oJWGSv5bRfOqRBv/tKLjtnmgaxtxjopCvQE=
X-Received: by 2002:a25:d9c2:: with SMTP id q185mr45412317ybg.293.1643901912855;
 Thu, 03 Feb 2022 07:25:12 -0800 (PST)
MIME-Version: 1.0
References: <20220202122848.647635-1-bigeasy@linutronix.de>
 <20220202122848.647635-4-bigeasy@linutronix.de> <CANn89iLVPnhybrdjRh6ccv6UZHW-_W0ZHRO5c7dnWU44FUgd_g@mail.gmail.com>
 <YfvwbsKm4XtTUlsx@linutronix.de>
In-Reply-To: <YfvwbsKm4XtTUlsx@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 07:25:01 -0800
Message-ID: <CANn89i+66MvzQVp=eTENzZY6s8+B+jQCoKEO_vXdzaDeHVTH5w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: dev: Makes sure netif_rx() can be
 invoked in any context.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 7:10 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-02-02 09:43:14 [-0800], Eric Dumazet wrote:
> > Maybe worth mentioning this commit will show a negative impact, for
> > network traffic
> > over loopback interface.
> >
> > My measure of the cost of local_bh_disable()/local_bh_enable() is ~6
> > nsec on one of my lab x86 hosts.
>
> So you are worried that
>     dev_loopback_xmit() -> netif_rx_ni()
>
> becomes
>     dev_loopback_xmit() -> netif_rx()


No, the loopback device (ifconfig log) I am referring to is in
drivers/net/loopback.c

loopback_xmit() calls netif_rx() directly, while bh are already disabled.

>
> and by that 6nsec slower because of that bh off/on? Can these 6nsec get
> a little lower if we substract the overhead of preempt-off/on?
> But maybe I picked the wrong loopback here.
>
> > Perhaps we could have a generic netif_rx(), and a __netif_rx() for the
> > virtual drivers (lo and maybe tunnels).
> >
> > void __netif_rx(struct sk_buff *skb);
> >
> > static inline int netif_rx(struct sk_buff *skb)
> > {
> >    int res;
> >     local_bh_disable();
> >     res = __netif_rx(skb);
> >   local_bh_enable();
> >   return res;
> > }
>
> But what is __netif_rx() doing? netif_rx_ni() has this part:
>
> |       preempt_disable();
> |       err = netif_rx_internal(skb);
> |       if (local_softirq_pending())
> |               do_softirq();
> |       preempt_enable();
>
> to ensure that smp_processor_id() and friends are quiet plus any raised
> softirqs are processed. With the current netif_rx() we end up with:
>
> |       local_bh_disable();
> |       ret = netif_rx_internal(skb);
> |       local_bh_enable();
>
> which provides the same. Assuming __netif_rx() as:
>
> | int __netif_rx(skb)
> | {
> |         trace_netif_rx_entry(skb);
> |
> |         ret = netif_rx_internal(skb);
> |         trace_netif_rx_exit(ret);
> |
> |         return ret;
> | }
>
> and the loopback interface is not invoking this in_interrupt() context.
>
> Sebastian

Instead of adding a local_bh_disable()/local_bh_enable() in netif_rx()
I suggested
to rename current netif_rx() to __netif_rx() and add a wrapper, eg :

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d1654bf067b30f2bb0b0825f88dea9..39232d99995cbd54c74e85905bb4af43b5b301ca
100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3668,7 +3668,17 @@ u32 bpf_prog_run_generic_xdp(struct sk_buff
*skb, struct xdp_buff *xdp,
                             struct bpf_prog *xdp_prog);
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
-int netif_rx(struct sk_buff *skb);
+int __netif_rx(struct sk_buff *skb);
+static inline int netif_rx(struct sk_buff *skb)
+{
+       int res;
+
+       local_bh_disable();
+       res = __netif_rx(skb);
+       local_bh_enable();
+       return res;
+}
+
 int netif_rx_ni(struct sk_buff *skb);
 int netif_rx_any_context(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65f9bcf88a6d73e2c9ff741d33c18..f962e549e0bfea96cdba5bc7e1d8694e46652eac
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4819,7 +4819,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 }

 /**
- *     netif_rx        -       post buffer to the network code
+ *     __netif_rx      -       post buffer to the network code
  *     @skb: buffer to post
  *
  *     This function receives a packet from a device driver and queues it for
@@ -4833,7 +4833,7 @@ static int netif_rx_internal(struct sk_buff *skb)
  *
  */

-int netif_rx(struct sk_buff *skb)
+int __netif_rx(struct sk_buff *skb)
 {
        int ret;

@@ -4844,7 +4844,7 @@ int netif_rx(struct sk_buff *skb)

        return ret;
 }
-EXPORT_SYMBOL(netif_rx);
+EXPORT_SYMBOL(__netif_rx);

 int netif_rx_ni(struct sk_buff *skb)
 {
