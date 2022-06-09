Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AFA5450F6
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344525AbiFIPgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344113AbiFIPgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D56818E464;
        Thu,  9 Jun 2022 08:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 076DB61F37;
        Thu,  9 Jun 2022 15:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02E1C34115;
        Thu,  9 Jun 2022 15:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654789003;
        bh=3Bfa3g8QOy3SZi2Yq0u8FnykgzHcPScJ0+28NvuA3AI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TghLKaKAsjXA1dxTXX5i3BtTL1h0XNZKP96nWd3bi21OhL9iaIwpoUxTtw9Q9m4Sb
         Nq3MYTpJS/zE0lxSAXSQSF6Lpy5lTAg8oUnj/FnacDOVtAXYCTlhyq2yzqBI9/IyJ3
         Ply7/33B0guHDJ8N1A02QtzByx8wBYZXUEpi7ZCV7WnpguCLR3edlpxyLnjQx6h6MJ
         X2jHSyrNLnhDRKDcksz8FgBiRBkabHEtJzE0yI25RriswvZn7YTkwgqTcj9w9ONkh1
         zgO8uMciC7JG6h3vF4jOGmOcdPEk2rZpLeuVH0X9+YNC00682fQq3iCGQHQUaP9E66
         KHBYoKXnzthAw==
Message-ID: <6559e518-fd7a-ea54-c576-c5454abf6c73@kernel.org>
Date:   Thu, 9 Jun 2022 09:36:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [net] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs
 using flowi_l3mdev
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Anton Makarov <am@3a-alliance.com>
References: <20220608091917.20345-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220608091917.20345-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/22 3:19 AM, Andrea Mayer wrote:
> Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
> reset for port devices") adds a new entry (flowi_l3mdev) in the common
> flow struct used for indicating the l3mdev index for later rule and
> table matching.
> The l3mdev_update_flow() has been adapted to properly set the
> flowi_l3mdev based on the flowi_oif/flowi_iif. In fact, when a valid
> flowi_iif is supplied to the l3mdev_update_flow(), this function can
> update the flowi_l3mdev entry only if it has not yet been set (i.e., the
> flowi_l3mdev entry is equal to 0).
> 
> The SRv6 End.DT6 behavior in VRF mode leverages a VRF device in order to
> force the routing lookup into the associated routing table. This routing
> operation is performed by seg6_lookup_any_nextop() preparing a flowi6
> data structure used by ip6_route_input_lookup() which, in turn,
> (indirectly) invokes l3mdev_update_flow().
> 
> However, seg6_lookup_any_nexthop() does not initialize the new
> flowi_l3mdev entry which is filled with random garbage data. This
> prevents l3mdev_update_flow() from properly updating the flowi_l3mdev
> with the VRF index, and thus SRv6 End.DT6 (VRF mode)/DT46 behaviors are
> broken.
> 
> This patch correctly initializes the flowi6 instance allocated and used
> by seg6_lookup_any_nexhtop(). Specifically, the entire flowi6 instance
> is wiped out: in case new entries are added to flowi/flowi6 (as happened
> with the flowi_l3mdev entry), we should no longer have incorrectly
> initialized values. As a result of this operation, the value of
> flowi_l3mdev is also set to 0.
> 
> The proposed fix can be tested easily. Starting from the commit
> referenced in the Fixes, selftests [1],[2] indicate that the SRv6
> End.DT6 (VRF mode)/DT46 behaviors no longer work correctly. By applying
> this patch, those behaviors are back to work properly again.
> 
> [1] - tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
> [2] - tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh
> 
> Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
> Reported-by: Anton Makarov <am@3a-alliance.com>
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 9fbe243a0e81..98a34287439c 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -218,6 +218,7 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
>  	struct flowi6 fl6;
>  	int dev_flags = 0;
>  
> +	memset(&fl6, 0, sizeof(fl6));
>  	fl6.flowi6_iif = skb->dev->ifindex;
>  	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
>  	fl6.saddr = hdr->saddr;

Missed the open initialization of this flow struct. Thanks for the fix:

Reviewed-by: David Ahern <dsahern@kernel.org>
