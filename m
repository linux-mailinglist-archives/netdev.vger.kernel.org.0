Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA365624D83
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiKJWKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiKJWKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:10:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C85C59878
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RfwZ6/kvQhwtexGPka8PoJUX6RAmerHajGSW8W2jSeE=; b=6Z4Y+Dc6+y0KZ6OUXAStydOCOy
        cJNFyaevqVnln2jVrbFdL29BHeKvw1VMd5YuGzDGjmoxLSz4KwMS+t0uFT/E5jM9G2ZdmAMaicgV5
        k4/9zMVsy/+q+WnwMMptHuz4h0nJaag+S00pYboFP3DavnrcFcOKOJ+33BB8+s/m31/I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otFkf-0024Ut-5P; Thu, 10 Nov 2022 23:10:25 +0100
Date:   Thu, 10 Nov 2022 23:10:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] net: dsa: marvell: Provide per device information
 about max frame size
Message-ID: <Y2120XvGIZvP+TxM@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-7-lukma@denx.de>
 <Y2pd9CFMzI5UZSiD@lunn.ch>
 <20221110163637.69a8490e@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110163637.69a8490e@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 04:36:37PM +0100, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > On Tue, Nov 08, 2022 at 09:23:27AM +0100, Lukasz Majewski wrote:
> > > Different Marvell DSA switches support different size of max frame
> > > bytes to be sent.
> > > 
> > > For example mv88e6185 supports max 1632B, which is now in-driver
> > > standard value. On the other hand - mv88e6071 supports 2048 bytes.
> > > 
> > > As this value is internal and may be different for each switch IC
> > > new entry in struct mv88e6xxx_info has been added to store it.
> > > 
> > > When the 'max_frame_size' is not defined (and hence zeroed by
> > > the kvzalloc()) the default of 1632 bytes is used.  
> > 
> > I would prefer every entry states the value.
> 
> You mean to add it explicitly (i.e. for each supported switch version)
> to the struct mv88e6xxx_ops ?

To the info structure. You added it for just your devices and left it
to 0 for the rest. Rather than special case 0, always set the value
and remove the special case. Maybe even -EINVAL if you find a 0 there.

   Andrew
