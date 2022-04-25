Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782A650ECD1
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiDYXui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYXuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:50:37 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95AE1903C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:47:31 -0700 (PDT)
Received: (qmail 66869 invoked by uid 89); 25 Apr 2022 23:47:30 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 25 Apr 2022 23:47:30 -0000
Date:   Mon, 25 Apr 2022 16:47:28 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425234728.cseqppyutr224wie@bsd-mbp.dhcp.thefacebook.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425031239.GA6294@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425031239.GA6294@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 08:12:39PM -0700, Richard Cochran wrote:
> On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:
> 
> > +static int bcm_ptp_settime_locked(struct bcm_ptp_private *priv,
> > +				  const struct timespec64 *ts)
> > +{
> > +	struct phy_device *phydev = priv->phydev;
> > +	u16 ctrl;
> > +
> > +	/* set up time code */
> > +	bcm_phy_write_exp(phydev, TIME_CODE_0, ts->tv_nsec);
> > +	bcm_phy_write_exp(phydev, TIME_CODE_1, ts->tv_nsec >> 16);
> > +	bcm_phy_write_exp(phydev, TIME_CODE_2, ts->tv_sec);
> > +	bcm_phy_write_exp(phydev, TIME_CODE_3, ts->tv_sec >> 16);
> > +	bcm_phy_write_exp(phydev, TIME_CODE_4, ts->tv_sec >> 32);
> > +
> > +	/* zero out NCO counter */
> > +	bcm_phy_write_exp(phydev, NCO_TIME_0, 0);
> > +	bcm_phy_write_exp(phydev, NCO_TIME_1, 0);
> > +	bcm_phy_write_exp(phydev, NCO_TIME_2_CTRL, 0);
> 
> You are setting the 48 bit counter to zero.
> 
> But Lasse's version does this:
> 
> 	// Assign original time codes (48 bit)
> 	local_time_codes[2] = 0x4000;
> 	local_time_codes[1] = (u16)(ts->tv_nsec >> 20);
> 	local_time_codes[0] = (u16)(ts->tv_nsec >> 4);
> 
> 	...
> 
> 	// Write Local Time Code Register
> 	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_0_REG, local_time_codes[0]);
> 	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_1_REG, local_time_codes[1]);
> 	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_2_REG, local_time_codes[2]);
> 
> My understanding is that the PPS output function uses the 48 bit
> counter, and so it ought to be set to a non-zero value.

I'm not sure what this is doing.  Setting BIT(14) says this is a
frequency control adjustment.  From my understanding, the local timer is
used for generating a oneshot output pulse, which the driver currently
doesn't do.


> In any case, it would be nice to have the 80/48 bit register usage
> clearly explained.

You and me both.
-- 
Jonathan
