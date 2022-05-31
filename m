Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158953932F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345053AbiEaOcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244389AbiEaOcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:32:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230132EF4
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DACE2B81199
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 14:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01407C385A9;
        Tue, 31 May 2022 14:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654007515;
        bh=/mocd5XcGuqflFwsD790qH6He3e3717biPtFsUgkwzU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=opJ2XsOyuU/KmivF/r7l66Eqqm2rn40k7zPxhScxZFsTVxXPDi+0p6AbtpSE0qaWw
         TqKM2QnbyhlDITA0vRdFd3/7MHzsc1nbpVJdR9CoKNTzhqrticc2Vvb+CBoW6qGCXL
         BUqhUbzgFT4mZk0xdBM4ASqFiQNNMB2R4HFN2W5Aqsodudnl+TQs187gh1hRH9sFoi
         mJdTcdG4yXf8mFCTn+BU2ZC9AEEQVb95twvdx/W09mvDiVcCmfNXbDj8PJWoN2qEPT
         lzFbNlr9TpetRc0VlidcBvshW4+r75bTc3BFv5p5owkedL3Sx5oXobNqcS1ZW3zqZ9
         f63uShoJ8Ghhg==
Message-ID: <461d1b36-70d3-31fb-6e03-edad2d39b04c@kernel.org>
Date:   Tue, 31 May 2022 08:31:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net V3] net: ping6: Fix ping -6 with interface name
Content-Language: en-US
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220531084544.15126-1-tariqt@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220531084544.15126-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/22 2:45 AM, Tariq Toukan wrote:
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
> ip6_datagram_send_ctl. Don't wipe fl6 after ip6_datagram_send_ctl() as
> changes in fl6 that may happen in the function are overwritten explicitly.
> Update comment accordingly.
> 
> Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/ipv6/ping.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> V3:
> Per David Ahern's comment, moved fl6.flowi6_oif init to the
> shared flow right after the memset.
> 
> V2:
> Per David Ahern's comment, moved memset before if (msg->msg_controllen),
> and updated the code comment accordingly.
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

The patch set with the Fixes tag added selftests using cmsg_sender.c.
You can extend it to support IPV6_PKTINFO and submit a selftest for this
case to -next when it opens.
