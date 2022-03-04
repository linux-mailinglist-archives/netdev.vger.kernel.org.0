Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C021F4CDE81
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiCDUJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiCDUHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:07:37 -0500
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Mar 2022 12:02:00 PST
Received: from mx.msync.work (mx.msync.work [IPv6:2001:41d0:d:357f:aaaa::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AA42067FF
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:02:00 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 02CEE1E078;
        Fri,  4 Mar 2022 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lexina.in; s=dkim;
        t=1646423574; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language:in-reply-to:references;
        bh=lKAg1aZ3/OVlbnHBQ2pMnRlOfyWJyfFmLorR+5Ap/IQ=;
        b=u4+p9YgsY4u3lL70tjKH6XhGIXH2yCrFY46fIuWJkAPggRctMKPAlLQpYm3qQFup4ynTL+
        ZOryPcFEz4vXCDX6kHGQYM9QWLDBu5SXF9dGYUVMz1IK7DFGmWNdQc0YrjUlNbtV8MsNXY
        k2UEtAbjNWrZ/qsyimEhAPSi5OWZoa0sj3OrRhDlSzofHdSyFE03XBBoLQ9weKNPQZ/tbU
        +nlVcMT/8GOU42lyEM7rQALoUSCp09YL+22l3ip5gQ+lpjZN8XN2h7obGYX0mizNgup75r
        ZYQJyfRBDdNkmD+wo0vDIS7rFKi5Gt6TcMeqUUHAB/whMIEiI31X4txyzDa0aw==
Message-ID: <962ae330-b2aa-c52d-5888-83b4fff74c44@lexina.in>
Date:   Fri, 4 Mar 2022 22:52:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net] net: phy: meson-gxl: fix interrupt handling in forced
 mode
Content-Language: ru
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org
References: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
From:   Vyacheslav <adeep@lexina.in>
In-Reply-To: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seems works for JetHub H1 (S905W with internal phy)

03.03.2022 10:54, Heiner Kallweit wrote:
> This PHY doesn't support a link-up interrupt source. If aneg is enabled
> we use the "aneg complete" interrupt for this purpose, but if aneg is
> disabled link-up isn't signaled currently.
> According to a vendor driver there's an additional "energy detect"
> interrupt source that can be used to signal link-up if aneg is disabled.
> We can safely ignore this interrupt source if aneg is enabled.
> 
> This patch was tested on a TX3 Mini TV box with S905W (even though
> boot message says it's a S905D).
> 
> This issue has been existing longer, but due to changes in phylib and
> the driver the patch applies only from the commit marked as fixed.
> 
> Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/net/phy/meson-gxl.c | 23 +++++++++++++----------
>   1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
> index 7e7904fee..c49062ad7 100644
> --- a/drivers/net/phy/meson-gxl.c
> +++ b/drivers/net/phy/meson-gxl.c
> @@ -30,8 +30,12 @@
>   #define  INTSRC_LINK_DOWN	BIT(4)
>   #define  INTSRC_REMOTE_FAULT	BIT(5)
>   #define  INTSRC_ANEG_COMPLETE	BIT(6)
> +#define  INTSRC_ENERGY_DETECT	BIT(7)
>   #define INTSRC_MASK	30
>   
> +#define INT_SOURCES (INTSRC_LINK_DOWN | INTSRC_ANEG_COMPLETE | \
> +		     INTSRC_ENERGY_DETECT)
> +
>   #define BANK_ANALOG_DSP		0
>   #define BANK_WOL		1
>   #define BANK_BIST		3
> @@ -200,7 +204,6 @@ static int meson_gxl_ack_interrupt(struct phy_device *phydev)
>   
>   static int meson_gxl_config_intr(struct phy_device *phydev)
>   {
> -	u16 val;
>   	int ret;
>   
>   	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> @@ -209,16 +212,9 @@ static int meson_gxl_config_intr(struct phy_device *phydev)
>   		if (ret)
>   			return ret;
>   
> -		val = INTSRC_ANEG_PR
> -			| INTSRC_PARALLEL_FAULT
> -			| INTSRC_ANEG_LP_ACK
> -			| INTSRC_LINK_DOWN
> -			| INTSRC_REMOTE_FAULT
> -			| INTSRC_ANEG_COMPLETE;
> -		ret = phy_write(phydev, INTSRC_MASK, val);
> +		ret = phy_write(phydev, INTSRC_MASK, INT_SOURCES);
>   	} else {
> -		val = 0;
> -		ret = phy_write(phydev, INTSRC_MASK, val);
> +		ret = phy_write(phydev, INTSRC_MASK, 0);
>   
>   		/* Ack any pending IRQ */
>   		ret = meson_gxl_ack_interrupt(phydev);
> @@ -237,9 +233,16 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
>   		return IRQ_NONE;
>   	}
>   
> +	irq_status &= INT_SOURCES;
> +
>   	if (irq_status == 0)
>   		return IRQ_NONE;
>   
> +	/* Aneg-complete interrupt is used for link-up detection */
> +	if (phydev->autoneg == AUTONEG_ENABLE &&
> +	    irq_status == INTSRC_ENERGY_DETECT)
> +		return IRQ_HANDLED;
> +
>   	phy_trigger_machine(phydev);
>   
>   	return IRQ_HANDLED;

-- 
Vyacheslav Bocharov
