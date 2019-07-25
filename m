Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB9074E21
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 14:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbfGYM2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 08:28:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2487 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727890AbfGYM2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 08:28:09 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id D203DAE15A54074DDC27;
        Thu, 25 Jul 2019 20:28:05 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 25 Jul 2019 20:28:05 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Thu, 25
 Jul 2019 20:28:04 +0800
Subject: Re: [PATCH net-next 07/11] net: hns3: adds debug messages to identify
 eth down cause
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-8-git-send-email-tanhuazhong@huawei.com>
 <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <30483e38-5e4a-0111-f431-4742ceb1aa62@huawei.com>
Date:   Thu, 25 Jul 2019 20:28:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <ffd942e7d7442549a3a6d469709b7f7405928afe.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/25 3:12, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>> From: Yonglong Liu <liuyonglong@huawei.com>
>>
>> Some times just see the eth interface have been down/up via
>> dmesg, but can not know why the eth down. So adds some debug
>> messages to identify the cause for this.
>>
> 
> I really don't like this. your default msg lvl has NETIF_MSG_IFDOWN
> turned on .. dumping every single operation that happens on your device
> by default to kernel log is too much ! 
> 
> We should really consider using trace buffers with well defined
> structures for vendor specific events. so we can use bpf filters and
> state of the art tools for netdev debugging.
> 

We do this because we can just see a link down message in dmesg, and had
take a long time to found the cause of link down, just because another
user changed the settings.

We can change the net_open/net_stop/dcbnl_ops to msg_drv (not default
turned on),  and want to keep the others default print to kernel log,
is it acceptable?

>> @@ -1593,6 +1603,11 @@ static int hns3_ndo_set_vf_vlan(struct
>> net_device *netdev, int vf, u16 vlan,
>>  	struct hnae3_handle *h = hns3_get_handle(netdev);
>>  	int ret = -EIO;
>>  
>> +	if (netif_msg_ifdown(h))
> 
> why msg_ifdown ? looks like netif_msg_drv is more appropriate, for many
> of the cases in this patch.
> 

This operation may cause link down, so we use msg_ifdown.

>> +		netdev_info(netdev,
>> +			    "set vf vlan: vf=%d, vlan=%d, qos=%d,
>> vlan_proto=%d\n",
>> +			    vf, vlan, qos, vlan_proto);
>> +
>>  	if (h->ae_algo->ops->set_vf_vlan_filter)
>>  		ret = h->ae_algo->ops->set_vf_vlan_filter(h, vf, vlan,
>>  							  qos,
>> vlan_proto);
>> @@ -1611,6 +1626,10 @@ static int hns3_nic_change_mtu(struct
>> net_device *netdev, int new_mtu)
>>  	if (!h->ae_algo->ops->set_mtu)
>>  		return -EOPNOTSUPP;
>>  
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(netdev, "change mtu from %d to %d\n",
>> +			    netdev->mtu, new_mtu);
>> +
>>  	ret = h->ae_algo->ops->set_mtu(h, new_mtu);
>>  	if (ret)
>>  		netdev_err(netdev, "failed to change MTU in hardware
>> %d\n",
>> @@ -4395,6 +4414,11 @@ int hns3_set_channels(struct net_device
>> *netdev,
>>  	if (kinfo->rss_size == new_tqp_num)
>>  		return 0;
>>  
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(netdev,
>> +			    "set channels: tqp_num=%d, rxfh=%d\n",
>> +			    new_tqp_num, rxfh_configured);
>> +
>>  	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
>>  	if (ret)
>>  		return ret;
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> index e71c92b..edb9845 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> @@ -311,6 +311,9 @@ static void hns3_self_test(struct net_device
>> *ndev,
>>  	if (eth_test->flags != ETH_TEST_FL_OFFLINE)
>>  		return;
>>  
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(ndev, "self test start\n");
>> +
>>  	st_param[HNAE3_LOOP_APP][0] = HNAE3_LOOP_APP;
>>  	st_param[HNAE3_LOOP_APP][1] =
>>  			h->flags & HNAE3_SUPPORT_APP_LOOPBACK;
>> @@ -374,6 +377,9 @@ static void hns3_self_test(struct net_device
>> *ndev,
>>  
>>  	if (if_running)
>>  		ndev->netdev_ops->ndo_open(ndev);
>> +
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(ndev, "self test end\n");
>>  }
>>  
>>  static int hns3_get_sset_count(struct net_device *netdev, int
>> stringset)
>> @@ -604,6 +610,11 @@ static int hns3_set_pauseparam(struct net_device
>> *netdev,
>>  {
>>  	struct hnae3_handle *h = hns3_get_handle(netdev);
>>  
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(netdev,
>> +			    "set pauseparam: autoneg=%d, rx:%d,
>> tx:%d\n",
>> +			    param->autoneg, param->rx_pause, param-
>>> tx_pause);
>> +
>>  	if (h->ae_algo->ops->set_pauseparam)
>>  		return h->ae_algo->ops->set_pauseparam(h, param-
>>> autoneg,
>>  						       param->rx_pause,
>> @@ -743,6 +754,13 @@ static int hns3_set_link_ksettings(struct
>> net_device *netdev,
>>  	if (cmd->base.speed == SPEED_1000 && cmd->base.duplex ==
>> DUPLEX_HALF)
>>  		return -EINVAL;
>>  
>> +	if (netif_msg_ifdown(handle))
>> +		netdev_info(netdev,
>> +			    "set link(%s): autoneg=%d, speed=%d,
>> duplex=%d\n",
>> +			    netdev->phydev ? "phy" : "mac",
>> +			    cmd->base.autoneg, cmd->base.speed,
>> +			    cmd->base.duplex);
>> +
>>  	/* Only support ksettings_set for netdev with phy attached for
>> now */
>>  	if (netdev->phydev)
>>  		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
>> @@ -984,6 +1002,10 @@ static int hns3_nway_reset(struct net_device
>> *netdev)
>>  		return -EINVAL;
>>  	}
>>  
>> +	if (netif_msg_ifdown(handle))
>> +		netdev_info(netdev, "nway reset (using %s)\n",
>> +			    phy ? "phy" : "mac");
>> +
>>  	if (phy)
>>  		return genphy_restart_aneg(phy);
>>  
>> @@ -1308,6 +1330,10 @@ static int hns3_set_fecparam(struct net_device
>> *netdev,
>>  	if (!ops->set_fec)
>>  		return -EOPNOTSUPP;
>>  	fec_mode = eth_to_loc_fec(fec->fec);
>> +
>> +	if (netif_msg_ifdown(handle))
>> +		netdev_info(netdev, "set fecparam: mode=%d\n",
>> fec_mode);
>> +
>>  	return ops->set_fec(handle, fec_mode);
>>  }
>>  
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
>> index bac4ce1..133e7c6 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
>> @@ -201,6 +201,7 @@ static int hclge_client_setup_tc(struct hclge_dev
>> *hdev)
>>  static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets
>> *ets)
>>  {
>>  	struct hclge_vport *vport = hclge_get_vport(h);
>> +	struct net_device *netdev = h->kinfo.netdev;
>>  	struct hclge_dev *hdev = vport->back;
>>  	bool map_changed = false;
>>  	u8 num_tc = 0;
>> @@ -215,6 +216,9 @@ static int hclge_ieee_setets(struct hnae3_handle
>> *h, struct ieee_ets *ets)
>>  		return ret;
>>  
>>  	if (map_changed) {
>> +		if (netif_msg_ifdown(h))
>> +			netdev_info(netdev, "set ets\n");
>> +
>>  		ret = hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
>>  		if (ret)
>>  			return ret;
>> @@ -300,6 +304,7 @@ static int hclge_ieee_getpfc(struct hnae3_handle
>> *h, struct ieee_pfc *pfc)
>>  static int hclge_ieee_setpfc(struct hnae3_handle *h, struct ieee_pfc
>> *pfc)
>>  {
>>  	struct hclge_vport *vport = hclge_get_vport(h);
>> +	struct net_device *netdev = h->kinfo.netdev;
>>  	struct hclge_dev *hdev = vport->back;
>>  	u8 i, j, pfc_map, *prio_tc;
>>  
>> @@ -325,6 +330,11 @@ static int hclge_ieee_setpfc(struct hnae3_handle
>> *h, struct ieee_pfc *pfc)
>>  	hdev->tm_info.hw_pfc_map = pfc_map;
>>  	hdev->tm_info.pfc_en = pfc->pfc_en;
>>  
>> +	if (netif_msg_ifdown(h))
>> +		netdev_info(netdev,
>> +			    "set pfc: pfc_en=%d, pfc_map=%d,
>> num_tc=%d\n",
>> +			    pfc->pfc_en, pfc_map, hdev-
>>> tm_info.num_tc);
>> +
>>  	hclge_tm_pfc_info_update(hdev);
>>  
>>  	return hclge_pause_setup_hw(hdev, false);
>> @@ -345,8 +355,12 @@ static u8 hclge_getdcbx(struct hnae3_handle *h)
>>  static u8 hclge_setdcbx(struct hnae3_handle *h, u8 mode)
>>  {
>>  	struct hclge_vport *vport = hclge_get_vport(h);
>> +	struct net_device *netdev = h->kinfo.netdev;
>>  	struct hclge_dev *hdev = vport->back;
>>  
>> +	if (netif_msg_drv(h))
>> +		netdev_info(netdev, "set dcbx: mode=%d\n", mode);
>> +
>>  	/* No support for LLD_MANAGED modes or CEE */
>>  	if ((mode & DCB_CAP_DCBX_LLD_MANAGED) ||
>>  	    (mode & DCB_CAP_DCBX_VER_CEE) ||

