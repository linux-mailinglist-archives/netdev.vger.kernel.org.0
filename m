Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0352F77C
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiEUCFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiEUCFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:05:03 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8171611D3
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:05:01 -0700 (PDT)
Received: (qmail 75051 invoked by uid 89); 21 May 2022 02:04:59 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 21 May 2022 02:04:59 -0000
Date:   Fri, 20 May 2022 19:04:56 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220521020456.fkgx7s5ymtxd5y2q@bsd-mbp.local>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
 <f5963ddb-01bb-6935-ecdd-0f9e7c0afda0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5963ddb-01bb-6935-ecdd-0f9e7c0afda0@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 10:24:25AM -0700, Florian Fainelli wrote:
> 
> 
> On 5/18/2022 3:39 PM, Jonathan Lemon wrote:
> > This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> > the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> > tested on that hardware.
> > 
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> [snip]
> 
> Looks good to me, just one question below:
> 
> > +static void bcm_ptp_init(struct bcm_ptp_private *priv)
> > +{
> > +	priv->nse_ctrl = NSE_GMODE_EN;
> > +
> > +	mutex_init(&priv->mutex);
> > +	skb_queue_head_init(&priv->tx_queue);
> > +
> > +	priv->mii_ts.rxtstamp = bcm_ptp_rxtstamp;
> > +	priv->mii_ts.txtstamp = bcm_ptp_txtstamp;
> > +	priv->mii_ts.hwtstamp = bcm_ptp_hwtstamp;
> > +	priv->mii_ts.ts_info = bcm_ptp_ts_info;
> > +
> > +	priv->phydev->mii_ts = &priv->mii_ts;
> > +
> > +	INIT_DELAYED_WORK(&priv->out_work, bcm_ptp_fsync_work);
> 
> Do we need to make sure that we cancel the workqueue in an bcm_ptp_exit()
> function?
> 
> I would imagine that the Ethernet MAC attached to that PHY device having
> stopped its receiver and transmitter should ensure no more packets coming in
> or out, however since this is a delayed/asynchronous work, do not we need to
> protect against use after free?

The workqueue is just mamually creatimg a 1PPS pulse on the SYNC_OUT
pin, no packet activity.  Arguably, the .suspend hook could stop all work,
but that seems out of scope here? (and this phy does not suspend/resume)
-- 
Jonathan   (one handed typist for a few weeks)
