Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2054EE6C5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 05:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiDADib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 23:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244625AbiDADia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 23:38:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D9C103D84
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 20:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA02B82201
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 03:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA87C2BBE4;
        Fri,  1 Apr 2022 03:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648784199;
        bh=orAtkJyFaQk31S0CA5r//FyjA4422x2SAZsoEUCiZDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YHPbP1zYUOgUtEQqHiVHZC/EsEUNb4Xuwj0uNCd2vtyKadvROq+yGWOjBvgJBmzEf
         qWhqbsfpK7VFwDJg67chruhwJZAwGzQel0ovRUKLIEVuF8LKXM3PZKFHDjWHd7GUaD
         VvHoaP5c57avIzxk7MtCmU39zIY6CwVwBozMb8co8euleABtXeB4ivSZlUWKIRt9Uq
         vy27Xt0Pwl9VffBLEPwnZoTB1Yw7ZPhSm9wB4h8Cv6k5QQWr/uPx9oiflGG10vrgvW
         OXSjMqjrsFeg+5PVpcW+FuGUwAIKUjbuuFJQE7JlhiYYxB37R0Ef0NseHpYe9/YKde
         tNWw9B7pcYNOw==
Date:   Thu, 31 Mar 2022 20:36:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org
Cc:     Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net-next] rtnetlink: return ENODEV when ifname does not
 exist and group is given
Message-ID: <20220331203637.004709d4@kernel.org>
In-Reply-To: <20220331123502.6472-1-florent.fourcot@wifirst.fr>
References: <20220331123502.6472-1-florent.fourcot@wifirst.fr>
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

On Thu, 31 Mar 2022 14:35:02 +0200 Florent Fourcot wrote:
> From: Florent Fourcot <florent.fourcot@wifirst.fr>
> To: netdev@vger.kernel.org
> Cc: Florent Fourcot <florent.fourcot@wifirst.fr>, Brian Baboch <brian.baboch@wifirst.fr>

Please run the patches thru ./scripts/get_maintainer.pl.
netdev is high volume (and Gmail hates it), we really need people 
to CC potential reviewers.

> When the interface does not exist, and a group is given, the given
> parameters are being set to all interfaces of the given group. The given
> IFNAME/ALT_IF_NAME are being ignored in that case.
> 
> That can be dangerous since a typo (or a deleted interface) can produce
> weird side effects for caller:
> 
> Case 1:
> 
>  IFLA_IFNAME=valid_interface
>  IFLA_GROUP=1
>  MTU=1234
> 
> Case 1 will update MTU and group of the given interface "valid_interface".
> 
> Case 2:
> 
>  IFLA_IFNAME=doesnotexist
>  IFLA_GROUP=1
>  MTU=1234
> 
> Case 2 will update MTU of all interfaces in group 1. IFLA_IFNAME is
> ignored in this case
> 
> This behaviour is not consistent and dangerous. In order to fix this issue,
> we now return ENODEV when the given IFNAME does not exist.

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 159c9c61e6af..3313419bbcba 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3417,10 +3417,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	}
>  
>  	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
> -		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
> +		if (ifm->ifi_index == 0 && tb[IFLA_GROUP]) {
> +			if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
> +				NL_SET_ERR_MSG(extack, "Cannot find interface with given name");
> +				return -ENODEV;
> +			}
>  			return rtnl_group_changelink(skb, net,
>  						nla_get_u32(tb[IFLA_GROUP]),
>  						ifm, extack, tb);
> +		}
>  		return -ENODEV;
>  	}

Would it be slightly cleaner to have a similar check in
validate_linkmsg()? Something like:

	if (!dev && !ifm->ifi_index && tb[IFLA_GROUP] &&
	    (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]))
