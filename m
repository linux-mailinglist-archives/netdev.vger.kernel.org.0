Return-Path: <netdev+bounces-5507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7820C711EB1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09CAF28166A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7981FCF;
	Fri, 26 May 2023 04:14:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0E01C26
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88201C433EF;
	Fri, 26 May 2023 04:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074445;
	bh=XQQ+kgqkZ6yxlcPNw2kRtmV+gbrNBEpPhA9H44tfW8c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P2NRcnEuC+CctA2+4Yluv5ThpN/mAKyz1+OT7psXtE3fIW0NkkeC54/mWPyuGYdzH
	 qOq8kCoM3q1Ljl6bqNy/a+uplX98WLSWfN/THyStwmOK0DWui25PMhSPoRqbrf6CV9
	 OP8j1ZkisGbrIMWN3k/fSfMKhqexNMMY3MXN88kHScJ0ZxMq7EbFjXULa0gWFrlsmL
	 llEbhvgWCMqi5m85lkPDnxXLOiRU3ux4mhiFZ1oFf/4zvPqaoM8WVm4qCC1YEWKLpB
	 Dt5CVtpGGPk7o1CvI45f+axCjVJAectLut93EnpPogJrHYrE7/Qq+ZhAxnRZO30/rH
	 nvwDlhGk3JIXQ==
Date: Thu, 25 May 2023 21:14:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
 andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
 jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
 hkallweit1@gmail.com, linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
 linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v9 8/9] net: txgbe: Implement phylink pcs
Message-ID: <20230525211403.44b5f766@kernel.org>
In-Reply-To: <20230524091722.522118-9-jiawenwu@trustnetic.com>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
	<20230524091722.522118-9-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 17:17:21 +0800 Jiawen Wu wrote:
> +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> +	if (ret)
> +		return ret;
> +
> +	mdiodev = mdio_device_create(mii_bus, 0);
> +	if (IS_ERR(mdiodev))
> +		return PTR_ERR(mdiodev);
> +
> +	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
> +	if (IS_ERR(xpcs)) {
> +		mdio_device_free(mdiodev);
> +		return PTR_ERR(xpcs);
> +	}

How does the mdiodev get destroyed in case of success?
Seems like either freeing it in case of xpcs error is unnecessary 
or it needs to also be freed when xpcs is destroyed?

