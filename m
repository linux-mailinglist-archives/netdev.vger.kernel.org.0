Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0DF234BDE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGaUEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgGaUEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:04:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C5121744;
        Fri, 31 Jul 2020 20:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225844;
        bh=UFX2Vyq3OqWP/oxaNHNwBoCXVkFDa+R+nGngOe84KXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOjkRAw1vzuh2AjUn0E37dHI1+kKkcm+q8ShbnwfTh0UYNAHIe8edVT7oF1nWPxGc
         wrdHq1cGvVsQse5QxF/F1b0SygPTiN1gvydXlXPpLN0zfTpWYakBVp8pNoJe9kdhS2
         H2oaGFv7iiQjLrjryv7snYITqQmmI20fJPtKwYfQ=
Date:   Fri, 31 Jul 2020 13:04:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v4 net-next 04/10] qed: implement devlink info request
Message-ID: <20200731130402.2288f44a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200731055401.940-5-irusskikh@marvell.com>
References: <20200731055401.940-1-irusskikh@marvell.com>
        <20200731055401.940-5-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 08:53:55 +0300 Igor Russkikh wrote:
> Here we return existing fw & mfw versions, we also fetch device's
> serial number.
> 
> The base device specific structure (qed_dev_info) was not directly
> available to the base driver before.
> Thus, here we create and store a private copy of this structure
> in qed_dev root object.

Please include example output of devlink info on you device.

> diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> index a62c47c61edf..57ef2c56c884 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> @@ -45,7 +45,55 @@ static const struct devlink_param qed_devlink_params[] = {
>  			     qed_dl_param_get, qed_dl_param_set, NULL),
>  };
>  
> -static const struct devlink_ops qed_dl_ops;
> +static int qed_devlink_info_get(struct devlink *devlink,
> +				struct devlink_info_req *req,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct qed_devlink *qed_dl = devlink_priv(devlink);
> +	struct qed_dev *cdev = qed_dl->cdev;
> +	struct qed_dev_info *dev_info;
> +	char buf[100];
> +	int err;
> +
> +	dev_info = &cdev->common_dev_info;
> +
> +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
> +	if (err)
> +		return err;
> +
> +	memcpy(buf, cdev->hwfns[0].hw_info.part_num, sizeof(cdev->hwfns[0].hw_info.part_num));
> +	buf[sizeof(cdev->hwfns[0].hw_info.part_num)] = 0;

Part number != serial number. What's the thing you're reporting here
actually identifying.

> +
> +	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
> +		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_3),
> +		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_2),
> +		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_1),
> +		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_0));
> +
> +	err = devlink_info_version_stored_put(req,
> +					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
> +	if (err)
> +		return err;

Assuming MFW means management FW - this looks good.

> +	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
> +		 dev_info->fw_major,
> +		 dev_info->fw_minor,
> +		 dev_info->fw_rev,
> +		 dev_info->fw_eng);
> +
> +	return devlink_info_version_running_put(req,
> +						DEVLINK_INFO_VERSION_GENERIC_FW, buf);

But what's this one?
