Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015096E2E20
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDOBPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDOBPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686EE6EBB
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F166860CEB
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068F4C4339B;
        Sat, 15 Apr 2023 01:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681521338;
        bh=3dSB7lwwFfzgC7W88RsVSGPg5AmF0RbMQgr+wmXvMjk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VfoQcxsYTBfZY8DVum8w5qGp5hClUskVGCMZMKjVGthTAlajxBltkomTQ1zJkB1nU
         FkVqFMbhNL1eVeizgFpA/CrjZO7hBwTIxt+pZkjGdgvyF3tm02+3PC7nZyYEIU/ENW
         Fd7i3edgbhUgeCuk1tLuKjW8mrGYsa+iXgIKvuroxf9RJu1USpvmv8mdbJmqnAURjp
         oz1GFJCzK45NHQ+ur/HKTS0ZX2tyfHduUIzQGlwG3tsaQu5t6Asqg6CT2NCS25w4Dv
         hESRIeZghicueZZXjMfu11zaikrvfJL+zUSCKfitICNh1z4V4bsYZjMvbtvk8s8wHr
         nwDxQKRMrUePA==
Date:   Fri, 14 Apr 2023 18:15:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net/sched: sch_qfq: use extack on errors
 messages
Message-ID: <20230414181537.4f477617@kernel.org>
In-Reply-To: <20230414185309.220286-3-pctammela@mojatatu.com>
References: <20230414185309.220286-1-pctammela@mojatatu.com>
        <20230414185309.220286-3-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 15:53:10 -0300 Pedro Tammela wrote:
>  	if (tca[TCA_OPTIONS] == NULL) {
> -		pr_notice("qfq: no options\n");
> +		NL_SET_ERR_MSG_MOD(extack, "missing options");

NL_REQ_ATTR_CHECK() (probably in addition to the string message)
since it's legacy netlink.

>  		return -EINVAL;
>  	}
>  
>  	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
> -					  qfq_policy, NULL);
> +					  qfq_policy, extack);
>  	if (err < 0)
>  		return err;
>  
>  	if (tb[TCA_QFQ_WEIGHT]) {
>  		weight = nla_get_u32(tb[TCA_QFQ_WEIGHT]);
>  		if (!weight || weight > (1UL << QFQ_MAX_WSHIFT)) {
> -			pr_notice("qfq: invalid weight %u\n", weight);
> +			NL_SET_ERR_MSG_FMT_MOD(extack, "invalid weight %u\n",
> +					       weight);

The checks should be expressed as part of the policy and parsing will
take care of the extack

>  			return -EINVAL;
>  		}
>  	} else
> @@ -424,7 +425,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
>  	if (tb[TCA_QFQ_LMAX]) {
>  		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
>  		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
> -			pr_notice("qfq: invalid max length %u\n", lmax);
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "invalid max length %u\n", lmax);
>  			return -EINVAL;

ditto
