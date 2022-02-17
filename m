Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C834B976E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiBQEGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:06:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiBQEGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:06:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2632DAE4E;
        Wed, 16 Feb 2022 20:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8651561DA4;
        Thu, 17 Feb 2022 04:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E796EC340E9;
        Thu, 17 Feb 2022 04:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645070788;
        bh=/5gq54EHd5uDDlMUAQpNiGLfpy7vF+5N3geE0AGsy6U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d9x3AqAVXGSwqLO/VIK2akk51+iXl2lzC+Qx5CHPuIrbez2RHPojBnXcKIxFlr9PN
         8S9O8gP/VGFJNPvr8NtUW3CCmAcIbQB2/uM9sACaZpLRKY2EHB4tn806IXRHtaxAkm
         97R3zpEKPqxWFhE+W2hgitxi9hNXkpxq9FmvFiGpKW+YY2VM62m29JIX6+VXBX0GRU
         LaUB4VO1zPwcq3+gPpgEzH26KHEbR8gxv3e7jjOVpkOooYnoJ12/JBcFWb/XbtDc4u
         JR8LmD5AKdOL6kPRW3C0xA2WDmAG5WXXfecjGDImuoIiokyGBR5M7AxOKrQlwQ2aGH
         /0BN2EC1g1Www==
Message-ID: <fb8a11f9-3799-d43a-cc5a-2419254c47e5@kernel.org>
Date:   Wed, 16 Feb 2022 21:06:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 2/9] net: tcp: add skb drop reasons to
 tcp_v4_rcv()
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
 <20220216035426.2233808-3-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220216035426.2233808-3-imagedong@tencent.com>
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
> @@ -2137,8 +2141,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  
>  no_tcp_socket:
>  	drop_reason = SKB_DROP_REASON_NO_SOCKET;
> -	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
> +	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
> +		drop_reason = SKB_DROP_REASON_XFRM_POLICY;

no socket reason trumps the xfrm failure; it was first.

>  		goto discard_it;
> +	}
>  
>  	tcp_v4_fill_cb(skb, iph, th);
>  
