Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A47E234F6F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 04:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgHAC1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 22:27:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726888AbgHAC1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 22:27:54 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 256A86775E3F101F8845;
        Sat,  1 Aug 2020 10:27:52 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 1 Aug 2020 10:27:51 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 1 Aug 2020 10:27:51 +0800
Subject: Re: [PATCH net-next v2 1/2] hinic: add generating mailbox random
 index support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200731015642.17452-1-luobin9@huawei.com>
 <20200731015642.17452-2-luobin9@huawei.com>
 <20200731125212.4d58a90a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <0b5955cc-f552-2264-2a59-971604b7f7a4@huawei.com>
Date:   Sat, 1 Aug 2020 10:27:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200731125212.4d58a90a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/1 3:52, Jakub Kicinski wrote:
> On Fri, 31 Jul 2020 09:56:41 +0800 Luo bin wrote:
>> add support to generate mailbox random id of VF to ensure that
>> mailbox messages PF received are from the correct VF.
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
>> index 47c93f946b94..c72aa8e8bce8 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
>> @@ -486,6 +486,111 @@ static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
>>  	kfree(rcv_mbox_temp);
>>  }
>>  
>> +static int set_vf_mbox_random_id(struct hinic_hwdev *hwdev, u16 func_id)
>> +{
>> +	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
>> +	struct hinic_set_random_id rand_info = {0};
>> +	u16 out_size = sizeof(rand_info);
>> +	struct hinic_pfhwdev *pfhwdev;
>> +	int ret;
>> +
>> +	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
>> +
>> +	rand_info.version = HINIC_CMD_VER_FUNC_ID;
>> +	rand_info.func_idx = func_id;
>> +	rand_info.vf_in_pf = (u8)(func_id - hinic_glb_pf_vf_offset(hwdev->hwif));
> 
> this cast is unnecessary
> 
Will fix. Thanks for your review.
>> +	get_random_bytes(&rand_info.random_id, sizeof(u32));
> 
> get_random_u32()
> 
Will fix. Thanks for your review.
>> +
>> +	func_to_func->vf_mbx_rand_id[func_id] = rand_info.random_id;
>> +
>> +	ret = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
>> +				HINIC_MGMT_CMD_SET_VF_RANDOM_ID,
>> +				&rand_info, sizeof(rand_info),
>> +				&rand_info, &out_size, HINIC_MGMT_MSG_SYNC);
>> +	if ((rand_info.status != HINIC_MGMT_CMD_UNSUPPORTED &&
>> +	     rand_info.status) || !out_size || ret) {
>> +		dev_err(&hwdev->hwif->pdev->dev, "Set VF random id failed, err: %d, status: 0x%x, out size: 0x%x\n",
>> +			ret, rand_info.status, out_size);
>> +		return -EIO;
>> +	}
>> +
>> +	if (rand_info.status == HINIC_MGMT_CMD_UNSUPPORTED)
>> +		return rand_info.status;
>> +
>> +	func_to_func->vf_mbx_old_rand_id[func_id] =
>> +				func_to_func->vf_mbx_rand_id[func_id];
>> +
>> +	return 0;
>> +}
> 
>> +static bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func,
>> +				    u8 *header)
>> +{
>> +	struct hinic_hwdev *hwdev = func_to_func->hwdev;
>> +	struct hinic_mbox_work *mbox_work = NULL;
>> +	u64 mbox_header = *((u64 *)header);
>> +	u16 offset, src;
>> +	u32 random_id;
>> +	int vf_in_pf;
>> +
>> +	src = HINIC_MBOX_HEADER_GET(mbox_header, SRC_GLB_FUNC_IDX);
>> +
>> +	if (IS_PF_OR_PPF_SRC(src) || !func_to_func->support_vf_random)
>> +		return true;
>> +
>> +	if (!HINIC_IS_PPF(hwdev->hwif)) {
>> +		offset = hinic_glb_pf_vf_offset(hwdev->hwif);
>> +		vf_in_pf = src - offset;
>> +
>> +		if (vf_in_pf < 1 || vf_in_pf > hwdev->nic_cap.max_vf) {
>> +			dev_warn(&hwdev->hwif->pdev->dev,
>> +				 "Receive vf id(0x%x) is invalid, vf id should be from 0x%x to 0x%x\n",
>> +				 src, offset + 1,
>> +				 hwdev->nic_cap.max_vf + offset);
>> +			return false;
>> +		}
>> +	}
>> +
>> +	random_id = be32_to_cpu(*(u32 *)(header + MBOX_SEG_LEN +
>> +					 MBOX_HEADER_SZ));
>> +
>> +	if (random_id == func_to_func->vf_mbx_rand_id[src] ||
>> +	    random_id == func_to_func->vf_mbx_old_rand_id[src])
> 
> What guarantees src < MAX_FUNCTION_NUM ?
> 
It has been checked if src >= MAX_FUNCTION_NUM in hinic_mbox_func_aeqe_handler before calling this function.
>> +		return true;
>> +
>> +	dev_warn(&hwdev->hwif->pdev->dev,
>> +		 "The mailbox random id(0x%x) of func_id(0x%x) doesn't match with pf reservation(0x%x)\n",
>> +		 random_id, src, func_to_func->vf_mbx_rand_id[src]);
>> +
>> +	mbox_work = kzalloc(sizeof(*mbox_work), GFP_KERNEL);
>> +	if (!mbox_work)
>> +		return false;
>> +
>> +	mbox_work->func_to_func = func_to_func;
>> +	mbox_work->src_func_idx = src;
>> +
>> +	INIT_WORK(&mbox_work->work, update_random_id_work_handler);
>> +	queue_work(func_to_func->workq, &mbox_work->work);
>> +
>> +	return false;
>> +}
> 
>> +int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev)
>> +{
>> +	u8 vf_in_pf;
>> +	int err = 0;
>> +
>> +	if (HINIC_IS_VF(hwdev->hwif))
>> +		return 0;
>> +
>> +	for (vf_in_pf = 1; vf_in_pf <= hwdev->nic_cap.max_vf; vf_in_pf++) {
>> +		err = set_vf_mbox_random_id(hwdev, hinic_glb_pf_vf_offset
>> +					    (hwdev->hwif) + vf_in_pf);
> 
> Parenthesis around hwdev->hwif not necessary
hwdev->hwif is the parameter of hinic_glb_pf_vf_offset function.
> 
>> +		if (err)
>> +			break;
>> +	}
>> +
>> +	if (err == HINIC_MGMT_CMD_UNSUPPORTED) {
>> +		hwdev->func_to_func->support_vf_random = false;
> 
> So all VFs need to support the feature for it to be used?
If this feature is not supported by fw, VFs can also be used, so we return success.
> 
>> +		err = 0;
>> +		dev_warn(&hwdev->hwif->pdev->dev, "Mgmt is unsupported to set VF%d random id\n",
>> +			 vf_in_pf - 1);
>> +	} else if (!err) {
>> +		hwdev->func_to_func->support_vf_random = true;
>> +		dev_info(&hwdev->hwif->pdev->dev, "PF Set VF random id success\n");
> 
> Is this info message really necessary?
I'll remove this info message. Thanks.
> 
>> +	}
> 
> .
> 
