Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C89E5388D5
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbiE3WSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 18:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiE3WSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 18:18:50 -0400
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5F873795
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 15:18:49 -0700 (PDT)
Received: (qmail 86987 invoked by uid 89); 30 May 2022 22:18:46 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 30 May 2022 22:18:46 -0000
Date:   Mon, 30 May 2022 15:18:45 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v5 2/2] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220530221845.r4pf7pyu2pabzqi5@bsd-mbp.dhcp.thefacebook.com>
References: <20220518223935.2312426-1-jonathan.lemon@gmail.com>
 <20220518223935.2312426-3-jonathan.lemon@gmail.com>
 <f5963ddb-01bb-6935-ecdd-0f9e7c0afda0@gmail.com>
 <20220521020456.fkgx7s5ymtxd5y2q@bsd-mbp.local>
 <dd55b6ce-204e-557b-ef70-1c91f80e5f8d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd55b6ce-204e-557b-ef70-1c91f80e5f8d@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 22, 2022 at 07:49:20PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/20/2022 7:04 PM, Jonathan Lemon wrote:
> > On Fri, May 20, 2022 at 10:24:25AM -0700, Florian Fainelli wrote:
> > > 
> > > 
> > > On 5/18/2022 3:39 PM, Jonathan Lemon wrote:
> > > > This adds PTP support for BCM54210E Broadcom PHYs, in particular,
> > > > the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
> > > > tested on that hardware.
> > > > 
> > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > > ---
> > > [snip]
> > > 
> > > Looks good to me, just one question below:
> > > 
> > > > +static void bcm_ptp_init(struct bcm_ptp_private *priv)
> > > > +{
> > > > +	priv->nse_ctrl = NSE_GMODE_EN;
> > > > +
> > > > +	mutex_init(&priv->mutex);
> > > > +	skb_queue_head_init(&priv->tx_queue);
> > > > +
> > > > +	priv->mii_ts.rxtstamp = bcm_ptp_rxtstamp;
> > > > +	priv->mii_ts.txtstamp = bcm_ptp_txtstamp;
> > > > +	priv->mii_ts.hwtstamp = bcm_ptp_hwtstamp;
> > > > +	priv->mii_ts.ts_info = bcm_ptp_ts_info;
> > > > +
> > > > +	priv->phydev->mii_ts = &priv->mii_ts;
> > > > +
> > > > +	INIT_DELAYED_WORK(&priv->out_work, bcm_ptp_fsync_work);
> > > 
> > > Do we need to make sure that we cancel the workqueue in an bcm_ptp_exit()
> > > function?
> > > 
> > > I would imagine that the Ethernet MAC attached to that PHY device having
> > > stopped its receiver and transmitter should ensure no more packets coming in
> > > or out, however since this is a delayed/asynchronous work, do not we need to
> > > protect against use after free?
> > 
> > The workqueue is just mamually creatimg a 1PPS pulse on the SYNC_OUT
> > pin, no packet activity.  Arguably, the .suspend hook could stop all work,
> > but that seems out of scope here? (and this phy does not suspend/resume)
> 
> The BCM54210E entry does have a suspend/resume entry so it seems to me that
> we do need to cancel the workqueue as the PHY library will not do that on
> our behalf. What I imagine could happen is that this workqueue generates
> spurious MDIO accesses *after* both the PHY and the bus have been suspended
> (and their driver's clock possibly gated already).

Yes, you're right.  I was looking at the rpi-5.15.y tree, which doesn't
have these hooks yet.  I'll add a call to stop the workqueue.

Actually, in the next series, I'll break out the extts/perout into
separate patch.

Thanks for pointing this out!
-- 
Jonathan
