Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF83352081F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiEIXJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiEIXJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382EB2C5120;
        Mon,  9 May 2022 16:05:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4864B81982;
        Mon,  9 May 2022 23:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AF2C385B3;
        Mon,  9 May 2022 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652137504;
        bh=CHx03g61aaqthzI5PRn6MxsxEayjKCY8kwxtYMe4234=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P4C+PPPDXm27+vdlTg1yXQJ2DpsA6H3/EmH+29AjiHC7iRqDAK8tq9x9TzLna2lGg
         dyO3hNV3PQJjg+4e8hxV9XSZsxZLTtchsfx01MlMtsuj7DS2Q3zw481bI2eIGe9jw6
         cS18m0ultVpU5fTD7hBb/8jyiUtuVo37oX3G0YinJwm9aoPr7ZCzG+Cw9bbtPINgyA
         mhSO+/96kLEjAe6iC0h8YJ+h+LUsNljwz0ZjFKAQaEzvovGTr4QYytiaz0z9GaAfXE
         ki1g6kw8ChZzqNMD8IzHhPx1NuqDMC+h61j7E92UV6z+XgifPiOt1XcN0Q+dpGabMu
         D4fJtctVfLZRg==
Date:   Mon, 9 May 2022 16:05:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zixuan Fu <r33s3n6@gmail.com>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH] driver: net: vmxnet3: fix possible use-after-free bugs
 in vmxnet3_rq_alloc_rx_buf()
Message-ID: <20220509160502.07f62963@kernel.org>
In-Reply-To: <20220506123118.2778522-1-r33s3n6@gmail.com>
References: <20220506123118.2778522-1-r33s3n6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 May 2022 20:31:18 +0800 Zixuan Fu wrote:
> In vmxnet3_rq_alloc_rx_buf(), when dma_map_single() fails, rbi->skb is
> freed immediately. Similarly, in another branch, when dma_map_page() fails,
> rbi->page is also freed. In the two cases, vmxnet3_rq_alloc_rx_buf()
> returns an error to its callers vmxnet3_rq_init() -> vmxnet3_rq_init_all()
> -> vmxnet3_activate_dev(). Then vmxnet3_activate_dev() calls  
> vmxnet3_rq_cleanup_all() in error handling code, and rbi->skb or rbi->page
> are freed again in vmxnet3_rq_cleanup_all(), causing use-after-free bugs.
> 
> To fix these possible bugs, rbi->skb and rbi->page should not be freed in 
> mxnet3_rq_alloc_rx_buf() when dma_map_single() fails.

You should not leave unmapped data on the ring. Freeing is fine, just
make sure the pointer is cleared.

> The error log in our fault-injection testing is shown as follows:
> 
> [   14.319016] BUG: KASAN: use-after-free in consume_skb+0x2f/0x150
> ...
> [   14.321586] Call Trace:
> ...
> [   14.325357]  consume_skb+0x2f/0x150
> [   14.325671]  vmxnet3_rq_cleanup_all+0x33a/0x4e0 [vmxnet3]
> [   14.326150]  vmxnet3_activate_dev+0xb9d/0x2ca0 [vmxnet3]
> [   14.326616]  vmxnet3_open+0x387/0x470 [vmxnet3]
> ...
> [   14.361675] Allocated by task 351:
> ...
> [   14.362688]  __netdev_alloc_skb+0x1b3/0x6f0
> [   14.362960]  vmxnet3_rq_alloc_rx_buf+0x1b0/0x8d0 [vmxnet3]
> [   14.363317]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
> [   14.363661]  vmxnet3_open+0x387/0x470 [vmxnet3]
> ...
> [   14.367309] 
> [   14.367412] Freed by task 351:
> ...
> [   14.368932]  __dev_kfree_skb_any+0xd2/0xe0
> [   14.369193]  vmxnet3_rq_alloc_rx_buf+0x71e/0x8d0 [vmxnet3]
> [   14.369544]  vmxnet3_activate_dev+0x3e3/0x2ca0 [vmxnet3]
> [   14.369883]  vmxnet3_open+0x387/0x470 [vmxnet3]
> [   14.370174]  __dev_open+0x28a/0x420
> [   14.370399]  __dev_change_flags+0x192/0x590
> [   14.370667]  dev_change_flags+0x7a/0x180
> [   14.370919]  do_setlink+0xb28/0x3570
> [   14.371150]  rtnl_newlink+0x1160/0x1740
> [   14.371399]  rtnetlink_rcv_msg+0x5bf/0xa50
> [   14.371661]  netlink_rcv_skb+0x1cd/0x3e0
> [   14.371913]  netlink_unicast+0x5dc/0x840
> [   14.372169]  netlink_sendmsg+0x856/0xc40
> [   14.372420]  ____sys_sendmsg+0x8a7/0x8d0
> [   14.372673]  __sys_sendmsg+0x1c2/0x270
> [   14.372914]  do_syscall_64+0x41/0x90
> [   14.373145]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> ...
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index d9d90baac72a..f17e9871ba27 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -588,7 +588,6 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
>  						DMA_FROM_DEVICE);
>  				if (dma_mapping_error(&adapter->pdev->dev,
>  						      rbi->dma_addr)) {
> -					dev_kfree_skb_any(rbi->skb);
>  					rq->stats.rx_buf_alloc_failure++;
>  					break;
>  				}
> @@ -612,7 +611,6 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
>  						DMA_FROM_DEVICE);
>  				if (dma_mapping_error(&adapter->pdev->dev,
>  						      rbi->dma_addr)) {
> -					put_page(rbi->page);
>  					rq->stats.rx_buf_alloc_failure++;
>  					break;
>  				}
