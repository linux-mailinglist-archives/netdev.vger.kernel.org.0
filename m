Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457064B9771
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiBQEHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:07:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiBQEHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:07:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B2A1C55BE;
        Wed, 16 Feb 2022 20:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D8761CDD;
        Thu, 17 Feb 2022 04:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EE6C340E9;
        Thu, 17 Feb 2022 04:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645070858;
        bh=fjwJWdGcrJSh0sn00v3pJAb/p+s41R0CKDbnX5GLN60=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nODLIADC+4RLaWWzC6VtH1zpkqXVh7/G/gNPgosBuD2l6IxwxlhTEj+XgmrJknumo
         QhaEtJ4g4vD0AzYXmY1CSNWxk1AcxLVG6j2UB+eJank2hkio2Y92DqCo/yGOFrrchi
         Y93p4XbwGdbro9wq+PoIiTtzPc5kQCoyPzU1Qaj+2jjQMSlnOovk/cAke/orOJ9b1j
         KI90LBklm3ZADt26SvfKKFMiW+oGLUG+AMHt7d72bAIzkmCE3KfJfvbWSKkFgiEuah
         2ZJIYM2EMnoBs4nj/otcpYm/m1bIEfpV++43h/qf6a1XjhCZFK7v6I9632XjvvUHuE
         27dIsinZlwcRA==
Message-ID: <244fae2e-bd5b-a46a-20ea-b294d45763ff@kernel.org>
Date:   Wed, 16 Feb 2022 21:07:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 3/9] net: tcp: use kfree_skb_reason() for
 tcp_v6_rcv()
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
References: <20220216035426.2233808-1-imagedong@tencent.com>
 <20220216035426.2233808-4-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220216035426.2233808-4-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/22 8:54 PM, menglong8.dong@gmail.com wrote:
> @@ -1779,13 +1789,17 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
>  	return ret ? -1 : 0;
>  
>  no_tcp_socket:
> -	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
> +	drop_reason = SKB_DROP_REASON_NO_SOCKET;
> +	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
> +		drop_reason = SKB_DROP_REASON_XFRM_POLICY;

same here. First failure takes precedence.

