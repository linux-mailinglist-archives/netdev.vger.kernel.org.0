Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD5B5E74A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfGCPDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:03:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:53334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:03:10 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1higmq-0001Ul-5r; Wed, 03 Jul 2019 17:03:08 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1higmp-000LtI-VV; Wed, 03 Jul 2019 17:03:08 +0200
Subject: Re: [PATCH v4 bpf-next] bpf: Add support for fq's EDT to HBM
To:     brakmo <brakmo@fb.com>, netdev <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20190702220952.3929270-1-brakmo@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b84ea6a0-2215-6cf0-912d-fb2be8217bab@iogearbox.net>
Date:   Wed, 3 Jul 2019 17:03:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190702220952.3929270-1-brakmo@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2019 12:09 AM, brakmo wrote:
> Adds support for fq's Earliest Departure Time to HBM (Host Bandwidth
> Manager). Includes a new BPF program supporting EDT, and also updates
> corresponding programs.
> 
> It will drop packets with an EDT of more than 500us in the future
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
> v1 -> v2: Incorporated Andrii's suggestions
> v2 -> v3: Incorporated Yonghong's suggestions
> v3 -> v4: Removed credit update that is not needed
> 
> Signed-off-by: Lawrence Brakmo <brakmo@fb.com>

Applied, thanks!
