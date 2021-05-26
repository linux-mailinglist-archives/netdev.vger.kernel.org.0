Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AA2392374
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 01:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhEZX6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 19:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhEZX6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 19:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 238E161009;
        Wed, 26 May 2021 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622073395;
        bh=90ckNSIPb73zG3mK/1uWcIJ3nmfL8eWPcIaML/PBSso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FCsvgGvE/8Bg5YahprFy0gjbXeipJl6ciyHLSV36/RSzM2Ovvkd2iGI6MP700lRP2
         LXjSk9qcFDiYRgTS4Fe5KeISbIiMb9MhjfH2gV/0ndv3WtIGtDPkm7LIMN5QVpPLH2
         im7pzFStYAoMjVCFx/9acdBwfB1cLp7rA7bg+TMxQMQe72eJ/i5BU/z72fJw0OFqE9
         kIgyTewfh48xb5EeFUPhI/WOjrk95PRlo05YIFhIFT+TQZpxQ0lI39sD3lXAdMdkMt
         ZFixI0T2QmBXWsa/q8ykLUDXAmAovEeDcCQMkRVdlvyJRxwKS1fstUxuWLOqVU0THM
         iy2YF82wnhbJw==
Date:   Wed, 26 May 2021 16:56:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
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
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC net-next 1/4] ethtool: extend coalesce API
Message-ID: <20210526165633.3f7982c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1622021262-8881-2-git-send-email-tanhuazhong@huawei.com>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
        <1622021262-8881-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 17:27:39 +0800 Huazhong Tan wrote:
> @@ -606,8 +611,12 @@ struct ethtool_ops {
>  			      struct ethtool_eeprom *, u8 *);
>  	int	(*set_eeprom)(struct net_device *,
>  			      struct ethtool_eeprom *, u8 *);
> -	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
> -	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
> +	int	(*get_coalesce)(struct net_device *,
> +				struct netlink_ext_ack *,

ext_ack is commonly the last argument AFAIR.

> +				struct kernel_ethtool_coalesce *);

Seeing all the driver changes I can't say I'm a huge fan of 
the encapsulation. We end up with a local variable for the "base"
structure, e.g.:

 static int wil_ethtoolops_set_coalesce(struct net_device *ndev,
-				       struct ethtool_coalesce *cp)
+				       struct netlink_ext_ack *extack,
+				       struct kernel_ethtool_coalesce *cp)
 {
+	struct ethtool_coalesce *coal_base = &cp->base;
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;

so why not leave the base alone and pass the new members in a separate
structure?

> +	int	(*set_coalesce)(struct net_device *,
> +				struct netlink_ext_ack *,
> +				struct kernel_ethtool_coalesce *);
>  	void	(*get_ringparam)(struct net_device *,
>  				 struct ethtool_ringparam *);
>  	int	(*set_ringparam)(struct net_device *,

>  static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
>  						   void __user *useraddr)
>  {
> -	struct ethtool_coalesce coalesce;
> +	struct kernel_ethtool_coalesce coalesce;
>  	int ret;
>  
>  	if (!dev->ethtool_ops->set_coalesce)
>  		return -EOPNOTSUPP;
>  
> -	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
> +	if (copy_from_user(&coalesce.base, useraddr, sizeof(coalesce.base)))
>  		return -EFAULT;
>  
>  	if (!ethtool_set_coalesce_supported(dev, &coalesce))
>  		return -EOPNOTSUPP;
>  
> -	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
> +	ret = dev->ethtool_ops->set_coalesce(dev, NULL, &coalesce);
>  	if (!ret)
>  		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
>  	return ret;

Should IOCTL overwrite the settings it doesn't know about with 0 
or preserve the existing values?
