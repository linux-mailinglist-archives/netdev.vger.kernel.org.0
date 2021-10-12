Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E748742ABE3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhJLS23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhJLS22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3103560E9C;
        Tue, 12 Oct 2021 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634063186;
        bh=sCtLtyrTYDK6T9KfJRi9mLSdSXF5dAzIexaujeuMwhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VgIJ7Ggz8X3rCYAeSiOVyaLheFHMuqK435HpDMQQpZSzBYDhr8HWL1hoI8Qf9MZs6
         nYpLNHgCjapPb8tYnUb9uSY1U9SS41rii93GT59s2v5awUyxPicE4/KNTb5IEkjaHJ
         GLhHTJmUsXakRhyEAG8I2p537jZzfdtNAUN0SNTb13prkqzHkFrV3Hy7HNL6g1EHxj
         dvbkESXVqEfajGDXoWTtBfx+Q1QviAR6S07fHGFgx+HcG4rpCcfxtOtBslF9KIyqEn
         riha2b6sB2PdwVT07RAAUqWY+1JUGiwcX3pp86/Z8dl1cLbdh1iK85Xh75LPUtHUjx
         ECQlaLVGPVPXQ==
Date:   Tue, 12 Oct 2021 11:26:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
Message-ID: <20211012112624.641ed3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012134127.11761-4-huangguangbin2@huawei.com>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
        <20211012134127.11761-4-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 21:41:24 +0800 Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add support to set rx buf len via ethtool -G parameter and get
> rx buf len via ethtool -g parameter.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>    ====================================  ======  ==========================

Does the documentation build without warnings?

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 266e95e4fb33..83544186cbb5 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -535,6 +535,14 @@ struct ethtool_ringparam {
>  	__u32	tx_pending;
>  };
>  
> +/**
> + * struct ethtool_ringparam_ext - RX/TX ring configuration
> + * @rx_buf_len: Current length of buffers on the rx ring.
> + */
> +struct ethtool_ringparam_ext {
> +	__u32	rx_buf_len;
> +};

This can be moved to include/linux/ethtool.h, user space does not need
to know about this structure.

> +	if (ringparam_ext.rx_buf_len != 0 &&
> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN)) {
> +		ret = -EOPNOTSUPP;
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[ETHTOOL_A_RINGS_RX_BUF_LEN],
> +				    "setting not supported rx buf len");

"setting rx buf len not supported" sounds better

> +		goto out_ops;
> +	}
> +
>  	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
>  	if (ret < 0)
>  		goto out_ops;

