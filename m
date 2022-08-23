Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB24259CDC5
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbiHWBZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235691AbiHWBZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:25:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC4C57E12
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16434CE16B7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29973C433C1;
        Tue, 23 Aug 2022 01:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661217924;
        bh=Ur11xO5l606JON8bSFXH+67fHouiHohRuESyBnjA3wg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CMRoVQxtTtpP/du9o9RC/isN5WJWeB4cCMwEi4XO1qGFBH6UYjPXwppSyJxQsMv4z
         X6n4IAhPAXDX7i/Q6l5BpYvItgRa8a+leISL3GmCSGgGjd7TlSMwSM/jDVNXqPuUE4
         xgy2lf36AYyauxE/Uqtr2ZJtJGUHXYWVe41PXbWSPTE7cZVwnAS2/37f/5jUnT6L8w
         JfgaaXqMM42klhl4RSnJNLqRhtmBKjiXS37G8sX1udCLDf4VI7XCDTjsOsHNFOlL2I
         0deIGImgnsxLC2ZhzgyFqntdsooFTkzCar5IU0AWufa1UBkCwIEn82Vu79P7/I+vEF
         Tz+18cwlgwVvQ==
Date:   Mon, 22 Aug 2022 18:25:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
Message-ID: <20220822182523.6821e176@kernel.org>
In-Reply-To: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 20:39:25 +0300 Vladimir Oltean wrote:
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index c548b969b083..804a00324c8b 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2487,7 +2487,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
>  			if (!err)
>  				dsa_bridge_mtu_normalization(dp);
>  			if (err == -EOPNOTSUPP) {
> -				if (!extack->_msg)
> +				if (extack && !extack->_msg)
>  					NL_SET_ERR_MSG_MOD(extack,
>  							   "Offloading not supported");

Other offload paths set the extack prior to the driver call,
which has the same effect. Can't we do the same thing here?
Do we care about preserving the extack from another notifier 
handler or something? Does not seem like that's the case judging 
but the commit under Fixes.

If it is the case (and hopefully not) we should add a new macro wrapper.
Manually twiddling with a field starting with an underscore makes
me feel dirty. Perhaps I have been writing too much python lately.
