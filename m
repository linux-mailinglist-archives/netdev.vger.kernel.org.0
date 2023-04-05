Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5F6D86F0
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjDETfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjDETfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:35:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A930D5FE1;
        Wed,  5 Apr 2023 12:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GJLiNwhsL8BaZ9KZ/zH+hWXBLPuylC9ipjO8vXLfsjw=; b=xaJkJYJMmcRDgsC5EpE9PRIgAQ
        HYv4+O2SHOJNB4PRH5kk8ZEsg5rvoIEsUC2FDG1gtqjCW2CRKPBLLrpsD6a+ZJV/znHN7muxtUtsT
        yBtbpPOYuABPPh1etdclBxinSgqEt/2mGDjmNaZas/9XQKGVlIKbAY40aBlw5RIJNzVw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk8up-009YP9-2g; Wed, 05 Apr 2023 21:35:31 +0200
Date:   Wed, 5 Apr 2023 21:35:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru, stable@vger.kernel.org
Subject: Re: [PATCH net] net: sfp: initialize sfp->i2c_block_size at sfp
 allocation
Message-ID: <19d7ef3c-de9d-4a44-92e9-16ac14b663d9@lunn.ch>
References: <20230405153900.747-1-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405153900.747-1-i.bornyakov@metrotek.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:39:00PM +0300, Ivan Bornyakov wrote:
> sfp->i2c_block_size is initialized at SFP module insertion in
> sfp_sm_mod_probe(). Because of that, if SFP module was not inserted
> since boot, ethtool -m leads to zero-length I2C read attempt.
> 
>   # ethtool -m xge0
>   i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
>   Cannot get Module EEPROM data: Operation not supported

Do i understand you correct in that this is when the SFP cage has
always been empty? The I2C transaction is going to fail whatever the
length is.

> If SFP module was plugged then removed at least once,
> sfp->i2c_block_size will be initialized and ethtool -m will fail with
> different error
> 
>   # ethtool -m xge0
>   Cannot get Module EEPROM data: Remote I/O error

So again, the SFP cage is empty?

I wonder if a better fix is to use

sfp->state & SFP_F_PRESENT

in sfp_module_eeprom() and sfp_module_eeprom_by_page() and don't even
do the I2C read if there is no module in the cage?

   Andrew
