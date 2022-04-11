Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159884FB58A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbiDKIDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiDKID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:03:29 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D305CDEB5;
        Mon, 11 Apr 2022 01:01:15 -0700 (PDT)
Received: from kwepemi500001.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KcLmB0mf5zBsFN;
        Mon, 11 Apr 2022 15:56:58 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500001.china.huawei.com (7.221.188.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 16:01:13 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Apr
 2022 16:01:13 +0800
Subject: Re: [PATCH net-next 2/3] net: ethtool: move checks before rtnl_lock()
 in ethnl_set_rings
To:     Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
 <20220408071245.40554-3-huangguangbin2@huawei.com>
 <20220408145850.2c5882ec@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <2134f66e-057b-ac49-25eb-4f0904fa8240@huawei.com>
Date:   Mon, 11 Apr 2022 16:01:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220408145850.2c5882ec@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/9 5:58, Jakub Kicinski wrote:
> On Fri, 8 Apr 2022 15:12:44 +0800 Guangbin Huang wrote:
>> +	if (tb[ETHTOOL_A_RINGS_RX_BUF_LEN] &&
>> +	    nla_get_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN]) != 0 &&
>
> I think we can drop the value checking. If attribute is present and
> drivers doesn't support - reject. I don't think that would require
> any changes to existing user space but please double check.
>
I have checked user space code and tested the delete version on my 
server, these value checking will be dropped in v2.
>> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
>> +		ret = -EOPNOTSUPP;
>> +		NL_SET_ERR_MSG_ATTR(info->extack,
>> +				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
>> +				    "setting rx buf len not supported");
>> +		goto out_dev;
>> +	}
>> +
>> +	if (tb[ETHTOOL_A_RINGS_CQE_SIZE] &&
>> +	    nla_get_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE]) &&
>> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_CQE_SIZE)) {
>> +		ret = -EOPNOTSUPP;
>> +		NL_SET_ERR_MSG_ATTR(info->extack,
>> +				    tb[ETHTOOL_A_RINGS_CQE_SIZE],
>> +				    "setting cqe size not supported");
>> +		goto out_dev;
>> +	}
>
> .
>

