Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06F6B8309
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCMUpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCMUps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:45:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E3B1B3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:45:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EDD661489
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F2EC433EF;
        Mon, 13 Mar 2023 20:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678740346;
        bh=pkV75EDzVXHoEoqjbLo658e8MHRWvGjvAAsq4YNelrQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ASEtD/9+xHdMr+osD5ezlJXKCNjNudmEvj5h5G1TR8IX+EnyTWAqO2Couh35WcYKw
         uhzj+soX05JEVCyuzy3T8lxuYR2dKf06iw7Yfv61hh9dntQg42cgoZRPqNbuIGOgV0
         I932KbTbwdghJuZcigcAt4bs6qtrVxLLWWxK97vLCCiIHMWrnMJK2iqw5oSSnGt4GU
         SdNU/GGL/fpWlcTbaAB2Wr8+uTYg0lifQTIxchG2c8bLxHIxFdqBj5gqpAiYkW9msd
         9Swc/FNsVwKslMGxgeS6iKe1calB69hN3UErpB68HfQgN58F9Xq7IEzOLb0s13mCXI
         syLVrJGLHP2tQ==
Message-ID: <c465f247-5305-9aa7-06f1-8958ff6f1990@kernel.org>
Date:   Mon, 13 Mar 2023 14:45:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 1/2] neighbour: annotate lockless accesses to
 n->nud_state
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230313201732.887488-1-edumazet@google.com>
 <20230313201732.887488-2-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230313201732.887488-2-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/23 2:17 PM, Eric Dumazet wrote:
> We have many lockless accesses to n->nud_state.
> 
> Before adding another one in the following patch,
> add annotations to readers and writers.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/net/vxlan/vxlan_core.c  |  4 ++--
>  include/net/neighbour.h         |  2 +-
>  net/bridge/br_arp_nd_proxy.c    |  4 ++--
>  net/bridge/br_netfilter_hooks.c |  3 ++-
>  net/core/filter.c               |  4 ++--
>  net/core/neighbour.c            | 28 ++++++++++++++--------------
>  net/ipv4/arp.c                  |  8 ++++----
>  net/ipv4/fib_semantics.c        |  4 ++--
>  net/ipv4/nexthop.c              |  4 ++--
>  net/ipv4/route.c                |  2 +-
>  net/ipv6/ip6_output.c           |  2 +-
>  net/ipv6/ndisc.c                |  4 ++--
>  net/ipv6/route.c                |  2 +-
>  13 files changed, 36 insertions(+), 35 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


