Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8354F560A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 08:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiDFGIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 02:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447097AbiDFE5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 00:57:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B73F26EC86
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 17:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5105861682
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 00:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C3FC385A1;
        Wed,  6 Apr 2022 00:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649206064;
        bh=x8hlaPnKCvTQAZAvmMUcnfRBWVYpxkPC6Fq34sU69Sg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=agvTXxmPzEr9u+Qjx0z3NH1eHf3Oxrqpx5gWwCxPvAmYGAOdb/Hf3ypspbykGuAE/
         J5G4ZpTO+3b7va2+xeGY1tRa/CdkabDfFm121RXiYjnvxxxf5EOw6JfDEUv+qnx/A+
         78qlKaB+6weFRPsr0uYuA4ab8eeLIetLChvcG5gjIhjmMypfMIrsCdhPCYUY80wT04
         THzBL8rwvnFRFisSu7AuqEtfB2us4EGUEH/yFh1NL1a6lySS2iF6qMV3L+tVIPck8H
         Qk0b3C04fhjSJvU4g71haxN7l4EoULYziBYi7ySEgIX0sguRJPqXurYWLF90WTHF+X
         45NvQ4uHWkoGg==
Date:   Tue, 5 Apr 2022 17:47:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v3 net-next 3/4] rtnetlink: return ENODEV when ifname
 does not exist and group is given
Message-ID: <20220405174743.153b1a36@kernel.org>
In-Reply-To: <20220405134237.16533-3-florent.fourcot@wifirst.fr>
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
        <20220405134237.16533-3-florent.fourcot@wifirst.fr>
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

On Tue,  5 Apr 2022 15:42:36 +0200 Florent Fourcot wrote:
> Changes in v3:
>   * Use a boolean to have condition duplication
> 
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
> ---
>  net/core/rtnetlink.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 33dbeed7e531..e93f4058cf08 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3279,6 +3279,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	struct net *dest_net, *link_net;
>  	struct nlattr **slave_data;
>  	char kind[MODULE_NAME_LEN];
> +	bool link_lookup = false;

link_specified ? Somehow link_lookup does not speak to me.

>  	struct net_device *dev;
>  	struct ifinfomsg *ifm;
>  	char ifname[IFNAMSIZ];
> @@ -3298,12 +3299,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		return err;
>  
>  	ifm = nlmsg_data(nlh);
> -	if (ifm->ifi_index > 0)
> +	if (ifm->ifi_index > 0) {
> +		link_lookup = true;
>  		dev = __dev_get_by_index(net, ifm->ifi_index);
> -	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
> +	} else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
> +		link_lookup = true;
>  		dev = rtnl_dev_get(net, tb);
> -	else
> +	} else {
>  		dev = NULL;

maybe set it to false here and don't do the initialization.
It doesn't matter in practice but the function has a "retry"
goto which skips the init.

> +	}
>  
>  	master_dev = NULL;
>  	m_ops = NULL;
> @@ -3405,8 +3409,14 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		return do_setlink(skb, dev, ifm, extack, tb, status);
>  	}
>  
> +

spurious new line

>  	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
> -		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
> +		/* No dev found and NLM_F_CREATE not set. Requested dev does not exist,
> +		 * or it's for a group
> +		*/
> +		if (link_lookup)
> +			return -ENODEV;
> +		if (tb[IFLA_GROUP])
