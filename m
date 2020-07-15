Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F5522018F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgGOBAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 21:00:48 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2541 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726356AbgGOBAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 21:00:47 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id D712171674DF9AAF01CF;
        Wed, 15 Jul 2020 09:00:45 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 15 Jul 2020 09:00:45 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 15 Jul 2020 09:00:44 +0800
Subject: Re: [PATCH net-next v2] hinic: add firmware update support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200714125433.18126-1-luobin9@huawei.com>
 <20200714113711.32107a16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <0025d09b-589e-a68e-7e17-a3c5558e0565@huawei.com>
Date:   Wed, 15 Jul 2020 09:00:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200714113711.32107a16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/15 2:37, Jakub Kicinski wrote:
> On Tue, 14 Jul 2020 20:54:33 +0800 Luo bin wrote:
>> add support to update firmware by the devlink flashing API
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> Minor nits below, otherwise I think this looks good.
> 
>> +static int hinic_firmware_update(struct hinic_devlink_priv *priv,
>> +				 const struct firmware *fw)
>> +{
>> +	struct host_image_st host_image;
>> +	int err;
>> +
>> +	memset(&host_image, 0, sizeof(struct host_image_st));
>> +
>> +	if (!check_image_valid(priv, fw->data, fw->size, &host_image) ||
>> +	    !check_image_integrity(priv, &host_image, FW_UPDATE_COLD) ||
>> +	    !check_image_device_type(priv, host_image.device_id))
> 
> These helpers should also set an appropriate message in extack, so the
> user can see it on the command line / inside their application.
> 
>> +		return -EINVAL;
>> +
>> +	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware begin\n");
>> +
>> +	err = hinic_flash_fw(priv, fw->data, &host_image);
>> +	if (err) {
>> +		if (err == HINIC_FW_DISMATCH_ERROR)
>> +			dev_err(&priv->hwdev->hwif->pdev->dev, "Firmware image doesn't match this card, please use newer image, err: %d\n",
> 
> Here as well - please make sure to return an error messages through
> extack.
> 
>> +				err);
>> +		else
>> +			dev_err(&priv->hwdev->hwif->pdev->dev, "Send firmware image data failed, err: %d\n",
>> +				err);
>> +		return err;
>> +	}
>> +
>> +	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware end\n");
>> +
>> +	return 0;
>> +}
> 
>> @@ -1086,6 +1090,17 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  		return PTR_ERR(hwdev);
>>  	}
>>  
>> +	devlink = hinic_devlink_alloc();
>> +	if (!devlink) {
>> +		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
>> +		err = -ENOMEM;
>> +		goto err_devlink_alloc;
>> +	}
>> +
>> +	priv = devlink_priv(devlink);
>> +	priv->hwdev = hwdev;
>> +	priv->devlink = devlink;
> 
> No need to remember the devlink pointer here, you can use
> priv_to_devlink(priv) to go from priv to devlink.
> 
>> +
>>  	num_qps = hinic_hwdev_num_qps(hwdev);
>>  	if (num_qps <= 0) {
>>  		dev_err(&pdev->dev, "Invalid number of QPS\n");
> .
> 
Will fix all. Thanks for your review.
