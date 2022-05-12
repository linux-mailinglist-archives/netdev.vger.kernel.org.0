Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77E05258CF
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359687AbiELX6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243920AbiELX6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:58:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9469D21A97D
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5533AB82A03
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967ABC385B8;
        Thu, 12 May 2022 23:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652399924;
        bh=nJNjmeZbumP+3wGIs/KP6olvhCflxq9YKEIBlWt5MUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsUC4M13ALmyVKUyv4hxYNoyfXkMR5A2CEHifO9Mu4bDF9dNv4XjZzMV6UIb0jjHR
         wQ1O8nom6UO5wF0vO8CstZY/MOgCW0klWfuh99ZR6tmD9xL/Vu6iUqvWKvS34oobb2
         xjK22cNVe+JuJvEu/5X7eQx2uop1DjK+FkpUPKcTuOLp7yNTv2eOJkOA/WZ0QPnyYK
         2uVAZWQ3r3LjNOGAlnIBAGZvUKiCHrN+xnD+QOSseoSI3BYWdPgKOnTjApAwtsYv9/
         26ZiB5QSAPyILplAk8rtIYqtog+VPWGkwJmEuzfxE+2CTVR0jljYmp0DtxGUPsOG5+
         9Wfklkve6zYjA==
Date:   Thu, 12 May 2022 16:58:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <Sunil.Goutham@cavium.com>,
        <hkelam@marvell.com>, <colin.king@intel.com>,
        <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH] octeontx2-pf: Add support for adaptive
 interrupt coalescing
Message-ID: <20220512165842.4f0ed0f8@kernel.org>
In-Reply-To: <20220512071912.672009-1-sumang@marvell.com>
References: <20220512071912.672009-1-sumang@marvell.com>
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

On Thu, 12 May 2022 12:49:12 +0530 Suman Ghosh wrote:
> Added support for adaptive IRQ coalescing. It uses net_dim
> algorithm to find the suitable delay/IRQ count based on the
> current packet rate.
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

You still claim this is tested? How can it work if you're not changing
.supported_coalesce_params? Do we have a bug in the core?

> +	/* Check and update coalesce status */
> +	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
> +			OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
> +		priv_coalesce_status = 1;
> +		if (!ec->use_adaptive_rx_coalesce || !ec->use_adaptive_tx_coalesce)
> +			pfvf->flags &= ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
> +	} else {
> +		priv_coalesce_status = 0;
> +		if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)
> +			pfvf->flags |= OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
> +	}

Won't this flip-flop the flag? You should probably reject 
adaptive_rx != adaptive_tx.

>  		/* Re-enable interrupts */
>  		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
> -			     BIT_ULL(0));
> +				BIT_ULL(0));

Unrelated and possibly misalinged?
