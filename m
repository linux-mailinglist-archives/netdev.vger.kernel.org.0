Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F071C3802AA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 06:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhENEKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 00:10:18 -0400
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:34088 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231171AbhENEKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 00:10:17 -0400
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 92C0B182CED2A;
        Fri, 14 May 2021 04:09:05 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 9E6862EBFA8;
        Fri, 14 May 2021 04:09:02 +0000 (UTC)
Message-ID: <fad21a091625a2d1c7975ffc620cab9efa4ce09e.camel@perches.com>
Subject: Re: [PATCH 1/7] rtl8xxxu: add code to handle
 BSS_CHANGED_TXPOWER/IEEE80211_CONF_CHANGE_POWER
From:   Joe Perches <joe@perches.com>
To:     Reto Schneider <code@reto-schneider.ch>, Jes.Sorensen@gmail.com,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 13 May 2021 21:09:01 -0700
In-Reply-To: <20210514020442.946-2-code@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
         <20210514020442.946-1-code@reto-schneider.ch>
         <20210514020442.946-2-code@reto-schneider.ch>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.68
X-Stat-Signature: 4x1z97i8kc1jk53bqo1ak56hd43pd335
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 9E6862EBFA8
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18YBu717zxvCrTp2AtDrS5EFL2OT+Rlmug=
X-HE-Tag: 1620965342-995075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-14 at 04:04 +0200, Reto Schneider wrote:
> From: Chris Chiu <chiu@endlessos.org>
> 
> The 'iw set txpower' is not handled by the driver. Use the existing
> set_tx_power function to apply the tx power change

trivial notes:

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
[]
> @@ -1382,6 +1382,38 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
>  	}
>  }
>  
> 
> +#define MAX_TXPWR_IDX_NMODE_92S		63
> +
> +u8
> +rtl8xxxu_gen1_dbm_to_txpwridx(struct rtl8xxxu_priv *priv, u16 mode, int dbm)
> +{
> +	u8 txpwridx;
> +	long offset;

why should offset be long when dbm is int?

> +
> +	switch (mode) {
> +	case WIRELESS_MODE_B:
> +		offset = -7;
> +		break;
> +	case WIRELESS_MODE_G:
> +	case WIRELESS_MODE_N_24G:
> +		offset = -8;
> +		break;
> +	default:
> +		offset = -8;
> +		break;
> +	}
> +
> +	if ((dbm - offset) > 0)
> +		txpwridx = (u8)((dbm - offset) * 2);

overflow of u8 when dbm >= 136?


> +	else
> +		txpwridx = 0;
> +
> +	if (txpwridx > MAX_TXPWR_IDX_NMODE_92S)
> +		txpwridx = MAX_TXPWR_IDX_NMODE_92S;
> +
> +	return txpwridx;
> +}
> +
>  void
>  rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
>  {
> @@ -4508,6 +4540,55 @@ rtl8xxxu_wireless_mode(struct ieee80211_hw *hw, struct ieee80211_sta *sta)
>  	return network_type;
>  }
>  
> 
> +static void rtl8xxxu_update_txpower(struct rtl8xxxu_priv *priv, int power)
> +{
> +	bool ht40 = false;

unnecessary initializations.

> +	struct ieee80211_hw *hw = priv->hw;
> +	int channel = hw->conf.chandef.chan->hw_value;
> +	u8 cck_txpwridx, ofdm_txpwridx;
> +	int i, group;
> +
> +	if (!priv->fops->dbm_to_txpwridx)
> +		return;
> +
> +	switch (hw->conf.chandef.width) {
> +	case NL80211_CHAN_WIDTH_20_NOHT:
> +	case NL80211_CHAN_WIDTH_20:
> +		ht40 = false;
> +		break;
> +	case NL80211_CHAN_WIDTH_40:
> +		ht40 = true;
> +		break;
> +	default:
> +		return;
> +	}


