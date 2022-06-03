Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8070053C391
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 06:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbiFCEYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 00:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiFCEYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 00:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AB435DCB;
        Thu,  2 Jun 2022 21:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F156361687;
        Fri,  3 Jun 2022 04:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43D8C385A9;
        Fri,  3 Jun 2022 04:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654230257;
        bh=VcPv64F+arj4pM7sQW/MRMnr268G7RMioGuGKmtHk1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HDBMkA0+jEtpi4t7vOKaGdzUkAsaY00BCPd5wU8y2xAN7CY0ONP/UwmBqk/AMmdgR
         e/LoAEKtxBkQT4uawhQ/n/sSOnNkltOL+tpo2ADh9bJVIziT1sUkiLRo+/boOnIWXa
         a+Hbb8MzmeNEy4DzOVgykKB6ecY1KvdFDD+AXpiQ08FVTbSVuGAdQDb9eoCDmfI2ES
         dpCjtC3fLce7y2dz/X/gwjSWGhGTUmdrn0CjBVwsx4fnotxRIE8GDLV/tR/Fo1snSd
         8Hq9ywuDwFzujTwvttyy8W8w4I6CubEqL/bsmMRwcEuNi8mhUM0qulhjIfN4tay8BR
         0zp/prdI3fN7g==
Date:   Thu, 2 Jun 2022 21:24:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev_alloc_frag
Message-ID: <20220602212415.71bc5133@kernel.org>
In-Reply-To: <1654229435-2934-1-git-send-email-chen45464546@163.com>
References: <1654229435-2934-1-git-send-email-chen45464546@163.com>
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

On Fri,  3 Jun 2022 12:10:35 +0800 Chen Lin wrote:
> -		ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +		if (ring->frag_size <= PAGE_SIZE)
> +			ring->data[i] = netdev_alloc_frag(ring->frag_size);
> +		else
> +			ring->data[i] = kmalloc(ring->frag_size, GFP_KERNEL);

Is it legal to allocate pages with kmalloc()? I mean they will end up
getting freed by page_frag_free(), not kfree().

Also there's more frag allocations here, search for napi_alloc_frag().

