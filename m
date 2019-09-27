Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE9C062C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfI0NSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:18:16 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40230 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfI0NSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 09:18:15 -0400
Received: by mail-yw1-f67.google.com with SMTP id e205so874288ywc.7
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 06:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tqFeCHhmmMXw+Lzy82GJwsQSn9mRnC6ZvcmnfufuB2Q=;
        b=pWiT7HZF3snL8mSPjPxDgPvG+59arMsilpoEL9ZFopYfybJzLzBHnWge+N29difp8i
         UyeDpSA0hX8BUmfU7+TzEF6j3oeC1qU27NCMEJSitV3uyVDRkU9gKcie1Ux9joRuiW1Q
         65W3KI3v7+8QQzlxdHDU7zunTDs5u6zP9bpqMyzkEaX5Vx5nhauOqqtj0/xkns+FNeli
         NCK2v5iiUeEVsO5fQGtrFoS/5U7AKTkDWOLA9JPddnLyi8kehEimfVOzbQljrC5tOony
         bRyzL0KufBc5AEVUqSx5lKDPEyC/VOyYitrLHSRFRdPdXff5z5gokAOO3padgNiYu5gi
         996A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tqFeCHhmmMXw+Lzy82GJwsQSn9mRnC6ZvcmnfufuB2Q=;
        b=jHzfakfl+ZIw3jx5tUukjdnl2JBuQdA41HODGcqs/cxzCGZFf/zGWKaVXJqvm2Q+Mn
         usWgCPkloIduutXsKhnagMk7y3uPlwRbMW4PrvW/T9lcLJdTXjvmsUvm3918lkXbtAkX
         sWezrKWWyihg1TrluWQLFETMydEQOHsrFZegYx7zDCZaGgPZa4vk/cNwMR/sxZYSSb4G
         GIkr7aiYmgdaawh8fUC0r0DVp/xUtnXIWGfIjrJNVioA3UcC4TjDfUlqGmEgErc5XesX
         MIVBY18ozimvMCu1iYjKlxvAsi4NLjHGP314MLQQlmcu/XuXmHfNko4M6fuNuCa85fsH
         2t9g==
X-Gm-Message-State: APjAAAW2ntqwFJTLDfj3cJxXW0XGLnz7c5LVJpcy/2DD2ljDOV2XJtza
        Hwo4q8MShT/TF3oPTsAilbP5IfWspjlPLdWJ+hmKFw==
X-Google-Smtp-Source: APXvYqwHCPYqykF2OkhPWKeKPIDCWoJtz6RmFRmEi2Ahwy8Sp+m2LmQccRFgVWNpQHd9I7xubS6Kqb8ELgtFGyF74ao=
X-Received: by 2002:a0d:fd03:: with SMTP id n3mr2623997ywf.146.1569590293715;
 Fri, 27 Sep 2019 06:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAGHK07B9E0AOBNtqVqKyJQOdU7ijdVi-7jLwnH+=S7ZgG5kpeA@mail.gmail.com>
 <20190927124017.26996-1-marek@cloudflare.com>
In-Reply-To: <20190927124017.26996-1-marek@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Sep 2019 06:18:02 -0700
Message-ID: <CANn89iKhKTXukDArB3gLt=jSxL3kdtvtVNA0omrpn4w6-EyXzQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     David Miller <davem@davemloft.net>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 5:40 AM Marek Majkowski <marek@cloudflare.com> wrote:
>
> On 9/27/19 10:25 AM, Jonathan Maxwell wrote:
> > Acked-by: Jon Maxwell <jmaxwell37@gmail.com>
> >
> > Thanks for fixing that Eric.
> >
>
> The patch seems to do the job.
>
> Tested-by: Marek Majkowski <marek@cloudflare.com>
>
> Here's a selftest:
>

Here is the packetdrill test :

`../common/defaults.sh`
    0 socket(..., SOCK_STREAM | SOCK_NONBLOCK, IPPROTO_TCP) = 4
   +0 setsockopt(4, SOL_TCP, TCP_USER_TIMEOUT, [8000], 4) = 0

   +0 sendto(4, ..., 1000, MSG_FASTOPEN, ..., ...) = -1
   +0 > S 0:0(0) <mss 1460,sackOK,TS val 100 ecr 0,nop,wscale 8>
   +1 > S 0:0(0) <mss 1460,sackOK,TS val 1100 ecr 0,nop,wscale 8>
   +2 > S 0:0(0) <mss 1460,sackOK,TS val 3100 ecr 0,nop,wscale 8>
   +4 > S 0:0(0) <mss 1460,sackOK,TS val 7100 ecr 0,nop,wscale 8>

  +10 write(4, ..., 1000) = -1 ETIMEDOUT (Connection Timed Out)
   +0 %{ assert tcpi_state == TCP_CLOSE }%
   +0 < S. 1234:1234(0) ack 1 win 5840 <mss 1460,sackOK,TS val 987134
ecr 7100,nop,wscale 8>
   +0 > R 1:1(0)



> ---8<---
> From: Marek Majkowski <marek@cloudflare.com>
> Date: Fri, 27 Sep 2019 13:37:52 +0200
> Subject: [PATCH] selftests/net: TCP_USER_TIMEOUT in SYN-SENT state
>
> Test the TCP_USER_TIMEOUT behavior, overriding TCP_SYNCNT
> when socket is in SYN-SENT state.
>
> Signed-off-by: Marek Majkowski <marek@cloudflare.com>
> ---
>  tools/testing/selftests/net/.gitignore        |   1 +
>  tools/testing/selftests/net/Makefile          |   3 +-
>  .../selftests/net/tcp_user_timeout_syn_sent.c | 322 ++++++++++++++++++
>  .../net/tcp_user_timeout_syn_sent.sh          |   4 +
>  4 files changed, 329 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
>  create mode 100755 tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh
>
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index c7cced739c34..bc6a2b7199b6 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -21,3 +21,4 @@ ipv6_flowlabel
>  ipv6_flowlabel_mgr
>  so_txtime
>  tcp_fastopen_backup_key
> +tcp_user_timeout_syn_sent
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 0bd6b23c97ef..065a171b8834 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -11,13 +11,14 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
>  TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
>  TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
>  TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh
> +TEST_PROGS += tcp_user_timeout_syn_sent.sh
>  TEST_PROGS_EXTENDED := in_netns.sh
>  TEST_GEN_FILES =  socket nettest
>  TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
>  TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
>  TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
>  TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
> -TEST_GEN_FILES += tcp_fastopen_backup_key
> +TEST_GEN_FILES += tcp_fastopen_backup_key tcp_user_timeout_syn_sent
>  TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
>  TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
>
> diff --git a/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
> new file mode 100644
> index 000000000000..1c9ec582359a
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
> @@ -0,0 +1,322 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Testing if TCP_USER_TIMEOUT on SYN-SENT state overides TCP_SYNCNT.
> + *
> + * Historically, TCP_USER_TIMEOUT made only sense on synchronized TCP
> + * states, like ESTABLISHED. There was a bug on SYN-SENT state: with
> + * TCP_USER_TIMEOUT set, the connect() would ETIMEDOUT after given
> + * time, but near the end of the timer would flood SYN packets to
> + * fulfill the TCP_SYNCNT counter. For example for 2000ms user
> + * timeout and default TCP_SYNCNT=6, the tcpdump would look like:
> + *
> + * 00:00.000000 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:01.029452 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:02.021354 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:02.033419 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:02.041633 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:02.049263 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + * 00:02.057264 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
> + *
> + * Notice, 5 out of 6 retransmissions are aligned to 2s. We fixed
> + * that, and this code tests for the regression. We do this by
> + * actively dropping SYN packets on listen socket with ebpf
> + * SOCKET_FILTER, and counting how many packets did we drop.
> + *
> + * See: https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
> + */
> +#include <arpa/inet.h>
> +#include <errno.h>
> +#include <error.h>
> +#include <linux/bpf.h>
> +#include <linux/tcp.h>
> +#include <linux/unistd.h>
> +#include <netinet/in.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <unistd.h>
> +
> +int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
> +                  int max_entries, uint32_t map_flags)
> +{
> +       union bpf_attr attr = {};
> +
> +       attr.map_type = map_type;
> +       attr.key_size = key_size;
> +       attr.value_size = value_size;
> +       attr.max_entries = max_entries;
> +       attr.map_flags = map_flags;
> +       return syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
> +}
> +
> +int bpf_load_program(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
> +                    size_t insns_cnt, const char *license,
> +                    uint32_t kern_version)
> +{
> +       union bpf_attr attr = {};
> +
> +       attr.prog_type = prog_type;
> +       attr.insns = (long)insns;
> +       attr.insn_cnt = insns_cnt;
> +       attr.license = (long)license;
> +       attr.log_buf = (long)NULL;
> +       attr.log_size = 0;
> +       attr.log_level = 0;
> +       attr.kern_version = kern_version;
> +
> +       int fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
> +       return fd;
> +}
> +
> +int bpf_map_update_elem(int fd, const void *key, const void *value,
> +                       uint64_t flags)
> +{
> +       union bpf_attr attr = {};
> +
> +       attr.map_fd = fd;
> +       attr.key = (long)key;
> +       attr.value = (long)value;
> +       attr.flags = flags;
> +
> +       return syscall(__NR_bpf, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
> +}
> +
> +int bpf_map_lookup_elem(int fd, const void *key, void *value)
> +{
> +       union bpf_attr attr = {};
> +
> +       attr.map_fd = fd;
> +       attr.key = (long)key;
> +       attr.value = (long)value;
> +
> +       return syscall(__NR_bpf, BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
> +}
> +
> +/*
> +struct bpf_map_def SEC("maps") stats_map = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(uint32_t),
> +       .value_size = sizeof(uint64_t),
> +       .max_entries = 2,
> +};
> +
> +SEC("socket_filter")
> +int _socket_filter(struct __sk_buff *skb)
> +{
> +       (void)skb;
> +
> +       uint32_t no = 0;
> +       uint64_t *value = bpf_map_lookup_elem(&stats_map, &no);
> +       if (value) {
> +               __sync_fetch_and_add(value, 1);
> +       }
> +       return 0; // DROP inbound SYN packets
> +}
> + */
> +
> +size_t bpf_insn_socket_filter_cnt = 12;
> +struct bpf_insn bpf_insn_socket_filter[] = {
> +       {
> +               .code = 0xb7,
> +               .dst_reg = BPF_REG_1,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0x63,
> +               .dst_reg = BPF_REG_10,
> +               .src_reg = BPF_REG_1,
> +               .off = -4,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0xbf,
> +               .dst_reg = BPF_REG_2,
> +               .src_reg = BPF_REG_10,
> +               .off = 0,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0x7,
> +               .dst_reg = BPF_REG_2,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = -4 /**/
> +       },
> +       {
> +               .code = 0x18,
> +               .dst_reg = BPF_REG_1,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 0 /* relocation for stats_map */
> +       },
> +       {
> +               .code = 0x0,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0x85,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 1 /**/
> +       },
> +       {
> +               .code = 0x15,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_0,
> +               .off = 2,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0xb7,
> +               .dst_reg = BPF_REG_1,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 1 /**/
> +       },
> +       {
> +               .code = 0xdb,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_1,
> +               .off = 0,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0xb7,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 0 /**/
> +       },
> +       {
> +               .code = 0x95,
> +               .dst_reg = BPF_REG_0,
> +               .src_reg = BPF_REG_0,
> +               .off = 0,
> +               .imm = 0 /**/
> +       }
> +};
> +
> +void socket_filter_fill_stats_map(int fd)
> +{
> +       bpf_insn_socket_filter[4].src_reg = BPF_REG_1;
> +       bpf_insn_socket_filter[4].imm = fd;
> +}
> +
> +static int net_setup_ebpf(int sd)
> +{
> +       int stats_map, bpf, r;
> +
> +       stats_map = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
> +                                  sizeof(uint64_t), 2, 0);
> +       if (stats_map < 0)
> +               error(1, errno, "bpf");
> +
> +       socket_filter_fill_stats_map(stats_map);
> +
> +       bpf = bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER,
> +                              bpf_insn_socket_filter,
> +                              bpf_insn_socket_filter_cnt, "Dual BSD/GPL", 0);
> +       if (bpf < 0)
> +               error(1, errno, "bpf");
> +
> +       r = setsockopt(sd, SOL_SOCKET, SO_ATTACH_BPF, &bpf, sizeof(bpf));
> +       if (r < 0)
> +               error(1, errno, "setsockopt(SO_ATTACH_FILTER)");
> +
> +       return stats_map;
> +}
> +
> +static int setup_server(struct sockaddr_in *addr)
> +{
> +       int sd, r;
> +       socklen_t addr_sz;
> +
> +       sd = socket(AF_INET, SOCK_STREAM, 0);
> +       if (sd < 0)
> +               error(1, errno, "socket()");
> +
> +       r = bind(sd, (struct sockaddr *)addr, sizeof(*addr));
> +       if (r != 0)
> +               error(1, errno, "bind()");
> +
> +       r = listen(sd, 16);
> +       if (r != 0)
> +               error(1, errno, "listen()");
> +
> +       addr_sz = sizeof(*addr);
> +       r = getsockname(sd, (struct sockaddr *)addr, &addr_sz);
> +       if (r != 0)
> +               error(1, errno, "getsockname()");
> +
> +       return sd;
> +}
> +
> +int main(void)
> +{
> +       struct sockaddr_in addr = {
> +               .sin_family = AF_INET,
> +               .sin_addr = { inet_addr("127.0.0.1") },
> +       };
> +
> +       int sd = setup_server(&addr);
> +       int stats_map = net_setup_ebpf(sd);
> +       struct {
> +               int user_timeout;
> +               int expected_counter;
> +       } tests[] = {
> +               { 200, 2 }, // TCP_USER_TIMEOUT kicks in on first retranmission
> +               { 1500, 2 },
> +               { 3500, 3 },
> +               { -1, -1 },
> +       };
> +
> +       int failed = 0, i;
> +
> +       for (i = 0; tests[i].user_timeout >= 0; i++) {
> +               int r, cd, v;
> +               uint32_t k = 0;
> +               uint64_t counter = 0;
> +
> +               r = bpf_map_update_elem(stats_map, &k, &counter, 0);
> +
> +               cd = socket(AF_INET, SOCK_STREAM, 0);
> +               if (cd < 0)
> +                       error(1, errno, "socket()");
> +
> +               v = tests[i].user_timeout;
> +               r = setsockopt(cd, IPPROTO_TCP, TCP_USER_TIMEOUT, &v,
> +                              sizeof(v));
> +               if (r != 0)
> +                       error(1, errno, "setsockopt()");
> +
> +               r = connect(cd, (struct sockaddr *)&addr, sizeof(addr));
> +               if (r != -1 && errno != ETIMEDOUT)
> +                       error(1, errno, "connect()");
> +
> +               r = bpf_map_lookup_elem(stats_map, &k, &counter);
> +               if (r != 0)
> +                       error(1, errno, "bpf_map_lookup_elem()");
> +
> +               if ((int)counter != tests[i].expected_counter) {
> +                       failed += 1;
> +                       printf("[!] Expecting %d SYN packets on "
> +                              "TCP_USER_TIMEOUT=%d, got %d\n",
> +                              tests[i].expected_counter, tests[i].user_timeout,
> +                              (int)counter);
> +               }
> +               close(cd);
> +       }
> +       close(sd);
> +       close(stats_map);
> +       if (failed == 0)
> +               fprintf(stderr, "PASSED\n");
> +       return failed;
> +}
> diff --git a/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh
> new file mode 100755
> index 000000000000..26765f3a92c6
> --- /dev/null
> +++ b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./in_netns.sh ./tcp_user_timeout_syn_sent
> --
> 2.17.1
>
