Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4DD35EA86
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 03:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349035AbhDNBwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 21:52:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3941 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhDNBwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 21:52:02 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FKll73Dd2z5qMx;
        Wed, 14 Apr 2021 09:49:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 14 Apr 2021 09:51:39 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 14 Apr
 2021 09:51:39 +0800
Subject: Re: [PATCH net-next 1/2] net: hns3: PF add support for pushing link
 status to VFs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>
References: <1618294621-41356-1-git-send-email-tanhuazhong@huawei.com>
 <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
 <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <2dac0fe0-cdcb-a3c5-0c72-7873857824fd@huawei.com>
Date:   Wed, 14 Apr 2021 09:51:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/4/14 1:18, Jakub Kicinski wrote:
> On Tue, 13 Apr 2021 14:17:00 +0800 Huazhong Tan wrote:
>> +static void hclge_push_link_status(struct hclge_dev *hdev)
>> +{
>> +	struct hclge_vport *vport;
>> +	int ret;
>> +	u16 i;
>> +
>> +	for (i = 0; i < pci_num_vf(hdev->pdev); i++) {
>> +		vport = &hdev->vport[i + HCLGE_VF_VPORT_START_NUM];
>> +
>> +		if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state) ||
>> +		    vport->vf_info.link_state != IFLA_VF_LINK_STATE_AUTO)
>> +			continue;
>> +
>> +		ret = hclge_push_vf_link_status(vport);
>> +		if (ret) {
>> +			dev_err(&hdev->pdev->dev,
>> +				"failed to push link status to vf%u, ret = %d\n",
>> +				i, ret);
> Isn't this error printed twice? Here and...

They are in different contexts. here will be called to
update the link status of all VFs when the underlying
link status is changed, while the below one is called
when the admin set up the specific VF link status.


Thanks.


>
>> +}
>> +
>>   static void hclge_update_link_status(struct hclge_dev *hdev)
>>   {
>>   	struct hnae3_handle *rhandle = &hdev->vport[0].roce;
>> @@ -3246,14 +3269,24 @@ static int hclge_set_vf_link_state(struct hnae3_handle *handle, int vf,
>>   {
>>   	struct hclge_vport *vport = hclge_get_vport(handle);
>>   	struct hclge_dev *hdev = vport->back;
>> +	int link_state_old;
>> +	int ret;
>>   
>>   	vport = hclge_get_vf_vport(hdev, vf);
>>   	if (!vport)
>>   		return -EINVAL;
>>   
>> +	link_state_old = vport->vf_info.link_state;
>>   	vport->vf_info.link_state = link_state;
>>   
>> -	return 0;
>> +	ret = hclge_push_vf_link_status(vport);
>> +	if (ret) {
>> +		vport->vf_info.link_state = link_state_old;
>> +		dev_err(&hdev->pdev->dev,
>> +			"failed to push vf%d link status, ret = %d\n", vf, ret);
>> +	}
> ... here?
>
> Otherwise the patches LGTM.
>
> .

