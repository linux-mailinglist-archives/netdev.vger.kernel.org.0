Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65250629BB4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiKOOND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238223AbiKOOMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:12:42 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B251A2CC8B;
        Tue, 15 Nov 2022 06:12:36 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NBSmY1F9Yz15MPB;
        Tue, 15 Nov 2022 22:12:13 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:12:33 +0800
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 22:12:33 +0800
Subject: Re: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
To:     Leon Romanovsky <leon@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
 <20220927111205.18060-2-huangguangbin2@huawei.com> <YzQh4Zu3Md1+Npeo@unreal>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <shenjian15@huawei.com>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <aaa5deae-1a79-b02f-75ee-37a31383e40c@huawei.com>
Date:   Tue, 15 Nov 2022 22:12:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YzQh4Zu3Md1+Npeo@unreal>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
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

> Can you please explain why do you need special define for boolean AND?
we use '&', just define a bitwise AND, not define boolean AND.
Thanks.

On 2022/9/28 18:28, Leon Romanovsky wrote:
> On Tue, Sep 27, 2022 at 07:12:02PM +0800, Guangbin Huang wrote:
>> From: Jian Shen <shenjian15@huawei.com>
>>
>> The expression '(k ^ ~v)' is exaclty '(k & v)', and
>> '(k & v) & k' is exaclty 'k & v'. So simplify the
>> expression for tcam key convert.
>>
>> It also add necessary brackets for them.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> index 495b639b0dc2..59bfacc687c9 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> @@ -827,15 +827,10 @@ struct hclge_vf_vlan_cfg {
>>   * Then for input key(k) and mask(v), we can calculate the value by
>>   * the formulae:
>>   *	x = (~k) & v
>> - *	y = (k ^ ~v) & k
>> + *	y = k & v
>>   */
>> -#define calc_x(x, k, v) (x = ~(k) & (v))
>> -#define calc_y(y, k, v) \
>> -	do { \
>> -		const typeof(k) _k_ = (k); \
>> -		const typeof(v) _v_ = (v); \
>> -		(y) = (_k_ ^ ~_v_) & (_k_); \
>> -	} while (0)
>> +#define calc_x(x, k, v) ((x) = ~(k) & (v))
>> +#define calc_y(y, k, v) ((y) = (k) & (v))
> 
> Can you please explain why do you need special define for boolean AND?
we use '&', just define a bitwise AND, not define boolean AND.
> 
> Thanks
> 
>>  
>>  #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
>>  #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
>> -- 
>> 2.33.0
>>
> .
> 
