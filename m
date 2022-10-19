Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6534060389E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 05:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiJSDaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 23:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJSDa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 23:30:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A98A62AA6;
        Tue, 18 Oct 2022 20:30:23 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MsbkZ5jWXznV0S;
        Wed, 19 Oct 2022 11:27:02 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:29:55 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 19 Oct
 2022 11:29:55 +0800
Subject: Re: [Patch v7 01/12] net: mana: Add support for auxiliary device
To:     <longli@microsoft.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, <edumazet@google.com>,
        <shiraz.saleem@intel.com>, "Ajay Sharma" <sharmaajay@microsoft.com>
CC:     <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
References: <1666034441-15424-1-git-send-email-longli@linuxonhyperv.com>
 <1666034441-15424-2-git-send-email-longli@linuxonhyperv.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8f23732f-8ee7-b120-1866-286503418d3e@huawei.com>
Date:   Wed, 19 Oct 2022 11:29:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1666034441-15424-2-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2022/10/18 3:20, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> In preparation for supporting MANA RDMA driver, add support for auxiliary
> device in the Ethernet driver. The RDMA device is modeled as an auxiliary
> device to the Ethernet device.

If the RDMA device is a auxiliary device in the Ethernet driver, is there
some type of hw reset that affect both net_device and ib_device?
Is there some kind of handling like pcie hot plug/unplug which already
handles this case, so the reset handling is not needed in the RDMA and
Ethernet driver?


> 
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> Change log:
> v3: define mana_adev_idx_alloc and mana_adev_idx_free as static
> v7: fix a bug that may assign a negative value to adev->id
> 
>  drivers/net/ethernet/microsoft/Kconfig        |  1 +
>  drivers/net/ethernet/microsoft/mana/gdma.h    |  2 +
>  .../ethernet/microsoft/mana/mana_auxiliary.h  | 10 +++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 83 ++++++++++++++++++-
