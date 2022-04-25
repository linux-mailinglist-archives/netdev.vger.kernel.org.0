Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44EC50ED0E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbiDYX6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbiDYX6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:58:48 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BCAEA9
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:55:43 -0700 (PDT)
Received: (qmail 22963 invoked by uid 89); 25 Apr 2022 23:55:42 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 25 Apr 2022 23:55:42 -0000
Date:   Mon, 25 Apr 2022 16:55:40 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425235540.vuacu26xb6bzpxob@bsd-mbp.dhcp.thefacebook.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425013800.GC4472@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425013800.GC4472@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 06:38:00PM -0700, Richard Cochran wrote:
> On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:
> 
> > +static bool bcm_ptp_get_tstamp(struct bcm_ptp_private *priv,
> > +			       struct bcm_ptp_capture *capts)
> > +{
> > +	struct phy_device *phydev = priv->phydev;
> > +	u16 ts[4], reg;
> > +	u32 sec, nsec;
> > +
> > +	mutex_lock(&priv->mutex);
> > +
> > +	reg = bcm_phy_read_exp(phydev, INTR_STATUS);
> > +	if ((reg & INTC_SOP) == 0) {
> > +		mutex_unlock(&priv->mutex);
> > +		return false;
> > +	}
> > +
> > +	bcm_phy_write_exp(phydev, TS_READ_CTRL, TS_READ_START);
> > +
> > +	ts[0] = bcm_phy_read_exp(phydev, TS_REG_0);
> > +	ts[1] = bcm_phy_read_exp(phydev, TS_REG_1);
> > +	ts[2] = bcm_phy_read_exp(phydev, TS_REG_2);
> > +	ts[3] = bcm_phy_read_exp(phydev, TS_REG_3);
> > +
> > +	/* not in be32 format for some reason */
> > +	capts->seq_id = bcm_phy_read_exp(priv->phydev, TS_INFO_0);
> > +
> > +	reg = bcm_phy_read_exp(phydev, TS_INFO_1);
> > +	capts->msgtype = reg >> 12;
> > +	capts->tx_dir = !!(reg & BIT(11));
> 
> Okay, so now I am sad.  The 541xx has:
> 
>   TIMESTAMP_INFO_1 0xA8C  bit 0 DIR, bits 1-2 msg_type, etc
>   TIMESTAMP_INFO_2 0xA8D  sequence ID
> 
> It is the same info, but randomly shuffled among the two registers in
> a different way.
> 
> So much for supporting multiple devices with a common code base.  :(

We could just have a chip-specific version of this function.  The
recovered timestamp is passed back in a structure, so the rest of the
code would be unchanged.
-- 
Jonathan    (no, not volunteering to do this...)
