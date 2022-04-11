Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139754FB573
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343492AbiDKIAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiDKIAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:00:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA98186DC;
        Mon, 11 Apr 2022 00:58:35 -0700 (PDT)
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KcLly17S1zgYcm;
        Mon, 11 Apr 2022 15:56:46 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 15:58:33 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Apr
 2022 15:58:33 +0800
Subject: Re: [PATCH net-next 1/3] net: ethtool: extend ringparam set/get APIs
 for tx_push
To:     Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220408071245.40554-1-huangguangbin2@huawei.com>
 <20220408071245.40554-2-huangguangbin2@huawei.com>
 <20220408145544.141c0799@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <3747f29a-a869-f934-648f-5fa7288223c2@huawei.com>
Date:   Mon, 11 Apr 2022 15:58:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220408145544.141c0799@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/4/9 5:55, Jakub Kicinski wrote:
> On Fri, 8 Apr 2022 15:12:43 +0800 Guangbin Huang wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently tx push is a standard driver feature which controls use of a fast
>> path descriptor push. So this patch extends the ringparam APIs and data
>> structures to support set/get tx push by ethtool -G/g.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>
>> +``ETHTOOL_A_RINGS_TX_PUSH`` flag is used to choose the ordinary path or the fast
>> +path to send packets. In ordinary path, driver fills BDs to DDR memory and
>> +notifies NIC hardware. In fast path, driver pushes BDs to the device memory
>> +directly and thus reducing the sending latencies. Setting tx push attribute "on"
>> +will enable tx push mode and send packets in fast path if packet size matches.
>> +For those not supported hardwares, this attributes is "off" by default settings.
>
> Since you need to respin to fix the kdoc warning - could you also add
> a mention that enabling this feature may increase CPU cost? Unless it's
> not the case for your implementation, I thought it usually is..
>
ok, i will add it in v2
>>  RINGS_SET
>>  =========
>> @@ -887,6 +894,7 @@ Request contents:
>>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
>> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>>    ====================================  ======  ===========================
>>
>>  Kernel checks that requested ring sizes do not exceed limits reported by
>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 4af58459a1e7..ede4f9154cd2 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -71,11 +71,13 @@ enum {
>>   * struct kernel_ethtool_ringparam - RX/TX ring configuration
>>   * @rx_buf_len: Current length of buffers on the rx ring.
>>   * @tcp_data_split: Scatter packet headers and data to separate buffers
>> + * @tx_push: The flag of tx push mode
>>   * @cqe_size: Size of TX/RX completion queue event
>>   */
>>  struct kernel_ethtool_ringparam {
>>  	u32	rx_buf_len;
>>  	u8	tcp_data_split;
>> +	u8	tx_push;
>>  	u32	cqe_size;
>>  };
>>
>> @@ -87,6 +89,7 @@ struct kernel_ethtool_ringparam {
>>  enum ethtool_supported_ring_param {
>>  	ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
>>  	ETHTOOL_RING_USE_CQE_SIZE   = BIT(1),
>> +	ETHTOOL_RING_USE_TX_PUSH    = BIT(2),
>
> include/linux/ethtool.h:94: warning: Enum value 'ETHTOOL_RING_USE_TX_PUSH' not described in enum 'ethtool_supported_ring_param'
thx, I will fix it in v2
>
>
> .
>

