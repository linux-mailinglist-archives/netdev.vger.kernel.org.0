Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5036407D0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiLBNmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiLBNmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:42:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8A8CFE4C;
        Fri,  2 Dec 2022 05:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E2EB81FCA;
        Fri,  2 Dec 2022 13:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD144C433D6;
        Fri,  2 Dec 2022 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669988517;
        bh=pzle8rnmgQXaHVjnaJXfCwlu4IBOfaiPs7PsXR2hPHk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SMipvr9JGPt6fVkybdkUDUJNQ7NMtsZZsy5h13MW5mozjjfzFjkjxDv1dS7tmMTS8
         w5gqwhmLBzdKzUsfSy6rk/1LOK0YDbZwejXTvgSueyN/2ZWRdUwkjcTpp8pcYBZA0s
         IxJvHWIpixUg6w4Md875jGRCxPC1IFWEJOV6o2gmdUnLW05u8wTWtQOI+GFNkY5JyX
         8rTqjxs6riY3JZLP2fz0izbnr+rrGzWccZJlvI0q08xG1lmEJdJMlWFV4/EENkO0q6
         Y6+LDnFtW1brAd4TqJOJNOD0cL6UafYBR4PtDqydroCJs5lIL9jB8mSqs8fHKkdSq5
         O8P/pt+LBLzXQ==
Message-ID: <f1c0cd94-516f-de25-90c1-3c7d51f3f447@kernel.org>
Date:   Fri, 2 Dec 2022 15:41:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        maciej.fijalkowski@intel.com, kuba@kernel.org, edumazet@google.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221129133501.30659-1-rogerq@kernel.org>
 <20221129133501.30659-5-rogerq@kernel.org>
 <9fdc4e0eee7ead18c119b6bc3e93f7f73d2980cd.camel@redhat.com>
 <c41064a1-9da7-d848-6f9f-e1f3b722c063@kernel.org> <Y4jGBtWurJ4tmHOc@lunn.ch>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y4jGBtWurJ4tmHOc@lunn.ch>
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



On 01/12/2022 17:19, Andrew Lunn wrote:
> On Thu, Dec 01, 2022 at 01:44:28PM +0200, Roger Quadros wrote:
>> Hi,
>>
>> On 01/12/2022 13:40, Paolo Abeni wrote:
>>> On Tue, 2022-11-29 at 15:34 +0200, Roger Quadros wrote:
>>>> @@ -555,11 +556,26 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>>>>  	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>>>>  	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
>>>>  	int ret, i;
>>>> +	u32 reg;
>>>>  
>>>>  	ret = pm_runtime_resume_and_get(common->dev);
>>>>  	if (ret < 0)
>>>>  		return ret;
>>>>  
>>>> +	/* Idle MAC port */
>>>> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
>>>> +	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
>>>> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
>>>> +
>>>> +	/* soft reset MAC */
>>>> +	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
>>>> +	mdelay(1);
>>>> +	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
>>>> +	if (reg) {
>>>> +		dev_err(common->dev, "soft RESET didn't complete\n");
>>>
>>> I *think* Andrew was asking for dev_dbg() here, but let's see what he
>>> has to say :)
>>
>> In the earlier revision we were not exiting with error, so dev_dbg()
>> was more appropriate there.
>> In this revision we error out so I thought dev_err() was ok.
> 
> Yes, i would agree. It is fatal, so dev_err() is appropriate.
> 
> What is not shown here is the return value. I think it is -EBUSY? I'm
> wondering if -ETIMEDOUT is better?

Yes it is -EBUSY. -ETIMEDOUT is better though so I'll re-spin this series.

cheers,
-roger
