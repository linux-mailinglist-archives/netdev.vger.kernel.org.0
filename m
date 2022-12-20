Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EAE6526B3
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiLTS6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 13:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLTS6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 13:58:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F0D1B1F5
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 10:58:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84F1DB81979
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 18:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04640C433D2;
        Tue, 20 Dec 2022 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671562707;
        bh=o/q6PmbyzDUD05jSsGV2QMxXsJLP5rveEOqAtGyDIJ4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kq7Bi7tjQIydqTALy5Uz1R6zX/y8iMjdeN+WwrX8d3BukAYo68W5KkHMH36ov53cz
         R1xgSfnO1yboDlWUMsi2utWSnZS8UIZlu4UPKQPPJ6G0obUfdzOgRwt8bKFtIvJVXM
         8fDrxc2mLR0KU64GcuNI5fDFtrmDDPCXISbQrTDevOJ68n+XBy+gfe4fxiqK5lf22w
         ga6peb6w/FrPClQ0Krdw2RgqOLiLtUl0MF4HXTB794RapJPzWpdBRjGmPbNyYumP3P
         2dizTyLRH0Vb2U4yxdFDl2RhXZGRavQ4FpBBZ9/dD/T/tRIb6vVvU7g//ww71Cqo4X
         gseXywcjpjjOA==
Message-ID: <5fc56e61-487f-96e8-5b39-c64f891eb334@kernel.org>
Date:   Tue, 20 Dec 2022 11:58:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net] net: vrf: determine the dst using the original
 ifindex for multicast
Content-Language: en-US
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, Jianlin Shi <jishi@redhat.com>
References: <20221220171825.1172237-1-atenart@kernel.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221220171825.1172237-1-atenart@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/22 10:18 AM, Antoine Tenart wrote:
> Multicast packets received on an interface bound to a VRF are marked as
> belonging to the VRF and the skb device is updated to point to the VRF
> device itself. This was fine even when a route was associated to a
> device as when performing a fib table lookup 'oif' in fib6_table_lookup
> (coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
> FLOWI_FLAG_SKIP_NH_OIF was set.
> 
> With commit 40867d74c374 ("net: Add l3mdev index to flow struct and
> avoid oif reset for port devices") this is not longer true and multicast
> traffic is not received on the original interface.
> 
> Instead of adding back a similar check in fib6_table_lookup determine
> the dst using the original ifindex for multicast VRF traffic. To make
> things consistent across the function do the above for all strict
> packets, which was the logic before commit 6f12fa775530 ("vrf: mark skb
> for multicast or link-local as enslaved to VRF"). Note that reverting to
> this behavior should be fine as the change was about marking packets
> belonging to the VRF, not about their dst.
> 
> Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
> Cc: David Ahern <dsahern@kernel.org>
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/net/vrf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


