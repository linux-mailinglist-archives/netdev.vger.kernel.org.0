Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7840234BC9
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 21:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGaTwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 15:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgGaTwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 15:52:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0343F21744;
        Fri, 31 Jul 2020 19:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225134;
        bh=wYER8X6pKIITSbInuYXTfuSmaYgOJT3nPkWi0yJlRnM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ug0xVmdlIo6eFa3xJ+SSwhCLZL6pPBKtQV0F6Vr8TQuXdvvaYfXUjw/71afpv7n1n
         xlxC2bW85MxBothP465TRlOd+KWEN0mIXgrlw3l3ewSX2P1QtciASYqq9WWnzEbQTI
         DuYxayxBjpOeCw588SOFZ4CelEEa/Okh+HtIGaZg=
Date:   Fri, 31 Jul 2020 12:52:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v2 1/2] hinic: add generating mailbox random
 index support
Message-ID: <20200731125212.4d58a90a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200731015642.17452-2-luobin9@huawei.com>
References: <20200731015642.17452-1-luobin9@huawei.com>
        <20200731015642.17452-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 09:56:41 +0800 Luo bin wrote:
> add support to generate mailbox random id of VF to ensure that
> mailbox messages PF received are from the correct VF.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> index 47c93f946b94..c72aa8e8bce8 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> @@ -486,6 +486,111 @@ static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
>  	kfree(rcv_mbox_temp);
>  }
>  
> +static int set_vf_mbox_random_id(struct hinic_hwdev *hwdev, u16 func_id)
> +{
> +	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
> +	struct hinic_set_random_id rand_info = {0};
> +	u16 out_size = sizeof(rand_info);
> +	struct hinic_pfhwdev *pfhwdev;
> +	int ret;
> +
> +	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
> +
> +	rand_info.version = HINIC_CMD_VER_FUNC_ID;
> +	rand_info.func_idx = func_id;
> +	rand_info.vf_in_pf = (u8)(func_id - hinic_glb_pf_vf_offset(hwdev->hwif));

this cast is unnecessary

> +	get_random_bytes(&rand_info.random_id, sizeof(u32));

get_random_u32()

> +
> +	func_to_func->vf_mbx_rand_id[func_id] = rand_info.random_id;
> +
> +	ret = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
> +				HINIC_MGMT_CMD_SET_VF_RANDOM_ID,
> +				&rand_info, sizeof(rand_info),
> +				&rand_info, &out_size, HINIC_MGMT_MSG_SYNC);
> +	if ((rand_info.status != HINIC_MGMT_CMD_UNSUPPORTED &&
> +	     rand_info.status) || !out_size || ret) {
> +		dev_err(&hwdev->hwif->pdev->dev, "Set VF random id failed, err: %d, status: 0x%x, out size: 0x%x\n",
> +			ret, rand_info.status, out_size);
> +		return -EIO;
> +	}
> +
> +	if (rand_info.status == HINIC_MGMT_CMD_UNSUPPORTED)
> +		return rand_info.status;
> +
> +	func_to_func->vf_mbx_old_rand_id[func_id] =
> +				func_to_func->vf_mbx_rand_id[func_id];
> +
> +	return 0;
> +}

> +static bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func,
> +				    u8 *header)
> +{
> +	struct hinic_hwdev *hwdev = func_to_func->hwdev;
> +	struct hinic_mbox_work *mbox_work = NULL;
> +	u64 mbox_header = *((u64 *)header);
> +	u16 offset, src;
> +	u32 random_id;
> +	int vf_in_pf;
> +
> +	src = HINIC_MBOX_HEADER_GET(mbox_header, SRC_GLB_FUNC_IDX);
> +
> +	if (IS_PF_OR_PPF_SRC(src) || !func_to_func->support_vf_random)
> +		return true;
> +
> +	if (!HINIC_IS_PPF(hwdev->hwif)) {
> +		offset = hinic_glb_pf_vf_offset(hwdev->hwif);
> +		vf_in_pf = src - offset;
> +
> +		if (vf_in_pf < 1 || vf_in_pf > hwdev->nic_cap.max_vf) {
> +			dev_warn(&hwdev->hwif->pdev->dev,
> +				 "Receive vf id(0x%x) is invalid, vf id should be from 0x%x to 0x%x\n",
> +				 src, offset + 1,
> +				 hwdev->nic_cap.max_vf + offset);
> +			return false;
> +		}
> +	}
> +
> +	random_id = be32_to_cpu(*(u32 *)(header + MBOX_SEG_LEN +
> +					 MBOX_HEADER_SZ));
> +
> +	if (random_id == func_to_func->vf_mbx_rand_id[src] ||
> +	    random_id == func_to_func->vf_mbx_old_rand_id[src])

What guarantees src < MAX_FUNCTION_NUM ?

> +		return true;
> +
> +	dev_warn(&hwdev->hwif->pdev->dev,
> +		 "The mailbox random id(0x%x) of func_id(0x%x) doesn't match with pf reservation(0x%x)\n",
> +		 random_id, src, func_to_func->vf_mbx_rand_id[src]);
> +
> +	mbox_work = kzalloc(sizeof(*mbox_work), GFP_KERNEL);
> +	if (!mbox_work)
> +		return false;
> +
> +	mbox_work->func_to_func = func_to_func;
> +	mbox_work->src_func_idx = src;
> +
> +	INIT_WORK(&mbox_work->work, update_random_id_work_handler);
> +	queue_work(func_to_func->workq, &mbox_work->work);
> +
> +	return false;
> +}

> +int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev)
> +{
> +	u8 vf_in_pf;
> +	int err = 0;
> +
> +	if (HINIC_IS_VF(hwdev->hwif))
> +		return 0;
> +
> +	for (vf_in_pf = 1; vf_in_pf <= hwdev->nic_cap.max_vf; vf_in_pf++) {
> +		err = set_vf_mbox_random_id(hwdev, hinic_glb_pf_vf_offset
> +					    (hwdev->hwif) + vf_in_pf);

Parenthesis around hwdev->hwif not necessary

> +		if (err)
> +			break;
> +	}
> +
> +	if (err == HINIC_MGMT_CMD_UNSUPPORTED) {
> +		hwdev->func_to_func->support_vf_random = false;

So all VFs need to support the feature for it to be used?

> +		err = 0;
> +		dev_warn(&hwdev->hwif->pdev->dev, "Mgmt is unsupported to set VF%d random id\n",
> +			 vf_in_pf - 1);
> +	} else if (!err) {
> +		hwdev->func_to_func->support_vf_random = true;
> +		dev_info(&hwdev->hwif->pdev->dev, "PF Set VF random id success\n");

Is this info message really necessary?

> +	}

