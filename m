Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361785FC307
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiJLJZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJLJZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:25:27 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296D44E615;
        Wed, 12 Oct 2022 02:25:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MnRyL6HwJz1CF4D;
        Wed, 12 Oct 2022 17:22:50 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 12 Oct 2022 17:25:22 +0800
Message-ID: <15f63fd8-0f0e-26bc-c74e-fc7666c6ff88@huawei.com>
Date:   Wed, 12 Oct 2022 17:25:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] net: hinic: Update the range of MTU from 256 to 9600
To:     Cai Huoqing <cai.huoqing@linux.dev>, <leonro@nvidia.com>
CC:     caihuoqing <caihuoqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221012082945.10353-1-cai.huoqing@linux.dev>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221012082945.10353-1-cai.huoqing@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/12 16:29, Cai Huoqing wrote:
> From: caihuoqing <caihuoqing@baidu.com>
> 
> Hinic hardware only support MTU from 256 to 9600, so set
> the max_mtu and min_mtu.
> 
> And not need to add the validity judgment when set mtu,
> because the judgment is made in net/core: dev_validate_mtu
> 
> Signed-off-by: caihuoqing <caihuoqing@baidu.com>
> ---
>   drivers/net/ethernet/huawei/hinic/hinic_dev.h  |  3 +++
>   drivers/net/ethernet/huawei/hinic/hinic_main.c |  3 ++-
>   drivers/net/ethernet/huawei/hinic/hinic_port.c | 17 +----------------
>   3 files changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> index a4fbf44f944c..2bbc94c0a9c1 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> @@ -22,6 +22,9 @@
>   
>   #define LP_PKT_CNT		64
>   
> +#define HINIC_MAX_MTU_SIZE		9600
> +#define HINIC_MIN_MTU_SIZE		256
> +
>   enum hinic_flags {
>   	HINIC_LINK_UP = BIT(0),
>   	HINIC_INTF_UP = BIT(1),
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index c23ee2ddbce3..41e52f775aae 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -1189,7 +1189,8 @@ static int nic_dev_init(struct pci_dev *pdev)
>   	else
>   		netdev->netdev_ops = &hinicvf_netdev_ops;
>   
> -	netdev->max_mtu = ETH_MAX_MTU;
> +	netdev->max_mtu = HINIC_MAX_MTU_SIZE;
> +	netdev->min_mtu = HINIC_MIN_MTU_SIZE;
>   
>   	nic_dev = netdev_priv(netdev);
>   	nic_dev->netdev = netdev;
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
> index 28ae6f1201a8..0a39c3dffa9a 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
> @@ -17,9 +17,6 @@
>   #include "hinic_port.h"
>   #include "hinic_dev.h"
>   
> -#define HINIC_MIN_MTU_SIZE              256
> -#define HINIC_MAX_JUMBO_FRAME_SIZE      15872
> -
>   enum mac_op {
>   	MAC_DEL,
>   	MAC_SET,
> @@ -147,24 +144,12 @@ int hinic_port_get_mac(struct hinic_dev *nic_dev, u8 *addr)
>    **/
>   int hinic_port_set_mtu(struct hinic_dev *nic_dev, int new_mtu)
>   {
> -	struct net_device *netdev = nic_dev->netdev;
>   	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>   	struct hinic_port_mtu_cmd port_mtu_cmd;
>   	struct hinic_hwif *hwif = hwdev->hwif;
>   	u16 out_size = sizeof(port_mtu_cmd);
>   	struct pci_dev *pdev = hwif->pdev;
> -	int err, max_frame;
> -
> -	if (new_mtu < HINIC_MIN_MTU_SIZE) {
> -		netif_err(nic_dev, drv, netdev, "mtu < MIN MTU size");
> -		return -EINVAL;
> -	}
> -
> -	max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> -	if (max_frame > HINIC_MAX_JUMBO_FRAME_SIZE) {
> -		netif_err(nic_dev, drv, netdev, "mtu > MAX MTU size");
> -		return -EINVAL;
> -	}
> +	int err;
>   
>   	port_mtu_cmd.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
>   	port_mtu_cmd.mtu = new_mtu;

Hi Cai:
	You cannot change the maximum supported jumbo frame size.
Because as far as I know, this is not compatible with the older
firmware version. If you change the maximum MTU, the maximum length
of packets received by the port will be affected with older fw. So
donot change it.

Zhengchao Shao
