Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E696D2105
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbjCaM7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjCaM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:59:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0C31BCE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:59:15 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1piELT-0007HC-29; Fri, 31 Mar 2023 14:59:07 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1piELS-0002LD-Oy; Fri, 31 Mar 2023 14:59:06 +0200
Date:   Fri, 31 Mar 2023 14:59:06 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc() outside the RCU
Message-ID: <20230331125906.GF15436@pengutronix.de>
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
 <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 08, 2023 at 10:13:22PM +0100, Martin Blumenstingl wrote:
> USB and (upcoming) SDIO support may sleep in the read/write handlers.
> Shrink the RCU critical section so it only cover the call to
> ieee80211_find_sta() and finding the ic_vht_cap/vht_cap based on the
> found station. This moves the chip's BFEE configuration outside the
> rcu_read_lock section and thus prevent "scheduling while atomic" or
> "Voluntary context switch within RCU read-side critical section!"
> warnings when accessing the registers using an SDIO card (which is
> where this issue has been spotted in the real world - but it also
> affects USB cards).

Unfortunately this introduces a regression on my RTW8821CU chip. With
this it constantly looses connection to the AP and reconnects shortly
after:

[  199.771143] wlan0: authenticate with b0:be:76:5e:7b:34
[  201.447301] wlan0: send auth to b0:be:76:5e:7b:34 (try 1/3)
[  201.456789] wlan0: authenticated
[  201.462356] wlan0: associate with b0:be:76:5e:7b:34 (try 1/3)
[  201.477263] wlan0: RX AssocResp from b0:be:76:5e:7b:34 (capab=0x431 status=0 aid=2)
[  201.512995] wlan0: associated
[  213.790399] wlan0: authenticate with b0:be:76:5e:7b:34
[  215.467302] wlan0: send auth to b0:be:76:5e:7b:34 (try 1/3)
[  215.470532] wlan0: authenticated
[  215.490355] wlan0: associate with b0:be:76:5e:7b:34 (try 1/3)
[  215.503777] wlan0: RX AssocResp from b0:be:76:5e:7b:34 (capab=0x431 status=0 aid=2)
[  215.539608] wlan0: associated
[  227.770596] wlan0: authenticate with b0:be:76:5e:7b:34
[  229.443302] wlan0: send auth to b0:be:76:5e:7b:34 (try 1/3)
[  229.451209] wlan0: authenticated
[  229.462487] wlan0: associate with b0:be:76:5e:7b:34 (try 1/3)
[  229.476077] wlan0: RX AssocResp from b0:be:76:5e:7b:34 (capab=0x431 status=0 aid=2)
[  229.513499] wlan0: associated
[  241.738494] wlan0: authenticate with b0:be:76:5e:7b:34
[  243.407301] wlan0: send auth to b0:be:76:5e:7b:34 (try 1/3)
[  243.411207] wlan0: authenticated
[  243.423213] wlan0: associate with b0:be:76:5e:7b:34 (try 1/3)
[  243.439822] wlan0: RX AssocResp from b0:be:76:5e:7b:34 (capab=0x431 status=0 aid=2)
[  243.476731] wlan0: associated

I haven't got any further information yet, I just realized this when I
rebased my own RTW88 bugfix series from v6.2.2 to v6.3-rc4 before
sending it.

RTW8723D and RTW8822CU seem unaffected though.

Sascha

> 
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> v1 -> v2:
> - Added Ping-Ke's Reviewed-by (thank you!)
> 
> v2 -> v3:
> - Added Sascha's Tested-by (thank you!)
> - added "wifi" prefix to the subject and reworded the title accordingly
> 
> 
>  drivers/net/wireless/realtek/rtw88/bf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
> index 038a30b170ef..c827c4a2814b 100644
> --- a/drivers/net/wireless/realtek/rtw88/bf.c
> +++ b/drivers/net/wireless/realtek/rtw88/bf.c
> @@ -49,19 +49,23 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  
>  	sta = ieee80211_find_sta(vif, bssid);
>  	if (!sta) {
> +		rcu_read_unlock();
> +
>  		rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
>  			 bssid);
> -		goto out_unlock;
> +		return;
>  	}
>  
>  	ic_vht_cap = &hw->wiphy->bands[NL80211_BAND_5GHZ]->vht_cap;
>  	vht_cap = &sta->deflink.vht_cap;
>  
> +	rcu_read_unlock();
> +
>  	if ((ic_vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE) &&
>  	    (vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
>  		if (bfinfo->bfer_mu_cnt >= chip->bfer_mu_max_num) {
>  			rtw_dbg(rtwdev, RTW_DBG_BF, "mu bfer number over limit\n");
> -			goto out_unlock;
> +			return;
>  		}
>  
>  		ether_addr_copy(bfee->mac_addr, bssid);
> @@ -75,7 +79,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  		   (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)) {
>  		if (bfinfo->bfer_su_cnt >= chip->bfer_su_max_num) {
>  			rtw_dbg(rtwdev, RTW_DBG_BF, "su bfer number over limit\n");
> -			goto out_unlock;
> +			return;
>  		}
>  
>  		sound_dim = vht_cap->cap &
> @@ -98,9 +102,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
>  
>  		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
>  	}
> -
> -out_unlock:
> -	rcu_read_unlock();
>  }
>  
>  void rtw_bf_init_bfer_entry_mu(struct rtw_dev *rtwdev,
> -- 
> 2.39.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
