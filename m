Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3220417EC3B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCIWoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:44:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:50918 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgCIWoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:44:20 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jBR89-00030S-5k; Mon, 09 Mar 2020 23:44:14 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jBR88-000JCt-Tu; Mon, 09 Mar 2020 23:44:12 +0100
Subject: Re: [PATCH bpf-next v4 00/12] bpf: sockmap, sockhash: support storing
 UDP sockets
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200309111243.6982-1-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5525dcc1-c77d-eb99-302f-2aca58ec56fc@iogearbox.net>
Date:   Mon, 9 Mar 2020 23:44:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200309111243.6982-1-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25746/Mon Mar  9 12:13:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/20 12:12 PM, Lorenz Bauer wrote:
> I've adressed John's nit in patch 3, and added the reviews and acks.
> 
> Changes since v3:
> - Clarify !psock check in sock_map_link_no_progs
> 
> Changes since v2:
> - Remove sk_psock_hooks based on Jakub's idea
> - Fix reference to tcp_bpf_clone in commit message
> - Add inet_csk_has_ulp helper
> 
> Changes since v1:
> - Check newsk->sk_prot in tcp_bpf_clone
> - Fix compilation with BPF_STREAM_PARSER disabled
> - Use spin_lock_init instead of static initializer
> - Elaborate on TCPF_SYN_RECV
> - Cosmetic changes to TEST macros, and more tests
> - Add Jakub and me as maintainers
> 
> Lorenz Bauer (12):
>    bpf: sockmap: only check ULP for TCP sockets
>    skmsg: update saved hooks only once
>    bpf: tcp: move assertions into tcp_bpf_get_proto
>    bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
>    bpf: sockmap: move generic sockmap hooks from BPF TCP
>    bpf: sockmap: simplify sock_map_init_proto
>    bpf: add sockmap hooks for UDP sockets
>    bpf: sockmap: add UDP support
>    selftests: bpf: don't listen() on UDP sockets
>    selftests: bpf: add tests for UDP sockets in sockmap
>    selftests: bpf: enable UDP sockmap reuseport tests
>    bpf, doc: update maintainers for L7 BPF
> 
>   MAINTAINERS                                   |   3 +
>   include/linux/bpf.h                           |   4 +-
>   include/linux/skmsg.h                         |  56 ++---
>   include/net/inet_connection_sock.h            |   6 +
>   include/net/tcp.h                             |  20 +-
>   include/net/udp.h                             |   5 +
>   net/core/sock_map.c                           | 157 +++++++++++---
>   net/ipv4/Makefile                             |   1 +
>   net/ipv4/tcp_bpf.c                            | 114 ++--------
>   net/ipv4/tcp_ulp.c                            |   7 -
>   net/ipv4/udp_bpf.c                            |  53 +++++
>   .../bpf/prog_tests/select_reuseport.c         |   6 -
>   .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
>   13 files changed, 402 insertions(+), 234 deletions(-)
>   create mode 100644 net/ipv4/udp_bpf.c
> 

Applied, thanks!
