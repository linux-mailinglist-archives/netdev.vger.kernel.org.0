Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D9392388
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhE0ACI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhE0ACH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:02:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC288613BE;
        Thu, 27 May 2021 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622073635;
        bh=2z6iUFSqJV7E/48LptF7faqYhKdXPQRDX1dYgIyTg5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pSFpIAnXDtjFaDyOmEVdl/59zjg1am+1ehAHmYIa6oLdWtNFshsFKhr2QQv8j1yxi
         3B91P+XcEJjoKe6IVc7TDIOtJCjqZTOpPLOpvH12ROg+JZfu72YSGi2NQU8w94Rbp8
         VDrKHKqH0uLQ+YZkZOsl2CDo7e+JXY2GVqUhcPji0yQ+PcffHV3jgqypoOUtcbrMp8
         6O0VNhUPuS9Cbsm64fnU2IkEnP4vno6k85rbEaD1TWQWS5KQ/G5YnRRIgEazGmfYO8
         UoS2CpEz3NErOqiIoiKio58E2AMxnDt9XtRxhik7QDPGc3phSuVT9G+7Lh1ZxSW6CJ
         jB/ruhufHs07w==
Date:   Wed, 26 May 2021 17:00:33 -0700
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
Subject: Re: [RFC net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
Message-ID: <20210526170033.62c8e6eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1622021262-8881-3-git-send-email-tanhuazhong@huawei.com>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
        <1622021262-8881-3-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 17:27:40 +0800 Huazhong Tan wrote:
> Currently, there many drivers who support CQE mode configuration,
> some configure it as a fixed when initialized, some provide an
> interface to change it by ethtool private flags. In order make it
> more generic, add 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
> 'ETHTOOL_A_COALESCE_USE_CQE_RX' attribute and expand struct
> kernel_ethtool_coalesce with use_cqe_mode_tx and use_cqe_mode_rx,
> then these parameters can be accessed by ethtool netlink coalesce
> uAPI.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 25131df..975394e 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -937,6 +937,8 @@ Kernel response contents:
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
>    ===========================================  ======  =======================
>  
>  Attributes are only included in reply if their value is not zero or the
> @@ -975,6 +977,8 @@ Request contents:
>    ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>    ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>    ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
>    ===========================================  ======  =======================
>  
>  Request is rejected if it attributes declared as unsupported by driver (i.e.

You need to thoroughly document the semantics. Can you point us to
which drivers/devices implement similar modes of operation (if they
exist we need to make sure semantics match)?

> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 1030540..9d0a386 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -179,6 +179,8 @@ __ethtool_get_link_ksettings(struct net_device *dev,
>  
>  struct kernel_ethtool_coalesce {
>  	struct ethtool_coalesce	base;
> +	__u32	use_cqe_mode_tx;
> +	__u32	use_cqe_mode_rx;

No __ in front, this is not a user space structure.
Why not bool or a bitfield?

>  };
>  
>  /**

> @@ -216,6 +223,8 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
>  	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
>  	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
>  	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },

This needs a policy to make sure values are <= 1.
