Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07442314AA
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgG1VdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:33:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:36118 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgG1VdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:33:16 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0XDl-0005Yp-GD; Tue, 28 Jul 2020 23:33:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0XDl-000FAD-AU; Tue, 28 Jul 2020 23:33:13 +0200
Subject: Re: [PATCH v5 bpf-next 4/6] bpf, x64: rework pro/epilogue and
 tailcall handling in JIT
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
References: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
 <20200724173557.5764-5-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <38407b6c-12a2-671f-9929-2ef39be62542@iogearbox.net>
Date:   Tue, 28 Jul 2020 23:33:12 +0200
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
[...]
[...]
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 7be02e555ab9..d86a35474d7b 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -773,7 +773,8 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>   
>   	if (size > poke_tab_max)
>   		return -ENOSPC;
> -	if (poke->ip || poke->ip_stable || poke->adj_off)
> +	if (poke->tailcall_target || poke->tailcall_target_stable ||
> +	    poke->tailcall_bypass || poke->adj_off || poke->bypass_addr)
>   		return -EINVAL;

Hmm, I thought we've been through this from prior review rounds, but these sort of changes
break bisectability. You've already renamed the whole thing in patch 3/6 (poke->ip and the
poke->ip_stable). So if you've applied up to patch 3, then build breaks right here.

>   	switch (poke->reason) {
> 

