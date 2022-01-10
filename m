Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCFD48A076
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 20:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbiAJTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 14:53:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50368 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239531AbiAJTxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 14:53:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C294EB811EC;
        Mon, 10 Jan 2022 19:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67497C36AF3;
        Mon, 10 Jan 2022 19:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641844422;
        bh=GUqeXcbpeOgjCzgp1RhM7+MnH+gaKz5+oIguOPeFqAc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=e1vb5BXmTXnH/F9VDHsHSxV/QV1+L69URQ10Gz2iT9xOAuzTklhngdWzbypwqaUbv
         B8OOrRnJ9T5/uLWHTlGr8za4dj/TcPs5+80MfLxXisjZwV8dAGKPypd90dTVk2SdFj
         KXShErJGDcj9uiyccNg/Zo6JE3xGRFurxz3ZQ7ap0raex64Wwe7K0ehVVwTH0YEltX
         lCBGlIJOu0JGlAjncss7pBdicGYgS9S1bMitrCwtBaJHqwMiqIGe9ZNyrRdcqJEm4D
         rlkq1pbCyLISZbYttwo/u5GSc8B0vfCTyX3175Bl2Lpx7Sem1ZV2SUibnTCVxjHEX9
         o0ifPI3XGN8SA==
Received: by mail-yb1-f181.google.com with SMTP id p5so33808590ybd.13;
        Mon, 10 Jan 2022 11:53:42 -0800 (PST)
X-Gm-Message-State: AOAM531SdplT00yQbRSe3KqvhkS/EG1YhevIQfVd1ay5KO07i5ZQrQDs
        HOaUdEI2xQ1H6L3wJ6hqNT2IAfhtWiDHmjOqC6w=
X-Google-Smtp-Source: ABdhPJwgVKrsOJaa3NoMZl85ToIT/Eq9F6rtQGhJAsTR5+OSMOsjV4Ea7IEtSEhgNKjbv6AskYtY5dwuxB5XMLPVWqg=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr1615182ybq.47.1641844421292;
 Mon, 10 Jan 2022 11:53:41 -0800 (PST)
MIME-Version: 1.0
References: <20220107200600.1688870-1-quic_twear@quicinc.com>
In-Reply-To: <20220107200600.1688870-1-quic_twear@quicinc.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 Jan 2022 11:53:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5XvmbGFoUVRodhbfqA9Xv-j5F25W0qyviw-ytvg-cP7Q@mail.gmail.com>
Message-ID: <CAPhsuW5XvmbGFoUVRodhbfqA9Xv-j5F25W0qyviw-ytvg-cP7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
To:     Tyler Wear <quic_twear@quicinc.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 12:07 PM Tyler Wear <quic_twear@quicinc.com> wrote:
>
> Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
> Instead of adding generic function for just modifying the ds field,
> add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
> This allows other fields in the network and transport header to be
> modified in the future.
>
> Checksum API's also need to be added for completeness.
>
> It is not possible to use CGROUP_(SET|GET)SOCKOPT since
> the policy may change during runtime and would result
> in a large number of entries with wildcards.
>
> V4 patch fixes warnings and errors from checkpatch.
>
> The existing check for bpf_try_make_writable() should mean that
> skb_share_check() is not needed.
>
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>  net/core/filter.c                             |  10 ++
>  .../bpf/prog_tests/cgroup_store_bytes.c       | 104 ++++++++++++++++++
>  .../selftests/bpf/progs/cgroup_store_bytes.c  |  69 ++++++++++++
>  3 files changed, 183 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6102f093d59a..ce01a8036361 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7299,6 +7299,16 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_sk_storage_delete_proto;
>         case BPF_FUNC_perf_event_output:
>                 return &bpf_skb_event_output_proto;
> +       case BPF_FUNC_skb_store_bytes:
> +               return &bpf_skb_store_bytes_proto;
> +       case BPF_FUNC_csum_update:
> +               return &bpf_csum_update_proto;
> +       case BPF_FUNC_csum_level:
> +               return &bpf_csum_level_proto;
> +       case BPF_FUNC_l3_csum_replace:
> +               return &bpf_l3_csum_replace_proto;
> +       case BPF_FUNC_l4_csum_replace:
> +               return &bpf_l4_csum_replace_proto;
>  #ifdef CONFIG_SOCK_CGROUP_DATA
>         case BPF_FUNC_skb_cgroup_id:
>                 return &bpf_skb_cgroup_id_proto;

Please put changes to selftests in a separate patch.

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..4b87ff003008
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +void test_cgroup_store_bytes(void)
> +{
> +       int server_fd, cgroup_fd, prog_fd, map_fd, client_fd;
> +       int err;
> +       struct bpf_object *obj;
> +       struct bpf_program *prog;
> +       struct bpf_map *test_result;
> +       __u32 duration = 0;
> +
> +       __u32 map_key = 0;
> +       __u32 map_value = 0;
> +
> +       cgroup_fd = test__join_cgroup("/cgroup_store_bytes");
> +       if (CHECK_FAIL(cgroup_fd < 0))

Please use ASSERT_* macros as much as possible, for example, use
ASSERT_GE for fd.

> +               return;
> +
> +       server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +       if (CHECK_FAIL(server_fd < 0))
> +               goto close_cgroup_fd;
> +
> +       err = bpf_prog_load("./cgroup_store_bytes.o", BPF_PROG_TYPE_CGROUP_SKB,
> +                                               &obj, &prog_fd);

Can we use bpf skeleton to simplify the code?

> +
> +       if (CHECK_FAIL(err))
> +               goto close_server_fd;
> +
> +       test_result = bpf_object__find_map_by_name(obj, "test_result");
> +       if (CHECK_FAIL(!test_result))
> +               goto close_bpf_object;
> +
> +       map_fd = bpf_map__fd(test_result);
> +       if (map_fd < 0)
> +               goto close_bpf_object;
> +
> +       prog = bpf_object__find_program_by_name(obj, "cgroup_store_bytes");
> +       if (CHECK_FAIL(!prog))
> +               goto close_bpf_object;
> +
> +       err = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS,
> +                                                       BPF_F_ALLOW_MULTI);
> +       if (CHECK_FAIL(err))
> +               goto close_bpf_object;
> +
> +       client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +       if (CHECK_FAIL(client_fd < 0))
> +               goto close_bpf_object;
> +
> +       struct sockaddr server_addr;

Please put all variable declarations at the beginning of the function.

> +       socklen_t addrlen = sizeof(server_addr);
> +
> +       if (getsockname(server_fd, &server_addr, &addrlen)) {
> +               perror("Failed to get server addr");
> +               return -1;
> +       }
> +
> +       char buf[] = "testing";
> +
> +       if (CHECK_FAIL(sendto(client_fd, buf, sizeof(buf), 0, &server_addr,
> +                       sizeof(server_addr)) != sizeof(buf))) {
> +               perror("Can't write on client");
> +               goto close_client_fd;
> +       }
> +
> +       struct sockaddr_storage ss;
> +       char recv_buf[BUFSIZ];
> +       socklen_t slen;
> +
> +       if (recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0,
> +                       (struct sockaddr *)&ss, &slen) <= 0) {
> +               perror("Recvfrom received no packets");
> +               goto close_client_fd;
> +       }
> +
> +       struct in_addr addr = ((struct sockaddr_in *)&ss)->sin_addr;
> +
> +       CHECK(addr.s_addr != 0xac100164, "bpf", "bpf program failed to change saddr");
> +
> +       unsigned short port = ((struct sockaddr_in *)&ss)->sin_port;
> +
> +       CHECK(port != htons(5555), "bpf", "bpf program failed to change port");
> +
> +       err = bpf_map_lookup_elem(map_fd, &map_key, &map_value);
> +       if (CHECK_FAIL(err))
> +               goto close_client_fd;
> +
> +       CHECK(map_value != 1, "bpf", "bpf program returned failure");
> +
> +close_client_fd:
> +       close(client_fd);
> +
> +close_bpf_object:
> +       bpf_object__close(obj);
> +
> +close_server_fd:
> +       close(server_fd);
> +
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..dc28e46c5069
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <errno.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <netinet/in.h>
> +#include <netinet/udp.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define IP_SRC_OFF offsetof(struct iphdr, saddr)
> +#define UDP_SPORT_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, source))
> +
> +#define IS_PSEUDO 0x10
> +
> +#define UDP_CSUM_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, check))
> +#define IP_CSUM_OFF offsetof(struct iphdr, check)
> +#define TOS_OFF offsetof(struct iphdr, tos)
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u32);
> +} test_result SEC(".maps");

We can just use a global variable here. The compiler will put it in
a map (bss or data).

> +
> +SEC("cgroup_skb/egress")
> +int cgroup_store_bytes(struct __sk_buff *skb)
> +{
> +       struct ethhdr eth;
> +       struct iphdr iph;
> +       struct udphdr udph;
> +
> +       __u32 map_key = 0;
> +       __u32 test_passed = 0;
> +
> +       if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph),
> +                                                                       BPF_HDR_START_NET))
> +               goto fail;
> +
> +       if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph),
> +                                                                       BPF_HDR_START_NET))
> +               goto fail;
> +
> +       __u32 old_ip = htonl(iph.saddr);
> +       __u32 new_ip = 0xac100164; //172.16.1.100
> +
> +       bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_ip, new_ip,
> +                                               IS_PSEUDO | sizeof(new_ip));
> +       bpf_l3_csum_replace(skb, IP_CSUM_OFF, old_ip, new_ip, sizeof(new_ip));
> +       if (bpf_skb_store_bytes(skb, IP_SRC_OFF, &new_ip, sizeof(new_ip), 0) < 0)
> +               goto fail;
> +
> +       __u16 old_port = udph.source;
> +       __u16 new_port = 5555;
> +
> +       bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port,
> +                                               IS_PSEUDO | sizeof(new_port));
> +       if (bpf_skb_store_bytes(skb, UDP_SPORT_OFF, &new_port, sizeof(new_port),
> +                                                       0) < 0)
> +               goto fail;
> +
> +       test_passed = 1;
> +
> +fail:
> +       bpf_map_update_elem(&test_result, &map_key, &test_passed, BPF_ANY);
> +
> +       return 1;
> +}
> --
> 2.25.1
>
