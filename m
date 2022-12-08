Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6546465D2
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLHA0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHA0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:26:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B5C8D65C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/lqRFtbsZAV7ATt0VUUzYtl/zsAii7JnGJkI8ZUNJbo=; b=6cB4zBuh37f/azpQ/DqQC36pxF
        yO2ZYexzxxMWVfML9Be39OqBmRP40ZzbhSCeGt1Z3/lcrmzrtI9tBIvgixD+/JSPVes7dyvR3Q+17
        3dwRaIbl1xSpbKMEtF/hEONQ3Za1Yey+nPqMJnET2t+BPBekPWV4UIeRv7xDvxYIUB/s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p34jx-004hjB-Tu; Thu, 08 Dec 2022 01:26:17 +0100
Date:   Thu, 8 Dec 2022 01:26:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y5EvKciMg3Nkj8ln@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01>
 <Y4i/Aeqh94ZP/mA0@lunn.ch>
 <20221206182823.08e5f917@kernel.org>
 <Y5CZp0QJVejOpWSY@lunn.ch>
 <87v8mne09m.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8mne09m.fsf@kurt>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:50:13PM +0100, Kurt Kanzenbach wrote:
> On Wed Dec 07 2022, Andrew Lunn wrote:
> > On Tue, Dec 06, 2022 at 06:28:23PM -0800, Jakub Kicinski wrote:
> >> On Thu, 1 Dec 2022 15:49:37 +0100 Andrew Lunn wrote:
> >> > > The root cause is the MAC using the internal clock as a PTP reference
> >> > > (default), which should be allowed since the connection to an external
> >> > > PTP clock is optional from an HW perspective. The internal clock seems
> >> > > to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.  
> >> > 
> >> > I think we need help from somebody who understands PTP on this device.
> >> > The clock is clearly out of range, but how important is that to PTP?
> >> > Will PTP work if the value is clamped to 0xff? Or should we be
> >> > returning -EINVAL and disabling PTP because it has no chance of
> >> > working?
> >> 
> >> Indeed, we need some more info here :( Like does the PTP actually
> >> work with 2.5 MHz clock? The frequency adjustment only cares about 
> >> the addend, what is sub_second_inc thing?
> >
> > Hi Jakub
> >
> > I Cc: many of the people who worked on PTP with this hardware, and
> > nobody has replied.
> >
> > I think we should wait a couple more days, and then add a range check,
> > and disable PTP for invalid clocks. That might provoke feedback.
> 
> Here's the Altera manual:
> 
>  https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/functional-description-of-the-emac.html
> 
> Table 183 shows the minimum PTP frequencies and also states "Therefore,
> a higher PTP clock frequency gives better system performance.".
> 
> So, I'd say using a clock of 2.5MHz seems possible, but will result in
> suboptimal precision.

Thanks for the info. So i seems like the correct fix is to camp to
0xff, rather than mask with 0xff.

      Andrew
