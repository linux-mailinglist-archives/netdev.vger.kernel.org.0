Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819D14F182F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378514AbiDDPWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344613AbiDDPWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:22:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BDA3CA67;
        Mon,  4 Apr 2022 08:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eRnVwLqxvaZkK5inK6QPhoSx1abWW++tjzz4e/jN0cE=; b=N/SwS967cwXIhNIsdZEPKbcl50
        NlGBxBsYqBz63vqSTe9mXa0WoNV0H7lRX7/D3hloi5zAWd+s3g7s6qTesZfoGdq5esU9xpPpNXPAJ
        q52nGl5oyYJh7yT0bLAtL+4RRKDo2RbSOumUM/GJWZUBXtsKqAxFBlLih495I6Hi8vmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbOVI-00E6md-Fl; Mon, 04 Apr 2022 17:20:28 +0200
Date:   Mon, 4 Apr 2022 17:20:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     richardcochran@gmail.com, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <YksMvHgXZxA+YZci@lunn.ch>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404150508.3945833-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 05:05:08PM +0200, Michael Walle wrote:
> Sorry for digging out this older thread, but it seems to be discussed
> in [1].
> 
> > IMO, the default should be PHY because up until now the PHY layer was
> > prefered.
> > 
> > Or would you say the MAC layer should take default priority?
> > 
> > (that may well break some existing systems)
> 
> Correct me if I'm wrong, but for systems with multiple interfaces,
> in particular switches, you'd need external circuits to synchronize
> the PHCs within in the PHYs.

If the PHYs are external. There are switches with internal PHYs, so
they might already have the needed synchronisation.

> (And if you use a time aware scheduler
> you'd need to synchronize the MAC, too). Whereas for switches there
> is usually just one PHC in the MAC which just works.

And there could be switches with the MACs being totally
independent. In theory.

> On these systems, pushing the timestamping to the PHY would mean
> that this external circuitry must exist and have to be in use/
> supported. MAC timestamping will work in all cases without any
> external dependencies.

And if the MAC are independent, you need the external dependency.

> I'm working on a board with the LAN9668 switch which has one LAN8814
> PHY and two GPY215 PHYs and two internal PHYs. The LAN9668 driver
> will forward all timestamping ioctls to the PHY if it supports
> timestamping (unconditionally). As soon as the patches to add ptp
> support to the LAN8814 will be accepted, I guess it will break the
> PTP/TAS support because there is no synchronization between all the
> PHCs on that board. Thus, IMHO MAC timestamping should be the default.

There are arguments for MAC being the defaults. But we must have the
option to do different, see above. But the real problem here is
history. It is very hard to change a default without breaking systems
which depend on that default. I believe Russell has a system which
will break if the default is changed.

So i suspect the default cannot be changed, but maybe we need a
mechanism where an interface or a board can express a preference it
would prefer be used when there are multiple choices, in addition to
the user space API to make the selection.

   Andrew
