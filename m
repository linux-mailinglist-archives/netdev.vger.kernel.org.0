Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E1426027
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhJGXG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJGXG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 19:06:26 -0400
X-Greylist: delayed 1669 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Oct 2021 16:04:32 PDT
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A50BC061570;
        Thu,  7 Oct 2021 16:04:32 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1mYc00-0003P2-Io; Fri, 08 Oct 2021 00:36:25 +0200
Date:   Thu, 7 Oct 2021 23:36:10 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Nick Hainke <vincent@systemli.org>
Cc:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: [RFC v1] mt76: mt7615: mt7622: fix adhoc and ibss mode
Message-ID: <YV92Wjo+3dZ49DL6@makrotopia.org>
References: <20211007212323.1223602-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007212323.1223602-1-vincent@systemli.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, Oct 07, 2021 at 11:23:23PM +0200, Nick Hainke wrote:
> Subject: [RFC v1] mt76: mt7615: mt7622: fix adhoc and ibss mode
Ad-Hoc and IBSS mode are synonyms.
What probably meant to write 'fix adhoc and mesh mode', right?

> Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
> 
> commit 7f4b7920318b ("mt76: mt7615: add ibss support") introduced IBSS
> and commit f4ec7fdf7f83 ("mt76: mt7615: enable support for mesh")
> meshpoint support.
> 
> Both used in the "get_omac_idx"-function:
> 
> 	if (~mask & BIT(HW_BSSID_0))
> 		return HW_BSSID_0;
> 
> With commit d8d59f66d136 ("mt76: mt7615: support 16 interfaces") the
> adhoc and meshpoint mode should "prefer hw bssid slot 1-3". However,
> with that change the ibss or meshpoint mode will not send any beacon on
> the mt7622 wifi anymore. Devices were still able to exchange data but
> only if a bssid already existed. Two mt7622 devices will never be able
> to communicate.
> 
> This commits reverts the preferation of slot 1-3 for adhoc and
> meshpoint. Only NL80211_IFTYPE_STATION will still prefer slot 1-3.
> 
> Tested on Banana Pi R64.
> 
> Signed-off-by: Nick Hainke <vincent@systemli.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
> index dada43d6d879..51260a669d16 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
> @@ -135,8 +135,6 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
>  	int i;
>  
>  	switch (type) {
> -	case NL80211_IFTYPE_MESH_POINT:
> -	case NL80211_IFTYPE_ADHOC:
>  	case NL80211_IFTYPE_STATION:
>  		/* prefer hw bssid slot 1-3 */
>  		i = get_free_idx(mask, HW_BSSID_1, HW_BSSID_3);
> @@ -160,6 +158,8 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
>  			return HW_BSSID_0;
>  
>  		break;
> +	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_MESH_POINT:
>  	case NL80211_IFTYPE_MONITOR:
>  	case NL80211_IFTYPE_AP:
>  		/* ap uses hw bssid 0 and ext bssid */
> -- 
> 2.33.0
> 
> 
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
