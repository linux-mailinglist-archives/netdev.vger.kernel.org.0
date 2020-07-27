Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E139B22F8D7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgG0TSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgG0TSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:18:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE87C061794;
        Mon, 27 Jul 2020 12:18:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C26B12763789;
        Mon, 27 Jul 2020 12:01:52 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:18:36 -0700 (PDT)
Message-Id: <20200727.121836.2197759951419525125.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH net-next] qed: fix the allocation of the chains with an
 external PBL
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200727115133.1631-1-alobakin@marvell.com>
References: <20200727115133.1631-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:01:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Mon, 27 Jul 2020 14:51:33 +0300

> Dan reports static checker warning:
> 
> "The patch 9b6ee3cf95d3: "qed: sanitize PBL chains allocation" from Jul
> 23, 2020, leads to the following static checker warning:
> 
> 	drivers/net/ethernet/qlogic/qed/qed_chain.c:299 qed_chain_alloc_pbl()
> 	error: uninitialized symbol 'pbl_virt'.
> 
> drivers/net/ethernet/qlogic/qed/qed_chain.c
>    249  static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
>    250  {
>    251          struct device *dev = &cdev->pdev->dev;
>    252          struct addr_tbl_entry *addr_tbl;
>    253          dma_addr_t phys, pbl_phys;
>    254          __le64 *pbl_virt;
>                 ^^^^^^^^^^^^^^^^
> [...]
>    271          if (chain->b_external_pbl)
>    272                  goto alloc_pages;
>                         ^^^^^^^^^^^^^^^^ uninitialized
> [...]
>    298                  /* Fill the PBL table with the physical address of the page */
>    299                  pbl_virt[i] = cpu_to_le64(phys);
>                         ^^^^^^^^^^^
> [...]
> "
> 
> This issue was introduced with commit c3a321b06a80 ("qed: simplify
> initialization of the chains with an external PBL"), when
> chain->pbl_sp.table_virt initialization was moved up to
> qed_chain_init_params().
> Fix it by initializing pbl_virt with an already filled chain struct field.
> 
> Fixes: c3a321b06a80 ("qed: simplify initialization of the chains with an external PBL")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>

Applied, thank you.
