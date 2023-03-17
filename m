Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8885C6BDEEF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCQCjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCQCi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:38:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A38F7D80;
        Thu, 16 Mar 2023 19:38:25 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pd7W350VjznXGh;
        Fri, 17 Mar 2023 10:34:23 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 17 Mar
 2023 10:37:23 +0800
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
To:     Jakub Kicinski <kuba@kernel.org>, Ronak Doshi <doshir@vmware.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
 <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
 <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
 <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
 <20230315211329.1c7b3566@kernel.org>
 <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
 <20230316133405.0ffbea6a@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <06e4a534-d15d-4b17-b548-4927d42152e1@huawei.com>
Date:   Fri, 17 Mar 2023 10:37:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230316133405.0ffbea6a@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

On 2023/3/17 4:34, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 05:21:42 +0000 Ronak Doshi wrote:
>> Below are some sample test numbers collected by our perf team. 
>>                           Test                                    socket & msg size                          base               using only gro
>> 1VM    14vcpu UDP stream receive        256K 256 bytes (packets/sec)    217.01 Kps    187.98 Kps         -13.37%
>> 16VM  2vcpu   TCP stream send Thpt     8K     256 bytes (Gbps)                18.00 Gbps    17.02 Gbps         -5.44%
>> 1VM    14vcpu ResponseTimeMean Receive (in micro secs)                      163 us             170 us                -4.29%
> 
> A bit more than I suspected, thanks for the data.

Maybe we do some investigation to find out why the performace lost is more than
suspected first.

For example if LRO'ed skb is added in gro_list->list, and then new LRO'ed skb from
the same flow only go through the whole GSO processing only to find out we have to
flush out the old LRO'ed in the gro_list->list, and add new LRO'ed skb in gro_list->list
again?


> .
> 
