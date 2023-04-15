Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9C26E2E76
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDOCEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjDOCEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:04:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E0C4ECE;
        Fri, 14 Apr 2023 19:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABDC1616C5;
        Sat, 15 Apr 2023 02:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B6AC433EF;
        Sat, 15 Apr 2023 02:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681524288;
        bh=Csm4EYNPLH6QAZF7fKplciWMsh1+01xrJCMQTRnwAbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RhYpD9NArgG25ROMmPONTZjEGRElfFECaIblJ4IPQbzIKBs1VtlrQBxYhe25MR071
         LNkO8V8FsM/tURYjuEs4D3jWv23lhheKb3FSs53/2iox36aQqYlRh38VXOtMCKFID9
         CAREmcgqd7DhohfE5cAStOWasKW4A7WBK+ZbQHPX81Of04obpMpBRXapsEV4p2kl5H
         e1qg6jiRBiIGGuGiXpc+vjASeN0jFEJmzhYiyWbQcNWY8ndFl/3tnZlJxarsVqOcnx
         WleK0V84ADhuikD+T7G5EBuul9q8+9/JJpGCpUVi9grso/Ey25uVtVKZ9qeXcp4itR
         5Gun3kpPNSTgw==
Date:   Fri, 14 Apr 2023 19:04:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230414190446.719f651f@kernel.org>
In-Reply-To: <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 14:16:01 -0700 Haiyang Zhang wrote:
> +/* Allocate frag for rx buffer, and save the old buf */
> +static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq,

The fill function is spelled with a _ between rx and oob,
please be consistent. 

> +			      struct mana_recv_buf_oob *rxoob, void **old_buf)
> +{
> +	dma_addr_t da;
> +	void *va;
> +
> +	va = mana_get_rxfrag(rxq, dev, &da, true);
> +

no empty lines between function call and error check.
Please fix this in all the code this patch set is touching.

> +	if (!va)
> +		return;
