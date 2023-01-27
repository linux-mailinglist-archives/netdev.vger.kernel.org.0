Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FFE67DD43
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 06:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbjA0Fz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 00:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjA0FzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 00:55:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3610A3E628;
        Thu, 26 Jan 2023 21:55:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C0B61A04;
        Fri, 27 Jan 2023 05:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E927CC433EF;
        Fri, 27 Jan 2023 05:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674798923;
        bh=Ng3cjHH7fvmWV2oDwptKJzUWLlWm9PT0AunJx1+FGCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+KgUII6hGErmurSPU5xAPx1el3dLYoF65pW9TBM1xzhUgzBDmUhglJr5nvxNYT6J
         UMhgCYzkXE91HE9fzwVxVZ4BzObAe2OEeAJBTAsbQbsJ2CkgGiUUHUbTO6/VhE+WUk
         3mNtSwwloawGfpGm1W00lv3ZN8+Yi9CSnsF/gsKu0HjKcmpq5JobELt2wKF8xPFSk+
         kJZnnzxGBvdSVHO5qjDlzcESS24K2O0cQXG19BfsOQEF02qF11ACRs/DezBwKPf2Ym
         atSxh79XtTa1MqJmt1uMtjc20n9hInvdftu60Mj9Ss9cHxjXoNRkTX7IUTgeYrfH3b
         QHaunO1EF1HYw==
Date:   Fri, 27 Jan 2023 11:25:09 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: qrtr: free memory on error path in
 radix_tree_insert()
Message-ID: <20230127055509.GA7809@thinkpad>
References: <20230125134831.8090-1-n.petrova@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230125134831.8090-1-n.petrova@fintech.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 04:48:31PM +0300, Natalia Petrova wrote:
> Function radix_tree_insert() returns errors if the node hasn't
> been initialized and added to the tree.
> 
> "kfree(node)" and return value "NULL" of node_get() help
> to avoid using unclear node in other calls.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

This patch should also be backported to stable kernels. Could you please add,

Cc: <stable@vger.kernel.org> # 5.7

Thanks,
Mani

> ---
>  net/qrtr/ns.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 1990d496fcfc..e595079c2caf 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -83,7 +83,10 @@ static struct qrtr_node *node_get(unsigned int node_id)
>  
>  	node->id = node_id;
>  
> -	radix_tree_insert(&nodes, node_id, node);
> +	if (radix_tree_insert(&nodes, node_id, node)) {
> +		kfree(node);
> +		return NULL;
> +	}
>  
>  	return node;
>  }
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
