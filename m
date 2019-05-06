Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E06F14B5B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 15:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfEFN51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 09:57:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:40660 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfEFN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 09:57:27 -0400
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNe7Q-0007Zq-VV; Mon, 06 May 2019 15:57:25 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNe7Q-0001ty-IQ; Mon, 06 May 2019 15:57:24 +0200
Subject: Re: [PATCH v6 bpf-next 01/17] bpf: verifier: offer more accurate
 helper function arg and return type
To:     Jiong Wang <jiong.wang@netronome.com>, alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
 <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2c83afa7-d3ba-0881-e98f-81a406367f93@iogearbox.net>
Date:   Mon, 6 May 2019 15:57:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1556880164-10689-2-git-send-email-jiong.wang@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2019 12:42 PM, Jiong Wang wrote:
> BPF helper call transfers execution from eBPF insns to native functions
> while verifier insn walker only walks eBPF insns. So, verifier can only
> knows argument and return value types from explicit helper function
> prototype descriptions.
> 
> For 32-bit optimization, it is important to know whether argument (register
> use from eBPF insn) and return value (register define from external
> function) is 32-bit or 64-bit, so corresponding registers could be
> zero-extended correctly.
> 
> For arguments, they are register uses, we conservatively treat all of them
> as 64-bit at default, while the following new bpf_arg_type are added so we
> could start to mark those frequently used helper functions with more
> accurate argument type.
> 
>   ARG_CONST_SIZE32
>   ARG_CONST_SIZE32_OR_ZERO

For the above two, I was wondering is there a case where the passed size is
not used as 32 bit aka couldn't we generally assume 32 bit here w/o adding
these two extra arg types? For ARG_ANYTHING32 and RET_INTEGER64 definitely
makes sense (btw, opt-in value like RET_INTEGER32 might have been easier for
reviewing converted helpers).

>   ARG_ANYTHING32
> 
> A few helper functions shown up frequently inside Cilium bpf program are
> updated using these new types.
> 
> For return values, they are register defs, we need to know accurate width
> for correct zero extensions. Given most of the helper functions returning
> integers return 32-bit value, a new RET_INTEGER64 is added to make those
> functions return 64-bit value. All related helper functions are updated.
> 
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
[...]

> @@ -2003,9 +2003,9 @@ static const struct bpf_func_proto bpf_csum_diff_proto = {
>  	.pkt_access	= true,
>  	.ret_type	= RET_INTEGER,
>  	.arg1_type	= ARG_PTR_TO_MEM_OR_NULL,
> -	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg2_type	= ARG_CONST_SIZE32_OR_ZERO,
>  	.arg3_type	= ARG_PTR_TO_MEM_OR_NULL,
> -	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg4_type	= ARG_CONST_SIZE32_OR_ZERO,
>  	.arg5_type	= ARG_ANYTHING,
>  };

I noticed that the above and also bpf_csum_update() would need to be converted
to RET_INTEGER64 as they would break otherwise: it's returning error but also
u32 csum value, so use for error checking would be s64 ret = bpf_csum_xyz(...).

Thanks,
Daniel
