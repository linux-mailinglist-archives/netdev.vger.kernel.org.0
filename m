Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45D263855F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiKYImQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKYImP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:42:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C8623EAC;
        Fri, 25 Nov 2022 00:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF870B8297E;
        Fri, 25 Nov 2022 08:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA784C433D6;
        Fri, 25 Nov 2022 08:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669365728;
        bh=wNK5p2ICZvmDUo5ht1Bd/UZayoyWfUcZHgC5WWokmFc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JjgMYWb2d03U7t8XE3LAWDfXT3leoe5w1RvlMgUox4xqkUB5pYaUf+dmSrPiJwuh6
         ddNJWtrf2mI/zL+KrxLS9nrEKgkSejVshTEL6T8GPeS770FQ3Am01t0g7t2Aky7puP
         R/zUT18zrtFZghuodvIcp/dvzPcHmmjIXmnuGMZ2ZhQbO/UuBYyMn7lqWwfNxy1Q4y
         cGWC+W8cc2y9VuzcICxd2FNMNzDuNxwQifa7Y9J0o2zTkXAQHyi9Px3A3dkvfkuDev
         kB6cM/hAOyMsojHp07cHF6LaIHHAfFQ4WkuBWGS4mcQDzVYplHZxFAllWxJP38VHqJ
         3nE7yzVpV59Ag==
Message-ID: <6dc36b74-6982-7fcf-a396-8977f1146c05@kernel.org>
Date:   Fri, 25 Nov 2022 10:41:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221123124835.18937-1-rogerq@kernel.org>
 <20221123124835.18937-5-rogerq@kernel.org> <Y35bahTL2cMgXM1F@lunn.ch>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y35bahTL2cMgXM1F@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2022 19:42, Andrew Lunn wrote:
>> +static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common);
>> +
> 
> Please move the code around so you don't need this. Ideally as a patch
> which only does the move. It is then trivial to review.

OK.

> 
>>  static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
>>  				      const u8 *dev_addr)
>>  {
>> @@ -555,11 +558,24 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>>  	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>>  	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
>>  	int ret, i;
>> +	u32 reg;
>>  
>>  	ret = pm_runtime_resume_and_get(common->dev);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> +	/* Idle MAC port */
>> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
>> +	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
>> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
>> +
>> +	/* soft reset MAC */
>> +	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
>> +	mdelay(1);
>> +	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
>> +	if (reg)
>> +		dev_info(common->dev, "mac reset not yet done\n");
> 
> Should that be dev_info()? dev_dbg()

Do you think we should error out here as this might indicate some
hardware malfunction and it is unlikely to work?
In that case dev_err() seems more appropriate?

> 
>        Andrew

cheers,
-roger
