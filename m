Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011CF1B2ED6
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgDUSNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgDUSNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 14:13:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DEBF206D5;
        Tue, 21 Apr 2020 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587492834;
        bh=0TT0L66H3oFxmX6WwJme2Bh+aMVhD0ckmx2GZykmn4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tI0tBHitsSsvQV5/YVgJ70h59rYxHJIl5Wm7OUyc/dwDkclA7eB2CdO856exPzXRD
         P1S9HlOcAOIBMbQCEmC7MCaIh6X8yjbvrCoyb2qxVXnSvJy0w87jiwouTfkroN90ci
         LgaS/N9I5EZNcR4mA8MyqKkrYeyAcdgWiSvZTdVY=
Date:   Tue, 21 Apr 2020 11:13:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next 1/3] hinic: add mailbox function support
Message-ID: <20200421111352.263c7cbb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421045635.8128-2-luobin9@huawei.com>
References: <20200421045635.8128-1-luobin9@huawei.com>
        <20200421045635.8128-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020 04:56:33 +0000 Luo bin wrote:
> virtual function and physical function can communicate with each
> other through mailbox channel supported by hw
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

> +static int recv_vf_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
> +				struct hinic_recv_mbox *recv_mbox,
> +				void *buf_out, u16 *out_size)
> +{
> +	hinic_vf_mbox_cb cb;
> +	int ret = 0;
> +
> +	if (recv_mbox->mod >= HINIC_MOD_MAX) {
> +		dev_err(&func_to_func->hwif->pdev->dev, "Receive illegal mbox message, mod = %d\n",
> +			recv_mbox->mod);

You may want to rate limit these, otherwise VF may spam PFs logs.

> +		return -EINVAL;
> +	}

> +static int mbox_func_params_valid(struct hinic_mbox_func_to_func *func_to_func,
> +				  void *buf_in, u16 in_size)
> +{
> +	if (!buf_in || !in_size)
> +		return -EINVAL;

This is defensive programming, we don't do that in the kernel, callers
should not pass NULL buffer and 0 size.

Also you probably want the size to be size_t, otherwise it may get
truncated before the check below.

> +	if (in_size > HINIC_MBOX_DATA_SIZE) {
> +		dev_err(&func_to_func->hwif->pdev->dev,
> +			"Mbox msg len(%d) exceed limit(%d)\n",
> +			in_size, HINIC_MBOX_DATA_SIZE);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int hinic_mbox_to_pf(struct hinic_hwdev *hwdev,
> +		     enum hinic_mod_type mod, u8 cmd, void *buf_in,
> +		     u16 in_size, void *buf_out, u16 *out_size, u32 timeout)
> +{
> +	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
> +	int err = mbox_func_params_valid(func_to_func, buf_in, in_size);
> +
> +	if (err)
> +		return err;
> +
> +	if (!HINIC_IS_VF(hwdev->hwif)) {
> +		dev_err(&hwdev->hwif->pdev->dev, "Params error, func_type: %d\n",
> +			HINIC_FUNC_TYPE(hwdev->hwif));
> +		return -EINVAL;
> +	}
> +
> +	err = hinic_mbox_to_func(func_to_func, mod, cmd,
> +				 hinic_pf_id_of_vf_hw(hwdev->hwif), buf_in,
> +				 in_size, buf_out, out_size, timeout);
> +	return err;

return hinic_mbox_to...

directly

> +}

> +static int comm_pf_mbox_handler(void *handle, u16 vf_id, u8 cmd, void *buf_in,
> +				u16 in_size, void *buf_out, u16 *out_size)
> +{
> +	struct hinic_hwdev *hwdev = handle;
> +	struct hinic_pfhwdev *pfhwdev;
> +	int err = 0;
> +
> +	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
> +
> +	if (cmd == HINIC_COMM_CMD_START_FLR) {
> +		*out_size = 0;
> +	} else {
> +		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
> +					cmd, buf_in, in_size, buf_out, out_size,
> +					HINIC_MGMT_MSG_SYNC);
> +		if (err  && err != HINIC_MBOX_PF_BUSY_ACTIVE_FW)

Double space, please run checkpatch --strict on the patches

> +			dev_err(&hwdev->hwif->pdev->dev,
> +				"PF mbox common callback handler err: %d\n",
> +				err);
> +	}
> +
> +	return err;
> +}
