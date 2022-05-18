Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5152B4DC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbiERIco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiERIcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:32:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB384ECD5
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:32:41 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrF6i-0005rw-Ea; Wed, 18 May 2022 10:32:36 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrF6c-0002Y8-VS; Wed, 18 May 2022 10:32:30 +0200
Date:   Wed, 18 May 2022 10:32:30 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        neo_jou <neo_jou@realtek.com>
Subject: Re: [PATCH 06/10] rtw88: Add common USB chip support
Message-ID: <20220518083230.GR25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-7-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518082318.3898514-7-s.hauer@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:27:57 up 48 days, 20:57, 79 users,  load average: 0.07, 0.10,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 10:23:14AM +0200, Sascha Hauer wrote:
> Add the common bits and pieces to add USB support to the RTW88 driver.
> This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> itself is first written by Neo Jou.
> 
> Signed-off-by: neo_jou <neo_jou@realtek.com>
> Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
>  drivers/net/wireless/realtek/rtw88/Makefile |    2 +
>  drivers/net/wireless/realtek/rtw88/mac.c    |    3 +
>  drivers/net/wireless/realtek/rtw88/main.c   |    5 +
>  drivers/net/wireless/realtek/rtw88/main.h   |    4 +
>  drivers/net/wireless/realtek/rtw88/reg.h    |    1 +
>  drivers/net/wireless/realtek/rtw88/tx.h     |   31 +
>  drivers/net/wireless/realtek/rtw88/usb.c    | 1051 +++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/usb.h    |  109 ++
>  9 files changed, 1209 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> index e3d7cb6c12902..1624c5db69bac 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -16,6 +16,9 @@ config RTW88_CORE
>  config RTW88_PCI
>  	tristate
>  
> +config RTW88_USB
> +	tristate
> +
>  config RTW88_8822B
>  	tristate
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> index 834c66ec0af9e..9e095f8181483 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -45,4 +45,6 @@ obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
>  rtw88_8821ce-objs		:= rtw8821ce.o
>  
>  obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
> +obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
>  rtw88_pci-objs			:= pci.o
> +rtw88_usb-objs			:= usb.o
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index d1678aed9d9cb..19728c705eaa9 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -1032,6 +1032,9 @@ static int txdma_queue_mapping(struct rtw_dev *rtwdev)
>  	if (rtw_chip_wcpu_11ac(rtwdev))
>  		rtw_write32(rtwdev, REG_H2CQ_CSR, BIT_H2CQ_FULL);
>  
> +	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB)
> +		rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_ARBBW_EN);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 5afb8bef9696a..162fa432ce0d1 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1715,6 +1715,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
>  		rtwdev->hci.rpwm_addr = 0x03d9;
>  		rtwdev->hci.cpwm_addr = 0x03da;
>  		break;
> +	case RTW_HCI_TYPE_USB:
> +		rtwdev->hci.rpwm_addr = 0xfe58;
> +		rtwdev->hci.cpwm_addr = 0xfe57;
> +		break;
>  	default:
>  		rtw_err(rtwdev, "unsupported hci type\n");
>  		return -EINVAL;
> @@ -2105,6 +2109,7 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
>  	hw->wiphy->available_antennas_rx = hal->antenna_rx;
>  
>  	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
> +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
>  			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;

This change should be in a separate patch. I don't have an idea though
what it's good for anyway. Is this change desired for the PCI variants
as well or only for USB? Do we want to have this change at all?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
