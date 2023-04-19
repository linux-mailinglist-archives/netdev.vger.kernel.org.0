Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55B66E7E3C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjDSP2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjDSP2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:28:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567EC59D5
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6yN0dgul2x9FdUyon8O/uoBqeEOVVdJfjFsCqQkZfy8=; b=hrGc1YfR4XmtDrlbSVWiJSg0P7
        2TFp1HUj+AwOoVUP3Am73fpKzKctCB8coYZ0WfUSUEmgQ2AmZofRwS4/KySxifbQ5XkJw03KTFt7a
        IzSlK3j6/hUI2tQ85vxpoBfaR7Bf6dioWw3p8LBvYXirKGnJ8n6a/3kWylypAH/XnuJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pp9iA-00Ai2f-1M; Wed, 19 Apr 2023 17:27:10 +0200
Date:   Wed, 19 Apr 2023 17:27:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH v2] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <de2435f5-cbb0-4303-ad6a-878cf008074c@lunn.ch>
References: <ZD/Nl+4JAmW2VTzh@debian>
 <ZD/Nl+4JAmW2VTzh@debian>
 <20230419151257.etde4jit4pquec6c@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419151257.etde4jit4pquec6c@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int lan867x_read_status(struct phy_device *phydev)
> > +{
> > +	/* The phy has some limitations, namely:
> > +	 *  - always reports link up
> > +	 *  - only supports 10MBit half duplex
> > +	 *  - does not support auto negotiate
> > +	 */
> > +	phydev->link = 1;
> > +	phydev->duplex = DUPLEX_HALF;
> > +	phydev->speed = SPEED_10;
> > +	phydev->autoneg = AUTONEG_DISABLE;
> 
> Sounds really suboptimal if phylib has to poll once per second to find
> out static information. Does the PHY have an architectural limitation in
> that it does not report link status? Is it a T1S thing? Something should
> change here, but I'm not really sure what. A PHY that doesn't report
> link status seems... strange?

Hi Vladimir

I thought that as well. I skimmed the data sheet, and i don't see
anything. You can maybe imply there is no link by looking for PLCA
beacons, but i don't know how reliable that is. You are not forced to
use PLCA, so there might not be any, but communication is still
possible.

The other T1S PHY, NCN26000, does have link status. So i don't think
it is a T1S thing.

Also, the typical use case of T1S is automotive. There are no RJ45
plug/sockets to be unplugged. It is an industrial connector. And i
expect such applications don't really care about L2 connectivity.  L7
either works, or it does not.

My thinking was, the overhead of a pointless poll once per second is
minimal, not enough to justify a change to the core.

	 Andrew
