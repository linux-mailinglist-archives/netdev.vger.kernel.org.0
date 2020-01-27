Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F052F14A31A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgA0LhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:37:09 -0500
Received: from www62.your-server.de ([213.133.104.62]:50590 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730237AbgA0LhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:37:08 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw2Kh-0000X8-0Z; Mon, 27 Jan 2020 12:13:31 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iw2Kg-000NlG-O3; Mon, 27 Jan 2020 12:13:30 +0100
Subject: Re: [PATCH bpf-next v4 00/12] Extend SOCKMAP to store listening
 sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f82cfdef-6674-d7c8-4173-cd6488dd4b9c@iogearbox.net>
Date:   Mon, 27 Jan 2020 12:13:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25707/Sun Jan 26 12:40:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 4:55 PM, Jakub Sitnicki wrote:
[...]
> Jakub Sitnicki (12):
>    bpf, sk_msg: Don't clear saved sock proto on restore
>    net, sk_msg: Annotate lockless access to sk_prot on clone
>    net, sk_msg: Clear sk_user_data pointer on clone if tagged
>    tcp_bpf: Don't let child socket inherit parent protocol ops on copy
>    bpf, sockmap: Allow inserting listening TCP sockets into sockmap
>    bpf, sockmap: Don't set up sockmap progs for listening sockets
>    bpf, sockmap: Return socket cookie on lookup from syscall
>    bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
>    bpf: Allow selecting reuseport socket from a SOCKMAP
>    net: Generate reuseport group ID on group creation
>    selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
>    selftests/bpf: Tests for SOCKMAP holding listening sockets
> 
>   include/linux/skmsg.h                         |   15 +-
>   include/net/sock.h                            |   37 +-
>   include/net/sock_reuseport.h                  |    2 -
>   include/net/tcp.h                             |    7 +
>   kernel/bpf/reuseport_array.c                  |    5 -
>   kernel/bpf/verifier.c                         |    6 +-
>   net/core/filter.c                             |   27 +-
>   net/core/skmsg.c                              |    2 +-
>   net/core/sock.c                               |   11 +-
>   net/core/sock_map.c                           |  133 +-
>   net/core/sock_reuseport.c                     |   50 +-
>   net/ipv4/tcp_bpf.c                            |   17 +-
>   net/ipv4/tcp_minisocks.c                      |    2 +
>   net/ipv4/tcp_ulp.c                            |    3 +-
>   net/tls/tls_main.c                            |    3 +-
>   .../bpf/prog_tests/select_reuseport.c         |   60 +-
>   .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
>   .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
>   tools/testing/selftests/bpf/test_maps.c       |    6 +-
>   19 files changed, 1811 insertions(+), 107 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> 

Unfortunately, the series needs one last rebase in order to be applied due
to conflicts from John's earlier sockmap/tls fixes from Jan/11th [0].

Thanks a lot,
Daniel

   [0] https://patchwork.ozlabs.org/cover/1221534/
