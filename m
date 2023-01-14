Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E3466A947
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 05:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjANEnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 23:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjANEnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 23:43:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E819A4;
        Fri, 13 Jan 2023 20:43:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C53A60244;
        Sat, 14 Jan 2023 04:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EC1C433EF;
        Sat, 14 Jan 2023 04:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673671419;
        bh=Aw1JOVEKYhI6P8qbtUHjmC7jHC2m7SKSHccHTWk4hnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dhZOMye8WuOwIbtWLRD2HsU6aDCR0iV7kCl3rRMnP3RvWOACTltc5Tm0ferN1uL3m
         vydqEMMX5tlNnntK9rTUyHc+JQ91q6xdD2ZJ5fHHx8g/MinjcSbJPCbEsBs0hMWwR1
         id1avQjeVaNHl/6kOzqQ9LjQNOLcTg5bwNl8x+UnhioYfX/aQC2ZytjDl9tfLtbROP
         19sbo19XVRPkeU+8swtsGsn3nw5jX7td6zXKqwmd//bmtPsMHrKmAXNY/Dlx0Mzd+R
         Rax0A6EfHNsUVCNg4gJKxVFYsBb1m7B5BLe6ge0UlMdVh9jBKmGuoVt+Yr/oBIekjY
         uRkX1vfLWy2gg==
Date:   Fri, 13 Jan 2023 20:43:36 -0800
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
Message-ID: <20230113204336.401a2062@kernel.org>
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
> +/**
> + * enum ethtool_stats_src - source of ethtool statistics
> + * @ETHTOOL_STATS_SRC_AGGREGATE:
> + *	if device supports a MAC merge layer, this retrieves the aggregate
> + *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
> + *	statistics of the single (express) MAC.
> + * @ETHTOOL_STATS_SRC_EMAC:
> + *	if device supports a MM layer, this retrieves the eMAC statistics.
> + *	Otherwise, it retrieves the statistics of the single (express) MAC.
> + * @ETHTOOL_STATS_SRC_PMAC:
> + *	if device supports a MM layer, this retrieves the pMAC statistics.
> + */
> +enum ethtool_stats_src {
> +	ETHTOOL_STATS_SRC_AGGREGATE,
> +	ETHTOOL_STATS_SRC_EMAC,
> +	ETHTOOL_STATS_SRC_PMAC,
> +};

Should we somehow call it "MAC stats"?

Right now its named like a generic attribute, but it's not part of 
the header nest (ETHTOOL_A_HEADER_*).

I'm not sure myself which way is better, but feels like either it
should be generic, in the header nest, and parsed by the common code;
or named more specifically and stay in the per-cmd attrs.
