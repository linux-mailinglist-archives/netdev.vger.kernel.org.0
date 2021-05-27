Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D724039246A
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhE0Bld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:41:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5562 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhE0Blc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:41:32 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fr9R60ypkzjX8v;
        Thu, 27 May 2021 09:37:06 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 09:39:58 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 09:39:58 +0800
Subject: Re: [RFC net-next 1/4] ethtool: extend coalesce API
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <mkubecek@suse.cz>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
 <1622021262-8881-2-git-send-email-tanhuazhong@huawei.com>
 <20210526165633.3f7982c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <87bc57e0-1c37-1867-d958-fcfdda9ac743@huawei.com>
Date:   Thu, 27 May 2021 09:39:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210526165633.3f7982c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/5/27 7:56, Jakub Kicinski wrote:
> On Wed, 26 May 2021 17:27:39 +0800 Huazhong Tan wrote:
>> @@ -606,8 +611,12 @@ struct ethtool_ops {
>>   			      struct ethtool_eeprom *, u8 *);
>>   	int	(*set_eeprom)(struct net_device *,
>>   			      struct ethtool_eeprom *, u8 *);
>> -	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
>> -	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
>> +	int	(*get_coalesce)(struct net_device *,
>> +				struct netlink_ext_ack *,
> ext_ack is commonly the last argument AFAIR.


yes, will fix it.


>> +				struct kernel_ethtool_coalesce *);
> Seeing all the driver changes I can't say I'm a huge fan of
> the encapsulation. We end up with a local variable for the "base"
> structure, e.g.:
>
>   static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
> -				       struct ethtool_coalesce *cp)
> +				       struct netlink_ext_ack *extack,
> +				       struct kernel_ethtool_coalesce *cp)
>   {
> +	struct ethtool_coalesce *coal_base = &cp->base;
>   	struct wil6210_priv *wil = ndev_to_wil(ndev);
>   	struct wireless_dev *wdev = ndev->ieee80211_ptr;
>
> so why not leave the base alone and pass the new members in a separate
> structure?


This is a similar approach as struct ethtool_link_ksettings
suggested by Michal in last year's discussion.
https://lore.kernel.org/lkml/20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz/

add a new separate structure can make less change. like below
what we have to do is just add a new parameter.
static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
-                       struct ethtool_coalesce *cp)
+                       struct ethtool_coalesce *cp,
+                       struct ethtool_ext_coalesce *ext_cp,
+                       struct netlink_ext_ack *extack)
{
      struct wil6210_priv *wil = ndev_to_wil(ndev);
      struct wireless_dev *wdev = ndev->ieee80211_ptr;

If this is ok, i will send a V2 for it.


>> +	int	(*set_coalesce)(struct net_device *,
>> +				struct netlink_ext_ack *,
>> +				struct kernel_ethtool_coalesce *);
>>   	void	(*get_ringparam)(struct net_device *,
>>   				 struct ethtool_ringparam *);
>>   	int	(*set_ringparam)(struct net_device *,
>>   static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
>>   						   void __user *useraddr)
>>   {
>> -	struct ethtool_coalesce coalesce;
>> +	struct kernel_ethtool_coalesce coalesce;
>>   	int ret;
>>   
>>   	if (!dev->ethtool_ops->set_coalesce)
>>   		return -EOPNOTSUPP;
>>   
>> -	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
>> +	if (copy_from_user(&coalesce.base, useraddr, sizeof(coalesce.base)))
>>   		return -EFAULT;
>>   
>>   	if (!ethtool_set_coalesce_supported(dev, &coalesce))
>>   		return -EOPNOTSUPP;
>>   
>> -	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
>> +	ret = dev->ethtool_ops->set_coalesce(dev, NULL, &coalesce);
>>   	if (!ret)
>>   		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
>>   	return ret;
> Should IOCTL overwrite the settings it doesn't know about with 0
> or preserve the existing values?


IOCTL will overwrite the setting with random value,
will a get_coalesce before copy_from_user() to fix it.


Thanks.

Huazhong.

> .

