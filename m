Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E59EC978
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKAUQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:16:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:41122 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAUQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 16:16:48 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1KGdvH007674;
        Fri, 1 Nov 2019 15:16:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572639399;
        bh=XckIMX9TOLpRUdwAePmoGCJdYT+5toAsS7w8nr/Ee6g=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=KR7VIPH0NTgTtD80kS210fYpguS9kMl4YdKPGmpZbtSTuuhRX2+XlvkcwHp+D+ix3
         XODUzzhmCjJUQ+xaiMe9D2M0m13QBd8GqNq21rOee59yOBZVyzbSJECZgT9FokhvQk
         z93jEJIge/VQlVzsVtrT5h2rNa+ES67pz0TZSScA=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1KGdwk109200
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 15:16:39 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 15:16:25 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 15:16:25 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1KGZS0093218;
        Fri, 1 Nov 2019 15:16:36 -0500
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029122422.GL15259@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <d87c72e1-cb91-04a2-c881-0d8eec4671e2@ti.com>
Date:   Fri, 1 Nov 2019 22:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029122422.GL15259@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 29/10/2019 14:24, Andrew Lunn wrote:
>>   config TI_CPTS
>>   	bool "TI Common Platform Time Sync (CPTS) Support"
>> -	depends on TI_CPSW || TI_KEYSTONE_NETCP || COMPILE_TEST
>> +	depends on TI_CPSW || TI_KEYSTONE_NETCP || COMPILE_TEST || TI_CPSW_SWITCHDEV
> 
> nit picking, but COMPILE_TEST is generally last on the line.
> 
>> +/**
>> + * cpsw_set_mc - adds multicast entry to the table if it's not added or deletes
>> + * if it's not deleted
>> + * @ndev: device to sync
>> + * @addr: address to be added or deleted
>> + * @vid: vlan id, if vid < 0 set/unset address for real device
>> + * @add: add address if the flag is set or remove otherwise
>> + */
>> +static int cpsw_set_mc(struct net_device *ndev, const u8 *addr,
>> +		       int vid, int add)
>> +{
>> +	struct cpsw_priv *priv = netdev_priv(ndev);
>> +	struct cpsw_common *cpsw = priv->cpsw;
>> +	int slave_no = cpsw_slave_index(cpsw, priv);
>> +	int mask, flags, ret;
> 
> David will complain about reverse Christmas tree. You need to move
> some of the assignments into the body of the function. This problems
> happens a few times in the code.
> 
>> +static int cpsw_set_pauseparam(struct net_device *ndev,
>> +			       struct ethtool_pauseparam *pause)
>> +{
>> +	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
>> +	struct cpsw_priv *priv = netdev_priv(ndev);
>> +
>> +	priv->rx_pause = pause->rx_pause ? true : false;
>> +	priv->tx_pause = pause->tx_pause ? true : false;
>> +
>> +	return phy_restart_aneg(cpsw->slaves[priv->emac_port - 1].phy);
>> +}
> 
> You should look at the value of pause.autoneg.

I'll use phy_validate_pause() and phy_set_asym_pause() here,
and fix other comments.

> 
>> +static const struct devlink_ops cpsw_devlink_ops;
> 
> It would be nice to avoid this forward declaration.

It's not declaration, it's definition of devlink_ops without any standard callbacks implemented.

> 
>> +static const struct devlink_param cpsw_devlink_params[] = {
>> +	DEVLINK_PARAM_DRIVER(CPSW_DL_PARAM_ALE_BYPASS,
>> +			     "ale_bypass", DEVLINK_PARAM_TYPE_BOOL,
>> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
>> +			     cpsw_dl_ale_ctrl_get, cpsw_dl_ale_ctrl_set, NULL),
>> +};
> 
> Is this documented?

In patch 9. But I'll update it and add standard devlink parameter definition, like:

ale_bypass	[DEVICE, DRIVER-SPECIFIC]
		Allows to enable ALE_CONTROL(4).BYPASS mode for debug purposes
		Type: bool
		Configuration mode: runtime

Thank you for review.

-- 
Best regards,
grygorii
