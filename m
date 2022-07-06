Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E2A568B90
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiGFOoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiGFOoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A5D252B9
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F2CB81CF4
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 14:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C48BC341CA;
        Wed,  6 Jul 2022 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657118654;
        bh=mQJxYTYtm+zbpdHKaWs+B74Gn88BDh6IUFuN692DNdk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YPQohdkqzONyxCNnB47Z/wkAnck/QZx9v3X1oVw37Xs5qlyEaey2mu/k21OwP7OBj
         2IXUbQCC49IjRvBxoylFfzoiHHyy564B55epYDC91Esl1q5U5hedtPN24t8fefVKH7
         34J0UlIkSRvJ8VmHAL75L9WJIiA7NYJkLcRjlAQl0Z8kHz/rqq4pYNd1upRccS0eqq
         +g9vuZn3IEiQ4V8T8akBojWwxZkd+lJBfmmkcNFUE4C6heAOp9dNgm5KUlfvub5+GJ
         hJSh+kkz+upr2Jfz0kg98pOzj7Rs6yvaVVV/yhKMXyNrkCnzDCGAbfrQElYVTb97tQ
         I5kLVKpcG1TpA==
Message-ID: <6c066fbb-0664-4a89-8c1e-7c369f6f894c@kernel.org>
Date:   Wed, 6 Jul 2022 08:44:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4] net: ip6mr: add RTM_GETROUTE netlink op
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <20220706100024.112074-1-equinox@diac24.net>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220706100024.112074-1-equinox@diac24.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 4:00 AM, David Lamparter wrote:
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index ec6e1509fc7c..f567c055dba4 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -2510,6 +2512,104 @@ static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pk
>  	rtnl_set_sk_err(net, RTNLGRP_IPV6_MROUTE_R, -ENOBUFS);
>  }
>  
> +static const struct nla_policy ip6mr_getroute_policy[RTA_MAX + 1] = {
> +	[RTA_SRC]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_DST]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
> +	[RTA_TABLE]		= { .type = NLA_U32 },
> +};
> +
> +static int ip6mr_rtm_valid_getroute_req(struct sk_buff *skb,
> +					const struct nlmsghdr *nlh,
> +					struct nlattr **tb,
> +					struct netlink_ext_ack *extack)
> +{
> +	struct rtmsg *rtm;
> +	int err;
> +
> +	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, ip6mr_getroute_policy,
> +			  extack);
> +	if (err)
> +		return err;
> +
> +	rtm = nlmsg_data(nlh);
> +	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
> +	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
> +	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
> +	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
> +		NL_SET_ERR_MSG(extack,
> +			       "ipv6: Invalid values in header for multicast route get request");

This (and other NL_SET_ERR_MSG) should be NL_SET_ERR_MSG_MOD and then
drop the "ipv6: " prefix on the messages; it comes from 'KBUILD_MODNAME
": "'

> +		return -EINVAL;
> +	}
> +
> +	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
> +	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
> +		NL_SET_ERR_MSG(extack, "ipv6: rtm_src_len and rtm_dst_len must be 128 for IPv6");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +


with that change:
Reviewed-by: David Ahern <dsahern@kernel.org>
