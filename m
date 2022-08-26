Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A625A3032
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344734AbiHZTvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbiHZTvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:51:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0012E68D7;
        Fri, 26 Aug 2022 12:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WHWgyZwOYt0ERDM3VLaqXQ19lWQ7CWa684W/FQaw+UA=; b=r6IG98sZlE9Jq1u//TbhWfAGbV
        aXin1hNGByAMXp6XahdFfDu+h6yyN66fEXYtMd/teltMY2dy908m+0bU6HMse/2XwBQZJEGD+mUjq
        3InVH3NuQnhnK0xcUdJrVUbAWva1OfU+z8QX7o11OszBGII26gVk5X/w2rIMu26ijWUQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRfMX-00Eidz-OJ; Fri, 26 Aug 2022 21:51:29 +0200
Date:   Fri, 26 Aug 2022 21:51:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michael Walle <michael@walle.cc>, Divya.Koppera@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for
 lan8814 phy
Message-ID: <YwkkQc7NpJegEr+/@lunn.ch>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
 <20220826084249.1031557-1-michael@walle.cc>
 <CO1PR11MB477162C762EF35B0E115B952E2759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <421712ea840fbe5edffcae4a6cb08150@walle.cc>
 <20220826095429.GE2116@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826095429.GE2116@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > In lan8814 phy only channel 0 is used for 100base-tx. So returning SQI
> > > value for channel 0.
> > 
> > What if the other pairs are bad? Maybe Oleksij has an opinion here.
> > 
> > Also 100baseTX (and 10baseT) has two pairs, one for transmitting and one
> > for receiving. I guess you meassure the SQI on the receiving side. So is
> > channel 0 correct here?
> > 
> > Again this is the first time I hear about SQI but it puzzles me that
> > it only evaluate one pair in this case. So as a user who reads this
> > SQI might be misleaded.
> 
> Wow! I was so possessed with one-pair networks, that forgot to image
> that there is 1000Base-T with more then one pairs :D
> 
> Yes, your are right. We wont to have readings from all RX channels and
> be able to export them to the user space. In fact, if i see it
> correctly, the LAN8814_DCQ_CTRL_CHANNEL_MASK value should be synced with
> the MDI-X state. Otherwise we will be reading TX channels.

I don't know if i should trust the datasheet i found, but it suggests
the register in MMD device 1 space has a field to indicate which cable
pair should be measured. So for 1000Base-T all pairs are both Rx and
Tx, so i would expect 4 values are returned. That then might need an
uAPI extension, if you were focused on T1 :-)

    Andrew
