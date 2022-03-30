Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510FF4EBD06
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiC3I6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244488AbiC3I6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:58:19 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750B514146F
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:56:34 -0700 (PDT)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KT0f72tbNz1GD0p;
        Wed, 30 Mar 2022 16:56:15 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 30 Mar 2022 16:56:32 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 30 Mar
 2022 16:56:32 +0800
Subject: Re: [RFCv3 PATCH net-next 2/2] net-next: hn3: add tx push support in
 hns3 ring param process
To:     Michal Kubecek <mkubecek@suse.cz>
References: <20220329091913.17869-1-wangjie125@huawei.com>
 <20220329091913.17869-3-wangjie125@huawei.com>
 <20220329194430.udh5i77kkrgun7b7@lion.mk-sys.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <moyufeng@huawei.com>,
        <linyunsheng@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <c26fc6ad-3517-48aa-1e30-5a1659e49c20@huawei.com>
Date:   Wed, 30 Mar 2022 16:56:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220329194430.udh5i77kkrgun7b7@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/30 3:44, Michal Kubecek wrote:
> On Tue, Mar 29, 2022 at 05:19:13PM +0800, Jie Wang wrote:
>> This patch adds tx push param to hns3 ring param and adapts the set and get
>> API of ring params. So users can set it by cmd ethtool -G and get it by cmd
>> ethtool -g.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> ---
>>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 33 ++++++++++++++++++-
>>  1 file changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> index 6469238ae090..5bc509f90d2a 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> @@ -664,6 +664,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
>>  	param->tx_pending = priv->ring[0].desc_num;
>>  	param->rx_pending = priv->ring[rx_queue_index].desc_num;
>>  	kernel_param->rx_buf_len = priv->ring[rx_queue_index].buf_size;
>> +	kernel_param->tx_push = test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE,
>> +					 &priv->state);
>>  }
>>
>>  static void hns3_get_pauseparam(struct net_device *netdev,
>> @@ -1114,6 +1116,30 @@ static int hns3_change_rx_buf_len(struct net_device *ndev, u32 rx_buf_len)
>>  	return 0;
>>  }
>>
>> +static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
>> +{
>> +	struct hns3_nic_priv *priv = netdev_priv(netdev);
>> +	struct hnae3_handle *h = hns3_get_handle(netdev);
>> +	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
>> +	u32 old_state = test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
>> +
>> +	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps) && tx_push)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (tx_push == old_state)
>> +		return 0;
>> +
>> +	netdev_info(netdev, "Changing tx push from %s to %s\n",
>> +		    old_state ? "on" : "off", tx_push ? "on" : "off");
>
> A nitpick: do we really want an unconditional log message for each
> change? If someone wants to monitor them, that's what the netlink
> notifications were created for.
>
Actually this log is no need to display for each change, I will use 
netdev_dbg instead.
> Michal
>
>> +
>> +	if (tx_push)
>> +		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
>> +	else
>> +		clear_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
>> +
>> +	return 0;
>> +}
>> +
>>  static int hns3_set_ringparam(struct net_device *ndev,
>>  			      struct ethtool_ringparam *param,
>>  			      struct kernel_ethtool_ringparam *kernel_param,

