Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E82E03B9
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLVBSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgLVBSS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D47622B3B;
        Tue, 22 Dec 2020 01:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608599857;
        bh=wti+R8Pia1qW5WBqV75vnMZuuA/CzuCLXmaOZ/5pZjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MdiaXd4bYa33oErIFi1M8Hu0zMZ+J5NNIZvHd1I1s+o9uzN5jJINSCI1FKRqOBK4A
         lVW5sUHGTNyUMMX4YOt5BnqRAcMKxAkvaH147PIpfwd8ytR1CV+XZXFybJP3HtqeZv
         +cNY26gbir2t1A6ejHX8lE2Zy5jy8TNRYgPYx4JZeiZttSjrw5NuG1CyrLNqrvmnBA
         dbBq1vA0LFu8Jj5GXvDVC2NcCuKG6z/wGeCnwoMnbPm60AEHCJgLemCB/NDIJHz3KM
         KFwzEU71yzkmqMfxiL/E8bOu43IJWRbuO5zab9os/4LDipbVWyJCJsS0TgYMi7s7X1
         dMN4+TdrUXzAA==
Date:   Mon, 21 Dec 2020 17:17:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] sch_htb: Hierarchical QoS hardware
 offload
Message-ID: <20201221171736.6f5ebe1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215074213.32652-4-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
        <20201215074213.32652-4-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 09:42:11 +0200 Maxim Mikityanskiy wrote:
> +	q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
> +
> +	if (q->offload) {
> +		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
> +			return -EOPNOTSUPP;

Is there a check somewhere making sure this is the root?

> +		q->num_direct_qdiscs = dev->real_num_tx_queues;

Why real_num_tx_queues? How do you handle queue count changes?

> +		q->direct_qdiscs = kcalloc(q->num_direct_qdiscs,
> +					   sizeof(*q->direct_qdiscs),
> +					   GFP_KERNEL);
> +		if (!q->direct_qdiscs)
> +			return -ENOMEM;
> +	}

I can't quite parse after 20 minutes of staring at this code what the
relationship between the device queues and classes is. Is there any
relationship between real_num_tx_queues and classes?
