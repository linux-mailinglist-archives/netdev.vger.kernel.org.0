Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD81A60ED27
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 02:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiJ0Atz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 20:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiJ0Aty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 20:49:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12512AD0;
        Wed, 26 Oct 2022 17:49:51 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MyRnW0jxbzpW1n;
        Thu, 27 Oct 2022 08:46:23 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 08:49:49 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 08:49:48 +0800
Subject: Re: [PATCH V7 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
To:     Gal Pressman <gal@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <linux-s390@vger.kernel.org>
References: <20211118121245.49842-1-huangguangbin2@huawei.com>
 <40d6352e-8c6b-404f-8b6a-df1816239ab0@nvidia.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4466b159-7476-f833-ec22-ee234b70110b@huawei.com>
Date:   Thu, 27 Oct 2022 08:49:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <40d6352e-8c6b-404f-8b6a-df1816239ab0@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/26 22:00, Gal Pressman wrote:
> On 18/11/2021 14:12, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> This series add support to set/get tx copybreak buf size and rx buf len via
>> ethtool and hns3 driver implements them.
>>
>> Tx copybreak buf size is used for tx copybreak feature which for small size
>> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
>> --set-tunable command to set it, examples are as follow:
>>
>> 1. set tx spare buf size to 102400:
>> $ ethtool --set-tunable eth1 tx-buf-size 102400
>>
>> 2. get tx spare buf size:
>> $ ethtool --get-tunable eth1 tx-buf-size
>> tx-buf-size: 102400
> 
> Hi Guangbin,
> Can you please clarify the difference between TX copybreak and TX
> copybreak buf size?

Hi Gal,
'TX copybreak buf size' is the size of buffer allocated to a queue
in order to support copybreak handling when skb->len <= 'TX copybreak',

see hns3_can_use_tx_bounce() for 'TX copybreak' and
hns3_init_tx_spare_buffer() for 'TX copybreak buf size'.

> .
> 
