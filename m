Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB65993DB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbiHSD7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345788AbiHSD7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFEA4D17B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 20:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBEEFB82555
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 03:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25636C433C1;
        Fri, 19 Aug 2022 03:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660881537;
        bh=Is+fnIn29JENTwKJ9mVptF6B9ZG5fem0AFlhrWiWjDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sADdeGPbwjJNjeukBY1hv8YN4kJQA25vvynttbebSAlpZIwUSi7pbewCOszg+B5bb
         XwFGhxVk/4i9F5aYt7/+A2507zxmGCQeOTkIxWTSTt+r3u6tYbap40f+MAZcm2JATW
         8J4lvZ62pyPOh5mJ72InKn8PJc+oYVaq8f7wpFEbfwPrhPj15NzTQ6MsumjJwyFqA7
         9dnVj7uqx8qxFJrEE7g3zdyWi2v24FwBA/Z0GZLFDgjxXvUu+Pi40zbR9/tLeQHzCi
         z6VhJtMrmtpkd6Erx/n6ra0S6G+dV4+FnSU9jRejKXzvAkb4c1t59hm/KxIUZwL5AA
         FwjEc64PyOtFA==
Date:   Thu, 18 Aug 2022 20:58:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Message-ID: <20220818205856.1ab7f5d1@kernel.org>
In-Reply-To: <20220818135256.2763602-9-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
        <20220818135256.2763602-9-vladimir.oltean@nxp.com>
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

On Thu, 18 Aug 2022 16:52:55 +0300 Vladimir Oltean wrote:
> This is a partial revert of commit c295f9831f1d ("net: mscc: ocelot:
> switch from {,un}set to {,un}assign for tag_8021q CPU ports"), because
> as it turns out, this isn't how tag_8021q CPU ports under a LAG are
> supposed to work.
> 
> Under that scenario, all user ports are "assigned" to the single
> tag_8021q CPU port represented by the logical port corresponding to the
> bonding interface. So one CPU port in a LAG would have is_dsa_8021q_cpu
> set to true (the one whose physical port ID is equal to the logical port
> ID), and the other one to false.
> 
> In turn, this makes 2 undesirable things happen:
> 
> (1) PGID_CPU contains only the first physical CPU port, rather than both
> (2) only the first CPU port will be added to the private VLANs used by
>     ocelot for VLAN-unaware bridging
> 
> To make the driver behave in the same way for both bonded CPU ports, we
> need to bring back the old concept of setting up a port as a tag_8021q
> CPU port, and this is what deals with VLAN membership and PGID_CPU
> updating. But we also need the CPU port "assignment" (the user to CPU
> port affinity), and this is what updates the PGID_SRC forwarding rules.
> 
> All DSA CPU ports are statically configured for tag_8021q mode when the
> tagging protocol is changed to ocelot-8021q. User ports are "assigned"
> to one CPU port or the other dynamically (this will be handled by a
> future change).

ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_seville.ko] undefined!
