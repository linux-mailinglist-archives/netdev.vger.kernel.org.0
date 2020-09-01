Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D3C259E00
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgIASUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:20:50 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43950 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgIASUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:32 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 081IKM9T129956;
        Tue, 1 Sep 2020 13:20:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598984422;
        bh=D1SwdTHk6TLH9N6r+z4UmBhX+znpYKWwPBdkI5tVGRY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=XKlSEu9fB6/7Pxl68K7I2Jh31em0qGm5bimWKipsemp52IHk+c48KPvzYLxI0ymUl
         walf+TD1UCPJlB4d/vZNSJK5HG6vfIXE7CKatwWWGU6Io8omqhpa++7+9Xh7GsK00k
         MWRC9cj8JWGQjdo0vy8/yKCBdX2T6eFEkX0KTGQg=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 081IKMCN076464
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Sep 2020 13:20:22 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 1 Sep
 2020 13:20:22 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 1 Sep 2020 13:20:22 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081IKLH4004188;
        Tue, 1 Sep 2020 13:20:21 -0500
Subject: Re: [PATCH] can: m_can_platform: don't call m_can_class_suspend in
 runtime suspend
To:     Lucas Stach <l.stach@pengutronix.de>,
        Sriram Dash <sriram.dash@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, <kernel@pengutronix.de>,
        <patchwork-lst@pengutronix.de>
References: <20200811081545.19921-1-l.stach@pengutronix.de>
 <20200811081545.19921-2-l.stach@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <342496c0-4d87-3877-5d75-023c586d7076@ti.com>
Date:   Tue, 1 Sep 2020 13:20:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811081545.19921-2-l.stach@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lucase

On 8/11/20 3:15 AM, Lucas Stach wrote:
> 0704c5743694 (can: m_can_platform: remove unnecessary m_can_class_resume()
> call) removed the m_can_class_resume() call in the runtime resume path
> to get rid of a infinite recursion, so the runtime resume now only handles
> the device clocks. Unfortunately it did not remove the complementary
> m_can_class_suspend() call in the runtime suspend function, so those paths
> are now unbalanced, which causes the pinctrl state to get stuck on the
> "sleep" state, which breaks all CAN functionality on SoCs where this state
> is defined. Remove the m_can_class_suspend() call to fix this.
>
> Fixes: 0704c5743694 (can: m_can_platform: remove unnecessary
>                       m_can_class_resume() call)

Not sure about this wrap around for the fixes in the commit msg.

Otherwise

Acked-by: Dan Murphy <dmurphy@ti.com>

> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>   drivers/net/can/m_can/m_can_platform.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 38ea5e600fb8..e6d0cb9ee02f 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -144,8 +144,6 @@ static int __maybe_unused m_can_runtime_suspend(struct device *dev)
>   	struct net_device *ndev = dev_get_drvdata(dev);
>   	struct m_can_classdev *mcan_class = netdev_priv(ndev);
>   
> -	m_can_class_suspend(dev);
> -
>   	clk_disable_unprepare(mcan_class->cclk);
>   	clk_disable_unprepare(mcan_class->hclk);
>   
