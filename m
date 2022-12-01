Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82B363F320
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiLAOtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiLAOtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:49:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4C6AC188
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e1jGcyaVV//iB19k70zp2KvP4AEda1Ddt8g8Gmm3KLc=; b=uIQ8JuSncadKm6Hmp2d7x0ePRC
        b6U9+4KdfkvGxUzjNQQZ1y11iHz8m/ZF7m1Xed9jAkO+h3Ny3T+DZplb9gVuw5Qu4XtJ/r7BpyhMd
        2kiuWAbC87votYdQ02mk+l0gNx4uaYoFx23RNJm78QSkR9fn8/nogYFW9+iVMcRrQO9s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0ksb-0044Mn-Al; Thu, 01 Dec 2022 15:49:37 +0100
Date:   Thu, 1 Dec 2022 15:49:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com,
        Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y4i/Aeqh94ZP/mA0@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4iA6mwSaZw+PKHZ@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:24:42AM +0100, Piergiorgio Beruto wrote:
> On Thu, Dec 01, 2022 at 02:39:03AM +0100, Andrew Lunn wrote:
> > On Thu, Dec 01, 2022 at 01:37:08AM +0100, Piergiorgio Beruto wrote:
> > > Depending on the HW platform and configuration, the
> > > stmmac_config_sub_second_increment() function may return 0 in the
> > > sec_inc variable. Therefore, the subsequent div_u64 operation can Oops
> > > the kernel because of the divisor being 0.
> > 
> > I'm wondering why it would return 0? Is the configuration actually
> > invalid? Is ptp_clock is too small, such that the value of data is
> > bigger than 255, but when masked with 0xff it gives zero?
> Ok, I did some more analysis on this. On my reference board, I got two
> PHYs connected to two stmmac, one is 1000BASE-T, the other one is
> 10BASE-T1S.
> 
> Fot the 1000BASE-T PHY everything works ok. The ptp_clock is 0ee6b280
> which gives data = 8 that is less than FF.
> 
> For the 10BASE-T1 PHY the ptp_clock is 001dcd65 which gives data = 400
> (too large). Therefore, it is 0 after masking.

So both too large, and also unlucky. If it had been 0x3ff you would
not of noticed.

> The root cause is the MAC using the internal clock as a PTP reference
> (default), which should be allowed since the connection to an external
> PTP clock is optional from an HW perspective. The internal clock seems
> to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.

I think we need help from somebody who understands PTP on this device.
The clock is clearly out of range, but how important is that to PTP?
Will PTP work if the value is clamped to 0xff? Or should we be
returning -EINVAL and disabling PTP because it has no chance of
working?

Add to Cc: a few people who have worked on the PTP code. Lets see what
they have to say.

     Andrew
