Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADB4DA62C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352550AbiCOXUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352544AbiCOXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4702AC6E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F66A60EA9
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 23:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4255C340ED;
        Tue, 15 Mar 2022 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386349;
        bh=iqCau1bRwlWSl6BC1nex1PVfU6+9EqCWuOliE+WJ8ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=An/UJP2wvM00Wp5VCHoe1fKGTXSsSYz8HtlP9DGx4LDJ1BBhk3xL0G8MON7AmgS3P
         WdLtwjunaKFtlgjRCiKtfwXPotMxLiXyfZd4SApAey+j5BJQ2uSdxl9/1ZrREmIXxK
         Lmh9nttKIcex8dlCwXPuXXBKw2sgPV2vCpG9RgsYdz+GkOf57rlQSLOTb+nQxAHWGV
         W47nOjcyNG2RfCnO3S64LxUeKOFxeXzMYxKFV2IE49PROV0gOueCFz6V4OtTkhRNbh
         V3oxXNpwlbBsrT7FJxJY3ZW7LRNzF3wwTBh6TEiNLjk9bsjDoxsNGiCbt1Q3NLUKnd
         PykS7CSbWjfdw==
Date:   Tue, 15 Mar 2022 16:19:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>, ntspring@fb.com
Subject: Re: [PATCH v3 net] ipv6: tcp: drop silly ICMPv6 packet too big
 messages
Message-ID: <20220315161907.653379f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210708072109.1241563-1-eric.dumazet@gmail.com>
References: <20210708072109.1241563-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Jul 2021 00:21:09 -0700 Eric Dumazet wrote:
> +	/* Drop requests trying to increase our current mss.
> +	 * Check done in __ip6_rt_update_pmtu() is too late.
> +	 */
> +	if (tcp_mtu_to_mss(sk, mtu) >= tcp_sk(sk)->mss_cache)
> +		return;

Hi Eric! I think this breaks TFO + pMTU.

mss_cache is 1208 but TFO seems to use tp->rx_opt.mss_clamp
to size the packet. So we ignore the incoming PTB. Should we 
init mss_cache for TFO?
