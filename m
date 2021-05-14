Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916843802C7
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 06:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhENEX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 00:23:28 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:52356 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232177AbhENEX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 00:23:26 -0400
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 10349837F24A;
        Fri, 14 May 2021 04:22:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 6D592B2796;
        Fri, 14 May 2021 04:22:10 +0000 (UTC)
Message-ID: <d1ae6de53236629d2d02bed1af280e1cbf4c4e8c.camel@perches.com>
Subject: Re: [PATCH 2/7] rtl8xxxu: add handle for mac80211 get_txpower
From:   Joe Perches <joe@perches.com>
To:     Reto Schneider <code@reto-schneider.ch>, Jes.Sorensen@gmail.com,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 13 May 2021 21:22:09 -0700
In-Reply-To: <20210514020442.946-3-code@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
         <20210514020442.946-1-code@reto-schneider.ch>
         <20210514020442.946-3-code@reto-schneider.ch>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.56
X-Stat-Signature: dk8dqn4byhkc677ruoy5f8jfh8rn1dfe
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 6D592B2796
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18ODrWJ8BvWBzNaBhnO6Y0bbB7RSrNHloA=
X-HE-Tag: 1620966130-521492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-14 at 04:04 +0200, Reto Schneider wrote:
> From: Chris Chiu <chiu@endlessos.org>
> 
> add .get_txpower handle for mac80211 operations for `iw` and `wext`
> tools to get the underlying tx power (max limit).
[]
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
[]

> +int
> +rtl8xxxu_gen1_get_tx_power(struct rtl8xxxu_priv *priv)
> +{
> +	u8 txpwr_level;
> +	int txpwr_dbm;
> +
> +	txpwr_level = priv->cur_cck_txpwridx;
> +	txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_B,
> +						  txpwr_level);
> +	txpwr_level = priv->cur_ofdm24g_txpwridx +
> +		      priv->ofdm_tx_power_index_diff[1].a;
> +
> +	if (rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_G, txpwr_level)
> +	    > txpwr_dbm)
> +		txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_G,
> +							  txpwr_level);

probably better to use a temporaries instead of multiple calls.

	foo = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_G, txpwr_level);
	if (foo > txpwr_dbm)
		txpwr_dbm = foo;

> +	txpwr_level = priv->cur_ofdm24g_txpwridx;
> +	if (rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_N_24G,
> +					  txpwr_level) > txpwr_dbm)
> +		txpwr_dbm = rtl8xxxu_gen1_txpwridx_to_dbm(priv,
> +							  WIRELESS_MODE_N_24G,
> +							  txpwr_level);
> +
> +	return txpwr_dbm;

	foo = rtl8xxxu_gen1_txpwridx_to_dbm(priv, WIRELESS_MODE_N_24G, txpwr_level);

	return min(txpwr_dbm, foo);


