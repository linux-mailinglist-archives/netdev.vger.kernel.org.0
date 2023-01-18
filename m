Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2A671D37
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjARNN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjARNNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:13:34 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F12237F1E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:36:49 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NxlVr1hdJzqVH5;
        Wed, 18 Jan 2023 20:31:32 +0800 (CST)
Received: from [10.67.101.149] (10.67.101.149) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 18 Jan 2023 20:36:25 +0800
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
To:     Paolo Abeni <pabeni@redhat.com>, Hao Lan <lanhao@huawei.com>,
        <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com>
 <504c2c6ba951859cbd007cfd441dde7de1a8f479.camel@redhat.com>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <richardcochran@gmail.com>,
        <shenjian15@huawei.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <7694a726-d294-a700-f021-03370d761139@huawei.com>
Date:   Wed, 18 Jan 2023 20:36:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <504c2c6ba951859cbd007cfd441dde7de1a8f479.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/17 16:04, Paolo Abeni wrote:
> Hello,
>
> On Fri, 2023-01-13 at 10:08 +0800, Hao Lan wrote:
> [...]
>
>> +static void hclge_get_vf_fault_bitmap(struct hclge_desc *desc,
>> +				      unsigned long *bitmap)
>> +{
>> +#define HCLGE_FIR_FAULT_BYTES	24
>> +#define HCLGE_SEC_FAULT_BYTES	8
>> +
>> +	u8 *buff;
>> +
>> +	memcpy(bitmap, desc[0].data, HCLGE_FIR_FAULT_BYTES);
>> +	buff = (u8 *)bitmap + HCLGE_FIR_FAULT_BYTES;
>> +	memcpy(buff, desc[1].data, HCLGE_SEC_FAULT_BYTES);
>> +}
>
> The above works under the assumption that:
>
> 	HCLGE_FIR_FAULT_BYTES + HCLGE_SEC_FAULT_BYTES == BITS_TO_BYTES(HCLGE_VPORT_NUM)
>
> I think it's better to enforce such condition at build time with a
> BUILD_BUG_ON(), to avoid future issues.
>
> Also I think Leon still deserve a reply to one of his questions,
> specifically: What will happen (at recovery time) with driver bound to
> this VF?
>
> Thanks!
>
> Paolo
>
As discussed in reply to Leon, it missed to notify VF driver to prepare for
the reset in V1, So I will add notify to VF driver in v2 to make sure the
VF driver will init to normal at recovery time.

Thanks!
> .
>
