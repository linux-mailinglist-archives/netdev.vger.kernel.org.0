Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1D35A4C2F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiH2MqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiH2MqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:46:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48A796741;
        Mon, 29 Aug 2022 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oPV5NlAapyYKsMKix8J75RJ02IN7sGmLcvFnbH2RKWA=; b=20wFvXOaYJIZPTsPGsPrCPepIh
        4rNSfHsAu4ElWMwNcC0k2+qtA5Op1OnO8WFZI/KAU1TJ5wK5gYw4Ki5LQuIRje2Uez63NKAuoCM5z
        7K3/AnAGde4HwVjdc4LkYrhQoV81xImhX8IG8S5H2OLj+csizhCC8JYJZEoHnXgAI9Pc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSduP-00Exg8-PQ; Mon, 29 Aug 2022 14:30:29 +0200
Date:   Mon, 29 Aug 2022 14:30:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     michael@walle.cc, o.rempel@pengutronix.de,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YwyxZQrpuJo98yGk@lunn.ch>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
 <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <421712ea840fbe5edffcae4a6cb08150@walle.cc>
 <CO1PR11MB47715CFC7E22969BD00F9E6AE2769@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47715CFC7E22969BD00F9E6AE2769@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes Channel 0 is correct.
> 
> > Again this is the first time I hear about SQI but it puzzles me that
> > it only evaluate one pair in this case. So as a user who reads this
> > SQI might be misleaded.
> > 
> 
> Yeah, It needs uAPI extension.

I think the current uAPI actually allows it, sort of. You can have
multiple instances of a netlink property in a netlink message.  So
simply add 2 or 4 ETHTOOL_A_LINKSTATE_SQI properties. The existing
user space tools will likely just print the first value it
finds. Newer versions can walk the messages and print them all.

The alternative is to add a new nest, like i did for cable test
results:

 +-+-------------------------------------------+--------+---------------------+
 | | ``ETHTOOL_A_CABLE_NEST_RESULT``           | nested | cable test result   |
 +-+-+-----------------------------------------+--------+---------------------+
 | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number         |
 +-+-+-----------------------------------------+--------+---------------------+
 | | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code         |
 +-+-+-----------------------------------------+--------+---------------------+

You can then explicitly indicate which cable pair the SQI value
corresponds to. In order to keep backwards compatibility, you would
still need to provide ETHTOOL_A_LINKSTATE_SQI, and then additionally
have these nests.

     Andrew
