Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D453C7059
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhGMMhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:37:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:10478 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236230AbhGMMhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:37:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPKjn2RcBzcbkr;
        Tue, 13 Jul 2021 20:30:53 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 20:34:10 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Jul 2021 20:34:09 +0800
Subject: Re: [PATCH net-next 1/9] devlink: add documentation for hns3 driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1626053698-46849-1-git-send-email-huangguangbin2@huawei.com>
 <1626053698-46849-2-git-send-email-huangguangbin2@huawei.com>
 <20210712113243.2d786fe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <09d3972e-20d9-095e-ead3-b3ed7fcf2767@huawei.com>
Date:   Tue, 13 Jul 2021 20:34:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210712113243.2d786fe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/13 2:32, Jakub Kicinski wrote:
> On Mon, 12 Jul 2021 09:34:50 +0800 Guangbin Huang wrote:
>> +Parameters
>> +==========
>> +
>> +The ``hns3`` driver implements the following driver-specific
>> +parameters.
>> +
>> +.. list-table:: Driver-specific parameters implemented
>> +   :widths: 10 10 10 70
>> +
>> +   * - Name
>> +     - Type
>> +     - Mode
>> +     - Description
>> +   * - ``rx_buf_len``
>> +     - U32
>> +     - driverinit
>> +     - Set rx BD buffer size.
>> +       * Now only support setting 2048 and 4096.
> 
> Can you elaborate further? If I was a user reading this I'd still have
> little confidence what this does. Does it change the size of each
> buffer put on the Rx ring between 2k and 4k? Why is that a devlink
> feature, we configure rings via ethtool.
> 
Yes, we can add more detailed descriptions about this feature and tx_buf_size
in V2. This devlink feature is to change the buffer size of each BD of Rx ring
between 2KB and 4KB.

Now ethtool -G paramter supports setting some ring configurations such as
queue depth and so on，but not supports setting rx BD buffer size. And
devlink can support this function.

For another thing, setting rx BD buffer size needs to reload resource
pool(for resource pool details, see the link: [1]) to take effect, so
even if ethtool support this function, it still needs next reload to
take effect. Now devlink supports reload operation(patch 6/9), so we can
set rx BD buffer size via devlink, then do devlink reload operation to
make it take effect.

To sum up, we choose devlink to set rx BD buffer size.

>> +   * - ``tx_buf_size``
>> +     - U32
>> +     - driverinit
>> +     - Set tx spare buf size.
>> +
>> +       * The size is setted for tx bounce feature.
> 
> ... and what is the tx bounce feature?
> .
> 
Tx bounce buffer feature is used for small size packet or frag. It adds a queue
based tx shared bounce buffer to memcpy the small packet when the len of xmitted
skb is below tx_copybreak(value to distinguish small size and normal size), and
reduce the overhead of dma map and unmap when IOMMU is on. For more details, see
link: [2], this devlink feature is setting tx bounce buffer size for it.


1.  https://lore.kernel.org/patchwork/cover/816549/
2.  https://patchwork.kernel.org/project/netdevbpf/patch/1623825377-41948-4-git-send-email-huangguangbin2@huawei.com/
