Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109B96E0DF2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjDMNEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDMNEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:04:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7000B6A42;
        Thu, 13 Apr 2023 06:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E7E61574;
        Thu, 13 Apr 2023 13:04:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4B3C433EF;
        Thu, 13 Apr 2023 13:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681391072;
        bh=45Dth3u/C8VS64hODTY5Dhhg4w/QuvdiQ3hHX+zxnhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BtGbMQ9T+VLC5Hz2tZj+h9EK2KX7RsXaasedk2hn9l8ca7NBMa6tjnyD9JdYaZnxH
         GmpzQjuFwlvR74fZELsiqYV4MhOTOhlRmswSZR5o9CXgNDzdCJO0A0sbUp/LuJ5c5L
         8UrVkagVapbfczpRG/ddGQZAp1tyIdjKleF8FFYxqDFKlw7nGlgYPhO9ENVY1xiEPz
         WuL/JuIEmMfd0Co+O8/srSEv/G3hPPc+BZv4XnE5MqdtTasSeiz5vSupn4PEqHnvGX
         qKfG5BCJn/c03b0ocvumaRKaR9ILH6ai9ryJtW0WM7d1QjUBLPcS1QYNyunZopT9Wj
         sDvfs0hDHZgwg==
Date:   Thu, 13 Apr 2023 16:04:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, longli@microsoft.com,
        ssengar@linux.microsoft.com, linux-rdma@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
        hawk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230413130428.GO17993@unreal>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
 <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 02:16:01PM -0700, Haiyang Zhang wrote:
> Move out common buffer allocation code from mana_process_rx_cqe() and
> mana_alloc_rx_wqe() to helper functions.
> Refactor related variables so they can be changed in one place, and buffer
> sizes are in sync.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> V3:
> Refectored to multiple patches for readability. Suggested by Jacob Keller.
> 
> V2:
> Refectored to multiple patches for readability. Suggested by Yunsheng Lin.
> 
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 154 ++++++++++--------
>  include/net/mana/mana.h                       |   6 +-
>  2 files changed, 91 insertions(+), 69 deletions(-)

<...>

> +static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
> +			     dma_addr_t *da, bool is_napi)
> +{
> +	struct page *page;
> +	void *va;
> +
> +	/* Reuse XDP dropped page if available */
> +	if (rxq->xdp_save_va) {
> +		va = rxq->xdp_save_va;
> +		rxq->xdp_save_va = NULL;
> +	} else {
> +		page = dev_alloc_page();

Documentation/networking/page_pool.rst
   10 Basic use involves replacing alloc_pages() calls with the
   11 page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
   12 replacing dev_alloc_pages().

General question, is this sentence applicable to all new code or only
for XDP related paths?

Thanks
