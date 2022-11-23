Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FFA634C75
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbiKWBLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiKWBKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:10:37 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEC6E0DD0;
        Tue, 22 Nov 2022 17:10:10 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NH31m2HHtzHv2R;
        Wed, 23 Nov 2022 09:09:32 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:10:08 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 09:10:07 +0800
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
To:     Andrew Lunn <andrew@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
 <Y3Y94/My9Al4pw+h@lunn.ch> <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
 <Y3eMMc7maaPCKUNS@lunn.ch> <3cb5a576-8eb7-54fc-4f4b-9db360b6713d@huawei.com>
 <Y3uM/qNkI8Cqiqr4@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <806343a9-abe7-cffb-c153-2e8bffc89c93@huawei.com>
Date:   Wed, 23 Nov 2022 09:10:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3uM/qNkI8Cqiqr4@lunn.ch>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/21 22:36, Andrew Lunn wrote:
>> Hi, Andrew
>>
>> My new patchset is ready, but I just found out that another patch has been
>> applied to netdev/net.git. Can I solve the problem in present way? And I
>> will add devm_ioremap_resource_optional() helper later to optimize related
>> drivers. How about this?
>
> This is one of those harder to merge changes. patches to lib/devres.c
> generally go via GregKH. Networking changes are merged via the netdev
> list.
>
> Did you find this issue via a static analyser? I assume you are
> running it over the entire tree and are finding problems in multiple
> subsystems? So devm_ioremap_resource_optional() is potentially going
> to be needed in lots of places?

Yes, I grep the entire drives, some drivers is really going to
be needed for devm_ioremap_resource_optional() case.

For example:

drivers/mmc/host/mtk-sd.c
drivers/mmc/host/sdhci-st.c
drivers/ufs/host/ufs-qcom.c
drivers/mfd/bcm2835-pm.c
net/mdio/mdio-ipq4019.c
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c

> One way to get this merged is to cross post the patch adding
> devm_ioremap_resource_optional() and ask GregKH to ACK it, and then
> get netdev to merge it. You can then use it within the netdev
> subsystem. What you cannot do is use it in other subsystems until the
> next kernel cycle when it will be globally available.
>
> So three patches. One adding devm_ioremap_resource_optional(), one to
> revert the 'fix', and one with the real fix using
> devm_ioremap_resource_optional().

Thanks
