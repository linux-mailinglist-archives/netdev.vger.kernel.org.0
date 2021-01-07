Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2472ECE84
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbhAGLSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:18:20 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1123 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbhAGLSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:18:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff6edd30001>; Thu, 07 Jan 2021 03:17:39 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan 2021 11:17:16
 +0000
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-4-olteanv@gmail.com>
 <20210107103835.GA1102653@shredder.lan>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Kurt Kanzenbach" <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "Woojung Huh" <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "Landen Chao" <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        "Taras Chornyi" <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Ioana Ciornei" <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 03/11] net: switchdev: remove the
 transaction structure from port object notifiers
In-Reply-To: <20210107103835.GA1102653@shredder.lan>
Date:   Thu, 7 Jan 2021 12:17:12 +0100
Message-ID: <87a6tluhc7.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610018260; bh=m+/Gzvr2q/qWMscrviEkq83SkX8jN7GdMETpdFs4gAU=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=HiAeqcxHTyzA/leN9oHHkRtHnzh3x3/Kx1uQ0Szo0oWezqbE8+qi0YsHpGjBMCuRK
         NQlxFzEQl9w8p100RcNGAvdxRn5ht15VmEk+F4M9p58qAYnpyKVwZ/MtVKv7mWb3vR
         PR/5Y1n3qBpMb/bTH7XMURte8PJ1qZgMkHOf0UqKpc6P/FgY6NEZnw+rSu86bGoDBI
         BWrx6+YvCvetFKrxmCZCvjeDcGE6w2rghSDQUaJm/v5IDnNno47PrDkhv3AtnRs+1Y
         UorNZ15diMpdo25hIggtKoxGF1VqlTfD7gqbt9fABDvGuEUZzNRvYb3AysQh6orC9F
         G6vvfT1unlDhw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@idosch.org> writes:

> +Petr
>
> On Thu, Jan 07, 2021 at 01:17:20AM +0200, Vladimir Oltean wrote:
>>  static int mlxsw_sp_port_obj_add(struct net_device *dev,
>>  				 const struct switchdev_obj *obj,
>> -				 struct switchdev_trans *trans,
>>  				 struct netlink_ext_ack *extack)
>>  {
>>  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
>>  	const struct switchdev_obj_port_vlan *vlan;
>> +	struct switchdev_trans trans;
>>  	int err = 0;
>>  
>>  	switch (obj->id) {
>>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>>  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
>> -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
>> +
>
> Got the regression results. The call to mlxsw_sp_span_respin() should be
> placed here because it needs to be triggered regardless of the return
> value of mlxsw_sp_port_vlans_add().

Agreed, the new code differs in that respin is not called on error path.
