Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691CF6877C1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjBBIo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBBIot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:44:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B886276
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:44:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FF82B8253D
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C53C4339B;
        Thu,  2 Feb 2023 08:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327484;
        bh=ZDfAsWQ9wIyu/IUtUIhVjLwt2yIX5cmNBLoEx4usywQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=emvrQGqWYT21lrsNWhMlwXTj3wYZqyEix6B4kQzqGPJjdf/YK8Ns8AtotFVvV3NZl
         YHsLEINrbjPJaSGliFPUFjHv/KHOi4CIwDx6NIimoNaVifvD4n9repA4yEiVm/j/xl
         MKgt9w7hcEx2lNUXbe/oStjoGDInG8fj56nwDnxh4lirvJb4JmKQzIziwq5892aqg/
         s4PBBIYoYdV4PaXAKzMr8qCWCdEDHAEwv2V3u1kb/SPwB9jLdEBYGc3Jvfd8nT+vqJ
         X8cuEcJT7E5oLLYcMowy2U9xv9ZzFVRElPskG/oFeUjNwGnEpQQZizlUXSkpWxOsR+
         3WkEJyK+Daoxw==
Date:   Thu, 2 Feb 2023 10:44:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Message-ID: <Y9t396bngCYyUR3g@unreal>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-4-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202013002.34358-4-shannon.nelson@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:29:59PM -0800, Shannon Nelson wrote:
> Make sure there are qcqs to clean before trying to swap resources
> or clean their interrupt assignments.
> 
> Fixes: 101b40a0171f ("ionic: change queue count with no reset")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 27 ++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 8499165b1563..c08d0762212c 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -2741,6 +2741,14 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
>  			sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
>  
>  		for (i = 0; i < qparam->nxqs; i++) {
> +			/* If missing, short placeholder qcq needed for swap */
> +			if (!lif->txqcqs[i]) {
> +				flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
> +				err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
> +						      4, desc_sz, comp_sz, sg_desc_sz,
> +						      lif->kern_pid, &lif->txqcqs[i]);

You are not checking return value, so you don't really need to store
returned value in err variable.

Thanks
