Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D904E440732
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ3ELv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:11:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13993 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhJ3ELu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 00:11:50 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hh5NP4NVgzWl5s;
        Sat, 30 Oct 2021 12:07:17 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Sat, 30 Oct 2021 12:09:16 +0800
Subject: Re: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
 <20211027184640.7955767e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211028114503.GM2744544@nvidia.com>
 <20211028070050.6ca7893b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b573b01c-2cc9-4722-6289-f7b9e0a43e19@huawei.com>
 <20211029121324.GT2744544@nvidia.com>
 <20211029064610.18daa788@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211029184752.GI2744544@nvidia.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <74ea44c7-7bf5-f4cd-c0aa-74e83cdc4448@huawei.com>
Date:   Sat, 30 Oct 2021 12:09:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211029184752.GI2744544@nvidia.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Oct 29, 2021 at 06:46:10AM -0700, Jakub Kicinski wrote:
>> On Fri, 29 Oct 2021 09:13:24 -0300 Jason Gunthorpe wrote:
>>> Jakub's path would be to test vlan_dev->reg_state != NETREG_REGISTERED
>>> in the work queue, but that feels pretty hacky to me as the main point
>>> of the UNREGISTERING state is to keep the object alive enough that
>>> those with outstanding gets can compelte their work and release the
>>> get. Leaving a wrecked object in UNREGISTERING is a bad design.
>>
>> That or we should investigate if we could hold the ref for real_dev all
>> the way until vlan_dev_free().
> 

Synchronize test results with the following modification:

@@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
        }

        vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
-
-       /* Get rid of the vlan's reference to real_dev */
-       dev_put(real_dev);
 }

@@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)

        free_percpu(vlan->vlan_pcpu_stats);
        vlan->vlan_pcpu_stats = NULL;
+
+       /* Get rid of the vlan's reference to real_dev */
+       dev_put(vlan->real_dev);
 }

It works on the UAF problem. And I have taken kmemleak tests for vlan_dev and real_dev,
no kmemleak problem and new UAF problem.

So take this modification for this problem?

> The latter is certainly better if it works out, no circular deps, etc.
> 
> Thanks,
> Jason
> .
> 
