Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710562347E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKIU0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKIU0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3937BC27
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EAA061CAF
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35517C433C1;
        Wed,  9 Nov 2022 20:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668025602;
        bh=Zoe6EL9bJrjl3DnUgt6QsT4U1juaMkC+WLj0BMMDgu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o6xwwvqGqSdjATAWPHJOAgG9iLikYa1+wYmW+VmJ0ZDHva9JTOtqh8T2jpo0KV1Vs
         c2qBs+E70PKUDf5WntcmP+QtyzgLW6kegGH7kXUlQUG0CVXRC70PvZAjgPo5UxI/8M
         xhvvPrDUJXc0sn2+RLTR1T1DQ1EoGfHqpQ1oSHCvTcCNlK4XOhZejSmm+SB9D/YbWD
         VuvLXSvedet2Ry7Sm71+wBV89bdJvmBWsZxBOF1LC5How54ytjdSRqwXhZdtmNnaw3
         YyCcOZrisM4vmlFi/eNUDxNtJgDWvdOt0T21PQrWyLFxwMwtVPgenH4Q1v9yB2PwUN
         8YR1Ebz8EJdSA==
Date:   Wed, 9 Nov 2022 12:26:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
Message-ID: <20221109122641.781b30d9@kernel.org>
In-Reply-To: <Y2vozcC2ahbhAvhM@unreal>
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
        <Y2vozcC2ahbhAvhM@unreal>
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

On Wed, 9 Nov 2022 19:52:13 +0200 Leon Romanovsky wrote:
> On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> > If ethtool_ops::get_drvinfo() callback isn't set,
> > ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> > ethtool_drvinfo::bus_info fields.
> > 
> > However, if the driver provides the callback function, those two
> > fields are not touched. This means that the driver has to fill these
> > itself.  
> 
> Can you please point to such drivers?

What you mean by "such drivers" is not clear from the quoted context,
at least to me.

> One can argue that they don't need to touch these fields in a first
> place and ethtool_drvinfo should always overwrite them.

Quite likely most driver prints to .driver and .bus_info can be dropped
with this patch in place. Then again, I'm suspecting it's a bit of a
chicken and an egg problem with people adding new drivers not having 
an incentive to add the print in the core and people who want to add
the print in the core not having any driver that would benefit.
Therefore I'd lean towards accepting Vincent's patch as is even if
the submission can likely be more thorough and strict.

While I'm typing - I've used dev_driver_string() to get the driver
name in the past. Perhaps something to consider?
