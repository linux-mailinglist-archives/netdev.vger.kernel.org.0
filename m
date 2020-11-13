Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D2F2B1451
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKMCez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:34:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7186 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgKMCez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:34:55 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CXMxY36znz15Vt3;
        Fri, 13 Nov 2020 10:34:41 +0800 (CST)
Received: from [10.174.177.230] (10.174.177.230) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 13 Nov 2020 10:34:46 +0800
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: add missed
 clk_disable_unprepare() in gswip_gphy_fw_load()
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <hauke@hauke-m.de>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1605179495-818-1-git-send-email-zhangchangzhong@huawei.com>
 <20201112124110.yhquvw2cptvh2oii@skbuf>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <04b3adaa-b385-3077-84ef-e5f66f22ed9e@huawei.com>
Date:   Fri, 13 Nov 2020 10:34:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20201112124110.yhquvw2cptvh2oii@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.230]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/12 20:41, Vladimir Oltean wrote:
> 
> gswip_gphy_fw_list
> -> gswip_gphy_fw_probe
>    -> gswip_gphy_fw_load
>       -> clk_prepare_enable
>       -> then fails
> 
> Then gswip_gphy_fw_list does this:
> 	for_each_available_child_of_node(gphy_fw_list_np, gphy_fw_np) {
> 		err = gswip_gphy_fw_probe(priv, &priv->gphy_fw[i],
> 					  gphy_fw_np, i);
> 		if (err)
> 			goto remove_gphy;
> 		i++;
> 	}
> 
> 	return 0;
> 
> remove_gphy:
> 	for (i = 0; i < priv->num_gphy_fw; i++)
> 		gswip_gphy_fw_remove(priv, &priv->gphy_fw[i]);
> 
> 
> Then gswip_gphy_fw_remove does this:
> gswip_gphy_fw_remove
> -> clk_disable_unprepare
> 
> What's wrong with this?
> .
> 
Thanks for reminding, I got it wrong.
