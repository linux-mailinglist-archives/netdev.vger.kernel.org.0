Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA0E54D629
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 02:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346954AbiFPAfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 20:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbiFPAfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 20:35:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CBE57115
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 17:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949C0B82262
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 00:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94DAC3411A;
        Thu, 16 Jun 2022 00:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655339718;
        bh=tJNYIifvGyw4MZgi/wp/If/B95O3PBuux+2+v2j9NG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=s+tFhcswaMBBoAfj6GZ1f/botaiB5TgCHP5jX5mAoDK4Vuvyon8Oy5lyocyrFVB83
         gLjcUheauuOh3Ic9nUxkXMc4V5i7eon3Rmxg2VaJ36GBwtOeaCxjP0NHMxBBceEvLc
         +3VBSwRhPD2xXDePG4uBWkO+b95yP+QbOJuTTZsfrHQYeEGN5m2H3tZeE7C0g5/jhG
         uo0dVfbtsbz3DsbQn7h2Gl5oY9S2SVkKYKNNosFuMlFMIBlVFW3rbjnbQDwLOx199J
         HDANm4UmXeIlmKN5vNsqJ542Daw9OGjEIVs+jdPXf85E9WFkRv4ROhMRm33XYmHQLJ
         J6K1oxtbO2T4g==
Date:   Wed, 15 Jun 2022 17:35:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     <davem@davemloft.net>, <dsahern@kernel.org>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>,
        <sbrivio@redhat.com>, Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>, maze@google.com
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit
 of dev mtu
Message-ID: <20220615173516.29c80c96@kernel.org>
In-Reply-To: <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
        <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jun 2022 23:01:54 -0600 Subash Abhinov Kasiviswanathan wrote:
> When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.
> 
> addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
> fib6_nh_mtu_change
> 
> As part of handling NETDEV_CHANGEMTU notification we land up on a
> condition where if route mtu is less than dev mtu and route mtu equals
> ipv6_devconf mtu, route mtu gets updated.
> 
> Due to this v6 traffic end up using wrong MTU then configured earlier.
> This commit fixes this by removing comparison with ipv6_devconf
> and updating route mtu only when it is greater than incoming dev mtu.
> 
> This can be easily reproduced with below script:
> pre-condition:
> device up(mtu = 1500) and route mtu for both v4 and v6 is 1500
> 
> test-script:
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1400
> ip -6 route change 2001::/64 dev eth0 metric 256 mtu 1400
> echo 1400 > /sys/class/net/eth0/mtu
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1500
> echo 1500 > /sys/class/net/eth0/mtu

CC maze, please add him if there is v3

I feel like the problem is with the fact that link mtu resets protocol
MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
whatever other quantification of infinity there is) so you don't have 
to touch it as you discover the MTU for v4 and v6? 

My worry is that the tweaking of the route MTU update heuristic will
have no end. 

Stefano, does that makes sense or you think the change is good?
