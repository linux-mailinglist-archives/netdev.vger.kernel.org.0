Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA34522569
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiEJU1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEJU1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6580F1A830
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAB0A61674
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A683C385CB;
        Tue, 10 May 2022 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652214439;
        bh=0Su4DxQf57kauRZz2GCQbO6/eidVhZjdC8r4AJrbMTk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HrM3+u6D9dkFV+m4j/tLtPqANnMNG+hKHXca+PYBNthYZI2OfFddvQNQZCIbyyXgw
         JMJaqkKyiqJuB8juLjYEHhPs/YKHM5MZCs1/L60t4O4KvG4NlkoIF78YEvCeEK2IeC
         pnNSZI0EbkSnJC1RwyMWSmY2ngA+6bg10zs31NsK/8FyqAIrxOSnJGLpVTSMVDbGtz
         31BRFzBJ35YkSXSAPvI1VDtMLoAA66FWVpP3awMUw7CxXgWC9tpq9TkgJWE2YrFEc8
         b48uuDSjb5rAZC0LbMxcFZIDKy9bt+y+1NVItHtgcSu3qwS1j7M4tCAT/EOZfW+IS3
         d3GIKcDHy/4PA==
Message-ID: <c083d69e-2310-39d3-960b-1971f095463c@kernel.org>
Date:   Tue, 10 May 2022 14:27:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net] net: ping6: Fix ping -6 with interface name
Content-Language: en-US
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220510172739.30823-1-tariqt@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220510172739.30823-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/22 11:27 AM, Tariq Toukan wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> When passing interface parameter to ping -6:
> $ ping -6 ::11:141:84:9 -I eth2
> Results in:
> PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
> ping: sendmsg: Invalid argument
> ping: sendmsg: Invalid argument
> 
> Initialize the fl6's outgoing interface (OIF) before triggering
> ip6_datagram_send_ctl.
> 
> Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/ipv6/ping.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index ff033d16549e..83f014559c0d 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -106,6 +106,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  
>  		opt.tot_len = sizeof(opt);
>  		ipc6.opt = &opt;
> +		memset(&fl6, 0, sizeof(fl6));
> +		fl6.flowi6_oif = oif;
>  
>  		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
>  		if (err < 0)

I agree that fl6 is used unitialized here, but right after this is:

        memset(&fl6, 0, sizeof(fl6));

        fl6.flowi6_proto = IPPROTO_ICMPV6;
        fl6.saddr = np->saddr;
        fl6.daddr = *daddr;
        fl6.flowi6_oif = oif;

so adding a memset before the call to ip6_datagram_send_ctl duplicates
the existing one. Best to move the memset before the 'if
(msg->msg_controllen) {'
