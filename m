Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0F55202D3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbiEIQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiEIQs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:48:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B7EE6CD9;
        Mon,  9 May 2022 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5crOhz1b2Yt/7xhvVXQallsdzBVJYK1M2zVGJWfie0o=; b=WprEvTGHNXuTJ2lhdPuXfQjQrG
        cbCUQaUc0KpKLXCvCveQNP+OIyUZxj/bNjSKveAEm2tYmhbTrtyA0fhe0huiZZLcXr6D9f8sFYVqJ
        uqjiShDApZzcmjbHGZfGjYGiNq+cWC/jPkigdMYWaXTDXJzQfrY5q9+OIMhYZ9Q40w2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no6VC-001yeT-Mx; Mon, 09 May 2022 18:44:54 +0200
Date:   Mon, 9 May 2022 18:44:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org
Subject: Re: [PATCH net-next 01/14] arm64: dts: mediatek: mt7986: introduce
 ethernet nodes
Message-ID: <YnlFBr1wgb/hlduy@lunn.ch>
References: <cover.1651839494.git.lorenzo@kernel.org>
 <1d555fbbac820e9b580da3e8c0db30e7d003c4b6.1651839494.git.lorenzo@kernel.org>
 <YnZ8o46pPdKMCbUF@lunn.ch>
 <YnlC3jvYarpV6BP1@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnlC3jvYarpV6BP1@lore-desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 06:35:42PM +0200, Lorenzo Bianconi wrote:
> > > +&eth {
> > > +	status = "okay";
> > > +
> > > +	gmac0: mac@0 {
> > > +		compatible = "mediatek,eth-mac";
> > > +		reg = <0>;
> > > +		phy-mode = "2500base-x";
> > > +
> > > +		fixed-link {
> > > +			speed = <2500>;
> > > +			full-duplex;
> > > +			pause;
> > > +		};
> > > +	};
> > > +
> > > +	gmac1: mac@1 {
> > > +		compatible = "mediatek,eth-mac";
> > > +		reg = <1>;
> > > +		phy-mode = "2500base-x";
> > > +
> > > +		fixed-link {
> > > +			speed = <2500>;
> > > +			full-duplex;
> > > +			pause;
> > > +		};
> > > +	};
> > 
> > Are both connected to the switch? It just seems unusual two have two
> > fixed-link ports.
> 
> afaik mac design supports autoneg only in 10M/100M/1G mode and mt7986 gmac1
> is connected to a 2.5Gbps phy on mt7986-ref board.

The MAC does not normally perform autoneg, the PHY
does. phylib/phylink then tells the MAC the result of the
negotiation. If there is a SERDES/PCS involved, and it is performing
the autoneg, phylink should get told about the result of the autoneg
and it will tell the MAC the result.

So the gmac1 should just have phy-handle pointing to the PHY, not a
fixed link.

      Andrew
