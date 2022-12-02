Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FB640125
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiLBHkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLBHk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:40:29 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D50AD98E;
        Thu,  1 Dec 2022 23:40:28 -0800 (PST)
Message-ID: <5cac050a-d67b-587f-411e-946117ba8324@linux.dev>
Date:   Thu, 1 Dec 2022 23:40:20 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next,v3 2/4] xfrm: interface: Add unstable helpers for
 setting/getting XFRM metadata from TC-BPF
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org, liuhangbin@gmail.com,
        lixiaoyan@google.com
References: <20221201211425.1528197-1-eyal.birger@gmail.com>
 <20221201211425.1528197-3-eyal.birger@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221201211425.1528197-3-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/22 1:14 PM, Eyal Birger wrote:
> +int bpf_skb_get_xfrm_info(struct __sk_buff *skb_ctx, struct bpf_xfrm_info *to)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct xfrm_md_info *info;
> +
> +	memset(to, 0, sizeof(*to));

This zero-ing is also not needed.  verifier ensures "to" is initialized before 
calling this kfunc.

> +
> +	info = skb_xfrm_md_info(skb);
> +	if (!info)
> +		return -EINVAL;
> +
> +	to->if_id = info->if_id;
> +	to->link = info->link;
> +	return 0;
> +}


