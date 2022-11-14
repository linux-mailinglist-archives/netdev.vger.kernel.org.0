Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CDA628A50
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 21:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiKNUTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 15:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237489AbiKNUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 15:19:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B821E13DCC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 12:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b/w82EMLclqSoa/I9bcJdsE5B2uChOLheD0SOFZ8ZwE=; b=4VSFdfj/MX63lvFO+QaK61uMMc
        XgnI4lyc4CVvavi3atfgFEygHkDUouangfYt/YPYJG8OOyOTyQ3dng51i+iDzhNt4hL6cU1lasYq7
        xhdkmBHeb+MAuavv1j1iFyQH29UP52nHN1sSj8/TJwuuwV3KnXti7A/v9cjKlJmb/Hxo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oufuk-002NV0-4S; Mon, 14 Nov 2022 21:18:42 +0100
Date:   Mon, 14 Nov 2022 21:18:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org,
        jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Message-ID: <Y3KiovqzjhfeyR80@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-2-mengyuanlou@net-swift.com>
 <20221114153438.703209-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114153438.703209-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 04:34:38PM +0100, Alexander Lobakin wrote:
> From: Mengyuan Lou <mengyuanlou@net-swift.com>
> Date: Tue,  8 Nov 2022 19:19:03 +0800
> 
> > From: Jiawen Wu <jiawenwu@trustnetic.com>
> > 
> > Add to get media type and physical layer module, support I2C access.
> > 
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > ---
> 
> [...]
> 
> > @@ -277,11 +647,30 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
> >  	struct wx_hw *wxhw = &hw->wxhw;
> >  	int status;
> >  
> > +	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
> > +	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
> > +	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
> > +	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;
> 
> Please merge this with the first declaration block, there must be
> only one.
> Also, are you sure you need all this simultaneously? Maybe reuse
> some of them?

I would not actually spend too much time reviewing this code. It needs
restructuring into a pcs driver, maybe in driver/net/pcs. And some of
it might get turning into generic PHY driver.

Very likely, this whole driver will get re-written as it is merged.

	Andrew
