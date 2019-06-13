Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D097244A8F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfFMSZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:25:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38495 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfFMSZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:25:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so21567147qtl.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5uWOeNLaO7QcRWioU3vPSDyX9WUq0a8uHLT9mAey5nc=;
        b=WtiNL7B9x6/8Jff0v43M3ZX43mUPew7sHfuwC8hfJKurFg7+bG0zMLkVSfgN+Lg5Pv
         I80lS/r9P90Zo4+pC5yknw/8RbTDKScYVUdInwJDVU0JlfxI5tMywiZTkq2ysAyniFwE
         eTFefNULPuLm8unAGWdNmBCaZXxKP5PdX/nQnxlmuqZCAGa5CTPh0z3lQd+WG2zRM7Hq
         f31z669Y4Raz7q0YUC+p9iOIb+zvyfHbuqWePBir61mjhVYy2ClG1OJSrA+DUKp+1F5z
         JMDq6ylgwcAdRDey6Ub0seRhnZ1QpuAb4N0gmCsvOSY7f4VqCPdbA9Kdu/4O71mwv785
         M3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5uWOeNLaO7QcRWioU3vPSDyX9WUq0a8uHLT9mAey5nc=;
        b=HLipgcK5+arNJc0w8NdFZ1+XqG8Qxzy0z/gjSVsQxlKGltSmofPN+LkhQ0nNqzF1sZ
         v2G6NU8nRuJJqBFf6CjHKh+MPC/u5aohe7N9EqOSNz9NwkqC9uOqb2H3gyYayTCgxy/k
         oQ1HIOb+WZnWaOJwPANfZiisXO3GW4ybEQlH1AS3WBXYne37WiDVcaqvKgmffGQ3w6aV
         Vx2zSkzaCchqlbkaD3XqUIGoUXBfn6pakgqwetmnSavwGbjFpeloDQNZT8dZsx5aM+D4
         XhHubxF886YXaMWwNGAxhDYebmjdNTAqIQMlqaXP8zgsIOD13N8ZlIlJVlRQ+Jc7xYWt
         BgSQ==
X-Gm-Message-State: APjAAAUmgdkqxb8SQdQoza/A5+EaDX1xQnclC3L7vyGnsxgw6XqFbguG
        LIdL1UW0KO2DBrdayGzMg2y+dG/XWfPIUuBqkEM6rgYKUgc=
X-Google-Smtp-Source: APXvYqz81VNamUERduGXnOEqFKt3zROTHOZ918vW8vcu3Xn5HIAnPwD+1IgkqAe53TbJ0fSdfLbwvzu1kHGTsrukRnI=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr4763915qvh.78.1560450355343;
 Thu, 13 Jun 2019 11:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190612164247.2258493-1-brakmo@fb.com>
In-Reply-To: <20190612164247.2258493-1-brakmo@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 11:25:43 -0700
Message-ID: <CAEf4Bzb5smUH_JFKPgik1z88wh2q0VSXeN_1vkw_Xf_CmiEfrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add support for fq's EDT to HBM
To:     brakmo <brakmo@fb.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

,

On Wed, Jun 12, 2019 at 11:08 AM brakmo <brakmo@fb.com> wrote:
>
> Adds support for fq's Earliest Departure Time to HBM (Host Bandwidth
> Manager). Includes a new BPF program supporting EDT, and also updates
> corresponding programs.
>
> It will drop packets with and EDT of more than 500us in the future

typo: and -> an

> unless the packet belongs to a flow with less than 2 packets in flight.
> This is done so each flow has at least 2 packets in flight, so they
> will not starve, and also to help prevent delayed ACK timeouts.
>
> It will also work with ECN enabled traffic, where the packets will be
> CE marked if their EDT is more than 50us in the future.
>
> The table below shows some performance numbers. The flows are back to
> back RPCS. One server sending to another, either 2 or 4 flows.
> One flow is a 10KB RPC, the rest are 1MB RPCs. When there are more
> than one flow of a given RPC size, the numbers represent averages.
>
> The rate limit applies to all flows (they are in the same cgroup).
> Tests ending with "-edt" ran with the new BPF program supporting EDT.
> Tests ending with "-hbt" ran on top HBT qdisc with the specified rate
> (i.e. no HBM). The other tests ran with the HBM BPF program included
> in the HBM patch-set.
>
> EDT has limited value when using DCTCP, but it helps in many cases when
> using Cubic. It usually achieves larger link utilization and lower
> 99% latencies for the 1MB RPCs.
> HBM ends up queueing a lot of packets with its default parameter values,
> reducing the goodput of the 10KB RPCs and increasing their latency. Also,
> the RTTs seen by the flows are quite large.
>
>                          Aggr              10K  10K  10K   1MB  1MB  1MB
>          Limit           rate drops  RTT  rate  P90  P99  rate  P90  P99
> Test      rate  Flows    Mbps   %     us  Mbps   us   us  Mbps   ms   ms
> --------  ----  -----    ---- -----  ---  ---- ---- ----  ---- ---- ----
> cubic       1G    2       904  0.02  108   257  511  539   647 13.4 24.5
> cubic-edt   1G    2       982  0.01  156   239  656  967   743 14.0 17.2
> dctcp       1G    2       977  0.00  105   324  408  744   653 14.5 15.9
> dctcp-edt   1G    2       981  0.01  142   321  417  811   660 15.7 17.0
> cubic-htb   1G    2       919  0.00 1825    40 2822 4140   879  9.7  9.9
>
> cubic     200M    2       155  0.30  220    81  532  655    74  283  450
> cubic-edt 200M    2       188  0.02  222    87 1035 1095   101   84   85
> dctcp     200M    2       188  0.03  111    77  912  939   111   76  325
> dctcp-edt 200M    2       188  0.03  217    74 1416 1738   114   76   79
> cubic-htb 200M    2       188  0.00 5015     8 14ms 15ms   180   48   50
>
> cubic       1G    4       952  0.03  110   165  516  546   262   38  154
> cubic-edt   1G    4       973  0.01  190   111 1034 1314   287   65   79
> dctcp       1G    4       951  0.00  103   180  617  905   257   37   38
> dctcp-edt   1G    4       967  0.00  163   151  732 1126   272   43   55
> cubic-htb   1G    4       914  0.00 3249    13  7ms  8ms   300   29   34
>
> cubic       5G    4      4236  0.00  134   305  490  624  1310   10   17
> cubic-edt   5G    4      4865  0.00  156   306  425  759  1520   10   16
> dctcp       5G    4      4936  0.00  128   485  221  409  1484    7    9
> dctcp-edt   5G    4      4924  0.00  148   390  392  623  1508   11   26
>
> Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
> ---
>  samples/bpf/Makefile       |   2 +
>  samples/bpf/do_hbm_test.sh |  22 ++---
>  samples/bpf/hbm.c          |  18 +++-
>  samples/bpf/hbm_edt_kern.c | 173 +++++++++++++++++++++++++++++++++++++
>  samples/bpf/hbm_kern.h     |  39 +++++++--
>  5 files changed, 235 insertions(+), 19 deletions(-)
>  create mode 100644 samples/bpf/hbm_edt_kern.c
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 4074a66a70ca..d6678c4b6ff1 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -168,6 +168,7 @@ always += task_fd_query_kern.o
>  always += xdp_sample_pkts_kern.o
>  always += ibumad_kern.o
>  always += hbm_out_kern.o
> +always += hbm_edt_kern.o
>
>  KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
>  KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/
> @@ -278,6 +279,7 @@ $(src)/*.c: verify_target_bpf $(LIBBPF)
>  $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
>  $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>  $(obj)/hbm.o: $(src)/hbm.h
> +$(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
>
>  # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
>  # But, there is no easy way to fix it, so just exclude it since it is
> diff --git a/samples/bpf/do_hbm_test.sh b/samples/bpf/do_hbm_test.sh
> index e48b047d4646..ffe4c0607341 100755
> --- a/samples/bpf/do_hbm_test.sh
> +++ b/samples/bpf/do_hbm_test.sh
> @@ -14,7 +14,7 @@ Usage() {
>    echo "loads. The output is the goodput in Mbps (unless -D was used)."
>    echo ""
>    echo "USAGE: $name [out] [-b=<prog>|--bpf=<prog>] [-c=<cc>|--cc=<cc>]"
> -  echo "             [-D] [-d=<delay>|--delay=<delay>] [--debug] [-E]"
> +  echo "             [-D] [-d=<delay>|--delay=<delay>] [--debug] [-E] [--edt]"
>    echo "             [-f=<#flows>|--flows=<#flows>] [-h] [-i=<id>|--id=<id >]"
>    echo "             [-l] [-N] [--no_cn] [-p=<port>|--port=<port>] [-P]"
>    echo "             [-q=<qdisc>] [-R] [-s=<server>|--server=<server]"
> @@ -30,6 +30,7 @@ Usage() {
>    echo "                      other detailed information. This information is"
>    echo "                      test dependent (i.e. iperf3 or netperf)."
>    echo "    -E                enable ECN (not required for dctcp)"
> +  echo "    --edt             use fq's Earliest Departure Time (requires fq)"
>    echo "    -f or --flows     number of concurrent flows (default=1)"
>    echo "    -i or --id        cgroup id (an integer, default is 1)"
>    echo "    -N                use netperf instead of iperf3"
> @@ -130,13 +131,12 @@ processArgs () {
>        details=1
>        ;;
>      -E)
> -     ecn=1
> +      ecn=1
> +      ;;
> +    --edt)
> +      flags="$flags --edt"
> +      qdisc="fq"
>       ;;
> -    # Support for upcomming fq Early Departure Time egress rate limiting
> -    #--edt)
> -    # prog="hbm_out_edt_kern.o"
> -    # qdisc="fq"
> -    # ;;
>      -f=*|--flows=*)
>        flows="${i#*=}"
>        ;;
> @@ -228,8 +228,8 @@ if [ "$netem" -ne "0" ] ; then
>    tc qdisc del dev lo root > /dev/null 2>&1
>    tc qdisc add dev lo root netem delay $netem\ms > /dev/null 2>&1
>  elif [ "$qdisc" != "" ] ; then
> -  tc qdisc del dev lo root > /dev/null 2>&1
> -  tc qdisc add dev lo root $qdisc > /dev/null 2>&1
> +  tc qdisc del dev eth0 root > /dev/null 2>&1
> +  tc qdisc add dev eth0 root $qdisc > /dev/null 2>&1
>  fi
>
>  n=0
> @@ -399,7 +399,9 @@ fi
>  if [ "$netem" -ne "0" ] ; then
>    tc qdisc del dev lo root > /dev/null 2>&1
>  fi
> -
> +if [ "$qdisc" != "" ] ; then
> +  tc qdisc del dev eth0 root > /dev/null 2>&1
> +fi
>  sleep 2
>
>  hbmPid=`ps ax | grep "hbm " | grep --invert-match "grep" | awk '{ print $1 }'`
> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index bdfce592207a..3b538d4d67a8 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -62,6 +62,7 @@ bool loopback_flag;
>  bool debugFlag;
>  bool work_conserving_flag;
>  bool no_cn_flag;
> +bool edt_flag;
>
>  static void Usage(void);
>  static void read_trace_pipe2(void);
> @@ -372,9 +373,14 @@ static int run_bpf_prog(char *prog, int cg_id)
>                 fprintf(fout, "avg rtt:%d\n",
>                         (int)(qstats.sum_rtt / (qstats.pkts_total + 1)));
>                 // Average credit
> -               fprintf(fout, "avg credit:%d\n",
> -                       (int)(qstats.sum_credit /
> -                             (1500 * ((int)qstats.pkts_total) + 1)));
> +               if (edt_flag)
> +                       fprintf(fout, "avg credit_ms:%.03f\n",
> +                               (qstats.sum_credit /
> +                                (qstats.pkts_total + 1.0)) / 1000000.0);
> +               else
> +                       fprintf(fout, "avg credit:%d\n",
> +                               (int)(qstats.sum_credit /
> +                                     (1500 * ((int)qstats.pkts_total ) + 1)));
>
>                 // Return values stats
>                 for (k = 0; k < RET_VAL_COUNT; k++) {
> @@ -408,6 +414,7 @@ static void Usage(void)
>                "  Where:\n"
>                "    -o         indicates egress direction (default)\n"
>                "    -d         print BPF trace debug buffer\n"
> +              "    --edt      use fq's Earliest Departure Time\n"
>                "    -l         also limit flows using loopback\n"
>                "    -n <#>     to create cgroup \"/hbm#\" and attach prog\n"
>                "               Default is /hbm1\n"
> @@ -433,6 +440,7 @@ int main(int argc, char **argv)
>         char *optstring = "iodln:r:st:wh";
>         struct option loptions[] = {
>                 {"no_cn", 0, NULL, 1},
> +               {"edt", 0, NULL, 2},
>                 {NULL, 0, NULL, 0}
>         };
>
> @@ -441,6 +449,10 @@ int main(int argc, char **argv)
>                 case 1:
>                         no_cn_flag = true;
>                         break;
> +               case 2:
> +                       prog = "hbm_edt_kern.o";
> +                       edt_flag = true;
> +                       break;
>                 case'o':
>                         break;
>                 case 'd':
> diff --git a/samples/bpf/hbm_edt_kern.c b/samples/bpf/hbm_edt_kern.c
> new file mode 100644
> index 000000000000..26cfb1d3cda0
> --- /dev/null
> +++ b/samples/bpf/hbm_edt_kern.c
> @@ -0,0 +1,173 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * Sample Host Bandwidth Manager (HBM) BPF program.
> + *
> + * A cgroup skb BPF egress program to limit cgroup output bandwidth.
> + * It uses a modified virtual token bucket queue to limit average
> + * egress bandwidth. The implementation uses credits instead of tokens.
> + * Negative credits imply that queueing would have happened (this is
> + * a virtual queue, so no queueing is done by it. However, queueing may
> + * occur at the actual qdisc (which is not used for rate limiting).
> + *
> + * This implementation uses 3 thresholds, one to start marking packets and
> + * the other two to drop packets:
> + *                                  CREDIT
> + *        - <--------------------------|------------------------> +
> + *              |    |          |      0
> + *              |  Large pkt    |
> + *              |  drop thresh  |
> + *   Small pkt drop             Mark threshold
> + *       thresh
> + *
> + * The effect of marking depends on the type of packet:
> + * a) If the packet is ECN enabled and it is a TCP packet, then the packet
> + *    is ECN marked.
> + * b) If the packet is a TCP packet, then we probabilistically call tcp_cwr
> + *    to reduce the congestion window. The current implementation uses a linear
> + *    distribution (0% probability at marking threshold, 100% probability
> + *    at drop threshold).
> + * c) If the packet is not a TCP packet, then it is dropped.
> + *
> + * If the credit is below the drop threshold, the packet is dropped. If it
> + * is a TCP packet, then it also calls tcp_cwr since packets dropped by
> + * by a cgroup skb BPF program do not automatically trigger a call to
> + * tcp_cwr in the current kernel code.
> + *
> + * This BPF program actually uses 2 drop thresholds, one threshold
> + * for larger packets (>= 120 bytes) and another for smaller packets. This
> + * protects smaller packets such as SYNs, ACKs, etc.
> + *
> + * The default bandwidth limit is set at 1Gbps but this can be changed by
> + * a user program through a shared BPF map. In addition, by default this BPF
> + * program does not limit connections using loopback. This behavior can be
> + * overwritten by the user program. There is also an option to calculate
> + * some statistics, such as percent of packets marked or dropped, which
> + * the user program can access.
> + *
> + * A latter patch provides such a program (hbm.c)

Now inaccurate copy/paste from samples/bpf/hbm_out_kern.c. Maybe remove in both?


> + */
> +
> +#include "hbm_kern.h"
> +
> +SEC("cgroup_skb/egress")
> +int _hbm_out_cg(struct __sk_buff *skb)
> +{
> +       struct hbm_pkt_info pkti;
> +       int len = skb->len;
> +       unsigned int queue_index = 0;
> +       unsigned long long curtime, sendtime;
> +       signed long long delta = 0, delta_send;
> +       bool congestion_flag = false;
> +       bool drop_flag = false;
> +       bool cwr_flag = false;
> +       bool ecn_ce_flag = false;
> +       struct hbm_vqueue *qdp;
> +       struct hbm_queue_stats *qsp = NULL;
> +       int rv = ALLOW_PKT;

I'm not sure we enforce reverse Christmas tree for samples, but it
would be nice nevertheless :)

> +
> +       qsp = bpf_map_lookup_elem(&queue_stats, &queue_index);
> +       if (qsp != NULL && !qsp->loopback && (skb->ifindex == 1))
> +               return ALLOW_PKT;
> +
> +       hbm_get_pkt_info(skb, &pkti);
> +
> +       // We may want to account for the length of headers in len
> +       // calculation, like ETH header + overhead, specially if it
> +       // is a gso packet. But I am not doing it right now.
> +
> +       qdp = bpf_get_local_storage(&queue_state, 0);
> +       if (!qdp)
> +               return ALLOW_PKT;
> +       else if (qdp->lasttime == 0)

nit: no need for else here

> +               hbm_init_edt_vqueue(qdp, 1024);
> +
> +       curtime = bpf_ktime_get_ns();
> +
> +       // Begin critical section
> +       bpf_spin_lock(&qdp->lock);
> +       delta = qdp->lasttime - ((signed long long) curtime);

You can drop signed long long cast here, it will be forced back to
unsigned long long by C "Usual arithmetic conversions" rule. But in
the end diff will be assigned to signed delta, so it shouldn't matter.

> +       // bound bursts to 100us
> +       if (delta < -BURST_SIZE_NS) {
> +               // negative delta is a credit that allows bursts
> +               qdp->lasttime = curtime - BURST_SIZE_NS;
> +               delta = -BURST_SIZE_NS;
> +       }
> +       sendtime = qdp->lasttime;
> +       delta_send = BYTES_TO_NS(len, qdp->rate);
> +       __sync_add_and_fetch(&(qdp->lasttime), delta_send);

Do you need __sync_add_and_fetch here? You are in critical section
anyway, so can do just:

qdp->lasttime += delta_send;

> +       bpf_spin_unlock(&qdp->lock);
> +       // End critical section
> +
> +       // Set EDT of packet
> +       skb->tstamp = sendtime;
> +
> +       // Check if we should update rate
> +       if (qsp != NULL && (qsp->rate * 128) != qdp->rate) {
> +               qdp->rate = qsp->rate * 128;
> +               bpf_printk("Updating rate: %d (1sec:%llu bits)\n",
> +                          (int)qdp->rate,
> +                          CREDIT_PER_NS(1000000000, qdp->rate) * 8);
> +       }
> +
> +       // Set flags (drop, congestion, cwr)
> +       // last packet will be sent in the future, bound latency
> +       if (delta > DROP_THRESH_NS || (delta > LARGE_PKT_DROP_THRESH_NS &&
> +                                      len > LARGE_PKT_THRESH)) {
> +               drop_flag = true;
> +               if (pkti.is_tcp && pkti.ecn == 0)
> +                       cwr_flag = true;
> +       } else if (delta > MARK_THRESH_NS) {
> +               if (pkti.is_tcp)
> +                       congestion_flag = true;
> +               else
> +                       drop_flag = true;
> +       }
> +
> +       if (congestion_flag) {
> +               if (bpf_skb_ecn_set_ce(skb)) {
> +                       ecn_ce_flag = true;
> +               } else {
> +                       if (pkti.is_tcp) {
> +                               unsigned int rand = bpf_get_prandom_u32();
> +
> +                               if (delta >= MARK_THRESH_NS +
> +                                   (rand % MARK_REGION_SIZE_NS)) {
> +                                       // Do congestion control
> +                                       cwr_flag = true;
> +                               }
> +                       } else if (len > LARGE_PKT_THRESH) {
> +                               // Problem if too many small packets?
> +                               drop_flag = true;
> +                               congestion_flag = false;
> +                       }
> +               }
> +       }
> +
> +       if (pkti.is_tcp && drop_flag && pkti.packets_out <= 1) {
> +               drop_flag = false;
> +               cwr_flag = true;
> +               congestion_flag = false;
> +       }
> +
> +       if (qsp != NULL)
> +               if (qsp->no_cn)

if (qsp && qsp->no_cn) ?

> +                       cwr_flag = false;
> +
> +       hbm_update_stats(qsp, len, curtime, congestion_flag, drop_flag,
> +                        cwr_flag, ecn_ce_flag, &pkti, (int) delta);
> +
> +       if (drop_flag) {
> +               __sync_add_and_fetch(&(qdp->credit), len);

you are not using qdp->credit for this algorithm, so no need to update it here.

> +               rv = DROP_PKT;
> +       }
> +
> +       if (cwr_flag)
> +               rv |= 2;

define constant for 2 similar to ALLOW_PKT and DROP_PKT?

> +       return rv;
> +}
> +char _license[] SEC("license") = "GPL";
> diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
> index be19cf1d5cd5..1a3502e3c8aa 100644
> --- a/samples/bpf/hbm_kern.h
> +++ b/samples/bpf/hbm_kern.h
> @@ -45,8 +45,18 @@
>  #define MAX_CREDIT             (100 * MAX_BYTES_PER_PACKET)
>  #define INIT_CREDIT            (INITIAL_CREDIT_PACKETS * MAX_BYTES_PER_PACKET)
>
> +// Time base accounting for fq's EDT
> +#define BURST_SIZE_NS          100000 // 100us
> +#define MARK_THRESH_NS         50000 // 50us
> +#define DROP_THRESH_NS         500000 // 500us
> +// Reserve 20us of queuing for small packets (less than 120 bytes)
> +#define LARGE_PKT_DROP_THRESH_NS (DROP_THRESH_NS - 20000)
> +#define MARK_REGION_SIZE_NS    (LARGE_PKT_DROP_THRESH_NS - MARK_THRESH_NS)
> +
>  // rate in bytes per ns << 20
>  #define CREDIT_PER_NS(delta, rate) ((((u64)(delta)) * (rate)) >> 20)
> +#define BYTES_PER_NS(delta, rate) ((((u64)(delta)) * (rate)) >> 20)
> +#define BYTES_TO_NS(bytes, rate) div64_u64(((u64)(bytes)) << 20, (u64)(rate))
>
>  struct bpf_map_def SEC("maps") queue_state = {
>         .type = BPF_MAP_TYPE_CGROUP_STORAGE,
> @@ -67,6 +77,7 @@ BPF_ANNOTATE_KV_PAIR(queue_stats, int, struct hbm_queue_stats);
>  struct hbm_pkt_info {
>         int     cwnd;
>         int     rtt;
> +       int     packets_out;
>         bool    is_ip;
>         bool    is_tcp;
>         short   ecn;
> @@ -86,16 +97,20 @@ static int get_tcp_info(struct __sk_buff *skb, struct hbm_pkt_info *pkti)
>                                 if (tp) {
>                                         pkti->cwnd = tp->snd_cwnd;
>                                         pkti->rtt = tp->srtt_us >> 3;
> +                                       pkti->packets_out = tp->packets_out;
>                                         return 0;
>                                 }
>                         }
>                 }
>         }
> +       pkti->cwnd = 0;
> +       pkti->rtt = 0;
> +       pkti->packets_out = 0;
>         return 1;
>  }
>
> -static __always_inline void hbm_get_pkt_info(struct __sk_buff *skb,
> -                                            struct hbm_pkt_info *pkti)
> +static void hbm_get_pkt_info(struct __sk_buff *skb,
> +                            struct hbm_pkt_info *pkti)
>  {
>         struct iphdr iph;
>         struct ipv6hdr *ip6h;
> @@ -123,10 +138,22 @@ static __always_inline void hbm_get_pkt_info(struct __sk_buff *skb,
>
>  static __always_inline void hbm_init_vqueue(struct hbm_vqueue *qdp, int rate)
>  {
> -               bpf_printk("Initializing queue_state, rate:%d\n", rate * 128);
> -               qdp->lasttime = bpf_ktime_get_ns();
> -               qdp->credit = INIT_CREDIT;
> -               qdp->rate = rate * 128;
> +       bpf_printk("Initializing queue_state, rate:%d\n", rate * 128);
> +       qdp->lasttime = bpf_ktime_get_ns();
> +       qdp->credit = INIT_CREDIT;
> +       qdp->rate = rate * 128;
> +}
> +
> +static __always_inline void hbm_init_edt_vqueue(struct hbm_vqueue *qdp,
> +                                               int rate)
> +{
> +       unsigned long long curtime;
> +
> +       curtime = bpf_ktime_get_ns();
> +       bpf_printk("Initializing queue_state, rate:%d\n", rate * 128);
> +       qdp->lasttime = curtime - BURST_SIZE_NS;        // support initial burst
> +       qdp->credit = 0;                                // not used
> +       qdp->rate = rate * 128;
>  }
>
>  static __always_inline void hbm_update_stats(struct hbm_queue_stats *qsp,
> --
> 2.17.1
>
