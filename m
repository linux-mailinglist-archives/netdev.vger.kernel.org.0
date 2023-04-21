Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4766EA1AD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjDUCdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUCdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:33:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28895210D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:33:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83236150C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E0EC433EF;
        Fri, 21 Apr 2023 02:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682044397;
        bh=a/ViuDAHHrYO87qr30b9XlZe4XJfemgAGL0ymbEqFS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B40ly4DvWwA/sA/39GS1VHVAD4PF3hKB2Leb8TBgzaACY/7uHUJtouT1NNMUfNBv4
         D6ExZ3Exb/5IF0RrLLGMc3OImXaHYiC+94PQdNIe6FRfTQxCMIxxW8IbMYIJkju1XS
         vAZIai+Y2eWNPvPxNCO1oGQMvDAswfL62Cco5MGt0nB0lz3GNwuK8gbNMX79DGmTxZ
         0zMPeFmDsAsytq0AZh7kRQ6KNpLwnulpknbTGXaWc2z0261a+p1Pim2lZVvOMgw0qg
         ESJiMqDk4PO6Zltkskl/+OQrvhF4nf5ihITVhWN9I90nksdvhoDEwH+5ZRB+Ltrch5
         s2SvTd0CTNX1w==
Date:   Thu, 20 Apr 2023 19:33:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 1/5] net/sched: act_pedit: simplify 'ex' key
 parsing error propagation
Message-ID: <20230420193315.35e3e9e4@kernel.org>
In-Reply-To: <20230418234354.582693-2-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
        <20230418234354.582693-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 20:43:50 -0300 Pedro Tammela wrote:
> 'err' is returned -EINVAL most of the time.
> Make the exception be the netlink parsing and remove the
> redundant error assignments in the other code paths.

> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index 4559a1507ea5..90f5214e679e 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -54,46 +54,39 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>  
>  	nla_for_each_nested(ka, nla, rem) {
>  		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
> +		int ret;
>  
> -		if (!n) {
> -			err = -EINVAL;
> +		if (!n)
>  			goto err_out;
> -		}
>  		n--;

IMHO this is not worth doing. Setting the error value before the jump
is more idiomatic. If anything I'd remove the unnecessary init of err
to EINVAL at the start of the function.
