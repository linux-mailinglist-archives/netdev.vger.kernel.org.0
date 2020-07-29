Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558C52327DD
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgG2XGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:06:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:55470 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgG2XGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:06:21 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0v9O-0006ej-2h; Thu, 30 Jul 2020 01:06:18 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0v9N-000XNc-Ta; Thu, 30 Jul 2020 01:06:17 +0200
Subject: Re: [PATCH v4 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     torvalds@linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200724203830.81531-1-alexei.starovoitov@gmail.com>
 <20200724203830.81531-4-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cbf754f2-714f-1493-09c9-b01cc4c3f70d@iogearbox.net>
Date:   Thu, 30 Jul 2020 01:06:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200724203830.81531-4-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 10:38 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add kernel module with user mode driver that populates bpffs with
> BPF iterators.
> 
> $ mount bpffs /my/bpffs/ -t bpf
> $ ls -la /my/bpffs/
> total 4
> drwxrwxrwt  2 root root    0 Jul  2 00:27 .
> drwxr-xr-x 19 root root 4096 Jul  2 00:09 ..
> -rw-------  1 root root    0 Jul  2 00:27 maps.debug
> -rw-------  1 root root    0 Jul  2 00:27 progs.debug
> 
> The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
> maps, load two BPF programs, attach them to BPF iterators, and finally send two
> bpf_link IDs back to the kernel.
> The kernel will pin two bpf_links into newly mounted bpffs instance under
> names "progs.debug" and "maps.debug". These two files become human readable.
> 
> $ cat /my/bpffs/progs.debug
>    id name            attached
>    11 dump_bpf_map    bpf_iter_bpf_map
>    12 dump_bpf_prog   bpf_iter_bpf_prog
>    27 test_pkt_access
>    32 test_main       test_pkt_access test_pkt_access
>    33 test_subprog1   test_pkt_access_subprog1 test_pkt_access
>    34 test_subprog2   test_pkt_access_subprog2 test_pkt_access
>    35 test_subprog3   test_pkt_access_subprog3 test_pkt_access
>    36 new_get_skb_len get_skb_len test_pkt_access
>    37 new_get_skb_ifindex get_skb_ifindex test_pkt_access
>    38 new_get_constant get_constant test_pkt_access
> 
> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> all BPF programs currently loaded in the system. This information is unstable
> and will change from kernel to kernel as ".debug" suffix conveys.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Looks like this needs one last respin, but either way the module handling looks much
cleaner now, Ack.

Thanks,
Daniel
