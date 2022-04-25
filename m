Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1304850ECE1
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiDYX4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDYX4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:56:10 -0400
Received: from smtp6.emailarray.com (smtp6.emailarray.com [65.39.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDE94131D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:53:05 -0700 (PDT)
Received: (qmail 16234 invoked by uid 89); 25 Apr 2022 23:53:03 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 25 Apr 2022 23:53:03 -0000
Date:   Mon, 25 Apr 2022 16:53:01 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425235301.hvcheqzjpnolcp6z@bsd-mbp.dhcp.thefacebook.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <91d60847-4721-971d-7e86-22e1dd3c694e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91d60847-4721-971d-7e86-22e1dd3c694e@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 04:27:06PM -0700, Florian Fainelli wrote:
> 
> 
> On 4/23/2022 7:23 PM, Jonathan Lemon wrote:
> > This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> > the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> > tested on that hardware.
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> 
> [snip]
> 
> Mostly checking register names/offsets/usage because I am not familiar
> enough with how PTP is supposed to work.
> 
> > +#define MODE_SEL_SHIFT_PORT		0
> > +#define MODE_SEL_SHIFT_CPU		8
> > +
> > +#define rx_mode(sel, evt, act) \
> > +	(((MODE_RX_##act) << (MODE_EVT_SHIFT_##evt)) << (MODE_SEL_SHIFT_##sel))
> > +
> > +#define tx_mode(sel, evt, act) \
> > +	(((MODE_TX_##act) << (MODE_EVT_SHIFT_##evt)) << (MODE_SEL_SHIFT_##sel))
> 
> I would capitalize these two macros to make it clear that they are exactly
> that, macros.

Ack.


> > +/* needs global TS capture first */
> > +#define TX_TS_CAPTURE		0x0821
> > +#define  TX_TS_CAP_EN			BIT(0)
> > +#define RX_TS_CAPTURE		0x0822
> > +#define  RX_TS_CAP_EN			BIT(0)
> > +
> > +#define TIME_CODE_0		0x0854
> 
> Maybe add a macro here as well:
> 
> #define TIME_CODE(x)		(TIME_CODE0 + (x))

I'd prrefer keep them separate, as not all of the registers are
sequential - the heartbeat registers for example.


> > +#define SHADOW_LOAD		0x085d
> > +#define  TIME_CODE_LOAD			BIT(10)
> > +#define  SYNC_OUT_LOAD			BIT(9)
> > +#define  NCO_TIME_LOAD			BIT(7)
> 
> NCO Divider load is bit 8 and Local time Load bit is 7, can you check which
> one you need?

Local time load.  NCO divider counts the SYNC_IN pulses and generates a
timestamp after <n> events (as I understand things).

 
> > +#define  FREQ_LOAD			BIT(6)
> > +#define INTR_MASK		0x085e
> > +#define INTR_STATUS		0x085f
> > +#define  INTC_FSYNC			BIT(0)
> > +#define  INTC_SOP			BIT(1)
> > +
> > +#define FREQ_REG_LSB		0x0873
> > +#define FREQ_REG_MSB		0x0874
> 
> Those two hold the NCO frequency, can you rename accordingly?


> > +#define TS_READ_CTRL		0x0885
> > +#define  TS_READ_START			BIT(0)
> > +#define  TS_READ_END			BIT(1)
> > +
> > +#define TIMECODE_CTRL		0x08c3
> > +#define  TX_TIMECODE_SEL		GENMASK(7, 0)
> > +#define  RX_TIMECODE_SEL		GENMASK(15, 8)
> 
> This one looks out of order compared to the other registers

Will rearrange the groups a bit.


> > +struct bcm_ptp_private *bcm_ptp_probe(struct phy_device *phydev)
> > +{
> > +	struct bcm_ptp_private *priv;
> > +	struct ptp_clock *clock;
> > +
> > +	switch (BRCM_PHY_MODEL(phydev)) {
> > +	case PHY_ID_BCM54210E:
> > +#ifdef PHY_ID_BCM54213PE
> > +	case PHY_ID_BCM54213PE:
> > +#endif
> 
> This does not exist upstream.

Yes, hence the #ifdef.  Will remove this for the next patch.  It's here
since I can just copy it over to the rpi-5.15 tree and have it still
work.
-- 
Jonathan
