Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37C32BAEE5
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKTPZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:25:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKTPZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:25:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kg8IG-008857-4u; Fri, 20 Nov 2020 16:25:48 +0100
Date:   Fri, 20 Nov 2020 16:25:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com, kuba@kernel.org,
        mkubecek@suse.cz
Subject: Re: [RFC V2 net-next 1/2] ethtool: add support for controling the
 type of adaptive coalescing
Message-ID: <20201120152548.GN1853236@lunn.ch>
References: <1605853479-4483-1-git-send-email-tanhuazhong@huawei.com>
 <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1605853479-4483-2-git-send-email-tanhuazhong@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -310,6 +334,13 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
>  	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
>  	if (ret < 0)
>  		goto out_ops;
> +
> +	if (ops->set_ext_coalesce) {
> +		ret = ops->set_ext_coalesce(dev, &ext_coalesce);
> +		if (ret < 0)
> +			goto out_ops;
> +	}
> +

The problem here is, if ops->set_ext_coalesce() fails, you need to
undo what dev->ethtool_ops->set_coalesce() did. From the users
perspective, this should be atomic. It does everything, or it does
nothing and returns an error code.

And that is not easy given this structure of two op calls.

    Andrew
