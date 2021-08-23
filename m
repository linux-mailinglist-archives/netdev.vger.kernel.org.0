Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220D43F4392
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 05:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhHWDHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 23:07:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14313 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhHWDHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 23:07:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GtHG63xdQz899l;
        Mon, 23 Aug 2021 11:06:54 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 23 Aug 2021 11:07:00 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 23 Aug
 2021 11:07:00 +0800
Subject: Re: [PATCH V3 net-next 2/4] ethtool: extend coalesce setting uAPI
 with CQE mode
To:     Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <1629444920-25437-1-git-send-email-moyufeng@huawei.com>
 <1629444920-25437-3-git-send-email-moyufeng@huawei.com>
 <32fd0b32-e748-42d9-6468-b5b1393511e9@ti.com>
 <20210820152116.0741369a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <merez@codeaurora.org>,
        <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <moyufeng@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <659649ed-4697-e622-424d-0ab418c571a3@huawei.com>
Date:   Mon, 23 Aug 2021 11:06:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20210820152116.0741369a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/21 6:21, Jakub Kicinski wrote:
> On Fri, 20 Aug 2021 21:27:13 +0300 Grygorii Strashko wrote:
>> This is very big change which is not only mix two separate changes, but also looks
>> half-done. From one side you're adding HW feature supported by limited number of HW,
>> from another - changing most of net drivers to support it by generating mix of legacy
>> and new kernel_ethtool_coalesce parameters.
>>
>> There is also an issue - you do not account get/set_per_queue_coalesce() in any way.
> 
> ethtool's netlink interface does not support per queue coalescing.
> I don't think it's fair to require it as part of this series.
> 
>> Would it be possible to consider following, please?
>>
>> - move extack change out of this series
> 
> Why? To have to change all the drivers twice?
> 
>> - option (a)
>>    add new callbacks in ethtool_ops as set_coalesce_cqe/get_coalesce_cqe for CQE support.
>>    Only required drivers will need to be changed.
> 
> All the params are changed as one operation from user space's
> perspective. Having two ops would make it problematic for drivers 
> to fail the entire op without modifying half of the parameters in 
> a previous callback.
> 
>> - option (b)
>>    add struct ethtool_coalesce as first field of kernel_ethtool_coalesce
> 
> This ends up being more painful than passing an extra parameter 
> in my experience.
> 
>> struct kernel_ethtool_coalesce {
>> 	/* legacy */
>> 	struct ethtool_coalesce coal;
>>
>> 	/* new */
>> 	u8 use_cqe_mode_tx;
>> 	u8 use_cqe_mode_rx;
>> };
>>
>> --  then b.1
>>    drivers can be updated as
>>     static int set_coalesce(struct net_device *dev,
>>     			    struct kernel_ethtool_coalesce *kernel_coal)
>>     {
>> 	struct ethtool_coalesce *coal = &kernel_coal->coal;
>>     
>>     (which will clearly indicate migration to the new interface )
>>
>> -- then b.2
>>      add new callbacks in ethtool_ops as set_coalesce_ext/get_coalesce_ext (extended)
>>      which will accept struct kernel_ethtool_coalesce as parameter an allow drivers to migrate when needed
>>      (or as separate patch which will do only migration).
>>
>> Personally, I like "b.2".
> 
> These options were considered. None of the options is great to 
> be honest. Let's try the new params, I say. 
> .
> 

Yes, these have been considered in previous RFCs. For details, please refer to [1].

[1]https://lore.kernel.org/netdev/20210526165633.3f7982c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

