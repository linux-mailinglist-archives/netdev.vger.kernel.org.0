Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621265849FF
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 04:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiG2C5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 22:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiG2C5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 22:57:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5C57AC2D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 19:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B5DCCE27CB
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEE9C433C1;
        Fri, 29 Jul 2022 02:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659063417;
        bh=GHdBhWNVNnTKC12PNSiPx5/8O4XY66Iy7fxcA677iTU=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=Eli6knwZ08AOpxHpKPv7BAsbJamvfQ+KmC4TzyDfffon838FMlPRPX2Vl++uGWpUi
         Cw+aQRdWAZdfNAOIVcUeWLkOO2nTQ2weSyypBrPddc2HLClEX+C5njMy7kAwsquwuN
         7Ugo3UUobB6ymyFcfwlZ2ESH/KBAqFPgNhRdpi9RrLhbjoggZdP+XCUFp4SZCh4PDr
         ih5JrjgjzLPNpoWXjybr4wsyRdlofxd7d5mOEGT9TFpi39jsP2cFHlD/Ts4L2SjM69
         YaS+q4SI9oirVy0uxlw7vXIK1tjRz1PrAGtWd33et54pbDH0vL+VVhTKNATp+zx1r/
         XGdny1kALjSHw==
Message-ID: <3fe65335-4ffe-d0e4-26c5-009b6dfbc633@kernel.org>
Date:   Thu, 28 Jul 2022 20:56:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: allow unbound socket for packets in VRF when
 tcp_l3mdev_accept set
Content-Language: en-US
To:     Mike Manning <mvrmanning@gmail.com>, netdev@vger.kernel.org,
        jluebbe@lasnet.de
References: <20220725181442.18041-1-mvrmanning@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220725181442.18041-1-mvrmanning@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/22 12:14 PM, Mike Manning wrote:
> The commit 3c82a21f4320 ("net: allow binding socket in a VRF when
> there's an unbound socket") changed the inet socket lookup to avoid
> packets in a VRF from matching an unbound socket. This is to ensure the
> necessary isolation between the default and other VRFs for routing and
> forwarding. VRF-unaware processes running in the default VRF cannot
> access another VRF and have to be run with 'ip vrf exec <vrf>'. This is
> to be expected with tcp_l3mdev_accept disabled, but could be reallowed
> when this sysctl option is enabled. So instead of directly checking dif
> and sdif in inet[6]_match, here call inet_sk_bound_dev_eq(). This
> allows a match on unbound socket for non-zero sdif i.e. for packets in
> a VRF, if tcp_l3mdev_accept is enabled.
> 
> Fixes: 3c82a21f4320 ("net: allow binding socket in a VRF when there's an unbound socket")
> Signed-off-by: Mike Manning <mvrmanning@gmail.com>
> Link: https://lore.kernel.org/netdev/a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de/
> ---
> 
> Nettest results for VRF testing remain unchanged:
> 
> $ diff nettest-baseline-502c6f8cedcc.txt nettest-fix.txt
> $ tail -3 nettest-fix.txt
> Tests passed: 869
> Tests failed:   5
> 
> Disclaimer: While I do not think that there should be any noticeable
> socket throughput degradation due to these changes, I am unable to
> carry out any performance tests for this, nor provide any follow-up
> support if there is any such degradation.
> 
> ---
>  include/net/inet6_hashtables.h |  7 +++----
>  include/net/inet_hashtables.h  | 19 +++----------------
>  include/net/inet_sock.h        | 11 +++++++++++
>  3 files changed, 17 insertions(+), 20 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
