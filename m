Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC06A09D5
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbjBWNKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbjBWNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:10:17 -0500
Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [IPv6:2001:41d0:1004:224b::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F43567A7
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:10:12 -0800 (PST)
Message-ID: <611f1770-982a-e09f-bd1e-616dcc2303d4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677157809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymmkMOcLF7AW+Hx15KTLNa7RDkkDpBqEAX76cQN74JE=;
        b=RlbqgkJgPNVZVp7+tB2+oQ0VwYRrg8NqqLBkMQHZA/ik9cDMKQwWQ7vg7D1WozXibClZsO
        p1Q1yE0eaI3l51zUfqKz9+8CdIYgX06y0q6Qcn7Y0+hz0bG5MntFbksXCwuvbdFAVvx06j
        n6Dimlf4/GWYuTe0iYPveMzc1iaKqsE=
Date:   Thu, 23 Feb 2023 21:10:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 1/8] RDMA/rxe: Creating listening sock in newlink
 function
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-2-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-2-yanjun.zhu@intel.com>
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
> Originally when the module rdma_rxe is loaded, the sock listening on udp
> port 4791 is created. Currently moving the creating listening port to
> newlink function.
> 
> So when running "rdma link add" command, the sock listening on udp port
> 4791 is created.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index 136c2efe3466..64644cb0bb38 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -192,6 +192,10 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
>   		goto err;
>   	}
>   
> +	err = rxe_net_init();
> +	if (err)
> +		return err;
> +
>   	err = rxe_net_add(ibdev_name, ndev);
>   	if (err) {
>   		rxe_dbg(exists, "failed to add %s\n", ndev->name);
> @@ -208,12 +212,6 @@ static struct rdma_link_ops rxe_link_ops = {
>   
>   static int __init rxe_module_init(void)
>   {
> -	int err;
> -
> -	err = rxe_net_init();
> -	if (err)
> -		return err;
> -
>   	rdma_link_register(&rxe_link_ops);
>   	pr_info("loaded\n");
>   	return 0;

