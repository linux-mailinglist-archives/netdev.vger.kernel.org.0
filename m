Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92763E940
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiLAFQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:16:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564CF8EE69
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 21:16:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE69C61E78
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F3EC433D6;
        Thu,  1 Dec 2022 05:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669871805;
        bh=HPWpNSLcq5pqzBfpA0Nm8VIasPFzBgT51p8dEkd6rdk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jZVusoswc+L/K85pLII2rcZeIAcfVrnfgcS7JQySPhOt7k4hD5//TfNBP7UpQsePc
         SDjIAjMx5fBV7LCUmHHX3tAqFMKe4iqNAl++2XMx7A+H4ZlN3vt2vegZu0hcNx3GPv
         GagjmC792VqWi76ARClxpr5PGbfRAnv4o4ZTABiRpcQRBhUT250a6S6FnrTLSCM+kj
         tnI/a0/uw9VLH4WwaFRag6N9SbdfVzWVkR1QZ9ZKwRc/exee+v0gFSpBeHvOMzQ/Dn
         YGAwso6QUsyFm1qiCY6SvJeQuBuMFEcg6gF9aoeCLbQ3kgqzxP0gAPctl7At8eI+SR
         WYVGtVg7aF5vg==
Date:   Wed, 30 Nov 2022 21:16:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
Message-ID: <20221130211643.01d65f46@kernel.org>
In-Reply-To: <20221128154456.689326-2-pctammela@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
        <20221128154456.689326-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 12:44:54 -0300 Pedro Tammela wrote:
> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
> optimize actions and filters that are compiled as built-ins into a direct call.
> The calls are ordered alphabetically, but new ones should be ideally
> added last.
> 
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.

> +#if IS_ENABLED(CONFIG_RETPOLINE) && IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)

The latter 'depends on' former, so just check the latter.

> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> +			   struct tcf_result *res)
> +{
> +	if (0) { /* noop */ }
> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
> +	else if (a->ops->act == tcf_bpf_act)
> +		return tcf_bpf_act(skb, a, res);
> +#endif

How does the 'else if' ladder compare to a switch statement?

> +#ifdef CONFIG_NET_CLS_ACT
> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> +			   struct tcf_result *res)
> +{
> +	return a->ops->act(skb, a, res);
> +}
> +#endif
> +
> +#ifdef CONFIG_NET_CLS
> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +				struct tcf_result *res)
> +{
> +	return tp->classify(skb, tp, res);
> +}
> +#endif

please don't wrap the static inline helpers in #ifdefs unless it's
actually necessary for build to pass.
