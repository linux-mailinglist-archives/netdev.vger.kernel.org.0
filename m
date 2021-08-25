Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB493F7806
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240844AbhHYPJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231995AbhHYPJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 11:09:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3B761100;
        Wed, 25 Aug 2021 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629904150;
        bh=8tsHrftLkYibnSX9r9OAwrT38gSVSfWcUHnYVtmUTa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tu7RZK21d0H1tc3JOIuf2KkV5FFDoSNqop7FDWLiA6zm2uBrokG7amkPLw+d4PVrj
         Jejd6SV63pC/Y53J84fjRT3zayzOjKelYEUryeiiFG1aArhEexHQKoYtUr5i2SM3TG
         g7Z7/fCLyJKc+8V2Vn5FcjIT8ZIO5WNB+3+eaoUB8CYZhGpTOFnHEePF6KeVBZoAss
         GF8C7vk9mvMIInHyTnh66UZZWSrjxmEba4F9Jfg1gyGZFREGjoITAwAu33Q3micZUs
         PLY3XXKPw/ZlIYRhRxWkXKGMlodqAV3pcy5WewWfC9rxsObb/RdTnpNj/5eKFeTS/S
         4+IDAKe54HUqA==
Date:   Wed, 25 Aug 2021 08:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [PATCH net-next 3/5] ethtool: add support to set/get rx buf len
Message-ID: <20210825080908.1a5690a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629873655-51539-4-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
        <1629873655-51539-4-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 14:40:53 +0800 Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add support to set rx buf len via ethtool -G parameter and get
> rx buf len via ethtool -g parameter.
> 
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 266e95e4fb33..6e26586274b3 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -516,6 +516,7 @@ struct ethtool_coalesce {
>   *	jumbo ring
>   * @tx_pending: Current maximum supported number of pending entries
>   *	per TX ring
> + * @rx_buf_len: Current supported size of rx ring BD buffer.

How about "Current length of buffers on the rx ring"?

>   * If the interface does not have separate RX mini and/or jumbo rings,
>   * @rx_mini_max_pending and/or @rx_jumbo_max_pending will be 0.
> @@ -533,6 +534,7 @@ struct ethtool_ringparam {
>  	__u32	rx_mini_pending;
>  	__u32	rx_jumbo_pending;
>  	__u32	tx_pending;
> +	__u32	rx_buf_len;
>  };

You can't extend this structure, because it's used by the IOCTL
interface directly. You need to pass the new value to the drivers 
in a different way. You can look at what Yufeng Mo did recently
for an example approach.

> @@ -105,6 +109,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>  	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
> +	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = { .type = NLA_U32 },

We should prevent user space for passing 0 as input, so we can use it
as a special value in the kernel. NLA_POLICY_MIN()

>  };
>  
>  int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
> @@ -142,6 +147,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>  	ethnl_update_u32(&ringparam.rx_jumbo_pending,
>  			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
>  	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
> +	ethnl_update_u32(&ringparam.rx_buf_len,
> +			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
>  	ret = 0;
>  	if (!mod)
>  		goto out_ops;

We need a way of preventing drivers which don't support the new option
from just silently ignoring it. Please add a capability like
cap_link_lanes_supported and reject non-0 ETHTOOL_A_RINGS_RX_BUF_LEN
if it's not set.
