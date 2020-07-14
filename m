Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1074421F990
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgGNShO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgGNShO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:37:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AF02242E;
        Tue, 14 Jul 2020 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751833;
        bh=BKAb98muHn6GmBF50FO655h4SFC2eTpInAM6XtGNvMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z/8VB7+4yVBSumjQdzo5+PFy6GSvnetzXN7yLBLJbxrPW+7vue0AREnv0/u1JI0NJ
         ZOiE0nCvDeW3mj0AV18u/qvi1rzK2YDyJBEAoWDZLhz+OSCUZH3PClMCMp5LkLnUWu
         6y21BdwuEYWy9Vfl6xfF+cU/xLsLE8DHg+xOOqRo=
Date:   Tue, 14 Jul 2020 11:37:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v2] hinic: add firmware update support
Message-ID: <20200714113711.32107a16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714125433.18126-1-luobin9@huawei.com>
References: <20200714125433.18126-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 20:54:33 +0800 Luo bin wrote:
> add support to update firmware by the devlink flashing API
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Minor nits below, otherwise I think this looks good.

> +static int hinic_firmware_update(struct hinic_devlink_priv *priv,
> +				 const struct firmware *fw)
> +{
> +	struct host_image_st host_image;
> +	int err;
> +
> +	memset(&host_image, 0, sizeof(struct host_image_st));
> +
> +	if (!check_image_valid(priv, fw->data, fw->size, &host_image) ||
> +	    !check_image_integrity(priv, &host_image, FW_UPDATE_COLD) ||
> +	    !check_image_device_type(priv, host_image.device_id))

These helpers should also set an appropriate message in extack, so the
user can see it on the command line / inside their application.

> +		return -EINVAL;
> +
> +	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware begin\n");
> +
> +	err = hinic_flash_fw(priv, fw->data, &host_image);
> +	if (err) {
> +		if (err == HINIC_FW_DISMATCH_ERROR)
> +			dev_err(&priv->hwdev->hwif->pdev->dev, "Firmware image doesn't match this card, please use newer image, err: %d\n",

Here as well - please make sure to return an error messages through
extack.

> +				err);
> +		else
> +			dev_err(&priv->hwdev->hwif->pdev->dev, "Send firmware image data failed, err: %d\n",
> +				err);
> +		return err;
> +	}
> +
> +	dev_info(&priv->hwdev->hwif->pdev->dev, "Flash firmware end\n");
> +
> +	return 0;
> +}

> @@ -1086,6 +1090,17 @@ static int nic_dev_init(struct pci_dev *pdev)
>  		return PTR_ERR(hwdev);
>  	}
>  
> +	devlink = hinic_devlink_alloc();
> +	if (!devlink) {
> +		dev_err(&pdev->dev, "Hinic devlink alloc failed\n");
> +		err = -ENOMEM;
> +		goto err_devlink_alloc;
> +	}
> +
> +	priv = devlink_priv(devlink);
> +	priv->hwdev = hwdev;
> +	priv->devlink = devlink;

No need to remember the devlink pointer here, you can use
priv_to_devlink(priv) to go from priv to devlink.

> +
>  	num_qps = hinic_hwdev_num_qps(hwdev);
>  	if (num_qps <= 0) {
>  		dev_err(&pdev->dev, "Invalid number of QPS\n");
