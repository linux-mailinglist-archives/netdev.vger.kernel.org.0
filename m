Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFED23E5A0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 03:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHGByw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 21:54:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgHGByw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 21:54:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C39C0F8C14D03B22675A;
        Fri,  7 Aug 2020 09:54:49 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 7 Aug 2020
 09:54:47 +0800
Subject: Re: [PATCH net] net: qcom/emac: Fix missing clk_disable_unprepare()
 in error path of emac_probe
To:     Timur Tabi <timur@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200806140647.43099-1-wanghai38@huawei.com>
 <87f41175-689e-f198-aaf6-9b9f04449ed8@kernel.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <df1bad2e-2a6a-ff70-9b91-f18df20aaec8@huawei.com>
Date:   Fri, 7 Aug 2020 09:54:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87f41175-689e-f198-aaf6-9b9f04449ed8@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/8/6 22:23, Timur Tabi 写道:
> On 8/6/20 9:06 AM, Wang Hai wrote:
>> In emac_clks_phase1_init() of emac_probe(), there may be a situation
>> in which some clk_prepare_enable() succeed and others fail.
>> If emac_clks_phase1_init() fails, goto err_undo_clocks to clean up
>> the clk that was successfully clk_prepare_enable().
>
> Good catch, however, I think the proper fix is to fix this in 
> emac_clks_phase1_init(), so that if some clocks fail, the other clocks 
> are cleaned up and then an error is returned.
>
> .
>
Thanks for your suggestion. May I fix it like this?

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c 
b/drivers/net/ethernet/qualcomm/emac/emac.c
index 7520c02eec12..7977ad02a7c6 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -474,13 +474,25 @@ static int emac_clks_phase1_init(struct 
platform_device *pdev,

         ret = clk_prepare_enable(adpt->clk[EMAC_CLK_CFG_AHB]);
         if (ret)
-               return ret;
+               goto disable_clk_axi;

         ret = clk_set_rate(adpt->clk[EMAC_CLK_HIGH_SPEED], 19200000);
         if (ret)
-               return ret;
+               goto disable_clk_cfg_ahb;

-       return clk_prepare_enable(adpt->clk[EMAC_CLK_HIGH_SPEED]);
+       ret = clk_prepare_enable(adpt->clk[EMAC_CLK_HIGH_SPEED]);
+       if (ret)
+               goto disable_clk_cfg_ahb;
+
+       return 0;
+
+disable_clk_cfg_ahb:
+       clk_disable_unprepare(adpt->clk[EMAC_CLK_CFG_AHB]);
+disable_clk_axi:
+       clk_disable_unprepare(adpt->clk[EMAC_CLK_AXI]);
+
+       return ret;
  }


