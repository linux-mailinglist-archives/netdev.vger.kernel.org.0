Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1EF678DDC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjAXCDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAXCDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA4B558A
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE7861047
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF37DC433D2;
        Tue, 24 Jan 2023 02:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674525825;
        bh=Qm2RVQnRVcS1Hdk1zUJnZqnxkPF8NbsSubpzlbi0BCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fnDb/NlJNZUBxb+7N63dw3b0fhMCfUsh7hEjbPYzlQJBDm6nRmab1GCJCfftAFhuJ
         2Aya2wovuVEb5nGI/WMNCLP5D7/ZNi6iiqvRz3USqAESDNMVhWn9dXyvW2x+he5Ynm
         vFNM46Ybn6Ioi/oWKrOxlgr5GsPgB+bUS/MhR7NpdynLzAeuLeJq4KLj8xOgi09pDE
         pivGE+0TGpMP5bNBVlq/LxMuhA40wSpHwyFVGPEY/9UhDsD04XDuE6mYvPp+MJLggJ
         sr3mlT8vWcFHw8IbReuqokQs82XV2AFslBNwe0VgCVmCP8+hoxEESv7P4vYKmJ2frQ
         bV5TuFyo+qoSA==
Date:   Mon, 23 Jan 2023 18:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] mlx5: fix skb leak while fifo resync
Message-ID: <20230123180343.0059622e@kernel.org>
In-Reply-To: <8537aa82-8ac9-3f76-c8ae-395a60ccddf8@nvidia.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
        <20230122161602.1958577-3-vadfed@meta.com>
        <8537aa82-8ac9-3f76-c8ae-395a60ccddf8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Jan 2023 14:38:35 +0200 Gal Pressman wrote:
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> > index 11a99e0f00c6..d60bb997c53b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> > @@ -102,6 +102,7 @@ static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
> >  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
> >  		skb_tstamp_tx(skb, &hwts);
> >  		ptpsq->cq_stats->resync_cqe++;
> > +		napi_consume_skb(skb, 1);  
> 
> Was wondering whether we should pass the actual budget here instead of
> 1, but looking at napi_consume_skb() it doesn't really matter..

We should pass the real budget in. The exact value does not matter, 
but it could matter whether it's zero or not. Budget is zero when
NAPI gets polled from an IRQ context.
