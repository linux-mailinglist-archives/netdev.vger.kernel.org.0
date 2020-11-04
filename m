Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D12A5C84
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbgKDB6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbgKDB6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 20:58:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3BEC061A4D
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 17:58:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id dk16so26844153ejb.12
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 17:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=bWMY14xPwHoO9Iq9rB2QuZa8Ukch1n4ewCAQZM40FdI=;
        b=U0m3qmgd8i0bKLxAs6hh8djT/TRD5exHpicLOSXMJ27fqYgQyGC0NkFLJtOYg5f3qf
         SY7Houc5hT53pZXFfYSfTvVpyFXiFj/HRUl9vBg/UZFbqYDQe+QR3ZtHrP3g8XtPDLq9
         hvzLbIxHuyehn8whwAMxPEM4Kh7zrUNdxz07tUsOz66zY9MNXPTrMMPiMiSTAA/JTjWH
         hdlgyFOIaqq6dPUGVJw35JuOjMh9p3C6GGsMDb2vxocXJiCsNP5cYwpjeufv6SxuXS3a
         IEybVuQNyg2qR2/Yj0/dlNfg8kNYKFSY+JNMUXLmqdvipLiLcdudpe4EBJ9n44kGME4B
         +GUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=bWMY14xPwHoO9Iq9rB2QuZa8Ukch1n4ewCAQZM40FdI=;
        b=GWNDYXYuLJ6qovJyq1QsiSOfWcX8ue7/G5VKuFrT+Bc4dF9bWcI5kSvvByQc5oChk6
         p6CRIhB70l0GOJmNShpDAC0LGgRWme7bMbSjJkDYW5rGy5XCX8Ot99UIxi9LagpkrWFI
         SjgmYxHrZnOFdFhfbnbfF3iXqRH/x7eRwLrvPitTslBRBM+Bxnxme/p3pczyPI6u6Ttj
         6m0ZYlhgpQ0q4N5utEMTZG3+stA5Uv5rY1CPzh41zPr31RxG2j+M+FzBApv6uX+VylT2
         xZFPv6XLgXxzAfhBAYHFoSGRKJjk8bbezikuNyn4jKNiiFtCmmiFpQLU9KpefZmNVZhC
         GU6Q==
X-Gm-Message-State: AOAM533XAYlYhGS3tzcT4TF/tKa6Mpy9i8XA252pKTYGI0fe6cFOuDqP
        MydaqHMDEoJ597oTl8zZ81B6DGgpW4U=
X-Google-Smtp-Source: ABdhPJxhdiRXHy5jCeZdCaooj//ykeuvgkclM1vYzj2ok6T0ISQlE/0Bg/+ArWIM75n73/qrDOVEVw==
X-Received: by 2002:a17:906:c41:: with SMTP id t1mr16883248ejf.19.1604455116148;
        Tue, 03 Nov 2020 17:58:36 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b6sm247039edu.21.2020.11.03.17.58.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 17:58:35 -0800 (PST)
Date:   Wed, 4 Nov 2020 03:58:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Subject: DSA and ptp_classify_raw: saving some CPU cycles causes worse
 throughput?
Message-ID: <20201104015834.mcn2eoibxf6j3ksw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I was testing a simple patch:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c6806eef906f..e0cda3a65f28 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -511,6 +511,9 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	struct sk_buff *clone;
 	unsigned int type;
 
+	if (likely(!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)))
+		return;
+
 	type = ptp_classify_raw(skb);
 	if (type == PTP_CLASS_NONE)
 		return;

which had the following reasoning behind it: we can avoid
ptp_classify_raw when TX timestamping is not requested.

The point here is that ptp_classify_raw should be the most expensive
when it's not looking at a PTP frame:
-> test_ipv4
   -> test_ipv6
      -> test_8021q
         -> test_ieee1588
because only then would we know for sure that it's not a PTP frame.

But since we should anyway not do TX timestamping unless the flag
skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP is set, then let's just look
at that directly first. This saves 3 checks for each normal frame.

In theory all is ok, and here is some perf data taken on a board. Only
the consumers > 1% of CPU cycles are shown. The ptp_classify_raw is
visible via ___bpf_prog_run. There is a ptp_classify_raw called on TX
and another one called on RX. This patch just gets rid of the one on TX.
So ___bpf_prog_run goes from being the #2 consumer, at 4.93% CPU cycles,
to basically disappearing when there is mostly only TX traffic on the
interface.

$ perf record -e cycles iperf3 -c 192.168.1.2 -t 100

Before:

  Overhead  Command  Shared Object      Symbol
  ........  .......  .................  ......................................

    20.23%  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
    15.36%  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
     4.93%  iperf3   [kernel.kallsyms]  [k] ___bpf_prog_run
     3.09%  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     3.07%  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     3.01%  iperf3   [kernel.kallsyms]  [k] skb_segment
     2.33%  iperf3   [kernel.kallsyms]  [k] __dev_queue_xmit
     2.22%  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     1.83%  iperf3   [kernel.kallsyms]  [k] pfifo_fast_dequeue
     1.78%  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.71%  iperf3   [kernel.kallsyms]  [k] dev_hard_start_xmit
     1.71%  iperf3   [kernel.kallsyms]  [k] gfar_start_xmit
     1.66%  iperf3   [kernel.kallsyms]  [k] tcp_gso_segment
     1.50%  iperf3   [kernel.kallsyms]  [k] mmiocpy
     1.46%  iperf3   [kernel.kallsyms]  [k] __qdisc_run
     1.35%  iperf3   [kernel.kallsyms]  [k] sch_direct_xmit
     1.34%  iperf3   [kernel.kallsyms]  [k] pfifo_fast_enqueue
     1.28%  iperf3   [kernel.kallsyms]  [k] mmioset
     1.27%  iperf3   [kernel.kallsyms]  [k] tcp_ack
     1.10%  iperf3   [kernel.kallsyms]  [k] __alloc_skb
     1.07%  iperf3   [kernel.kallsyms]  [k] dsa_slave_xmit

After:

  Overhead  Command  Shared Object      Symbol
  ........  .......  .................  ......................................

    20.37%  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
    17.84%  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
     3.06%  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     3.01%  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     2.99%  iperf3   [kernel.kallsyms]  [k] skb_segment
     2.29%  iperf3   [kernel.kallsyms]  [k] __dev_queue_xmit
     2.28%  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     1.92%  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.69%  iperf3   [kernel.kallsyms]  [k] tcp_gso_segment
     1.64%  iperf3   [kernel.kallsyms]  [k] pfifo_fast_dequeue
     1.61%  iperf3   [kernel.kallsyms]  [k] gfar_start_xmit
     1.51%  iperf3   [kernel.kallsyms]  [k] dev_hard_start_xmit
     1.50%  iperf3   [kernel.kallsyms]  [k] __qdisc_run
     1.48%  iperf3   [kernel.kallsyms]  [k] mmiocpy
     1.42%  iperf3   [kernel.kallsyms]  [k] tcp_ack
     1.34%  iperf3   [kernel.kallsyms]  [k] pfifo_fast_enqueue
     1.31%  iperf3   [kernel.kallsyms]  [k] mmioset
     1.23%  iperf3   [kernel.kallsyms]  [k] sch_direct_xmit
     1.17%  iperf3   [kernel.kallsyms]  [k] dsa_slave_xmit
     1.13%  iperf3   [kernel.kallsyms]  [k] __alloc_skb

The only problem?
Throughput is actually a few Mbps worse, and this is 100% reproducible,
doesn't appear to be measurement error.

Before:
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-100.00 sec  10.9 GBytes   935 Mbits/sec    0             sender
[  5]   0.00-100.01 sec  10.9 GBytes   935 Mbits/sec                  receiver

After:
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-100.00 sec  10.8 GBytes   926 Mbits/sec    0             sender
[  5]   0.00-100.00 sec  10.8 GBytes   926 Mbits/sec                  receiver

I have tried to study the cache misses and branch misses in the good and
bad case, but I am not seeing any obvious sign there:

Before:

# Samples: 339K of event 'cache-misses'
# Event count (approx.): 647900762
#
# Overhead       Samples  Command  Shared Object      Symbol
# ........  ............  .......  .................  ......................................
#
    30.40%        102932  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
    27.70%         93906  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
     3.22%         10923  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     3.21%         10886  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     2.82%          9711  iperf3   [kernel.kallsyms]  [k] tcp_gso_segment
     2.28%          7718  iperf3   [kernel.kallsyms]  [k] skb_segment
     2.20%          7507  iperf3   [kernel.kallsyms]  [k] ___bpf_prog_run
     1.81%          6124  iperf3   [kernel.kallsyms]  [k] mmioset
     1.66%          5706  iperf3   [kernel.kallsyms]  [k] inet_gso_segment
     1.17%          4028  iperf3   [kernel.kallsyms]  [k] ip_send_check
     1.13%          3863  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.12%          3801  iperf3   [kernel.kallsyms]  [k] __ksize
     1.12%          3783  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     1.08%          3723  iperf3   [kernel.kallsyms]  [k] csum_partial
     0.98%          3351  iperf3   [kernel.kallsyms]  [k] netdev_core_pick_tx

# Samples: 326K of event 'branch-misses'
# Event count (approx.): 527179670
#
# Overhead       Samples  Command  Shared Object      Symbol
# ........  ............  .......  .................  ....................................
#
    10.67%         34836  iperf3   [kernel.kallsyms]  [k] pfifo_fast_dequeue
     7.09%         23325  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     5.91%         19296  iperf3   [kernel.kallsyms]  [k] gfar_start_xmit
     4.94%         16183  iperf3   [kernel.kallsyms]  [k] __dev_queue_xmit
     3.75%         12241  iperf3   [kernel.kallsyms]  [k] _raw_spin_lock
     3.67%         11990  iperf3   [kernel.kallsyms]  [k] __qdisc_run
     3.58%         11791  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     3.53%         11563  iperf3   [kernel.kallsyms]  [k] sch_direct_xmit
     3.51%         11477  iperf3   [kernel.kallsyms]  [k] dsa_slave_xmit
     3.35%         11014  iperf3   [kernel.kallsyms]  [k] mmioset
     3.30%         10854  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     2.25%          7361  iperf3   [kernel.kallsyms]  [k] ___bpf_prog_run
     2.16%          7075  iperf3   [kernel.kallsyms]  [k] dma_map_page_attrs
     2.09%          6837  iperf3   [kernel.kallsyms]  [k] dev_hard_start_xmit
     1.77%          5700  iperf3   [kernel.kallsyms]  [k] tcp_ack
     1.58%          5143  iperf3   [kernel.kallsyms]  [k] validate_xmit_skb.constprop.54
     1.56%          5143  iperf3   [kernel.kallsyms]  [k] __copy_skb_header
     1.45%          4757  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.36%          4483  iperf3   [kernel.kallsyms]  [k] mmiocpy
     1.30%          4277  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
     1.27%          4160  iperf3   [kernel.kallsyms]  [k] netif_skb_features
     1.20%          3897  iperf3   [kernel.kallsyms]  [k] get_page_from_freelist
     1.15%          3737  iperf3   [kernel.kallsyms]  [k] tcp_sendmsg_locked
     1.13%          3693  iperf3   [kernel.kallsyms]  [k] is_vmalloc_addr
     1.02%          3306  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
     0.98%          3202  iperf3   [kernel.kallsyms]  [k] pfifo_fast_enqueue

After:

# Samples: 290K of event 'cache-misses'
# Event count (approx.): 586163914
#
# Overhead       Samples  Command  Shared Object      Symbol
# ........  ............  .......  .................  .....................................
#
    32.97%         94339  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
    26.46%         77278  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
     3.17%          9246  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     3.03%          8838  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     2.46%          7258  iperf3   [kernel.kallsyms]  [k] tcp_gso_segment
     2.21%          6435  iperf3   [kernel.kallsyms]  [k] skb_segment
     1.87%          5518  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.72%          5021  iperf3   [kernel.kallsyms]  [k] mmioset
     1.51%          4449  iperf3   [kernel.kallsyms]  [k] inet_gso_segment
     1.06%          3104  iperf3   [kernel.kallsyms]  [k] __ksize
     1.05%          3057  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     1.04%          3073  iperf3   [kernel.kallsyms]  [k] ip_send_check
     0.96%          2761  iperf3   [kernel.kallsyms]  [k] tcp_sendmsg_locked
     0.96%          2836  iperf3   [kernel.kallsyms]  [k] csum_partial
     0.96%          2824  iperf3   [kernel.kallsyms]  [k] dsa_8021q_xmit


# Samples: 266K of event 'branch-misses'
# Event count (approx.): 370809162
#
# Overhead       Samples  Command  Shared Object      Symbol
# ........  ............  .......  .................  .....................................
#
     8.88%         25491  iperf3   [kernel.kallsyms]  [k] __kmalloc_track_caller
     5.16%         12016  iperf3   [kernel.kallsyms]  [k] pfifo_fast_dequeue
     4.86%         13401  iperf3   [kernel.kallsyms]  [k] __dev_queue_xmit
     4.32%         12298  iperf3   [kernel.kallsyms]  [k] skb_copy_and_csum_bits
     4.28%         12167  iperf3   [kernel.kallsyms]  [k] mmioset
     4.05%         11561  iperf3   [kernel.kallsyms]  [k] kmem_cache_alloc
     3.90%         10864  iperf3   [kernel.kallsyms]  [k] __qdisc_run
     3.19%          7854  iperf3   [kernel.kallsyms]  [k] gfar_start_xmit
     2.91%          7817  iperf3   [kernel.kallsyms]  [k] dsa_slave_xmit
     2.42%          6418  iperf3   [kernel.kallsyms]  [k] dev_hard_start_xmit
     2.08%          6087  iperf3   [kernel.kallsyms]  [k] mmiocpy
     2.05%          5786  iperf3   [kernel.kallsyms]  [k] tcp_ack
     1.87%          4610  iperf3   [kernel.kallsyms]  [k] sch_direct_xmit
     1.76%          5112  iperf3   [kernel.kallsyms]  [k] __copy_skb_header
     1.67%          4779  iperf3   [kernel.kallsyms]  [k] csum_partial_copy_nocheck
     1.60%          3862  iperf3   [kernel.kallsyms]  [k] sja1105_xmit
     1.52%          4593  iperf3   [kernel.kallsyms]  [k] get_page_from_freelist
     1.39%          4003  iperf3   [kernel.kallsyms]  [k] arm_copy_from_user
     1.31%          3881  iperf3   [kernel.kallsyms]  [k] tcp_sendmsg_locked
     1.26%          3183  iperf3   [kernel.kallsyms]  [k] _raw_spin_lock
     1.21%          2899  iperf3   [kernel.kallsyms]  [k] dma_map_page_attrs
     1.10%          3111  iperf3   [kernel.kallsyms]  [k] __free_pages_ok
     1.06%          3037  iperf3   [kernel.kallsyms]  [k] tcp_write_xmit
     0.95%          2667  iperf3   [kernel.kallsyms]  [k] skb_segment

My untrained eye tells me that in the 'after patch' case (the worse
one), there are less branch misses, and less cache misses. So by all
perf metrics, the throughput should be better, but it isn't. What gives?
