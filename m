Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3250EC94
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiDYXdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiDYXdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:33:52 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AD566AEE
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:30:46 -0700 (PDT)
Received: (qmail 81194 invoked by uid 89); 25 Apr 2022 23:30:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 25 Apr 2022 23:30:44 -0000
Date:   Mon, 25 Apr 2022 16:30:43 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220425233043.q5335cvto5c6zcck@bsd-mbp.dhcp.thefacebook.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425011931.GB4472@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425011931.GB4472@hoboy.vegasvil.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 06:19:31PM -0700, Richard Cochran wrote:
> On Sat, Apr 23, 2022 at 07:23:53PM -0700, Jonathan Lemon wrote:
> 
> > +static bool bcm_ptp_rxtstamp(struct mii_timestamper *mii_ts,
> > +			     struct sk_buff *skb, int type)
> > +{
> > +	struct bcm_ptp_private *priv = mii2priv(mii_ts);
> > +	struct skb_shared_hwtstamps *hwts;
> > +	struct ptp_header *header;
> > +	u32 sec, nsec;
> > +	u8 *data;
> > +
> > +	if (!priv->hwts_rx)
> > +		return false;
> > +
> > +	header = ptp_parse_header(skb, type);
> > +	if (!header)
> > +		return false;
> > +
> > +	data = (u8 *)(header + 1);
> 
> No need to pointer math, as ptp_header already has reserved1 and reserved2.
> 
> > +	sec = get_unaligned_be32(data);
> 
> Something is missing here.  The seconds field is only four bits, so
> the code needs to read the 80 bit counter once in a while and augment
> the time stamp with the upper bits.

The BCM chip inserts a 64-bit sec.nsec RX timestamp immediately after
the PTP header.  So I'm recovering it here.  I'll also update the patch
to memmove() the tail of the skb up in order to remove it, just in case
it makes a difference.
-- 
Jonathan
