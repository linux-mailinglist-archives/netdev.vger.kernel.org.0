Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F561176B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiJ1QUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ1QUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294241C5E24;
        Fri, 28 Oct 2022 09:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6580B82B09;
        Fri, 28 Oct 2022 16:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7F7C433C1;
        Fri, 28 Oct 2022 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666974049;
        bh=HopuDrv5BHKX7qrhsrWDV7WxoXzfKEYt2KGH+VrI3xg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/jiiH2PHKzEs/RSg+3pjiUG2RiHW+PCuSZQiNWvZD9ASK5DeLcsL7xy9V12cTnb6
         g+gI1F1p1NubcNJ9faww8Yq6WuaMFdE3foYq4p1Z2sOjbozBhK8rDHkSTcGBGY7G+P
         4+9uNmXF7fezrXv6k+bomOkPYGEs9pXRL9qQPkMzBKRGvztOOLIMhI4ZNnO+P3CKgF
         h2pJnx7QV3ppjqbiS+WPL3iD+W3fOo9ZlFP+DlKN06jYvHQgmi1y8Y2/kQpI5YlHVc
         qsPHSQax0U1gm0c9Rtv0IarwPnZQhDQw6Zw4Tds+FkYXklBB6SUDnE5OH954OXkSg3
         fP0ZPuYxBLGnQ==
Date:   Fri, 28 Oct 2022 09:20:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, michael.chan@broadcom.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221028092047.45fa3d19@kernel.org>
In-Reply-To: <Y1vIg8bR8NBnQ3J5@lunn.ch>
References: <20221028012719.2702267-1-kuba@kernel.org>
        <Y1vIg8bR8NBnQ3J5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 14:18:11 +0200 Andrew Lunn wrote:
> > @@ -67,6 +67,7 @@ static void phy_link_down(struct phy_device *phydev)
> >  {
> >  	phydev->phy_link_change(phydev, false);
> >  	phy_led_trigger_change_speed(phydev);
> > +	WRITE_ONCE(phydev->link_down_events, phydev->link_down_events + 1);  
> 
> I'm not sure the WRITE_ONCE adds much value. Many systems using PHYLIB
> are 32 bit, and i don't think WRITE_ONCE will make that 64 bit write
> atomic on 32 bit systems. And as Florian pointed out, you have bigger
> problems if you manged to overflow a u32 into a u64.
> 
> > @@ -723,6 +724,8 @@ struct phy_device {
> >  
> >  	int pma_extable;
> >  
> > +	unsigned int link_down_events;  
> 
> And here is unsigned int, not u64? Or u32? It would be good to be
> consistent.

I made it 32b on the phylib side so that WRITE_ONCE() was sufficient 
to ensure atomic writes.

Do you have a preference for it being 64b vs 32b at the uAPI level?
I was leaning slightly towards making both 32b in v3..

> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -262,6 +262,8 @@ enum {
> >  	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
> >  	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
> >  	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
> > +	ETHTOOL_A_LINKSTATE_PAD,
> > +	ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT,	/* u64 */  
> 
> What is the PAD for?

64b values have to be padded in netlink to ensure alignment.
