Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7886EA1BD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjDUCli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDUClh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:41:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52132D56
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7D460FF1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73784C433EF;
        Fri, 21 Apr 2023 02:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682044895;
        bh=clFHDFNX7bNxEcKuZ6g+XCG0wWh+QEc40qVwC0Z73oA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tsy/s0STizESqkETtkI56XHCuwWM1eqF6JBg5u18pSglEOsjzoiGai0gfBwGMMM0u
         InYbrAWB5Qxbkik8J2ALX1Mq5PBPhvAi/Dtm3sa1++Tt1eLj5Z3lwBXNkXPRXZxQFH
         yzuHlmk7CXwAwRNAE+bpCAQdgW07o9goen0kWCLMgemSI65P+Re1tX438PNrzgMAEg
         5R6tQ2qjglxwFF/qaWm2tC+o/EhcLIalWa44zs3FP+zwW9k/froHhviSxeHl5VnimW
         DniRlZ3xGHRhtkpMy4MRPi5OPvZW3SN9WaUFNSEf2ERnfqAjPf9EGb9xiYXRoeB73a
         UYpONj+SRnEXA==
Date:   Thu, 20 Apr 2023 19:41:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 3/5] net/sched: act_pedit: check static
 offsets a priori
Message-ID: <20230420194134.1b2b4fc8@kernel.org>
In-Reply-To: <20230418234354.582693-4-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
        <20230418234354.582693-4-pctammela@mojatatu.com>
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

On Tue, 18 Apr 2023 20:43:52 -0300 Pedro Tammela wrote:
> @@ -414,12 +420,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>  					       sizeof(_d), &_d);
>  			if (!d)
>  				goto bad;
> -			offset += (*d & tkey->offmask) >> tkey->shift;
> -		}
>  
> -		if (offset % 4) {
> -			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
> -			goto bad;
> +			offset += (*d & tkey->offmask) >> tkey->shift;

this line loads part of the offset from packet data, so it's not
exactly equivalent to the init time check. It's unlikely to be used
but I think that rejecting cur % 4 vs data patch check only is
technically a functional change, so needs to be discussed in the commit
msg.

> +			if (offset % 4) {
> +				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
> +				goto bad;
> +			}

