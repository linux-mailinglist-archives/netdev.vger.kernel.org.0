Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C426B30D85
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 13:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaLtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 07:49:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:39500 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfEaLtq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 07:49:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 04:49:45 -0700
X-ExtLoop1: 1
Received: from btopel-mobl.isw.intel.com (HELO btopel-mobl.ger.intel.com) ([10.103.211.157])
  by fmsmga001.fm.intel.com with ESMTP; 31 May 2019 04:49:43 -0700
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        magnus.karlsson@intel.com
Cc:     kernel-team@fb.com, bpf <bpf@vger.kernel.org>
References: <20190530185709.1861867-1-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <5fde46e3-1967-d802-d1db-f02d15d11aa4@intel.com>
Date:   Fri, 31 May 2019 13:49:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190530185709.1861867-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-30 20:57, Jonathan Lemon wrote:
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Instead of doing this,
> have bpf_map_lookup_elem() return the queue_id, as a way of
> indicating that there is a valid entry at the map index.
> 
> Rearrange some xdp_sock members to eliminate structure holes.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   include/net/xdp_sock.h                            |  6 +++---
>   kernel/bpf/verifier.c                             |  6 +++++-
>   kernel/bpf/xskmap.c                               |  4 +++-
>   .../selftests/bpf/verifier/prevent_map_lookup.c   | 15 ---------------
>   4 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d60f8a..7d84b1da43d2 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -57,12 +57,12 @@ struct xdp_sock {
>   	struct net_device *dev;
>   	struct xdp_umem *umem;
>   	struct list_head flush_node;
> -	u16 queue_id;
> -	struct xsk_queue *tx ____cacheline_aligned_in_smp;
> -	struct list_head list;
> +	u32 queue_id;

Why the increase of size?

>   	bool zc;
>   	/* Protects multiple processes in the control path */
>   	struct mutex mutex;
> +	struct xsk_queue *tx ____cacheline_aligned_in_smp;
> +	struct list_head list;
>   	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
>   	 * in the SKB destructor callback.
>   	 */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 2778417e6e0c..91c730f85e92 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2905,10 +2905,14 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>   	 * appear.
>   	 */
>   	case BPF_MAP_TYPE_CPUMAP:
> -	case BPF_MAP_TYPE_XSKMAP:
>   		if (func_id != BPF_FUNC_redirect_map)
>   			goto error;
>   		break;
> +	case BPF_MAP_TYPE_XSKMAP:
> +		if (func_id != BPF_FUNC_redirect_map &&
> +		    func_id != BPF_FUNC_map_lookup_elem)
> +			goto error;
> +		break;
>   	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
>   	case BPF_MAP_TYPE_HASH_OF_MAPS:
>   		if (func_id != BPF_FUNC_map_lookup_elem)
> diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
> index 686d244e798d..249b22089014 100644
> --- a/kernel/bpf/xskmap.c
> +++ b/kernel/bpf/xskmap.c
> @@ -154,7 +154,9 @@ void __xsk_map_flush(struct bpf_map *map)
>   
>   static void *xsk_map_lookup_elem(struct bpf_map *map, void *key)
>   {
> -	return ERR_PTR(-EOPNOTSUPP);
> +	struct xdp_sock *xs = __xsk_map_lookup_elem(map, *(u32 *)key);
> +
> +	return xs ? &xs->queue_id : NULL;

I like this! I haven't taken it for a spin, but still:

Acked-by: Björn Töpel <bjorn.topel@intel.com>

>   }
>   
>   static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
> diff --git a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> index bbdba990fefb..da7a4b37cb98 100644
> --- a/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> +++ b/tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
> @@ -28,21 +28,6 @@
>   	.errstr = "cannot pass map_type 18 into func bpf_map_lookup_elem",
>   	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
>   },
> -{
> -	"prevent map lookup in xskmap",
> -	.insns = {
> -	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
> -	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> -	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> -	BPF_LD_MAP_FD(BPF_REG_1, 0),
> -	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
> -	BPF_EXIT_INSN(),
> -	},
> -	.fixup_map_xskmap = { 3 },
> -	.result = REJECT,
> -	.errstr = "cannot pass map_type 17 into func bpf_map_lookup_elem",
> -	.prog_type = BPF_PROG_TYPE_XDP,
> -},
>   {
>   	"prevent map lookup in stack trace",
>   	.insns = {
> 
