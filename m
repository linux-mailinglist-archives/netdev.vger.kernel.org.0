Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABF65241B3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiELAwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiELAwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:52:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCE360A92
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF70561E4C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C47C34113;
        Thu, 12 May 2022 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652316730;
        bh=HDBUuZKuAG6Td7YW2WAA/QcqZSNDXLn59jjx0BRSqNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n7YVUHVCdPxABH6wVQ3ssRF3a0JLtxD6hiDoTlrRbWLtGcqzD6zGpiBD56RZALbfN
         iYz9nJPCivtag/kkIvwcqHJdDDbfLcUDiCUgcLahi1xPQ6qMSJ87GIMlkx57VINhaj
         53SsgoYwbl7gbtB2giZ7NacjnVeAQM+u6+RSrqa/vTx6G/eVwOq3zNaai6olW2USod
         /GgpIF/3Cdde2yGCpOWgfRSjpJgSlUkrJ3U0g7u1CF2QxSo5OTsxqAO3RjysR0NX5T
         cl26CaIzszNLprr+gpzXSPsoDDhb5JoVixvkAfLXdxrkamkQ8Tg+Bm5CeQNBMXl0av
         ghg0Ml+zIZRvA==
Date:   Wed, 11 May 2022 17:52:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Michael Walle <michael@walle.cc>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: count the tc-taprio window
 drops
Message-ID: <20220511175208.1be804ac@kernel.org>
In-Reply-To: <20220512002017.qxhyc5vautnrakni@skbuf>
References: <20220510163615.6096-1-vladimir.oltean@nxp.com>
        <20220510163615.6096-3-vladimir.oltean@nxp.com>
        <20220511152740.63883ddf@kernel.org>
        <20220511225745.xgrhiaghckrcxdaj@skbuf>
        <20220511161346.69c76869@kernel.org>
        <20220511231745.4olqfvxiz4qm5oht@skbuf>
        <20220511163655.08fc1ebc@kernel.org>
        <20220512002017.qxhyc5vautnrakni@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 00:20:18 +0000 Vladimir Oltean wrote:
> > We can argue semantics but there doesn't need to be a "standards body"
> > to add a structured stat in ethtool [1]. When next gen of enetc comes
> > out you'll likely try to use the same stat name or reuse the entire
> > driver. So you are already defining uAPI for your users, it's only
> > a question of scope at which the uAPI is defined.  
> 
> The trouble with over-standardization is that with a different driver
> that would use this ad-hoc structure for parts of it, you never know if
> a counter is 0 because it's 0 or because it's not implemented.
> As unstructured as the plain ethtool -S might be, at least if you see a
> counter there, you can expect that it actually counts something.

That's solved with the netlink ethtool stats. What's not repored by the
driver is not reported to user space. Grep for ETHTOOL_STAT_NOT_SET.
Maybe not beautiful but works.

> > What I'm not sure of is what to attach that statistic to. You have it
> > per ring and we famously don't have per ring APIs, so whatever, let
> > me apply as is and move on :)  
> 
> It would probably have to be per traffic class, since the media
> reservation gates are per traffic class (TX rings have a configurable
> mapping with traffic classes). Although an aggregate counter would also
> be plausible. Who knows?

Well, users sometimes know what they want but the days when the kernel
was written by its users are long gone. Or maybe that's just a perfect
example of the "good old days" fallacy :)

> I haven't seen this specific counter being reported by the LS1028A
> switch, for example (I'll have to check what increments on blocked
> transmission overruns).
> 
> > [1] Coincidentally I plan to add a "real link loss" statistic there
> > because AFAICR IEEE doesn't have a stat for it, and carrier_changes
> > count software events so it's meaningless to teams trying to track
> > cable issues.  
> 
> I didn't quite get what's wrong with the carrier_changes sysfs
> counter, and how "real link loss" would be implemented
> differently/more usefully? At least with phylib/phylink users,
> netif_carrier_on() + netif_carrier_off() are called exactly on
> phydev->phy_link_change() events. Are there other callers of
> netif_carrier_*() that pollute this counter and make it useless for
> reliable debugging?

Yup, drivers will do a netif_carrier_off() to stop Tx and prevent
the timeout watchdog from kicking in while they are doing some form 
of reconfig (ethtool -L / -G etc.).

I guess we can add a special API for taking things down without
bumping the counter. Since drivers I work with already report an
ethtool -S stat from the device for "PHY really went down" my first
instinct was a better ethtool stat...
