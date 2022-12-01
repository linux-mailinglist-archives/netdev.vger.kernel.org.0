Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBB263FAA8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiLAWiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiLAWiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:38:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98393BB02A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2923662155
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 22:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9AFC433D6;
        Thu,  1 Dec 2022 22:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669934293;
        bh=PCZtoeUfiGldJiFWim1zywUBAkadrWViRepJ37IsL6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0xM34z76oyUvf7Ts2T38n/IpJP/jfw+W7vMjOzW57BH/zv/ZkZj4DZH7vI/1Zmfx
         m0nz2FIQzM/cxKMYDAPBOPRsi9grPQJsa7apvHETdQ1wyBgsRZvhVL6XuKjQ6LkcjN
         qVKNB7lDuzEeIDjO3wSKlIUvNo2L9QNI+srkxJo4FNgNeHeZd+czTu12gJSqMP41j8
         qdaLfCT06wuKL6tW8OGf/BltnOP/9iaPAwMlA1jGPWpL5fQugjn0bKKPmsPWANS66k
         LEOmC1SNd27npJ1hLYw1Qajrv+T/eeKBMLb0WgpixKMOV+T9ktwAdh4JTb65m7wTnd
         NNvpALY1ZJ7iQ==
Date:   Thu, 1 Dec 2022 14:38:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
Message-ID: <20221201143812.47089fb1@kernel.org>
In-Reply-To: <19b7c2fe-2e56-cc56-86ca-dface0270bad@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
        <20221128154456.689326-2-pctammela@mojatatu.com>
        <20221130211643.01d65f46@kernel.org>
        <19b7c2fe-2e56-cc56-86ca-dface0270bad@mojatatu.com>
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

On Thu, 1 Dec 2022 13:40:34 -0300 Pedro Tammela wrote:
> >> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> >> +			   struct tcf_result *res)
> >> +{
> >> +	if (0) { /* noop */ }
> >> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
> >> +	else if (a->ops->act == tcf_bpf_act)
> >> +		return tcf_bpf_act(skb, a, res);
> >> +#endif  
> > 
> > How does the 'else if' ladder compare to a switch statement?  
> 
> It's the semantically the same, we would just need to do some casts to 
> unsigned long.

Sorry, should've been clearer, I mean in terms of generated code.
Is the machine code identical / better / worse?

> WDYT about the following?
> 
>    #define __TC_ACT_BUILTIN(builtin, fname) \
>       if (builtin && a->ops->act == fname) return fname(skb, a, res)
> 
>    #define _TC_ACT_BUILTIN(builtin, fname) __TC_ACT_BUILTIN(builtin, fname)
>    #define TC_ACT_BUILTIN(cfg, fname)  _TC_ACT_BUILTIN(IS_BUILTIN(cfg), 
> fname)
> 
>    static inline int __tc_act(struct sk_buff *skb, const struct 
> tc_action *a,
>                               struct tcf_result *res)
>    {
>            TC_ACT_BUILTIN(CONFIG_NET_ACT_BPF, tcf_bpf_act);
>    ...
> 
> It might be more pleasant to the reader.

Most definitely not to this reader :) The less macro magic the better.
I'm primarily curious about whether the compiler treats this sort of
construct the same as a switch.

> >> +#ifdef CONFIG_NET_CLS_ACT
> >> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> >> +			   struct tcf_result *res)
> >> +{
> >> +	return a->ops->act(skb, a, res);
> >> +}
> >> +#endif
> >> +
> >> +#ifdef CONFIG_NET_CLS
> >> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> >> +				struct tcf_result *res)
> >> +{
> >> +	return tp->classify(skb, tp, res);
> >> +}
> >> +#endif  
> > 
> > please don't wrap the static inline helpers in #ifdefs unless it's
> > actually necessary for build to pass.  
> 
> The only one really needed is CONFIG_NET_CLS_ACT because the struct 
> tc_action definition is protected by it. Perhaps we should move it out 
> of the #ifdef?

Yes, I think that's a nice cleanup.
