Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC85166A931
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 05:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjANEWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 23:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjANEWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 23:22:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB44C95;
        Fri, 13 Jan 2023 20:22:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7546CB822C2;
        Sat, 14 Jan 2023 04:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57EBC433D2;
        Sat, 14 Jan 2023 04:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673670132;
        bh=3hPwEascL6coLYgOqQdt4/tPGkfw2pv70pCZR8ByrIU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nCaX3WqXEyyvxS2pgfoobhBC3rq68OUDIt8u9GFhrPIB9wzT1yBsbtioAr7GCivZ/
         T0XDI9Z37NCupbNwHQ6S1vHPI1LHjOOyJVzMGQayl1yyweWJu7jcHPE+LLyDwrFmkt
         6twxwKZPl9HMgbKsaDOgYJuINYrvzKRl4Erlcy/VK4vjiG/cVfPhMkwYWKceDCAZ6G
         xAl8LdBmKGNN2s4BPGeLsowoNH57HiiDd6ZuvohD7djzGMZLW3TJZ+tPFW0To5lH17
         iqEam6rI6iSHHMVxc/S6lxs/7HzJrfbC2AhYmrN4GXz9I2hfuU6VECUNrJV3NMd2RA
         B8MJR8EQZ2gRg==
Date:   Fri, 13 Jan 2023 20:22:09 -0800
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
Message-ID: <20230113202209.158ead21@kernel.org>
In-Reply-To: <20230111161706.1465242-5-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
        <20230111161706.1465242-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 18:16:58 +0200 Vladimir Oltean wrote:
> +	int len = nla_total_size(sizeof(u32)); /* _STATS_SRC */
>  	unsigned int n_grps = 0, n_stats = 0;
> -	int len = 0;

nit: don't hide the first field in init
