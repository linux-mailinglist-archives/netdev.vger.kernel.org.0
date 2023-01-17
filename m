Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB12066E761
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjAQUE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjAQUCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:02:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A6946D44;
        Tue, 17 Jan 2023 10:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1CCB81263;
        Tue, 17 Jan 2023 18:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA69C433EF;
        Tue, 17 Jan 2023 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673981686;
        bh=kp5UsYKs1IV4dCBlFmKi8ZUkvTK5si51bJjpJiZUtbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P9e9tCj+d3Q6pIeFIhMLJQAsynNUlrMg25JsaG6CMXC4BWLvcVYsxOf4UoJh+3Zn3
         EqW8jBbtEKujOC5x6nd3lYYK3MwGkyyS56PTcb/WKCiKRNxYSh5dQPS8r/SIHHaLAI
         Fs8ib6i/kDPvVftaMVSsfcj05fh2mUaT/asL6wWX57Po+tJ/pVS2n618jHFFKNuiJQ
         ldi7agz2q5l6Yp/eEJ/5lC7gzCeZzaGG6wC4BnuBHbAJ7NX2GOAAEcIr9LCFA6OZT5
         AwXGGWl0OL1AfCXhuTvPCvKfZOza3GD81LWURXyxHUclDfe/c5N4svktp5mKtd+jjg
         NZ7R/CtQdqA9w==
Date:   Tue, 17 Jan 2023 10:54:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 04/12] net: ethtool: netlink: retrieve stats
 from multiple sources (eMAC, pMAC)
Message-ID: <20230117105444.7c1c1e35@kernel.org>
In-Reply-To: <20230116174234.yzq6cnczs6fxww6q@skbuf>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
        <20230111161706.1465242-5-vladimir.oltean@nxp.com>
        <20230113204336.401a2062@kernel.org>
        <20230114232214.tj6bsfhmhfg3zjxw@skbuf>
        <20230116174234.yzq6cnczs6fxww6q@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 19:42:34 +0200 Vladimir Oltean wrote:
> The request seems to be for ETHTOOL_A_PAUSE_HEADER to use a policy like this:
> 
>  const struct nla_policy ethnl_header_policy_mac_stats[] = {
>  	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
>  	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
>  					    .len = ALTIFNAMSIZ - 1 },
>  	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
>  							  ETHTOOL_FLAGS_STATS),
> +	[ETHTOOL_A_HEADER_MAC_STATS_SRC] = NLA_POLICY_MASK(NLA_U32,
> +							   ETHTOOL_MAC_STATS_SRC_PMAC),
>  };
> 
> and for ETHTOOL_A_STATS_HEADER to use a policy like this:
> 
> const struct nla_policy ethnl_header_policy_mac_stats_src_basic[] = {
> 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
> 	[ETHTOOL_A_HEADER_DEV_NAME]	= { .type = NLA_NUL_STRING,
> 					    .len = ALTIFNAMSIZ - 1 },
> 	[ETHTOOL_A_HEADER_FLAGS]	= NLA_POLICY_MASK(NLA_U32,
> 							  ETHTOOL_FLAGS_BASIC),
> +	[ETHTOOL_A_HEADER_MAC_STATS_SRC] = NLA_POLICY_MASK(NLA_U32,
> +							   ETHTOOL_MAC_STATS_SRC_PMAC),
> };
> 
> Did I get this right?

Sorry for the delay, I was out for $national-holiday.

This would be right, but it seems like you went for the other option 
in v3, which is also fine.
