Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735A362202A
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiKHXMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 18:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKHXMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 18:12:42 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C91A1181A;
        Tue,  8 Nov 2022 15:12:41 -0800 (PST)
Message-ID: <62bf28ac-c1fa-fc60-ce52-6d993a8a4bbf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667949159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23Tm+eKsq59oYINN64yC7sXxhhKfTi7aNRL9IyR7Fcg=;
        b=WbcoZyQpXbCkr7+milw/nMCvBLTKt7rZgDcD8YhRwEgEWygXmmvThOlypgTdP8HObpx6hL
        aiOyNE3Xs37eA6DW7C2gFD8KqCU77fb//5NoBRDkPntCdmZI+cOhXZrLQbS58GJ7K81FwC
        do1kxKXNwF8EvWDtX8dLaJmNB3R+oiI=
Date:   Tue, 8 Nov 2022 15:12:30 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf v2 1/5] bpf: Adapt 32-bit return value kfunc for
 32-bit ARM when zext extension
Content-Language: en-US
To:     Yang Jihong <yangjihong1@huawei.com>
References: <20221107092032.178235-1-yangjihong1@huawei.com>
 <20221107092032.178235-2-yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, illusionist.neo@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        benjamin.tissoires@redhat.com, memxor@gmail.com,
        asavkov@redhat.com, delyank@fb.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221107092032.178235-2-yangjihong1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/22 1:20 AM, Yang Jihong wrote:
> For ARM32 architecture, if data width of kfunc return value is 32 bits,
> need to do explicit zero extension for high 32-bit, insn_def_regno should
> return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
> opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.
> 
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>   kernel/bpf/verifier.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7f0a9f6cb889..bac37757ffca 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2404,6 +2404,9 @@ static int insn_def_regno(const struct bpf_insn *insn)
>   {
>   	switch (BPF_CLASS(insn->code)) {
>   	case BPF_JMP:
> +		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
> +			return insn->dst_reg;

This does not look right.  A kfunc can return void.  The btf type of the kfunc's 
return value needs to be checked against "void" first?
Also, this will affect insn_has_def32(), does is_reg64 (called from 
insn_has_def32) need to be adjusted also?


For patch 2, as replied earlier in v1, I would separate out the prog that does 
__sk_buff->sk and use the uapi's bpf.h instead of vmlinux.h since it does not 
need CO-RE.

This set should target for bpf-next instead of bpf.

> +		fallthrough;
>   	case BPF_JMP32:
>   	case BPF_ST:
>   		return -1;

