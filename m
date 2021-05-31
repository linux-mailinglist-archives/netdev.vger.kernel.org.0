Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D853953A8
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhEaBZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:25:45 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3291 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhEaBZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:25:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Ftcrp3WBfz1BGCN;
        Mon, 31 May 2021 09:19:22 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 09:24:02 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 31 May
 2021 09:24:01 +0800
Subject: Re: [RFC V2 net-next 1/3] ethtool: extend coalesce setting uAPI with
 CQE mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
 <1622258536-55776-2-git-send-email-tanhuazhong@huawei.com>
 <20210529142355.17fb609d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <dbdfcac5-f772-1b73-7af8-af2340f21aea@huawei.com>
Date:   Mon, 31 May 2021 09:24:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210529142355.17fb609d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/5/30 5:23, Jakub Kicinski wrote:
> On Sat, 29 May 2021 11:22:14 +0800 Huazhong Tan wrote:
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index 25131df..8e8c6b3 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -937,6 +937,8 @@ Kernel response contents:
>>     ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>>     ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>>     ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
>>     ===========================================  ======  =======================
>>   
>>   Attributes are only included in reply if their value is not zero or the
>> @@ -975,6 +977,8 @@ Request contents:
>>     ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>>     ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>>     ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    timer reset in CQE, Tx
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    timer reset in CQE, Rx
>>     ===========================================  ======  =======================
>>   
>>   Request is rejected if it attributes declared as unsupported by driver (i.e.
> Did you provide the theory of operation for CQE vs EQE mode somewhere,
> as I requested?


the definition of enum dim_cq_period_mode in include/linux/dim.h has

below comment:

/**
  * enum dim_cq_period_mode - Modes for CQ period count
  *
  * @DIM_CQ_PERIOD_MODE_START_FROM_EQE: Start counting from EQE
  * @DIM_CQ_PERIOD_MODE_START_FROM_CQE: Start counting from CQE (implies 
timer reset)
  * @DIM_CQ_PERIOD_NUM_MODES: Number of modes
  */


is this comment suitable? and add reference in 
Documentation/networking/ethtool-netlink.rst to

the comment in dim.h.


>> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
>> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },
> Why not NLA_POLICY_MAX(NLA_U8, 1) ?


will fix it.


> Any chance you could split the patch into adding the new parameter
> to the callback and adding new attributes?


ok, will split it in the next version.


Thanks.


> .

