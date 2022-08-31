Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5C15A89AC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiIAAAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiIAAAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:00:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF8813F35
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 16:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lk2SDLNCNv9Xc0Fia9ol/HIJcd5gdBPP3wxdxwYHpwY=; b=ZU8bw4FmcG+8GglxF4dNyRZamI
        z+SA4MXv0SRIegtxQ8TDA7vabwxzHVrnBywTBy9p1sZ00pMWPWNaRNw93N12pwvrfC7rhes92CPbI
        8oD8ftA3YgcDNRZ8jXRpJBAv2fCRLVC6QatJ2hbmlkLJjGvT5f2UaXVXaL9bNoSPiLrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTXcb-00FFWl-Aa; Thu, 01 Sep 2022 01:59:49 +0200
Date:   Thu, 1 Sep 2022 01:59:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 01/16] net: txgbe: Store PCI info
Message-ID: <Yw/19QZJeZE7yy+8@lunn.ch>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
 <20220830070454.146211-2-jiawenwu@trustnetic.com>
 <Yw6mFbl8abA1lgma@lunn.ch>
 <025701d8bce0$36fc7300$a4f55900$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025701d8bce0$36fc7300$a4f55900$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	/* if there's flash existing */
> > > +	if (!(rd32(hw, TXGBE_SPI_STATUS) &
> > > +	      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
> > > +		/* wait hw load flash done */
> > > +		for (i = 0; i < TXGBE_MAX_FLASH_LOAD_POLL_TIME; i++) {
> > > +			reg = rd32(hw, TXGBE_SPI_ILDR_STATUS);
> > > +			if (!(reg & check_bit)) {
> > > +				/* done */
> > > +				break;
> > > +			}
> > > +			msleep(200);
> > > +		}
> > 
> > This is what iopoll.h is for. Any sort of loop waiting for something to
> happen
> > should use one of the helpers in there.
> > 
> 
> The description of functions in iopoll.h states that maximum sleep time
> should be less than 20ms, is it okay to call it here for 200ms.

Should be fine.

You could always reduce the sleep and just poll 10 times more. What
you are doing, reading one register, is cheap.

    Andrew
