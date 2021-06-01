Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7162F396DF6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhFAHey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:34:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3489 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFAHex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:34:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvP2W21X0zYrxk;
        Tue,  1 Jun 2021 15:30:27 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 15:33:09 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 1 Jun 2021
 15:33:09 +0800
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
To:     Jakub Kicinski <kuba@kernel.org>, moyufeng <moyufeng@huawei.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20190301120358.7970f0ad@cakuba.netronome.com>
 <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190304174551.2300b7bc@cakuba.netronome.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
Date:   Tue, 1 Jun 2021 15:33:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/1 13:37, Jakub Kicinski wrote:
> On Mon, 31 May 2021 18:36:12 +0800 moyufeng wrote:
>> Hi, Jiri & Jakub
>>
>>     Generally, a devlink instance is created for each PF/VF. This
>> facilitates the query and configuration of the settings of each
>> function. But if some common objects, like the health status of
>> the entire ASIC, the data read by those instances will be duplicate.
>>
>>     So I wonder do I just need to apply a public devlink instance for the
>> entire ASIC to avoid reading the same data? If so, then I can't set
>> parameters for each function individually. Or is there a better suggestion
>> to implement it?
> 
> I don't think there is a great way to solve this today. In my mind
> devlink instances should be per ASIC, but I never had to solve this
> problem for a multi-function ASIC. 

Is there a reason why it didn't have to be solved yet?
Is it because the devices currently supporting devlink do not have
this kind of problem, like single-function ASIC or multi-function
ASIC without sharing common resource?

Was there a discussion how to solved it in the past?

> 
> Can you assume all functions are in the same control domain? Can they
> trust each other?

"same control domain" means if it is controlled by a single host, not
by multi hosts, right?

If the PF is not passed through to a vm using VFIO and other PF is still
in the host, then I think we can say it is controlled by a single host.

And each PF is trusted with each other right now, at least at the driver
level, but not between VF.

> 
> .
> 

