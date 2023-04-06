Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFA56D98FA
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbjDFOG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbjDFOGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:06:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB039EC6;
        Thu,  6 Apr 2023 07:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8oDZ3kRs6FRgfVq+RBtRMhtbWqUsbcDXqJPAfMNttQ4=; b=WGrifdM0YVtMczLeufRhUKtMzt
        +ve7ArrD/aGxPprJyRkQ8xa5CeYqhtKGRxT8IWAB05VpX8QNzrw1+IM1iRCwwBbJ6A8u2Y33MCStS
        KtZH0Hu6mhqZudtEJAG8i3gxaOcCvix9pPQeJnwCyHsIVzGYWojQYtbRRM7bjN6Cv84M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkQF8-009dMn-Er; Thu, 06 Apr 2023 16:05:38 +0200
Date:   Thu, 6 Apr 2023 16:05:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        system@metrotek.ru, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: sfp: initialize sfp->i2c_block_size at
 sfp allocation
Message-ID: <8e34fb09-87e0-4bab-bfd8-dd35b76eac53@lunn.ch>
References: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
 <20230406130833.32160-2-i.bornyakov@metrotek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406130833.32160-2-i.bornyakov@metrotek.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:08:32PM +0300, Ivan Bornyakov wrote:
> sfp->i2c_block_size is initialized at SFP module insertion in
> sfp_sm_mod_probe(). Because of that, if SFP module was never inserted
> since boot, sfp_read() call will lead to zero-length I2C read attempt,
> and not all I2C controllers are happy with zero-length reads.
> 
> One way to issue sfp_read() on empty SFP cage is to execute ethtool -m.
> If SFP module was never plugged since boot, there will be a zero-length
> I2C read attempt.
> 
>   # ethtool -m xge0
>   i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
>   Cannot get Module EEPROM data: Operation not supported
> 
> If SFP module was plugged then removed at least once,
> sfp->i2c_block_size will be initialized and ethtool -m will fail with
> different exit code and without I2C error
> 
>   # ethtool -m xge0
>   Cannot get Module EEPROM data: Remote I/O error
> 
> Fix this by initializing sfp->i2_block_size at struct sfp allocation
> stage so no wild sfp_read() could issue zero-length I2C read.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
> Cc: stable@vger.kernel.org

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
