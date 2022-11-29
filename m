Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16BBB63C537
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiK2Qdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbiK2Qdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:33:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A25F855;
        Tue, 29 Nov 2022 08:33:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3179AB8167C;
        Tue, 29 Nov 2022 16:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621DEC433C1;
        Tue, 29 Nov 2022 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669739626;
        bh=1eCnX9wv/YcnjFLvGFP9MR+rIFG900hL1gZWW6akEu0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fMz6jko+ubzb9ARnJH5NgEb0RBLex8Jk5ZeQKa2R2VPbTqFtDKqV0MW4SrR7vDEZ3
         DXK4aUOQEzBZY2DNjx38EtgqK0KCPaESNevMwjbwGxf6eT24Sv1g0bIWyEy9ngSZkp
         zGd+g3qAVuTTRRBYZBord8yGmOJYy0XdleBpkQlSqRVL24d4RkMzbGh9MWbWfKk2Ah
         LA+ltdQafptIbVf0gaBx8MVNQWC3c2SVvvaEcUldq2sgRh+hTVrzrLapNb/EY7Ctb+
         Z1jQUanCvcsqFePjllcxBCXw/LkeUeezqvLw1b9C7WOoAPu6WyaqqBR6tOrULzEMh9
         HeqAwxY3QGRlQ==
Message-ID: <a37f9c82-9f25-c5ba-f941-1cedf8c10187@kernel.org>
Date:   Tue, 29 Nov 2022 09:33:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net] net: Add a gfp_t parameter in ip_fib_metrics_init to
 support atomic context
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20221129055317.53788-1-duoming@zju.edu.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221129055317.53788-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 10:53 PM, Duoming Zhou wrote:
> The ip_fib_metrics_init() do not support atomic context, because it
> calls "kzalloc(..., GFP_KERNEL)". When ip_fib_metrics_init() is used
> in atomic context, the sleep-in-atomic-context bug will happen.

Did you actually hit this sleep-in-atomic-context bug or is it theory
based on code analysis?

> 
> For example, the neigh_proxy_process() is a timer handler that is
> used to process the proxy request that is timeout. But it could call
> ip_fib_metrics_init(). As a result, the can_block flag in ipv6_add_addr()
> and the gfp_flags in addrconf_f6i_alloc() and ip6_route_info_create()
> are useless. The process is shown below.
> 
>     (atomic context)
> neigh_proxy_process()
>   pndisc_redo()
>     ndisc_recv_ns()
>       addrconf_dad_failure()
>         ipv6_add_addr(..., bool can_block)
>           addrconf_f6i_alloc(..., gfp_t gfp_flags)

	cfg has fc_mx == NULL.

>             ip6_route_info_create(..., gfp_t gfp_flags)

	rt->fib6_metrics = ip_fib_metrics_init(net, cfg->fc_mx, cfg->fc_mx_len,
extack);

>               ip_fib_metrics_init()

        if (!fc_mx)
                return (struct dst_metrics *)&dst_default_metrics;


>                 kzalloc(..., GFP_KERNEL) //may sleep
> 

