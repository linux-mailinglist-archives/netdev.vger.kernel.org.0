Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F2B5E755
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGCPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:04:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:53630 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCPER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:04:17 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hignm-0001YH-22; Wed, 03 Jul 2019 17:04:06 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hignl-000UvV-S9; Wed, 03 Jul 2019 17:04:05 +0200
Subject: Re: [PATCH bpf-next v2 0/8] bpf: TCP RTT sock_ops bpf callback
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
References: <20190702161403.191066-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86dedabd-05fd-df3b-210b-8d9b0158146c@iogearbox.net>
Date:   Wed, 3 Jul 2019 17:04:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 06:13 PM, Stanislav Fomichev wrote:
> Congestion control team would like to have a periodic callback to
> track some TCP statistics. Let's add a sock_ops callback that can be
> selectively enabled on a socket by socket basis and is executed for
> every RTT. BPF program frequency can be further controlled by calling
> bpf_ktime_get_ns and bailing out early.
> 
> I run neper tcp_stream and tcp_rr tests with the sample program
> from the last patch and didn't observe any noticeable performance
> difference.
> 
> v2:
> * add a comment about second accept() in selftest (Yonghong Song)
> * refer to tcp_bpf.readme in sample program (Yonghong Song)
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Priyaranjan Jha <priyarjha@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> 
> Stanislav Fomichev (8):
>   bpf: add BPF_CGROUP_SOCK_OPS callback that is executed on every RTT
>   bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation
>   bpf: add dsack_dups/delivered{,_ce} to bpf_tcp_sock
>   bpf: add icsk_retransmits to bpf_tcp_sock
>   bpf/tools: sync bpf.h
>   selftests/bpf: test BPF_SOCK_OPS_RTT_CB
>   samples/bpf: add sample program that periodically dumps TCP stats
>   samples/bpf: fix tcp_bpf.readme detach command
> 
>  include/net/tcp.h                           |   8 +
>  include/uapi/linux/bpf.h                    |  12 +-
>  net/core/filter.c                           | 207 +++++++++++-----
>  net/ipv4/tcp_input.c                        |   4 +
>  samples/bpf/Makefile                        |   1 +
>  samples/bpf/tcp_bpf.readme                  |   2 +-
>  samples/bpf/tcp_dumpstats_kern.c            |  68 ++++++
>  tools/include/uapi/linux/bpf.h              |  12 +-
>  tools/testing/selftests/bpf/Makefile        |   3 +-
>  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
>  tools/testing/selftests/bpf/test_tcp_rtt.c  | 254 ++++++++++++++++++++
>  11 files changed, 574 insertions(+), 58 deletions(-)
>  create mode 100644 samples/bpf/tcp_dumpstats_kern.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
>  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
> 

Applied, thanks!
