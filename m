Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A034E646C41
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLHJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHJt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:49:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C3161538;
        Thu,  8 Dec 2022 01:49:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69F91B82304;
        Thu,  8 Dec 2022 09:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C67C433C1;
        Thu,  8 Dec 2022 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670492994;
        bh=bpD04RVwtpt4W5MxFSD4KUm5MDq2FuF0OMSAp3Zzgzg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=U/TAaVQ3a/ZBc84jaCzqDi3A/+KbHr89SUE3XqtFzTHHHsnkggH91+aLHIo+ZASG0
         v0xEagWtcAOopKrzxKrdrROuJmdY1YQq/pdp6uJ8g+pc2/99U55tzK9DI/nnvImk22
         oTzGIitUvqchiAuc9UKkdu2Lc+DvxZF0dk+SFryX3juslyznkEn3BsgvUYauHcIqIZ
         9DhJjXT0oTtSs597C3nLyZ3gKg8cCJ8hfrsPx0wFsBVs44qDvSILngeVczUDW8446E
         IsLWbkVNFyetP0QKpre67iw3EmNrsi1SZVNSADMXkjJ9zZXCpmr25cBR+jN1bDsrEz
         Ae8ywyGfc5XXQ==
Message-ID: <034523fc-5ecd-87ea-c0b4-8c21705cc50d@kernel.org>
Date:   Thu, 8 Dec 2022 11:49:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, andrew@lunn.ch,
        edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221206094419.19478-1-rogerq@kernel.org>
 <20221206094419.19478-5-rogerq@kernel.org>
 <20221207202120.12bc7c33@kernel.org>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20221207202120.12bc7c33@kernel.org>
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



On 08/12/2022 06:21, Jakub Kicinski wrote:
> On Tue,  6 Dec 2022 11:44:17 +0200 Roger Quadros wrote:
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
>> +	if (reg) {
>> +		dev_err(common->dev, "soft RESET didn't complete\n");
>> +		return -ETIMEDOUT;
> 
> Doesn't this function leak power management references on almost all
> error paths? Not really related to this set, tho.

Oh yes it does. I'll send a separate fix.

cheers,
-roger
