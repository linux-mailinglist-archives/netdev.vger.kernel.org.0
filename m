Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23A12C2C5A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390086AbgKXQIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728249AbgKXQIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:08:52 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45172206FB;
        Tue, 24 Nov 2020 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606234131;
        bh=kFIjd4F470oDUcyxpZWXG2t2KnXVDgQpQVoUT00qj+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bv2xo7g40OY19yPg2+fkzKKF52gx7FyzpLRxx0hgQOH8t8+qBL6jDtKgV0hGAc4y1
         kjnWgUbnW/khysLd4tggQIw9x45uZJ4Es5HMHBvYldZzR3BmC2wy1KbOd6IsF7CLnv
         HPbfuKGwhN3mCnwy7eTKSPU4c4bWwSwzq0xw32Fw=
Date:   Tue, 24 Nov 2020 10:09:06 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 117/141] rtl8xxxu: Fix fall-through warnings for Clang
Message-ID: <20201124160906.GB17735@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org>
 <691515e4-4d40-56cf-5f7a-1819aad1afa9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <691515e4-4d40-56cf-5f7a-1819aad1afa9@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 04:39:42PM -0500, Jes Sorensen wrote:
> On 11/20/20 1:38 PM, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix
> > multiple warnings by replacing /* fall through */ comments with
> > the new pseudo-keyword macro fallthrough; instead of letting the
> > code fall through to the next case.
> > 
> > Notice that Clang doesn't recognize /* fall through */ comments as
> > implicit fall-through markings.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> While I wasn't CC'ed on the cover-letter I see Jakub also raised issues
> about this unnecessary patch noise.
> 
> Quite frankly, this seems to be patch churn for the sake of patch churn.
> If clang is broken, fix clang instead.

Just notice that the idea behind this and the following patch is exactly
the same:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=3f95e92c8a8516b745594049dfccc8c5f8895eea

I could resend this same patch with a different changelog text, but I
don't think such a thing is necessary. However, if people prefer that
approach, just let me know and I can do it.

Thanks
--
Gustavo

> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 5cd7ef3625c5..afc97958fa4d 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -1145,7 +1145,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
> >  	switch (hw->conf.chandef.width) {
> >  	case NL80211_CHAN_WIDTH_20_NOHT:
> >  		ht = false;
> > -		/* fall through */
> > +		fallthrough;
> >  	case NL80211_CHAN_WIDTH_20:
> >  		opmode |= BW_OPMODE_20MHZ;
> >  		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
> > @@ -1272,7 +1272,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
> >  	switch (hw->conf.chandef.width) {
> >  	case NL80211_CHAN_WIDTH_20_NOHT:
> >  		ht = false;
> > -		/* fall through */
> > +		fallthrough;
> >  	case NL80211_CHAN_WIDTH_20:
> >  		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
> >  		subchannel = 0;
> > @@ -1741,11 +1741,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
> >  		case 3:
> >  			priv->ep_tx_low_queue = 1;
> >  			priv->ep_tx_count++;
> > -			/* fall through */
> > +			fallthrough;
> >  		case 2:
> >  			priv->ep_tx_normal_queue = 1;
> >  			priv->ep_tx_count++;
> > -			/* fall through */
> > +			fallthrough;
> >  		case 1:
> >  			priv->ep_tx_high_queue = 1;
> >  			priv->ep_tx_count++;
> > 
> 
