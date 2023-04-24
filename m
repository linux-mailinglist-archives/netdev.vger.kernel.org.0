Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44146ED0F1
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjDXPHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjDXPHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:07:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738102D53
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 08:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AhdXFo6Mt0BZhc2woGQXGIaEepwtjx7sxuRLupe0hLo=; b=cmfrHfHhB9WrgwxGu1j1RKVqVz
        IUaGbBjWns/OY8ZyMacEEcQpYF+sXAKXvxEGrMTjtn8On4VlDcb5JlPsYQ+UvUZriFNPjbT8Xc64V
        0OmoQXkyKPJt3ihcIow8SuNbRy/EJc48EhUDywcLrHElTQ9SEwtPhJ9QqADl4YTLWoaI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqxX6-00B6I9-KK; Mon, 24 Apr 2023 16:51:12 +0200
Date:   Mon, 24 Apr 2023 16:51:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: Fix reading LED reg property
Message-ID: <8fe294eb-4617-48e9-9625-4e3db717d4ef@lunn.ch>
References: <20230424134003.297827-1-alexander.stein@ew.tq-group.com>
 <c01a4c59-6668-4ae7-b7cf-54d5a5a7e897@lunn.ch>
 <4797433.GXAFRqVoOG@steina-w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4797433.GXAFRqVoOG@steina-w>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> $ hexdump -C /sys/firmware/devicetree/base/soc@0/bus@30800000/
> ethernet@30bf0000/mdio/ethernet-phy@3/leds/led@2/reg
> 00000000  00 00 00 02                                       |....|
> 00000004
> 
> Using of_property_read_u8 will only read the first byte, thus all values of 
> reg result in 0.

Ah! Thanks for the explanation. And the board i tested only had one
led, at reg = <0>; so it worked.

> > I deliberately used of_property_read_u8() because it will perform a
> > range check, and if the value is bigger or smaller than 0-256 it will
> > return an error. Your change does not include such range checks, which
> > i don't like.
> 
> Sure, I can added this check.

Great, thanks.

       Andrew
