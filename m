Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51A263A4BC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiK1JWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiK1JVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:21:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941F31571D;
        Mon, 28 Nov 2022 01:21:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E445AB80CB4;
        Mon, 28 Nov 2022 09:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BEFC433D6;
        Mon, 28 Nov 2022 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669627306;
        bh=SMcxKZiuICKO5Xo60+6v/dsm1MJeGWQRQxX6Iq8mnT8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Zl+I07p1A7NJAXcqB53dHyPNMujV5O6kRtnRpqFROBuODpCqFvBJRSajUwVViMmhp
         8GQdjE+8rNGyd+KUB5448+/yUpBuH5ZkMR5RZ7vtRk4R5AzBlhr45lmI9HnPbcXCfU
         nGXLQeiWY2LBIBACLpONxEttMcYcMueOUBEWbXe5D6ePSW+h8CZs8bvhgsv7CyfvUu
         vdBcCZvvy1zs0ubdjF8BiOFVLny+on/l6VCOyrXeLNwC1wguJdoB1N5Np3acDfMkla
         3WzFADIuqtmD28U9E8/J+mMp4nh8j6o0kIxxRp+Mi5eFCcgiri+ZQo8/es0JtQks9x
         VLB9JfaUFspXw==
Message-ID: <d20d3b73-38b4-fb06-2daa-125f446aeb44@kernel.org>
Date:   Mon, 28 Nov 2022 11:21:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 5/6] net: ethernet: ti: am65-cpsw: retain
 PORT_VLAN_REG after suspend/resume
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221123124835.18937-1-rogerq@kernel.org>
 <20221123124835.18937-6-rogerq@kernel.org> <Y4DBTbVxUpbJ5sEl@boxer>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y4DBTbVxUpbJ5sEl@boxer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2022 15:21, Maciej Fijalkowski wrote:
> On Wed, Nov 23, 2022 at 02:48:34PM +0200, Roger Quadros wrote:
>> During suspend resume the context of PORT_VLAN_REG is lost so
>> save it during suspend and restore it during resume for
>> host port and slave ports.
>>
>> Signed-off-by: Roger Quadros <rogerq@kernel.org>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> ---
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
>>  drivers/net/ethernet/ti/am65-cpsw-nuss.h | 4 ++++
>>  2 files changed, 11 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 0b59088e3728..f5357afde527 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -2875,7 +2875,9 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
>>  	struct am65_cpsw_port *port;
>>  	struct net_device *ndev;
>>  	int i, ret;
>> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);
> 
> Nit: I see that retrieving host pointer depends on getting the common
> pointer first from dev_get_drvdata(dev) so pure RCT is not possible to
> maintain here but nonetheless I would move this line just below the common
> pointer:
> 
> 	struct am65_cpsw_common *common = dev_get_drvdata(dev);
> 	struct am65_cpsw_host *host = am65_common_get_host(common);
> 	struct am65_cpsw_port *port;
> 	struct net_device *ndev;
> 	int i, ret;

OK.

> 
> Also I think plain 'host' for variable name is just fine, no need for _p
> suffix to indicate it is a pointer. in that case you should go with
> common_p etc.

host_p is the naming convention used throughout the driver.
Do think it is a good idea to change it at this one place?

> 
>>  
>> +	host_p->vid_context = readl(host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>>  	for (i = 0; i < common->port_num; i++) {
>>  		port = &common->ports[i];
>>  		ndev = port->ndev;
>> @@ -2883,6 +2885,7 @@ static int am65_cpsw_nuss_suspend(struct device *dev)
>>  		if (!ndev)
>>  			continue;
>>  
>> +		port->vid_context = readl(port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>>  		netif_device_detach(ndev);
>>  		if (netif_running(ndev)) {
>>  			rtnl_lock();
>> @@ -2909,6 +2912,7 @@ static int am65_cpsw_nuss_resume(struct device *dev)
>>  	struct am65_cpsw_port *port;
>>  	struct net_device *ndev;
>>  	int i, ret;
>> +	struct am65_cpsw_host *host_p = am65_common_get_host(common);
>>  
>>  	ret = am65_cpsw_nuss_init_tx_chns(common);
>>  	if (ret)
>> @@ -2941,8 +2945,11 @@ static int am65_cpsw_nuss_resume(struct device *dev)
>>  		}
>>  
>>  		netif_device_attach(ndev);
>> +		writel(port->vid_context, port->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>>  	}
>>  
>> +	writel(host_p->vid_context, host_p->port_base + AM65_CPSW_PORT_VLAN_REG_OFFSET);
>> +
>>  	return 0;
>>  }
>>  #endif /* CONFIG_PM_SLEEP */
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
>> index 2c9850fdfcb6..e95cc37a7286 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
>> @@ -55,12 +55,16 @@ struct am65_cpsw_port {
>>  	bool				rx_ts_enabled;
>>  	struct am65_cpsw_qos		qos;
>>  	struct devlink_port		devlink_port;
>> +	/* Only for suspend resume context */
>> +	u32				vid_context;
>>  };
>>  
>>  struct am65_cpsw_host {
>>  	struct am65_cpsw_common		*common;
>>  	void __iomem			*port_base;
>>  	void __iomem			*stat_base;
>> +	/* Only for suspend resume context */
>> +	u32				vid_context;
>>  };
>>  
>>  struct am65_cpsw_tx_chn {
>> -- 
>> 2.17.1
>>

--
cheers,
-roger
