Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CE26CF92D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjC3Cg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC3Cg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:36:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DFC4C2F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:36:55 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pn6sm5PTvzSqZH;
        Thu, 30 Mar 2023 10:33:16 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 30 Mar
 2023 10:36:53 +0800
Subject: Re: AMD IOMMU problem after NIC uses multi-page allocation
To:     Jakub Kicinski <kuba@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
CC:     <iommu@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20230329181407.3eed7378@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5b669c86-773d-a46e-4925-03281f10ef12@huawei.com>
Date:   Thu, 30 Mar 2023 10:36:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230329181407.3eed7378@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/30 9:14, Jakub Kicinski wrote:
> Hi Joerg, Suravee,
> 
> I see an odd NIC behavior with AMD IOMMU in lazy mode (on 5.19).
> 
> The NIC allocates a buffer for Rx packets which is MTU rounded up 
> to page size. If I run it with 1500B MTU or 9000 MTU everything is
> fine, slight but manageable perf hit.
> 
> But if I flip the MTU to 9k, run some traffic and then go back to 1.5k 
> - 70%+ of CPU cycles are spent in alloc_iova (and children).
> 
> Does this ring any bells?

My bell points to below info, not sure if it will help?
https://lore.kernel.org/linux-iommu/20190815121104.29140-3-thunder.leizhen@huawei.com/

> .
> 
