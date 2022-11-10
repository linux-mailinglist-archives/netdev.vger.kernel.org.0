Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC86247BD
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 17:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiKJQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 11:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiKJQ7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 11:59:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2D121811
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 08:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FECCB82259
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 16:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A526C433C1;
        Thu, 10 Nov 2022 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668099549;
        bh=hmxY1dF8hIO1nlDn+CtHi3Lp4HcLd6ksoBSOWMnmfeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eBpRQG4/ZR5jZReLAZQIF3Y1xPswWeNztaHjDSPP/weggCEkwDo/RnFi/bCy127cl
         h+O2Tp4ZhYa7tE8mganwncZkftzGCcK4miiDUOlq9KOKyOHstZoPF5VgO3fE9zsN0G
         MVv9o5BWCKgn2OU94hoox7V9PQhUZPThZH6rFeSUog8TdgxjRpoMlInrbQpjB8zj6k
         lwO2oEtDdRm/noB3zo9daYi+lAhb/OWXK9i+8zNSCFKRDJb9J3Xvc+Qfw38PCvIDRI
         kqVpl5yM9E25+mvMjoFUSBAja3HEeV73nozqyYUDGWQVTSGZqg+ea1Soc1DKJsSjCQ
         gnh136MxGKxXw==
Date:   Thu, 10 Nov 2022 08:59:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <20221110085907.764e18cd@kernel.org>
In-Reply-To: <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
        <Y2vozcC2ahbhAvhM@unreal>
        <20221109122641.781b30d9@kernel.org>
        <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
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

On Thu, 10 Nov 2022 17:34:55 +0900 Vincent MAILHOL wrote:
> > While I'm typing - I've used dev_driver_string() to get the driver
> > name in the past. Perhaps something to consider?  
> 
> I am not sure of that one. If dev->dev.parent->driver is not set, it
> defaults to dev_bus_name() which is .bus_info, isn't it?
> https://elixir.bootlin.com/linux/latest/source/drivers/base/core.c#L2181

I don't think so?  We put dev_name() into bus_info, which is usually
the address of the device on the bus (e.g. (D)BDF for PCI, like
0000:00:14.3). The name of the bus is pci. dev_driver_string() will
also fall back to printing class name.

>  For the end user, it might be better to display an empty driver name
> in 'ethtool -i' rather than reporting the bus_info twice?
> 
> I mean, if you ask me for my opinion, then my answer is "I am not
> sure". If you have confidence that dev_driver_string() is better, then
> I will send a v2 right away.

Well, it doesn't matter. I asked because handful of popular drivers 
use dev_driver_string(). But.. these are drivers so parent->driver 
will be set and it ends up not making any difference.
