Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361B454203A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383979AbiFHATa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588539AbiFGXyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C3BFAA44;
        Tue,  7 Jun 2022 16:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 276E2B8245D;
        Tue,  7 Jun 2022 23:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731DCC3411C;
        Tue,  7 Jun 2022 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654643654;
        bh=HyJ/pBoolQywSI16EFt/cD0D9gnRf8vXON8lajK+0hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N46ZeFPhZrGOntfcSegxbZEKFrqlAdTxHgD+gMoUPhPncHMM8uEGZOjxi8Q+V/f6O
         4zZ+GBKyTQMIqokmuf0/1ole1b2h53PMkgRafFtzuETA3haeq2Vimi/g2/RuCBDwni
         Mlzp231tNQPOfvdCG0iv7epy1pIsqSMMTU+epl5bCcbJjGER99bnPsba1N+o5KNfrZ
         IloRN+j1Pm3t/VGnVKEdQonjrA0MJeCyex04r1iG3FGJl90OyNgi9y7Sc6x23DJcwv
         Jds7aHs+0vS1mnn+UjLgNNfKwqAhvAE1IT2X3D5C6zeuN0wgN2fMPqjaImlQbpa+ED
         PVBZJI+eQ/rBw==
Date:   Tue, 7 Jun 2022 16:14:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com
Subject: Re: [PATCH v4] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
Message-ID: <20220607161413.655dd63f@kernel.org>
In-Reply-To: <1654558751-3702-1-git-send-email-chen45464546@163.com>
References: <20220606143437.25397f08@kernel.org>
        <1654558751-3702-1-git-send-email-chen45464546@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Jun 2022 07:39:11 +0800 Chen Lin wrote:
> +static inline void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)

No need for inline, compiler will inline this anyway.

> +{
> +	void *data;

unsigned long data; then you can move the cast from the long line to
the return statement, saving us from the strange indentation.

> +	data = (void *)__get_free_pages(gfp_mask |
> +			  __GFP_COMP | __GFP_NOWARN,
> +			  get_order(mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH)));
> +
> +	return data;
> +}
