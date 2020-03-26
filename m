Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801BA193CBD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgCZKNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:13:44 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34948 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgCZKNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:13:44 -0400
Received: by mail-ot1-f66.google.com with SMTP id v2so675079oto.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 03:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuHCk77tCbCasAzyaJ+kKtIldZ0BFpvAAWnlvjwZyjA=;
        b=bD/WthBxaZlcC95kfdJ0n6oDY2wmwt34wz6P8tuXNk3ijRIgUhm3KF5dJy1EvR/3i1
         kwjpkUa7h0z9hOVLfylLKKsyR4Zr74vLPtkuudcM7PjaKmSNeXEvays8p3EBUzBJ8FzC
         8MjhmOe8jmoq5UJNsXdNY6axfwj5jJm2AUFdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuHCk77tCbCasAzyaJ+kKtIldZ0BFpvAAWnlvjwZyjA=;
        b=FbMyVycf24hfMFBrFVIeMBWqnvdDgl8C3bhh++MSI6mNSpjiwAwwbuaYtsltfym2md
         Mj7C6B9jxUXMpvSxno8VRsy2+T5SmbGhABOAXWimZeIKd11tBVso0EaBvyaSJ9Qqmd/0
         RpHUvzlBPiD0gk3IeAMRygOrmeMbcp1f5Wa9btFX2nBQ5xl2bUrZylJNoWo+F6CVk0V5
         GT5kWwztKswBoox+qVF09OsNG5hhuccGSEuO1V01qeI0O28k0lyNW3eOukGU/RogsZqG
         Je8kyBeZTEpPRMajWNLtZApmLFNAidC652YX1gIpf7/ZM2yPQpyZEXpGTMThQCw/c8qW
         uwUg==
X-Gm-Message-State: ANhLgQ10URy9mLo9uGnOjC99MeSzJ838TacPf1azE9TLdi86fyVVZiWm
        /y4oUN7PpO601zqmk8z3W2Fsfiqi0de34H4zSQZAGRf8Md4=
X-Google-Smtp-Source: ADFU+vugjRhDyNJmOxm2866DCF/Gm0RzUMZvyDFStmK8TUhFLERJ0VzNe6Q+DvNso1500XGyjFmDhSojzgqFnS4uqhw=
X-Received: by 2002:a9d:748e:: with SMTP id t14mr5942403otk.334.1585217623398;
 Thu, 26 Mar 2020 03:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
In-Reply-To: <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 26 Mar 2020 10:13:31 +0000
Message-ID: <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Yonghong Song <yhs@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 at 18:17, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/24/20 10:57 PM, Joe Stringer wrote:
> > From: Lorenz Bauer <lmb@cloudflare.com>
> >
> > Attach a tc direct-action classifier to lo in a fresh network
> > namespace, and rewrite all connection attempts to localhost:4321
> > to localhost:1234 (for port tests) and connections to unreachable
> > IPv4/IPv6 IPs to the local socket (for address tests).
> >
> > Keep in mind that both client to server and server to client traffic
> > passes the classifier.
> >
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > Co-authored-by: Joe Stringer <joe@wand.net.nz>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> > v2: Rebase onto test_progs infrastructure
> > v1: Initial commit
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   2 +-
> >   .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
> >   .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
> >   3 files changed, 372 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 7729892e0b04..4f7f83d059ca 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -76,7 +76,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   # Compile but not part of 'make run_tests'
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower
> > +     test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign
>
> No test_sk_assign any more as the test is integrated into test_progs, right?
>
> >
> >   TEST_CUSTOM_PROGS = urandom_read
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> > new file mode 100644
> > index 000000000000..1f0afcc20c48
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> > @@ -0,0 +1,244 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2018 Facebook
> > +// Copyright (c) 2019 Cloudflare
> > +// Copyright (c) 2020 Isovalent, Inc.
> > +/*
> > + * Test that the socket assign program is able to redirect traffic towards a
> > + * socket, regardless of whether the port or address destination of the traffic
> > + * matches the port.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +#include <fcntl.h>
> > +#include <signal.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +
> > +#include "test_progs.h"
> > +
> > +#define TEST_DPORT 4321
> > +#define TEST_DADDR (0xC0A80203)
> > +#define NS_SELF "/proc/self/ns/net"
> > +
> > +static __u32 duration;
> > +
> > +static bool configure_stack(int self_net)
>
> self_net parameter is not used.
>
> > +{
> > +     /* Move to a new networking namespace */
> > +     if (CHECK_FAIL(unshare(CLONE_NEWNET)))
> > +             return false;
>
> You can use CHECK to encode better error messages. Thhis is what
> most test_progs tests are using.
>
> > +     /* Configure necessary links, routes */
> > +     if (CHECK_FAIL(system("ip link set dev lo up")))
> > +             return false;
> > +     if (CHECK_FAIL(system("ip route add local default dev lo")))
> > +             return false;
> > +     if (CHECK_FAIL(system("ip -6 route add local default dev lo")))
> > +             return false;
> > +
> > +     /* Load qdisc, BPF program */
> > +     if (CHECK_FAIL(system("tc qdisc add dev lo clsact")))
> > +             return false;
> > +     if (CHECK_FAIL(system("tc filter add dev lo ingress bpf direct-action "
> > +                  "object-file ./test_sk_assign.o section sk_assign_test")))
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> > +static int start_server(const struct sockaddr *addr, socklen_t len)
> > +{
> > +     int fd;
> > +
> > +     fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > +     if (CHECK_FAIL(fd == -1))
> > +             goto out;
> > +     if (CHECK_FAIL(bind(fd, addr, len) == -1))
> > +             goto close_out;
> > +     if (CHECK_FAIL(listen(fd, 128) == -1))
> > +             goto close_out;
> > +
> > +     goto out;
> > +
> > +close_out:
> > +     close(fd);
> > +     fd = -1;
> > +out:
> > +     return fd;
> > +}
> > +
> > +static void handle_timeout(int signum)
> > +{
> > +     if (signum == SIGALRM)
> > +             fprintf(stderr, "Timed out while connecting to server\n");
> > +     kill(0, SIGKILL);
> > +}
> > +
> > +static struct sigaction timeout_action = {
> > +     .sa_handler = handle_timeout,
> > +};
> > +
> > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > +{
> > +     int fd = -1;
> > +
> > +     fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > +     if (CHECK_FAIL(fd == -1))
> > +             goto out;
> > +     if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > +             goto out;
>
> should this goto close_out?
>
> > +     alarm(3);
> > +     if (CHECK_FAIL(connect(fd, addr, len) == -1))
> > +             goto close_out;
> > +
> > +     goto out;
> > +
> > +close_out:
> > +     close(fd);
> > +     fd = -1;
> > +out:
> > +     return fd;
> > +}
> > +
> > +static in_port_t get_port(int fd)
> > +{
> > +     struct sockaddr_storage name;
> > +     socklen_t len;
> > +     in_port_t port = 0;
> > +
> > +     len = sizeof(name);
> > +     if (CHECK_FAIL(getsockname(fd, (struct sockaddr *)&name, &len)))
> > +             return port;
> > +
> > +     switch (name.ss_family) {
> > +     case AF_INET:
> > +             port = ((struct sockaddr_in *)&name)->sin_port;
> > +             break;
> > +     case AF_INET6:
> > +             port = ((struct sockaddr_in6 *)&name)->sin6_port;
> > +             break;
> > +     default:
> > +             CHECK(1, "Invalid address family", "%d\n", name.ss_family);
> > +     }
> > +     return port;
> > +}
> > +
> > +static int run_test(int server_fd, const struct sockaddr *addr, socklen_t len)
> > +{
> > +     int client = -1, srv_client = -1;
> > +     char buf[] = "testing";
> > +     in_port_t port;
> > +     int ret = 1;
> > +
> > +     client = connect_to_server(addr, len);
> > +     if (client == -1) {
> > +             perror("Cannot connect to server");
> > +             goto out;
> > +     }
> > +
> > +     srv_client = accept(server_fd, NULL, NULL);
> > +     if (CHECK_FAIL(srv_client == -1)) {
> > +             perror("Can't accept connection");
> > +             goto out;
> > +     }
> > +     if (CHECK_FAIL(write(client, buf, sizeof(buf)) != sizeof(buf))) {
> > +             perror("Can't write on client");
> > +             goto out;
> > +     }
> > +     if (CHECK_FAIL(read(srv_client, buf, sizeof(buf)) != sizeof(buf))) {
> > +             perror("Can't read on server");
> > +             goto out;
> > +     }
> > +
> > +     port = get_port(srv_client);
> > +     if (CHECK_FAIL(!port))
> > +             goto out;
> > +     if (CHECK(port != htons(TEST_DPORT), "Expected", "port %u but got %u",
> > +               TEST_DPORT, ntohs(port)))
> > +             goto out;
> > +
> > +     ret = 0;
> > +out:
> > +     close(client);
> > +     close(srv_client);
> > +     return ret;
> > +}
> > +
> > +static int do_sk_assign(void)
> > +{
> > +     struct sockaddr_in addr4;
> > +     struct sockaddr_in6 addr6;
> > +     int server = -1;
> > +     int server_v6 = -1;
> > +     int err = 1;
> > +
> > +     memset(&addr4, 0, sizeof(addr4));
> > +     addr4.sin_family = AF_INET;
> > +     addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> > +     addr4.sin_port = htons(1234);
> > +
> > +     memset(&addr6, 0, sizeof(addr6));
> > +     addr6.sin6_family = AF_INET6;
> > +     addr6.sin6_addr = in6addr_loopback;
> > +     addr6.sin6_port = htons(1234);
> > +
> > +     server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
> > +     if (server == -1)
> > +             goto out;
> > +
> > +     server_v6 = start_server((const struct sockaddr *)&addr6,
> > +                              sizeof(addr6));
> > +     if (server_v6 == -1)
> > +             goto out;
> > +
> > +     /* Connect to unbound ports */
> > +     addr4.sin_port = htons(TEST_DPORT);
> > +     addr6.sin6_port = htons(TEST_DPORT);
> > +
> > +     test__start_subtest("ipv4 port redir");
> > +     if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> > +             goto out;
> > +
> > +     test__start_subtest("ipv6 port redir");
> > +     if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> > +             goto out;
> > +
> > +     /* Connect to unbound addresses */
> > +     addr4.sin_addr.s_addr = htonl(TEST_DADDR);
> > +     addr6.sin6_addr.s6_addr32[3] = htonl(TEST_DADDR);
> > +
> > +     test__start_subtest("ipv4 addr redir");
> > +     if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> > +             goto out;
> > +
> > +     test__start_subtest("ipv6 addr redir");
> > +     if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> > +             goto out;
> > +
> > +     err = 0;
> > +out:
> > +     close(server);
> > +     close(server_v6);
> > +     return err;
> > +}
> > +
> > +void test_sk_assign(void)
> > +{
> > +     int self_net;
> > +
> > +     self_net = open(NS_SELF, O_RDONLY);
> > +     if (CHECK_FAIL(self_net < 0)) {
> > +             perror("Unable to open "NS_SELF);
> > +             return;
> > +     }
> > +
> > +     if (!configure_stack(self_net)) {
> > +             perror("configure_stack");
> > +             goto cleanup;
> > +     }
> > +
> > +     do_sk_assign();
> > +
> > +cleanup:
> > +     close(self_net);
>
> Did we exit the newly unshared net namespace and restored the previous
> namespace?
>
> > +}
> > diff --git a/tools/testing/selftests/bpf/progs/test_sk_assign.c b/tools/testing/selftests/bpf/progs/test_sk_assign.c
> > new file mode 100644
> > index 000000000000..7de30ad3f594
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_sk_assign.c
> > @@ -0,0 +1,127 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2019 Cloudflare Ltd.
> > +
> > +#include <stddef.h>
> > +#include <stdbool.h>
> > +#include <string.h>
> > +#include <linux/bpf.h>
> > +#include <linux/if_ether.h>
> > +#include <linux/in.h>
> > +#include <linux/ip.h>
> > +#include <linux/ipv6.h>
> > +#include <linux/pkt_cls.h>
> > +#include <linux/tcp.h>
> > +#include <sys/socket.h>
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_endian.h>
> > +
> > +int _version SEC("version") = 1;
> > +char _license[] SEC("license") = "GPL";
> > +
> > +/* Fill 'tuple' with L3 info, and attempt to find L4. On fail, return NULL. */
> > +static struct bpf_sock_tuple *get_tuple(void *data, __u64 nh_off,
> > +                                     void *data_end, __u16 eth_proto,
> > +                                     bool *ipv4)
> > +{
> > +     struct bpf_sock_tuple *result;
> > +     __u8 proto = 0;
> > +     __u64 ihl_len;
> > +
> > +     if (eth_proto == bpf_htons(ETH_P_IP)) {
> > +             struct iphdr *iph = (struct iphdr *)(data + nh_off);
> > +
> > +             if (iph + 1 > data_end)
> > +                     return NULL;
> > +             if (iph->ihl != 5)
> > +                     /* Options are not supported */
> > +                     return NULL;
> > +             ihl_len = iph->ihl * 4;
> > +             proto = iph->protocol;
> > +             *ipv4 = true;
> > +             result = (struct bpf_sock_tuple *)&iph->saddr;
> > +     } else if (eth_proto == bpf_htons(ETH_P_IPV6)) {
> > +             struct ipv6hdr *ip6h = (struct ipv6hdr *)(data + nh_off);
> > +
> > +             if (ip6h + 1 > data_end)
> > +                     return NULL;
> > +             ihl_len = sizeof(*ip6h);
> > +             proto = ip6h->nexthdr;
> > +             *ipv4 = false;
> > +             result = (struct bpf_sock_tuple *)&ip6h->saddr;
> > +     } else {
> > +             return NULL;
> > +     }
> > +
> > +     if (result + 1 > data_end || proto != IPPROTO_TCP)
> > +             return NULL;
> > +
> > +     return result;
> > +}
> > +
> > +SEC("sk_assign_test")
> > +int bpf_sk_assign_test(struct __sk_buff *skb)
> > +{
> > +     void *data_end = (void *)(long)skb->data_end;
> > +     void *data = (void *)(long)skb->data;
> > +     struct ethhdr *eth = (struct ethhdr *)(data);
> > +     struct bpf_sock_tuple *tuple, ln = {0};
> > +     struct bpf_sock *sk;
> > +     int tuple_len;
> > +     bool ipv4;
> > +     int ret;
> > +
> > +     if (eth + 1 > data_end)
> > +             return TC_ACT_SHOT;
> > +
> > +     tuple = get_tuple(data, sizeof(*eth), data_end, eth->h_proto, &ipv4);
> > +     if (!tuple)
> > +             return TC_ACT_SHOT;
> > +
> > +     tuple_len = ipv4 ? sizeof(tuple->ipv4) : sizeof(tuple->ipv6);
> > +     sk = bpf_skc_lookup_tcp(skb, tuple, tuple_len, BPF_F_CURRENT_NETNS, 0);
>
> You can get rid of tuple_len with
>         if (ipv4)
>                 sk = bpf_skc_lookup_tcp(..., sizeof(tuple->ipv4), ...);
>         else
>                 sk = bpf_skc_lookup_tcp(..., sizeof(tuple->ipv6), ...);
>
> and later on you can do common bpf_skc_lookup_tcp.
> But it may not be worthwhile to do it, as you have two separate calls
> in the above instead.
>
> > +     if (sk) {
> > +             if (sk->state != BPF_TCP_LISTEN)
> > +                     goto assign;
> > +
> > +             bpf_sk_release(sk);
> > +     }
> > +
> > +     if (ipv4) {
> > +             if (tuple->ipv4.dport != bpf_htons(4321))
> > +                     return TC_ACT_OK;
> > +
> > +             ln.ipv4.daddr = bpf_htonl(0x7f000001);
> > +             ln.ipv4.dport = bpf_htons(1234);
> > +
> > +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
> > +                                     BPF_F_CURRENT_NETNS, 0);
> > +     } else {
> > +             if (tuple->ipv6.dport != bpf_htons(4321))
> > +                     return TC_ACT_OK;
> > +
> > +             /* Upper parts of daddr are already zero. */
> > +             ln.ipv6.daddr[3] = bpf_htonl(0x1);
> > +             ln.ipv6.dport = bpf_htons(1234);
> > +
> > +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
> > +                                     BPF_F_CURRENT_NETNS, 0);
> > +     }
> > +
> > +     /* We can't do a single skc_lookup_tcp here, because then the compiler
> > +      * will likely spill tuple_len to the stack. This makes it lose all
> > +      * bounds information in the verifier, which then rejects the call as
> > +      * unsafe.
> > +      */
>
> This is a known issue. For scalars, only constant is restored properly
> in verifier at this moment. I did some hacking before to enable any
> scalars. The fear is this will make pruning performs worse. More
> study is needed here.

Of topic, but: this is actually one of the most challenging issues for
us when writing
BPF. It forces us to have very deep call graphs to hopefully avoid clang
spilling the constants. Please let me know if I can help in any way.

>
> > +     if (!sk)
> > +             return TC_ACT_SHOT;
> > +
> > +     if (sk->state != BPF_TCP_LISTEN) {
> > +             bpf_sk_release(sk);
> > +             return TC_ACT_SHOT;
> > +     }
> > +
> > +assign:
> > +     ret = bpf_sk_assign(skb, sk, 0);
> > +     bpf_sk_release(sk);
> > +     return ret == 0 ? TC_ACT_OK : TC_ACT_SHOT;
> > +}
> >



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
