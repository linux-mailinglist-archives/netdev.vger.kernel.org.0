Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8B86A0A34
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjBWNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbjBWNN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:13:27 -0500
X-Greylist: delayed 124 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 05:13:03 PST
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2EB49892
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:13:03 -0800 (PST)
Message-ID: <22cff730-f1f1-8352-03a2-2180aadec88d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677157911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TfqYANveQjWMETUPAwLIcizyMNVALIaHOY3hhYjq5Zg=;
        b=W39nQLpbO0QDJXXfSXuruFtCHw3j9wm3RMKqGIsRbpMIQleWXh7NQRrWtfpYTbmlW2oPrk
        b5TfuFqOCcSl0rTbQG+UhP8U+p516bYzjFISn3Ngp4wWVuLG+ww+hY/a0JVCTbNfMoFAAK
        7j4O6JerHOANGilC9mjrWKz3aReQ37I=
Date:   Thu, 23 Feb 2023 21:11:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 3/8] RDMA/nldev: Add dellink function pointer
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-4-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-4-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/2/14 14:06, Zhu Yanjun 写道:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> The newlink function pointer is added. And the sock listening on port 4791
> is added in the newlink function. So the dellink function is needed to
> remove the sock.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/core/nldev.c | 6 ++++++
>   include/rdma/rdma_netlink.h     | 2 ++
>   2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index d5d3e4f0de77..97a62685ed5b 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -1758,6 +1758,12 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
>   		return -EINVAL;
>   	}
>   
> +	if (device->link_ops) {
> +		err = device->link_ops->dellink(device);
> +		if (err)
> +			return err;
> +	}
> +
>   	ib_unregister_device_and_put(device);
>   	return 0;
>   }
> diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> index c2a79aeee113..bf9df004061f 100644
> --- a/include/rdma/rdma_netlink.h
> +++ b/include/rdma/rdma_netlink.h
> @@ -5,6 +5,7 @@
>   
>   #include <linux/netlink.h>
>   #include <uapi/rdma/rdma_netlink.h>
> +#include <rdma/ib_verbs.h>
>   
>   enum {
>   	RDMA_NLDEV_ATTR_EMPTY_STRING = 1,
> @@ -114,6 +115,7 @@ struct rdma_link_ops {
>   	struct list_head list;
>   	const char *type;
>   	int (*newlink)(const char *ibdev_name, struct net_device *ndev);
> +	int (*dellink)(struct ib_device *dev);
>   };
>   
>   void rdma_link_register(struct rdma_link_ops *ops);

