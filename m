Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0355BD5D3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 22:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiISUsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 16:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiISUr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 16:47:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF19D4A83A
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 13:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kNphrbmw0xLKuLVytu7DkiwNXoPBPHYsH+23ZM62sdM=; b=BGsmFtAcF9/KBbYpUi0DWFTs8Z
        MNNNgDiKLLmp/D5FvtqZ7ZmSD+vvg7ccwgxhcCJGZyEyk03CHwPjOSSpHN1EayiLtEJr4MjSIT8dN
        bAaqzDIL7ElvHnO8srRUViLUwT83tKGWbaIRIorMFQxyERIt/6zz89IvNqZJxV/KuESw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaNgL-00HAvR-3c; Mon, 19 Sep 2022 22:47:57 +0200
Date:   Mon, 19 Sep 2022 22:47:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander 'lynxis' Couzens <lynxis@fe80.eu>
Cc:     netdev@vger.kernel.org
Subject: Re: Handle phys changing the interface between 2500basex & SGMII
Message-ID: <YyjVfSx1w0oX3+/n@lunn.ch>
References: <20220919164713.13bb546e@javelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919164713.13bb546e@javelin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 04:47:13PM +0200, Alexander 'lynxis' Couzens wrote:
> Hi,
> 
> I've a mediatek mt7622 SoC connected to a realtek 2.5gbit copper phy
> (rtl8221) via SGMII/2500basex.
> 
> The rtl8221 is changing its phy interface depending on the link.
> So 2500basex for 2.5gbit copper and for all lower speeds (down to
> 10mbit) it's using SGMII.
> 
> What's the best way to implement it?

The marvel10g PHY driver is a good example to follow. It also changes
its host side interface mode as needed by whatever the copper side has
negotiated.

> Should the phy driver change the phy_interface on link up?

Yes.

> As a hack I've modified mac_link_up to handle the different speeds
> and changed the phylink_mac_ops validate to allow advertising lower
> speeds on 2500basex.

phylink should not need any changes. You just need your MAC driver to
follow what is happening in its callbacks.

       Andrew
