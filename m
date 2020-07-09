Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0321AAAD
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGIWkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:40:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:38788 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGIWkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:40:14 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtfD9-0000rf-SK; Fri, 10 Jul 2020 00:40:11 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtfD9-000Ndv-Ky; Fri, 10 Jul 2020 00:40:11 +0200
Subject: Re: [PATCHv6 bpf-next 2/3] sample/bpf: add xdp_redirect_map_multicast
 test
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-3-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6170ec86-9cce-a5ec-bd14-7aa56cee951e@iogearbox.net>
Date:   Fri, 10 Jul 2020 00:40:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709013008.3900892-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 3:30 AM, Hangbin Liu wrote:
> This is a sample for xdp multicast. In the sample we could forward all
> packets between given interfaces.
> 
> v5: add a null_map as we have strict the arg2 to ARG_CONST_MAP_PTR.
>      Move the testing part to bpf selftest in next patch.
> v4: no update.
> v3: add rxcnt map to show the packet transmit speed.
> v2: no update.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   samples/bpf/Makefile                      |   3 +
>   samples/bpf/xdp_redirect_map_multi_kern.c |  57 ++++++++
>   samples/bpf/xdp_redirect_map_multi_user.c | 166 ++++++++++++++++++++++
>   3 files changed, 226 insertions(+)
>   create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
>   create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index f87ee02073ba..fddca6cb76b8 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -41,6 +41,7 @@ tprogs-y += test_map_in_map
>   tprogs-y += per_socket_stats_example
>   tprogs-y += xdp_redirect
>   tprogs-y += xdp_redirect_map
> +tprogs-y += xdp_redirect_map_multi
>   tprogs-y += xdp_redirect_cpu
>   tprogs-y += xdp_monitor
>   tprogs-y += xdp_rxq_info
> @@ -97,6 +98,7 @@ test_map_in_map-objs := test_map_in_map_user.o
>   per_socket_stats_example-objs := cookie_uid_helper_example.o
>   xdp_redirect-objs := xdp_redirect_user.o
>   xdp_redirect_map-objs := xdp_redirect_map_user.o
> +xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
>   xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
>   xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
>   xdp_rxq_info-objs := xdp_rxq_info_user.o
> @@ -156,6 +158,7 @@ always-y += tcp_tos_reflect_kern.o
>   always-y += tcp_dumpstats_kern.o
>   always-y += xdp_redirect_kern.o
>   always-y += xdp_redirect_map_kern.o
> +always-y += xdp_redirect_map_multi_kern.o
>   always-y += xdp_redirect_cpu_kern.o
>   always-y += xdp_monitor_kern.o
>   always-y += xdp_rxq_info_kern.o
> diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi_kern.c
> new file mode 100644
> index 000000000000..cc7ebaedf55a
> --- /dev/null
> +++ b/samples/bpf/xdp_redirect_map_multi_kern.c
> @@ -0,0 +1,57 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + */
> +#define KBUILD_MODNAME "foo"
> +#include <uapi/linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct bpf_map_def SEC("maps") forward_map = {
> +	.type = BPF_MAP_TYPE_DEVMAP_HASH,
> +	.key_size = sizeof(u32),
> +	.value_size = sizeof(int),
> +	.max_entries = 256,
> +};
> +
> +struct bpf_map_def SEC("maps") null_map = {
> +	.type = BPF_MAP_TYPE_DEVMAP_HASH,
> +	.key_size = sizeof(u32),
> +	.value_size = sizeof(int),
> +	.max_entries = 1,
> +};
> +
> +struct bpf_map_def SEC("maps") rxcnt = {
> +	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +	.key_size = sizeof(u32),
> +	.value_size = sizeof(long),
> +	.max_entries = 1,
> +};
> +
> +SEC("xdp_redirect_map_multi")
> +int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
> +{
> +	long *value;
> +	u32 key = 0;
> +
> +	/* count packet in global counter */
> +	value = bpf_map_lookup_elem(&rxcnt, &key);
> +	if (value)
> +		*value += 1;
> +
> +	return bpf_redirect_map_multi(&forward_map, &null_map,
> +				      BPF_F_EXCLUDE_INGRESS);

Why not extending to allow use-case like ...

   return bpf_redirect_map_multi(&fwd_map, NULL, BPF_F_EXCLUDE_INGRESS);

... instead of requiring a dummy/'null' map?

Thanks,
Daniel
