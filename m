Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6833D178960
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCDEHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgCDEHr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 23:07:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEE1520CC7;
        Wed,  4 Mar 2020 04:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294866;
        bh=7D3OV679xd9v0u3l7IWpJz6uGwmUPLf3IoK6KvtkFew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BYizjpI+wyoB85Ykztqbb/3kZJGkNy3daxSF0xIH8rIyX6jDAOd1x0ICJTV5ejHJu
         NxVRbjuqdIDRkhCYS/2lrHcUGwlehMO8nH62NHzaXGEImsmyTqhpejwll8zdKw/kr3
         gg7kfK+5Fp/Femo18/8Udr1r5mTSYoTaryfLUSgU=
Date:   Tue, 3 Mar 2020 20:07:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 12/12] virtio_net: reject unsupported
 coalescing params
Message-ID: <20200303200743.35e188c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200304035501.628139-13-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
        <20200304035501.628139-13-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Mar 2020 19:55:01 -0800 Jakub Kicinski wrote:
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/virtio_net.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 84c0d9581f93..cfca3d134d4e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2273,6 +2273,7 @@ static void virtnet_update_settings(struct virtnet_info *vi)
>  }
>  
>  static const struct ethtool_ops virtnet_ethtool_ops = {
> +	.coalesce_types = ETHTOOL_COALESCE_TX_MAX_FRAMES,

Ugh, the last minute addition backfired, virtio_net does not support
changing RX settings, but they must be always configured to 1. This
should have been:

	.coalesce_types = ETHTOOL_COALESCE_MAX_FRAMES,

And the driver does in fact check for unsupported parameters.

>  	.get_drvinfo = virtnet_get_drvinfo,
>  	.get_link = ethtool_op_get_link,
>  	.get_ringparam = virtnet_get_ringparam,

