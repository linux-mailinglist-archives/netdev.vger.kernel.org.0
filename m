Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043C91CBA14
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgEHVt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:49:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C703921655;
        Fri,  8 May 2020 21:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588974598;
        bh=qkUTRLFzcDxgORfpd+BCzu4AQ/LotKSi2xDg0Aqh5Is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UHYOPg40kPT5bYMEEAeNbyA+aZeFkKmexvZ20xB9xEwmwkigFcWeY9vFrgfRa78aX
         adsRCEaL7y3uwSHoxmKkZi5+3EjYFlyWQwX9tlH9F1u+VOtoPOjHBu3Nt7ORDF4L7Y
         fwoj4ErTR6pTR+BWd6qE0lrR3KdUfv5QOkzkdfuw=
Date:   Fri, 8 May 2020 14:49:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v1] hinic: add three net_device_ops of vf
Message-ID: <20200508144956.19d2af7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507182119.20494-1-luobin9@huawei.com>
References: <20200507182119.20494-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 18:21:19 +0000 Luo bin wrote:
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> index 564fb2294a29..bc2f87e6cb5d 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
> @@ -627,7 +627,7 @@ wait_for_mbox_seg_completion(struct hinic_mbox_func_to_func *func_to_func,
>  	struct hinic_hwdev *hwdev = func_to_func->hwdev;
>  	struct completion *done = &send_mbox->send_done;
>  	u32 cnt = 0;
> -	ulong jif;
> +	unsigned long jif;
>  
>  	if (poll) {
>  		while (cnt < MBOX_MSG_POLLING_TIMEOUT) {
> @@ -869,7 +869,7 @@ int hinic_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
>  {
>  	struct hinic_recv_mbox *mbox_for_resp;
>  	struct mbox_msg_info msg_info = {0};
> -	ulong timeo;
> +	unsigned long timeo;
>  	int err;
>  
>  	mbox_for_resp = &func_to_func->mbox_resp[dst_func];

Unrelated cleanup.

> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index b66bb86cff96..3d6569d7bac8 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -427,10 +427,6 @@ static int hinic_open(struct net_device *netdev)
>  		goto err_func_port_state;
>  	}
>  
> -	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
> -		/* Wait up to 3 sec between port enable to link state */
> -		msleep(3000);

Why is this no longer needed?

>  	down(&nic_dev->mgmt_lock);
>  
>  	err = hinic_port_link_state(nic_dev, &link_state);

> +	if (link_state == HINIC_LINK_STATE_DOWN) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Link status must be up when setting vf tx rate\n");
> +		return -EPERM;
> +	}

Does this also mean the configuration is lost if link goes down?
