Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30B723155A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgG1WH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:07:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:41074 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgG1WH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 18:07:58 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0XlI-0000V3-T1; Wed, 29 Jul 2020 00:07:52 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0XlI-000MTB-Ll; Wed, 29 Jul 2020 00:07:52 +0200
Subject: Re: [PATCH v5 bpf-next 4/6] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
 <20200724173557.5764-5-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e0c1f8c5-cd73-48eb-7c92-fcf755319173@iogearbox.net>
Date:   Wed, 29 Jul 2020 00:07:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200724173557.5764-5-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25887/Tue Jul 28 17:44:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 7:35 PM, Maciej Fijalkowski wrote:
> This commit serves two things:
> 1) it optimizes BPF prologue/epilogue generation
> 2) it makes possible to have tailcalls within BPF subprogram
> 
> Both points are related to each other since without 1), 2) could not be
> achieved.
> 
[...]
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 6fe6491fa17a..e9d62a60134b 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -750,6 +750,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
>   				    struct bpf_prog *old,
>   				    struct bpf_prog *new)
>   {
> +	u8 *old_addr, *new_addr, *old_bypass_addr;
>   	struct prog_poke_elem *elem;
>   	struct bpf_array_aux *aux;
>   
> @@ -800,13 +801,47 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
>   			if (poke->tail_call.map != map ||
>   			    poke->tail_call.key != key)
>   				continue;
> +			/* protect against un-updated poke descriptors since
> +			 * we could fill them from subprog and the same desc
> +			 * is present on main's program poke tab
> +			 */
> +			if (!poke->tailcall_bypass || !poke->tailcall_target ||
> +			    !poke->bypass_addr)
> +				continue;

Thinking more about this, this check here is not sufficient. You basically need this here
given you copy all poke descs over to each of the subprogs in jit_subprogs(). So for those
that weren't handled by the subprog have the above addresses as NULL. But in jit_subprogs()
once we filled out the target addresses for the bpf-in-bpf calls we loop over each subprog
and do the extra/final pass in the JIT to complete the images. However, nothing protects
bpf_tail_call_direct_fixup() as far as I can see from patching at the NULL addr if there is
a target program loaded in the map at the given key. That will most likely blow up and hit
the BUG_ON().

Instead of these above workarounds, did you try to go the path to only copy over the poke
descs that are relevant for the individual subprog (but not all the others)?

Thanks,
Daniel
