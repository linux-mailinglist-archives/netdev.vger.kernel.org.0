Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3C54EDAF7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbiCaN7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiCaN67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:58:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD80216FAF;
        Thu, 31 Mar 2022 06:57:09 -0700 (PDT)
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KTlDv4TcFzgYH4;
        Thu, 31 Mar 2022 21:55:27 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 21:57:07 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 31 Mar
 2022 21:57:06 +0800
Subject: Re: [PATCH] net: phy: genphy_loopback: fix loopback failed when speed
 is unknown
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <o.rempel@pengutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <20220331114819.14929-1-huangguangbin2@huawei.com>
 <YkWdTpCsO8JhiSaT@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <130bb780-0dc1-3819-8f6d-f2daf4d9ece9@huawei.com>
Date:   Thu, 31 Mar 2022 21:57:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YkWdTpCsO8JhiSaT@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/31 20:23, Andrew Lunn wrote:
> On Thu, Mar 31, 2022 at 07:48:19PM +0800, Guangbin Huang wrote:
>> If phy link status is down because link partner goes down, the phy speed
>> will be updated to SPEED_UNKNOWN when autoneg on with general phy driver.
>> If test loopback in this case, the phy speed will be set to 10M. However,
>> the speed of mac may not be 10M, it causes loopback test failed.
>>
>> To fix this problem, if speed is SPEED_UNKNOWN, don't configure link speed.
> 
> I don't think this explanation is correct.
> 
> If speed is UNKNOWN, ctl is just going to have BMCR_LOOPBACK set. That
> is very similar to what you are doing. The code then waits for the
> link to establish. This is where i guess your problem is. Are you
> seeing ETIMEDOUT? Does the link not establish?
> 
> Thanks
> 	Andrew	
> .
> 
Hi Andrew
This problem is not timeout, I have print return value of phy_read_poll_timeout()
and it is 0.

In this case, as speed and duplex both are unknown, ctl is just set to 0x4000.
However, the follow code sets mask to ~0 for function phy_modify():
int genphy_loopback(struct phy_device *phydev, bool enable)
{
	if (enable) {
		...
		phy_modify(phydev, MII_BMCR, ~0, ctl);
		...
}
so all other bits of BMCR will be cleared and just set bit 14, I use phy trace to
prove that:

$ cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 923/923   #P:128
#
#                                _-----=> irqs-off/BH-disabled
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
   kworker/u257:2-694     [015] .....   209.263912: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
   kworker/u257:2-694     [015] .....   209.263951: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
   kworker/u257:2-694     [015] .....   209.263990: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
   kworker/u257:2-694     [015] .....   209.264028: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
   kworker/u257:2-694     [015] .....   209.264067: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x0000
          ethtool-1148    [007] .....   209.665693: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
          ethtool-1148    [007] .....   209.665706: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1840
          ethtool-1148    [007] .....   210.588139: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1840
          ethtool-1148    [007] .....   210.588152: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x1040
          ethtool-1148    [007] .....   210.615900: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x1040
          ethtool-1148    [007] .....   210.615912: mdio_access: mii-0000:bd:00.1 write phy:0x03 reg:0x00 val:0x4000 //here just set bit 14
          ethtool-1148    [007] .....   210.620952: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.625992: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.631034: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.636075: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.641116: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.646159: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.651215: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.656256: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.661296: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.666338: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x7989
          ethtool-1148    [007] .....   210.671378: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
          ethtool-1148    [007] .....   210.679016: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x4000
          ethtool-1148    [007] .....   210.679053: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
          ethtool-1148    [007] .....   210.679091: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
          ethtool-1148    [007] .....   210.679129: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x0000
          ethtool-1148    [007] .....   210.695902: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x00 val:0x4000
          ethtool-1148    [007] .....   210.695939: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x01 val:0x798d
          ethtool-1148    [007] .....   210.695977: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x09 val:0x0200
          ethtool-1148    [007] .....   210.696014: mdio_access: mii-0000:bd:00.1 read  phy:0x03 reg:0x0a val:0x0000

So phy speed will be set to 10M in this case, if previous speed of device before going
down is 10M, loopback test is pass. Only previous speed is 100M or 1000M, loopback test is failed.

Thanks
	Guangbin
.
