Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4337D45DE51
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356318AbhKYQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhKYQJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 11:09:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D0E60524;
        Thu, 25 Nov 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637856399;
        bh=+SEvyUrYH1aOLZEA1vLelQO7GzV7xXumt0EtC75gsus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GBZ3/dXcvMhmWwa+mmwxGSoB0Rhid4s/ZWG294oIXldP6RPRqiPVr84W9FFfMPc3b
         97pAFGfLbMT5MLidcaPzA1WfFd7G8EGnPHjntoPojosHUXj1jLRNEI42QP575UztCn
         Roz5JNDDfSb42bOUQUFpeOqGV1X223GEpB9wO9CKisvk0Yv32ABqFLBcrZefDDlOXX
         vilk/LLfl2WzaofxxMm3+dEEp9o2KmoS+B3jE3vvtkFZljtK/f0msaTIP2PchviGfy
         nQkkkij3EjYyWxOVuO3chK4NDzbVRUdoR7dMnjPxhE0xlwa7488EzqLH7GzPFfRygp
         t7l9Tn00JnasA==
Date:   Thu, 25 Nov 2021 08:06:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v2] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211125080638.33f02773@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125124713.9410-1-lschlesinger@drivenets.com>
References: <20211125124713.9410-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 14:47:13 +0200 Lahav Schlesinger wrote:
> +static int rtnl_list_dellink(struct net *net, void *ifindex_list, int size)

s/ifindex_list/ifindices/ ? it's not really a list

Can we make it an int pointer so we don't have to cast it later?

> +{
> +	const int num_devices = size / sizeof(int);
> +	struct net_device **dev_list;
> +	LIST_HEAD(list_kill);
> +	int i, ret;
> +
> +	if (size < 0 || size % sizeof(int))

Does core reject size == 0? It won't be valid either.

> +		return -EINVAL;
> +
> +	dev_list = kmalloc_array(num_devices, sizeof(*dev_list), GFP_KERNEL);
> +	if (!dev_list)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_devices; i++) {
> +		const struct rtnl_link_ops *ops;
> +		struct net_device *dev;
> +
> +		ret = -ENODEV;
> +		dev = __dev_get_by_index(net, ((int *)ifindex_list)[i]);
> +		if (!dev)
> +			goto out_free;
> +
> +		ret = -EOPNOTSUPP;
> +		ops = dev->rtnl_link_ops;
> +		if (!ops || !ops->dellink)
> +			goto out_free;
> +
> +		dev_list[i] = dev;
> +	}
> +
> +	for (i = 0; i < num_devices; i++) {
> +		const struct rtnl_link_ops *ops;
> +		struct net_device *dev;

the temp variables are unnecessary here, the whole thing comfortably
fits on a line:

		dev->rtnl_link_ops->dellink(dev_list[i], &list_kill);

> +		dev = dev_list[i];
> +		ops = dev->rtnl_link_ops;
> +		ops->dellink(dev, &list_kill);
> +	}
> +
> +	unregister_netdevice_many(&list_kill);
> +
> +	ret = 0;
> +
> +out_free:
> +	kfree(dev_list);
> +	return ret;
> +}
