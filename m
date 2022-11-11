Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E689625B03
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 14:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiKKNKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 08:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiKKNKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 08:10:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60056BF0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 05:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9TmE2fgE9XFLw1fojCQxxv8cBujglX3MPbojYLMZC38=; b=T1/n4ijRC36CgJxC0hAK6lQKb4
        /kMHL2WTzxoGjignOIS8PcMmfD8yyZbcN+oGF80Dhrm/rAfyiQA40qNIepuYitzkzakbCfJZyubAk
        bcdTYV1CCx3I/7C7x7YpEJ17eRmUcek9P4ZUzyum5i1X5bSEZ3MmiR+NICH1/0a1kzYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otTnB-0027c9-9z; Fri, 11 Nov 2022 14:09:57 +0100
Date:   Fri, 11 Nov 2022 14:09:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net br_netlink.c:y allow non "disabled" state for
 !netif_oper_up() links
Message-ID: <Y25JpVOSc6mh0cx8@lunn.ch>
References: <20221109152410.3572632-1-giometti@enneenne.com>
 <20221109152410.3572632-2-giometti@enneenne.com>
 <Y2vkwYyivfTqAfEp@lunn.ch>
 <1c6ce1f3-a116-7a17-145e-712113a99f1e@enneenne.com>
 <Y2v1hORCE+dPkjwW@lunn.ch>
 <114c9c4c-57b0-5cf5-2217-8bee3c94e6c7@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <114c9c4c-57b0-5cf5-2217-8bee3c94e6c7@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I also
> > wonder what the hardware drivers do? Since this is a change in
> > behaviour, they might not actually do anything.
> 
> For instance Marvell switches just set the state (see
> linux/drivers/net/dsa/mv88e6xxx/port.c) without checking for carrier status:

Yes, that was one i checked myself. I think i remember reviewing a DSA
driver which did not have a mechanism to disable a port, other than
the STP state. So there is a danger the mac_down() call is going to
change the STP state, and the mac_up() call will change it again.

> Yes, of course we can do it but (in case of MRP) the state machine must be
> altered in several points and, again, why the kernel should force such
> behaviour (i.e. introducing a policy) when drivers just don't consider it
> (see the above example).
> 
> The kernel should implement mechanisms while all policies should be into user space.

While i agree the policy should not be in the kernel, you have history
against you. Since this was never a requirement, and on first
mentioning it, it seems like an odd requirement, there is no guarantee
it will actually work for all drivers. So either you have to:

1) Say some kernel drivers are probably broken, will do horrible
   things to your network instead of being redundant, test it well
   before deploying.

2) Monitor for the link up event, and set the STP state as required.

The in kernel bridge/STP code takes this second approach, which again
reinforces the fact that because drivers never needed to support this,
some probably don't.

     Andrew
   
