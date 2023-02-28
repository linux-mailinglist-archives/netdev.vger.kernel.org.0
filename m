Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA516A6035
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjB1UOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 15:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjB1UOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 15:14:00 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6982A980
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 12:13:59 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A9E106D5;
        Tue, 28 Feb 2023 21:13:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677615237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=puUo3rLMdrjc6WAreGyMTicnvarj5rDB14R+sbJ+si0=;
        b=PF009GnwBWejNhpN4UAs92uc4A1yj31lN3+F767hCnhz3Ok4Zcna4Oqf9XlyVxAFX79Tnj
        s2E07+gzvuJsiFkChZl4Q5BZzrsXhd2Zgd5y+3CS640VlISWPZwbQ34CyqNTow3mxAxHuj
        UYxGf1jx98O952zZ8kUtyzNwlU6ZrMBkLnp+2QUO3Oj8R117KfRHMWyHKplZzDEFyyQlqM
        rJPDZjWf5xuxVk1UMU1CHC+JddRtvVByvuJ9tfc4mO7dOm0twl9nTrF10/ehqJ+b9bX7es
        p+fR2q66zbh4jjYT8pAvLsbgxbIeRH4oZECEOEwY3q1Y/Kft0UMqPHrIWKbVvg==
MIME-Version: 1.0
Date:   Tue, 28 Feb 2023 21:13:57 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
In-Reply-To: <Y/4yymy8ZBlMrjDG@shell.armlinux.org.uk>
References: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228164435.133881-1-michael@walle.cc>
 <Y/4yymy8ZBlMrjDG@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <a7d0a9c31e86441b836baf3b5cd7804d@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-02-28 17:58, schrieb Russell King (Oracle):
> On Tue, Feb 28, 2023 at 05:44:35PM +0100, Michael Walle wrote:
>> >> 4. Letting drivers override PHY at run time.
>> >
>> > I think this is the only sensible solution - we know for example that
>> > mvpp2 will prefer its PTP implementation as it is (a) higher resolution
>> > and (b) has more flexibility than what can be provided by the Marvell
>> > PHYs that it is often used with.
>> 
>> Please also consider that there might be one switch with a shared
>> PHC and multiple PHYs, each with its own PHC.
> 
> Doesn't the PTP API already allow that? The PHC is a separate API from
> the network hardware timestamping - and the netdev/PHY is required
> to implement the ethtool get_ts_info API that provides userspace with
> the index to the PHC associated with the interface.

Yes, but the source for the timestamp is the PHC. If the PHCs are
not synchronized, the timestamps won't be either. With a shared PHC,
the synchronization is already a given.

>> In this case, it is a
>> property of the board wether PHY timestamping actually works, because
>> it will need some kind of synchronization between all the PHYs.
> 
> How is this any different from e.g. a platform where there are
> multiple network interfaces each with their own independent PHC
> such as Macchiatobin, where there are two CP110 dies, each with
> their own group of three ethernet adapters, and each die has its
> own PHC shared between the three ethernet adapters?
> 
> Hardware synchronisation between the two PHCs isn't possible, but
> they might tick at the same rate (it's something that hasn't been
> checked.) However, the hardware signals aren't that helpful because
> there's no way to make e.g. the rising edge always be at the start
> of a second. So the synchronisation has to be done in software.
> 
> I don't think PHCs need to be synchronised in hardware to "actually
> work". Take an example of a PC with two network cards, both having
> their own independent PHC.

That might be true if you just want to use PTP as a time sync protocol,
but keep in mind that there is also the time aware scheduler which uses
the PHC as its time source, too. If you want to use PHY timestamping
in this case, the PHCs needs to be synchronized. Honestly, I'm not 
really
sure, how that is supposed to work.
All I'm trying to say, is there might also be some board constraints so
the MAC driver might not always be telling what is best, PHY or MAC.

-michael
