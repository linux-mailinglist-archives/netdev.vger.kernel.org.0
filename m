Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6815751B6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbiGNPWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbiGNPWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:22:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E7B5F129
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:22:34 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1oC0fO-0004Zv-2k; Thu, 14 Jul 2022 17:22:14 +0200
Message-ID: <efa997a0-f1a1-c09f-801c-80617e2f51dc@pengutronix.de>
Date:   Thu, 14 Jul 2022 17:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] wifi: brcmfmac: support brcm,ccode-map-trivial DT
 property
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20220711123005.3055300-1-alvin@pqrs.dk>
 <20220711123005.3055300-3-alvin@pqrs.dk>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220711123005.3055300-3-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.07.22 14:30, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Commit a21bf90e927f ("brcmfmac: use ISO3166 country code and 0 rev as
> fallback on some devices") introduced a fallback mechanism whereby a
> trivial mapping from ISO3166 country codes to firmware country code and
> revision is used on some devices. This fallback operates on the device
> level, so it is enabled only for certain supported chipsets.
> 
> In general though, the firmware country codes are determined by the CLM
> blob, which is board-specific and may vary despite the underlying
> chipset being the same.
> 
> The aforementioned commit is actually a refinement of a previous commit
> that was reverted in commit 151a7c12c4fc ("Revert "brcmfmac: use ISO3166
> country code and 0 rev as fallback"") due to regressions with a BCM4359
> device. The refinement restricted the fallback mechanism to specific
> chipsets such as the BCM4345.
> 
> We use a chipset - CYW88359 - that the driver identifies as a BCM4359
> too. But in our case, the CLM blob uses ISO3166 country codes
> internally, and all with revision 0. So the trivial mapping is exactly
> what is needed in order for the driver to sync the kernel regulatory
> domain to the firmware. This is just a matter of how the CLM blob was
> prepared by the hardware vendor. The same could hold for other boards
> too.
> 
> Although the brcm,ccode-map device tree property is useful for cases
> where the mapping is more complex, the trivial case invites a much
> simpler specification. This patch adds support for parsing the
> brcm,ccode-map-trivial device tree property. Subordinate to the more
> specific brcm,ccode-map property, this new proprety simply informs the
> driver that the fallback method should be used in every case.
> 
> In the absence of the new property in the device tree, expect no
> functional change.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c       | 6 ++++++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 3ae6779fe153..db45da33adfd 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -7481,6 +7481,9 @@ int brcmf_cfg80211_wait_vif_event(struct brcmf_cfg80211_info *cfg,
>  
>  static bool brmcf_use_iso3166_ccode_fallback(struct brcmf_pub *drvr)
>  {
> +	if (drvr->settings->trivial_ccode_map)
> +		return true;
> +
>  	switch (drvr->bus_if->chip) {
>  	case BRCM_CC_4345_CHIP_ID:
>  	case BRCM_CC_43602_CHIP_ID:
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index 15accc88d5c0..fe717cce5d55 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -38,6 +38,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
>   * @fcmode: FWS flow control.
>   * @roamoff: Firmware roaming off?
>   * @ignore_probe_fail: Ignore probe failure.
> + * @trivial_ccode_map: Assume firmware uses ISO3166 country codes with rev 0
>   * @country_codes: If available, pointer to struct for translating country codes
>   * @bus: Bus specific platform data. Only SDIO at the mmoment.
>   */
> @@ -48,6 +49,7 @@ struct brcmf_mp_device {
>  	bool		roamoff;
>  	bool		iapp;
>  	bool		ignore_probe_fail;
> +	bool		trivial_ccode_map;
>  	struct brcmfmac_pd_cc *country_codes;
>  	const char	*board_type;
>  	unsigned char	mac[ETH_ALEN];
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index 083ac58f466d..1add942462f8 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -24,6 +24,12 @@ static int brcmf_of_get_country_codes(struct device *dev,
>  
>  	count = of_property_count_strings(np, "brcm,ccode-map");
>  	if (count < 0) {
> +		/* If no explicit country code map is specified, check whether
> +		 * the trivial map should be used.
> +		 */
> +		settings->trivial_ccode_map =
> +			of_property_read_bool(np, "brcm,ccode-map-trivial");
> +
>  		/* The property is optional, so return success if it doesn't
>  		 * exist. Otherwise propagate the error code.
>  		 */


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
