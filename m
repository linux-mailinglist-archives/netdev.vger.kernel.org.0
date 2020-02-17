Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C721615E8
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgBQPPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:15:50 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:43576 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgBQPPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:15:50 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01HFFTk5125091;
        Mon, 17 Feb 2020 09:15:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581952529;
        bh=sesL32PDsZi01y0X5NncQMWx/LULUnsHSmLX5Wya1Xc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gCgf3hT+IcPMAv4XKF0sDStZbR0mz80E4QENsSIj7d/a/S0T9abzOcR9XKl/l4VRP
         2SmDJfX6EVy8ENek08jsvgB0YRJuZdn2JrQ2R1I74ByocsVYcggHmzoqhPB3jhe/ry
         f8Pk6FCS1OW8+2L6kaPAZzzqZsr6mp6T8TUrhg6o=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01HFFTfv119247
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Feb 2020 09:15:29 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 17
 Feb 2020 09:15:28 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 17 Feb 2020 09:15:28 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01HFFSIB067034;
        Mon, 17 Feb 2020 09:15:28 -0600
Subject: Re: [PATCH v2 2/3] can: m_can: m_can_platform: Add support for
 enabling transceiver
To:     Faiz Abbas <faiz_abbas@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
 <20200217142836.23702-3-faiz_abbas@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <250f905a-33c3-dd17-15c9-e282299dd742@ti.com>
Date:   Mon, 17 Feb 2020 09:10:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200217142836.23702-3-faiz_abbas@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Faiz

On 2/17/20 8:28 AM, Faiz Abbas wrote:
> CAN transceivers on some boards have a standby line which can be
> toggled to enable/disable the transceiver. Model this as an optional
> fixed xceiver regulator.
>
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Acked-by: Sriram Dash <sriram.dash@samsung.com>
> ---
>   drivers/net/can/m_can/m_can_platform.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 38ea5e600fb8..719468fab507 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -6,6 +6,7 @@
>   // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
>   
>   #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>   
>   #include "m_can.h"
>   
> @@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
>   {
>   	struct m_can_classdev *mcan_class;
>   	struct m_can_plat_priv *priv;
> +	struct regulator *reg_xceiver;
>   	struct resource *res;
>   	void __iomem *addr;
>   	void __iomem *mram_addr;
> @@ -111,6 +113,10 @@ static int m_can_plat_probe(struct platform_device *pdev)
>   
>   	m_can_init_ram(mcan_class);
>   
> +	reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
> +	if (PTR_ERR(reg_xceiver) == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +

Where is this regulator enabled?

Shouldn't the regulator be managed by runtime PM as well?

Dan

