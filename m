Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3263B4F810C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiDGN4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiDGN4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:56:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9ED14B017;
        Thu,  7 Apr 2022 06:54:46 -0700 (PDT)
Received: from kwepemi100019.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KZ2rq2MCtzgYPC;
        Thu,  7 Apr 2022 21:52:59 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100019.china.huawei.com (7.221.188.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Apr 2022 21:54:44 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 7 Apr
 2022 21:54:44 +0800
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when speed
 is unknown
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch> <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
 <YkW6J9rM6O/cb/lv@lunn.ch> <20220401064006.GB4449@pengutronix.de>
 <YkbsraBQ5ynYG9wz@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <d42ae21a-6136-5340-6851-e3108759937a@huawei.com>
Date:   Thu, 7 Apr 2022 21:54:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YkbsraBQ5ynYG9wz@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/1 20:14, Andrew Lunn wrote:
>>> O.K. So it should be set into 10M half duplex. But why does this cause
>>> it not to loopback packets? Does the PHY you are using not actually
>>> support 10 Half? Why does it need to be the same speed as when the
>>> link was up? And why does it actually set LSTATUS indicating there is
>>> link?
>>>
>>> Is this a generic problem, all PHYs are like this, or is this specific
>>> to the PHY you are using? Maybe this PHY needs its own loopback
>>> function because it does something odd?
>>
>> It looks for me like attempt to fix loopback test for setup without active
>> link partner. Correct?
> 
> You should not need a link partner for loopback to work. This is local
> loopback. The PHY is also saying it has link, if the LSTATUS bit is
> set. So i don't see why previous speed is relevant hear. This seems to
> me to be an issue for this particular PHY.
> 
> What i don't like about this patch is that it is not deterministic
> what mode the PHY will end up in if speed is unknown. Without the
> patch, it is 10Mbps, which is historically a sensible default.
> 
> If this PHY has never had link, what speed does it use? Does it still
> work in that case?
> 
>     Andrew
> .
> 
Hi Andrew,
The PHY we test is RTL8211F, it supports 10 half. This problem actually is,
our board has MAC connected with PHY, when loopback test, packet flow is
MAC->PHY->MAC, it needs speed of MAC and PHY should be same when they work.

If PHY speed is unknown when PHY goes down, we will not set MAC speed in
adjust_link interface. In this case, we hope that PHY speed should not be
changed, as the old code of function genphy_loopback() before patch
"net: phy: genphy_loopback: add link speed configuration".

If PHY has never link, MAC speed has never be set in adjust_link interface,
yeah, in this case, MAC and PHY may has different speed, and they can not work.
I think we can accept this situation.

I think it is general problem if there is MAC connected with PHY.
