Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD14F82B7
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiDGPYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344591AbiDGPYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:24:36 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61320D80D;
        Thu,  7 Apr 2022 08:22:35 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ncTxj-0003Hy-VO; Thu, 07 Apr 2022 17:22:20 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ncTxj-000Hlq-Ix; Thu, 07 Apr 2022 17:22:19 +0200
Subject: Re: [PATCH v5 1/3] selftests: bpf: add test for bpf_skb_change_proto
To:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Maciej enczykowski <maze@google.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220407084727.10241-1-lina.wang@mediatek.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
Date:   Thu, 7 Apr 2022 17:22:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220407084727.10241-1-lina.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26505/Thu Apr  7 10:25:37 2022)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lina,

On 4/7/22 10:47 AM, Lina Wang wrote:
> The code is copied from the Android Open Source Project and the author(
> Maciej Żenczykowski) has gave permission to relicense it under GPLv2.
> 
> The test is to change input IPv6 packets to IPv4 ones and output IPv4 to
> IPv6 with bpf_skb_change_proto.
> 
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>
> ---
>   tools/testing/selftests/bpf/progs/nat6to4.c | 293 ++++++++++++++++++++
>   1 file changed, 293 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/progs/nat6to4.c

Thanks for adding a selftest into your series!

Your patch 2/3 is utilizing this program out of selftests/net/udpgro_frglist.sh,
however, this is a bit problematic given BPF CI which runs on every BPF submitted
patch. Meaning, udpgro_frglist.sh won't be covered by CI and only needs to be run
manually. Could you properly include this into test_progs from BPF suite (that way,
BPF CI will also pick it up)? See also [2] for more complex netns setups.

Thanks again!
Daniel

Some small comments below.

   [0] https://patchwork.kernel.org/project/netdevbpf/patch/20220407084727.10241-2-lina.wang@mediatek.com/
   [1] https://github.com/kernel-patches/bpf/actions
   [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/tree/tools/testing/selftests/bpf/prog_tests/xdp_bonding.c

> diff --git a/tools/testing/selftests/bpf/progs/nat6to4.c b/tools/testing/selftests/bpf/progs/nat6to4.c
> new file mode 100644
> index 000000000000..099950f7a6cc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/nat6to4.c
> @@ -0,0 +1,293 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * This code is taken from the Android Open Source Project and the author
> + * (Maciej Żenczykowski) has gave permission to relicense it under the
> + * GPLv2. Therefore this program is free software;
> + * You can redistribute it and/or modify it under the terms of the GNU
> + * General Public License version 2 as published by the Free Software
> + * Foundation
> +
> + * The original headers, including the original license headers, are
> + * included below for completeness.
> + *
> + * Copyright (C) 2019 The Android Open Source Project
> + *
> + * Licensed under the Apache License, Version 2.0 (the "License");
> + * you may not use this file except in compliance with the License.
> + * You may obtain a copy of the License at
> + *
> + *      http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * Unless required by applicable law or agreed to in writing, software
> + * distributed under the License is distributed on an "AS IS" BASIS,
> + * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> + * See the License for the specific language governing permissions and
> + * limitations under the License.
> + */
> +#include <linux/bpf.h>
> +#include <linux/if.h>
> +#include <linux/if_ether.h>
> +#include <linux/if_packet.h>
> +#include <linux/in.h>
> +#include <linux/in6.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/pkt_cls.h>
> +#include <linux/swab.h>
> +#include <stdbool.h>
> +#include <stdint.h>
> +
> +// bionic kernel uapi linux/udp.h header is munged...

nit: Throughout the file, please use C style comments as per kernel coding convention.

> +#define __kernel_udphdr udphdr
> +#include <linux/udp.h>
> +
> +#include <bpf/bpf_helpers.h>
> +
> +#define htons(x) (__builtin_constant_p(x) ? ___constant_swab16(x) : __builtin_bswap16(x))
> +#define htonl(x) (__builtin_constant_p(x) ? ___constant_swab32(x) : __builtin_bswap32(x))
> +#define ntohs(x) htons(x)
> +#define ntohl(x) htonl(x)

nit: Please use libbpf's bpf_htons() and friends helpers [3].

   [3] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/tree/tools/lib/bpf/bpf_endian.h

OT: In Cilium we run similar NAT46/64 translation for XDP and tc/BPF for our LB services [4] (that is,
v4 VIP with v6 backends, and v6 VIP with v4 backends).

   [4] https://github.com/cilium/cilium/blob/master/bpf/lib/nat_46x64.h
       https://github.com/cilium/cilium/blob/master/test/nat46x64/test.sh
