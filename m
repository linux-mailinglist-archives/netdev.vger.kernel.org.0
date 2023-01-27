Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9472567DECB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjA0H6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjA0H6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:58:39 -0500
Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF71757BB
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:58:37 -0800 (PST)
Message-ID: <befb819f-abc4-c7a1-1f82-9559542f9138@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674806315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCyMrk9aN65WEKM1E5bYRN1lFodwyHbxv5dcbOPmgug=;
        b=J2NFVLZHJjIRQqWiDnmsc+ZdaWRw6e0V7HMwt0c76ud0bxzrZIIfDh1ezD2ysO1kr5bzX4
        e4jNrGgxnZA2vJ0C9vKhiUS1N4NIZc2dhq4zctkRL8WRrpM6+qVk+xDSBf5TyRqu1FgRJ3
        buFAnvFFQzLg8RFfl9LAfkjfK1vQZQU=
Date:   Thu, 26 Jan 2023 23:58:24 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v8 bpf-next 3/5] bpf: Add skb dynptrs
Content-Language: en-US
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, memxor@gmail.com,
        kernel-team@fb.com, bpf <bpf@vger.kernel.org>
References: <20230126233439.3739120-1-joannelkoong@gmail.com>
 <20230126233439.3739120-4-joannelkoong@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230126233439.3739120-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/23 3:34 PM, Joanne Koong wrote:
> +static enum bpf_dynptr_type dynptr_get_type(struct bpf_verifier_env *env,
> +					    struct bpf_reg_state *reg)
> +{
> +	struct bpf_func_state *state = func(env, reg);
> +	int spi = __get_spi(reg->off);
> +
> +	if (spi < 0) {
> +		verbose(env, "verifier internal error: invalid spi when querying dynptr type\n");
> +		return BPF_DYNPTR_TYPE_INVALID;
> +	}
> +
> +	return state->stack[spi].spilled_ptr.dynptr.type;
> +}

CI fails: 
https://github.com/kernel-patches/bpf/actions/runs/4020275998/jobs/6908210555

My local KASAN also reports the error.
