Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C004641328
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 03:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiLCCOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 21:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiLCCOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 21:14:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77CCD293A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:14:46 -0800 (PST)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NPCzX5rB5zRpcQ;
        Sat,  3 Dec 2022 10:14:00 +0800 (CST)
Received: from [10.174.179.163] (10.174.179.163) by
 kwepemi500024.china.huawei.com (7.221.188.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 3 Dec 2022 10:14:44 +0800
Message-ID: <3974847f-1098-5add-4782-c952e626448c@huawei.com>
Date:   Sat, 3 Dec 2022 10:14:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH net v3] net: mdiobus: fix double put fwnode in the error
 path
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, <netdev@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ioana.ciornei@nxp.com>,
        <calvin.johnson@oss.nxp.com>, <grant.likely@arm.com>
References: <20221202051833.699945-1-yangyingliang@huawei.com>
From:   Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20221202051833.699945-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.163]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500024.china.huawei.com (7.221.188.100)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/2 13:18, Yang Yingliang wrote:
> If phy_device_register() or fwnode_mdiobus_phy_device_register()
> fail, phy_device_free() is called, the device refcount is decreased
> to 0, then fwnode_handle_put() will be called in phy_device_release(),
> but in the error path, fwnode_handle_put() has already been called,
> so set fwnode to NULL after fwnode_handle_put() in the error path to
> avoid double put.
>
> Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
> Reported-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2 -> v3:
>    set fwnode to NULL before calling fwnode_handle_put()
>
> v1 -> v2:
>    Don't remove fwnode_handle_put() in the error path,
>    set fwnode to NULL avoid double put.
> ---
>   drivers/net/mdio/fwnode_mdio.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index eb344f6d4a7b..b782c35c4ac1 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -98,6 +98,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>   	 */
>   	rc = phy_device_register(phy);
>   	if (rc) {
> +		device_set_node(&phy->mdio.dev, NULL);
>   		fwnode_handle_put(child);
>   		return rc;
>   	}
> @@ -153,7 +154,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>   		/* All data is now stored in the phy struct, so register it */
>   		rc = phy_device_register(phy);
>   		if (rc) {
> -			fwnode_handle_put(phy->mdio.dev.fwnode);
> +			phy->mdio.dev.fwnode = NULL;
> +			fwnode_handle_put(child);
>   			goto clean_phy;
>   		}
>   	} else if (is_of_node(child)) {

Reviewed-by: Zeng Heng <zengheng4@huawei.com>

Tested-by: Zeng Heng <zengheng4@huawei.com>

