Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692B9506D59
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348484AbiDSNWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349866AbiDSNWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:22:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECADEDF04
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 06:20:10 -0700 (PDT)
Received: from kwepemi100004.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KjPYG0LB3zhXYy;
        Tue, 19 Apr 2022 21:20:02 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100004.china.huawei.com (7.221.188.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 21:20:07 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 19 Apr
 2022 21:20:06 +0800
Subject: Re: [PATCH ethtool-next] ethtool: netlink: add support to get/set tx
 push by ethtool -G/g
To:     Michal Kubecek <mkubecek@suse.cz>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220419125030.3230-1-huangguangbin2@huawei.com>
 <20220419130702.xlnodeeeycn6jja6@lion.mk-sys.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <1b67ba4e-c470-bb78-392c-dc9a187ea7b8@huawei.com>
Date:   Tue, 19 Apr 2022 21:20:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220419130702.xlnodeeeycn6jja6@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/19 21:07, Michal Kubecek wrote:
> On Tue, Apr 19, 2022 at 08:50:30PM +0800, Guangbin Huang wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently tx push is a standard feature for NICs such as Mellanox, HNS3.
>> But there is no command to set or get this feature.
>>
>> So this patch adds support for "ethtool -G <dev> tx-push on|off" and
>> "ethtool -g <dev>" to set/get tx push mode.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
> [...]
>> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
>> index d8b19cf98003..79fe0bf686f3 100644
>> --- a/uapi/linux/ethtool_netlink.h
>> +++ b/uapi/linux/ethtool_netlink.h
>> @@ -330,6 +330,7 @@ enum {
>>  	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
>>  	ETHTOOL_A_RINGS_TX,				/* u32 */
>>  	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
>> +	ETHTOOL_A_RINGS_TX_PUSH = 13,			/* u8  */
>>
>>  	/* add new constants above here */
>>  	__ETHTOOL_A_RINGS_CNT,
>
> Please update the uapi headers from sanitized kernel headers as
> described here:
>
>   https://www.kernel.org/pub/software/network/ethtool/devel.html
>
> (the paragraph starting "If you need new or updated definitions..." near
> the end of the page).
>
> Michal
Thank you for your guidance. I will use the method to update the uapi 
headers in patch v2
>


