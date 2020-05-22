Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCE21DEDA9
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgEVQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:50:44 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48284 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgEVQuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 12:50:44 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MGoe5h005468;
        Fri, 22 May 2020 11:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590166240;
        bh=HdIYz55354lSc/wkq+/VKrVzqonZyPgLG9fA4GqyAE4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=SrAk3VuHMmfAtcR+Ps3J+I+6TtWSs34K1OwdsPL+MiDf4BBPdTaH8gu2kbZJwAdx+
         gY99ALs0lMV5Iuurwtta4jt342fpt4DEig18OanLZJwKwrp9ORaYAypvFHhbIQfNm7
         kPa2JpTk6sTowvW38OBOZ6BIgUOcuu5M3Gi0vJFs=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04MGoe01130828
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 11:50:40 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 11:50:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 11:50:40 -0500
Received: from [10.250.48.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MGoegS102382;
        Fri, 22 May 2020 11:50:40 -0500
Subject: Re: [PATCH] net: ethernet: ti: cpsw: fix ASSERT_RTNL() warning during
 suspend
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <20200522163931.29905-1-grygorii.strashko@ti.com>
From:   Suman Anna <s-anna@ti.com>
Message-ID: <df01fb0e-940f-f14a-aba0-670f3b61d3f8@ti.com>
Date:   Fri, 22 May 2020 11:50:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522163931.29905-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 11:39 AM, Grygorii Strashko wrote:
> vlan_for_each() are required to be called with rtnl_lock taken, otherwise
> ASSERT_RTNL() warning will be triggered - which happens now during System
> resume from suspend:
>    cpsw_suspend()
>    |- cpsw_ndo_stop()
>      |- __hw_addr_ref_unsync_dev()
>        |- cpsw_purge_all_mc()
>           |- vlan_for_each()
>              |- ASSERT_RTNL();
> 
> Hence, fix it by surrounding cpsw_ndo_stop() by rtnl_lock/unlock() calls.
> 
> Fixes: 15180eca569b net: ethernet: ti: cpsw: fix vlan mcast

Format for this should be
Fixes: 15180eca569b ("net: ethernet: ti: cpsw: fix vlan mcast")

regards
Suman

> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index c2c5bf87da01..ffeb8633e530 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1753,11 +1753,15 @@ static int cpsw_suspend(struct device *dev)
>   	struct cpsw_common *cpsw = dev_get_drvdata(dev);
>   	int i;
>   
> +	rtnl_lock();
> +
>   	for (i = 0; i < cpsw->data.slaves; i++)
>   		if (cpsw->slaves[i].ndev)
>   			if (netif_running(cpsw->slaves[i].ndev))
>   				cpsw_ndo_stop(cpsw->slaves[i].ndev);
>   
> +	rtnl_unlock();
> +
>   	/* Select sleep pin state */
>   	pinctrl_pm_select_sleep_state(dev);
>   
> 

