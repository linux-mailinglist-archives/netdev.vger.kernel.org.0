Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3492C63EDA2
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLAKYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiLAKYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:24:41 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566BD99526
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:24:38 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id EA96D75;
        Thu,  1 Dec 2022 11:24:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669890276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+lbWRFC02fnUwOoHI4SYL4Ltc49sGWrpADNNYxCv50=;
        b=egWlvgEVzHY3Zt5k8BYgZ3uBEoj1clRB/sMYcY8jAN64GxkIXk+ld2dFytiVx/3r2Ix+X2
        Um6rqfMk5N2C437+B6ebonXkryuZn0Btreed8bWK0FaD1IhpxHpu9HB/429wZcowI6MkwY
        yAe4A+jrCspwzySEI9kencec+CGedKy8tW+RNGrQE48dQ78d07ZUQdGBfwuX3ksMPte3mr
        IxvbVtTar+i+ZwbFFUGQ2NCCOlUd2a4j/Epfnf8pUcNlqIoNv1fgKV0JusDnnGBCnEyCo/
        G0lw0p5TaO5m0Xbcvneo7ZlfA3/S7GsCWnJzXUoZwU2EsDdfYeQZnsU9dyhMNg==
MIME-Version: 1.0
Date:   Thu, 01 Dec 2022 11:24:35 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
In-Reply-To: <Y4S4EfChuo0wmX2k@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch> <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
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

Am 2022-11-28 14:30, schrieb Andrew Lunn:
> On Mon, Nov 28, 2022 at 08:41:17AM +0100, Michael Walle wrote:
>> Am 2022-11-25 16:17, schrieb Andrew Lunn:
>> > Or even turn it into an input and see if you can read its
>> > state and poll it until it clears?
>> 
>> Btw, I don't think that's possible for shared interrupts. In
>> the worst case you'd poll while another device is asserting the
>> interrupt line.
> 
> Yes, i thought about that afterwards. You need a timeout of 2ms for
> your polling, and then assume its the other PHY. But it also seems
> pretty unlikely that both PHYs go down within 2ms of each other. Maybe
> if you are using a bond and the switch at the other end looses power,
> but for normal use cases, it seems unlikely. It is also a question of
> complexity vs gain. 802.3 says something like you have to wait 750ms
> before declaring link down, so adding a 2ms sleep is just a bit more
> noise.

There are also other PHYs connected to this interrupt line, esp.
the LAN8814 which might do PHY timestamping in the future. Therefore,
I'd prefer a solution which "unblocks" interrupt line.

That being said, I've developed a patchset which change the MDINT
to GPIO mode (which isn't that easy because you need to go through
a mailbox mechanism to write to the internal bus), just to notice
that the access is apparently blocked as long as the interrupt
line is low :( I suspect that somehow the complete internal
bus is stalled due to some event, after which also the interrupt
line is released. Maybe they can't release the interrupt line
exactly because of this, who knows.

So, switching the line to GPIO input doesn't help here, which also
means the interrupt line will be stuck the whole time. Back to your
other suggestion that we can somehow poll the line. Currently I'm
trying to exploit the fact that even a read is blocked. IOW, in the
interrupt handler, I just read an internal register and wait until
that read was successful. Should be rather easy and also circument
the question "is this interrupt I'm polling on from another PHY
of the same line".

-michael
