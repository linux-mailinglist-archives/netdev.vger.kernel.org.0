Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2E564971
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 21:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiGCTIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 15:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiGCTHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 15:07:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E2E240
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 12:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30D49B80BEB
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 19:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976EAC341C6;
        Sun,  3 Jul 2022 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656875254;
        bh=/3BCI/eAgkQbdDCYF0CpQ3+lKQCP4tF9lzj1Pyd2Bk0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SsCYhJ4NxefmAYLCJbxJmC+3pZaP6dsS+2ybgpVz2NpXWY4WJfu4l55C4t9fgJ5hF
         WDaUoWC2zNxWeDMeLanBlRvNxAlRQ1aeAGcCDQaH/Gr1wFnxaaUodd/fte37uDcuDj
         kY5RwdIVBrw2sk8i+Xw1fSoIuNRcTV/ESvrhPCJrCmCoxg7JDMCPjjBjzxqoQ1XVvh
         OGEVkSHnyEkkhtpBR6TKe/ynLCdUDgPl+CpRffOPMDCAkuhVnws3ZjkIBbXScrXCIr
         l5D6NPz8S0Dh7ITXwP8b/RmQageDZ5QGzUY6C53UAU14iSeX/9Yu/+BQHID9DYt24d
         G+6Hemd5QdVGA==
Message-ID: <0d18f6a3-78da-2dee-d715-39a043870eec@kernel.org>
Date:   Sun, 3 Jul 2022 13:07:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 2/2] net: ip6mr: add RTM_GETROUTE netlink op
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220630202706.33555ad2@kernel.org>
 <20220701075805.65978-1-equinox@diac24.net>
 <20220701075805.65978-3-equinox@diac24.net>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220701075805.65978-3-equinox@diac24.net>
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

On 7/1/22 1:58 AM, David Lamparter wrote:
> @@ -2510,6 +2512,121 @@ static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pk
>  	rtnl_set_sk_err(net, RTNLGRP_IPV6_MROUTE_R, -ENOBUFS);
>  }
>  
> +static int ip6mr_rtm_valid_getroute_req(struct sk_buff *skb,
> +					const struct nlmsghdr *nlh,
> +					struct nlattr **tb,
> +					struct netlink_ext_ack *extack)
> +{
> +	struct rtmsg *rtm;
> +	int i, err;
> +
> +	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
> +		NL_SET_ERR_MSG(extack, "ipv6: Invalid header for multicast route get request");
> +		return -EINVAL;
> +	}
> +
> +	if (!netlink_strict_get_check(skb))
> +		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
> +					      rtm_ipv6_policy, extack);

Since this is new code, it always operates in strict mode.

> +
> +	rtm = nlmsg_data(nlh);
> +	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
> +	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
> +	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
> +	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
> +		NL_SET_ERR_MSG(extack, "ipv6: Invalid values in header for multicast route get request");
> +		return -EINVAL;
> +	}
> +
> +	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
> +					    rtm_ipv6_policy, extack);

nlmsg_parse here.


