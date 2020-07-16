Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B5222DEC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGPV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:29:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:58916 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgGPV3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:29:36 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwBRZ-000796-JW; Thu, 16 Jul 2020 23:29:29 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwBRZ-0003IN-DB; Thu, 16 Jul 2020 23:29:29 +0200
Subject: Re: [PATCH bpf-next 2/5] bpf: allow for tailcalls in BPF subprograms
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
 <20200715233634.3868-3-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <912b5e97-1951-5a7c-e3c1-41bc3bf4b58a@iogearbox.net>
Date:   Thu, 16 Jul 2020 23:29:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715233634.3868-3-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/20 1:36 AM, Maciej Fijalkowski wrote:
> Relax verifier's restriction that was meant to forbid tailcall usage
> when subprog count was higher than 1.
> 
> Also, do not max out the stack depth of program that utilizes tailcalls.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>   kernel/bpf/verifier.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c1efc9d08fd..6481342b31ba 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -4172,10 +4172,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>   	case BPF_FUNC_tail_call:
>   		if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
>   			goto error;
> -		if (env->subprog_cnt > 1) {
> -			verbose(env, "tail_calls are not allowed in programs with bpf-to-bpf calls\n");
> -			return -EINVAL;
> -		}
>   		break;
>   	case BPF_FUNC_perf_event_read:
>   	case BPF_FUNC_perf_event_output:
> @@ -10252,7 +10248,6 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>   			 * the program array.
>   			 */
>   			prog->cb_access = 1;
> -			env->prog->aux->stack_depth = MAX_BPF_STACK;
>   			env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
>   
>   			/* mark bpf_tail_call as different opcode to avoid

Also, isn't this broken when JIT is not used (as in stack oob access)?
