Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317495F3205
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJCOgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiJCOgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:36:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17FF4F65E
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13775CE0CDD
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 14:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB122C433C1;
        Mon,  3 Oct 2022 14:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664807765;
        bh=0JqUoLvIQH2mIhdmVj6Sti5ypPz0DytlvqJw+03RmJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y3wgcp2O9BT0OaRYasoC+mCN4N+wURF0su/BVo4PLjgW9QV8MLpe0V6tGmjJciuu0
         KfHCRtzpqU1Hm8BUR+Iqvh8GU7k9MHFhlnTdWR+70bzAS4DqCkRGV6idC/0Buc8NX7
         JH75VqDPx6gau8MKWPPdsiwoXubqCORqTeTuyNHiHvRa0SXRLB4vjqcRf/V8aZBWj2
         /rdem0RnVg0mY/6XbDfvheb3LY+Oj6nwkNXUvzLNjW8rdVd7dPMG+THmksmNreD0lw
         gCJO6E7l5mNq9k/9/CKyJ5EkeSnSZh8+TGOL4hdYV7DCH/ZtWGOXuM49ARzfB7T8+k
         wMI4c7AVuwvaA==
Date:   Mon, 3 Oct 2022 07:36:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Message-ID: <20221003073603.1d98c206@kernel.org>
In-Reply-To: <20221001155337.ycodmomj7wz4s5rx@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
        <20220816203417.45f95215@kernel.org>
        <20220817115008.t56j2vkd6ludcuu6@skbuf>
        <20220817114642.4de48b52@kernel.org>
        <20221001155337.ycodmomj7wz4s5rx@skbuf>
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

On Sat, 1 Oct 2022 15:53:38 +0000 Vladimir Oltean wrote:
> > Add a attribute to ETHTOOL_MSG_STATS_GET, let's call it
> > ETHTOOL_A_STATS_EXPRESS, a flag.  
> 
> I'll add this to the UAPI and to internal data structures, ok?
> 
> enum ethtool_stats_src {
> 	ETHTOOL_STATS_SRC_AGGREGATE = 0,
> 	ETHTOOL_STATS_SRC_EMAC,
> 	ETHTOOL_STATS_SRC_PMAC,
> };

Yup!

> > Plumb thru to all the stats callback an extra argument 
> > (a structure for future extensibility) with a bool pMAC;
> > 
> > Add a capability field to ethtool_ops to announce that
> > driver will pay attention to the bool pMAC / has support.  
> 
> You mean capability field as in ethtool_ops::supported_coalesce_params,
> right? (we discussed about this separately).
> This won't fit the enetc driver very well. Some enetc ports on the NXP
> LS1028A support the MM layer (port 0, port 2) and some don't (port 1,
> port 3). Yet they share the same PF driver. So populating mm_supported =
> true in the const struct enetc_pf_ethtool_ops isn't going to cover both.
> I can, however, key on my ethtool_ops :: get_mm_state() function which
> lets the driver report a "bool supported". Is this ok?

That happens, I think about the capability in the ops as driver caps
rather than HW caps. The driver can still return -EOPNOTSUPP, but it
guarantees to check the field's value. 

Most (all but one) datacenter NIC vendors have uber-drivers for all
their HW generations these days, static per-driver caps can't map to 
HW caps in my world.

So weak preference for sticking to that model to avoid confusion about
the semantics of existing caps vs caps which should use a function call.
