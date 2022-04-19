Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3850E506D0C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350962AbiDSNFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238368AbiDSNFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:05:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A510377D1;
        Tue, 19 Apr 2022 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=PkViwl74IgQv6A5OVVFYe3s2y/HJKzzwnj5gCY5pUYc=; b=UT
        gbmQeBCCK5DZlOV9yoMn0ByV71MqjkQKVGVsR7xZCji5q5lbfCUb36SOoaglC59zk7g0LmXpDuSv1
        TStoBcBa9ijlPFpr+AZ5NPU+O/N5zThYQbkjigFtQDUGrFp2jOBOW93CRnXiFgJo7QzbIdLb4Z26I
        Wt4qAB05Qh8Z4Tc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngnVX-00GV78-Oi; Tue, 19 Apr 2022 15:03:03 +0200
Date:   Tue, 19 Apr 2022 15:03:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next v8 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <Yl6zBwiJ2O1ALnjs@lunn.ch>
References: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
 <1649817118-14667-3-git-send-email-wellslutw@gmail.com>
 <20220414141825.50eb8b6a@kernel.org>
 <Ylgjab6qLsrzKZKc@lunn.ch>
 <e784ab5356aa4b6e93765b54bdefea0a@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e784ab5356aa4b6e93765b54bdefea0a@sphcmbx02.sunplus.com.tw>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:07:55AM +0000, Wells Lu 呂芳騰 wrote:
> > > > +		/* Get mac-address from nvmem. */
> > > > +		ret = spl2sw_nvmem_get_mac_address(&pdev->dev, port_np, mac_addr);
> > > > +		if (ret) {
> > > > +			dev_info(&pdev->dev, "Generate a random mac address!\n");
> > > > +
> > > > +			/* Generate a mac address using OUI of Sunplus Technology
> > > > +			 * and random controller number.
> > > > +			 */
> > > > +			mac_addr[0] = 0xfc; /* OUI of Sunplus: fc:4b:bc */
> > > > +			mac_addr[1] = 0x4b;
> > > > +			mac_addr[2] = 0xbc;
> > > > +			mac_addr[3] = get_random_int() % 256;
> > > > +			mac_addr[4] = get_random_int() % 256;
> > > > +			mac_addr[5] = get_random_int() % 256;
> > >
> > > I don't think you can do that. Either you use your OUI and assign the
> > > address at manufacture or you must use a locally administered address.
> > > And if locally administered address is used it better be completely
> > > random to lower the probability of collision to absolute minimum.
> > 
> > I commented about that in an earlier version of these patches. We probably need a quote
> > from the 802.1 or 802.3 which says this is O.K.
> > 
> > 	 Andrew
> 
> Hi Andrew,
> 
> I plan to replace above statements with:
> 
> 	eth_random_addr(mac_addr);

O.K, that is good.

> Do you mean I can keep use the mac address: "OUI + random number"?

If you can show us text in an IEEE 802.1, IEEE 802.3, or some other
IEEE document which says this is allowed.

> Only need to add comment for it.

Add a comment which points to a document which says you are allowed to
do this. This is very unusual, so questions will be asked, and if you
point people at the answer it will help.

      Andrew
