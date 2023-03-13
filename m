Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001AD6B8173
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCMTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCMTJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D557102
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 12:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C69F161461
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 19:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5846C433EF;
        Mon, 13 Mar 2023 19:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678734584;
        bh=3khtob64uBXvckIf4dufyQjeuB+SGmmGMMKn0zv9hhY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uH6GEvPumFTnxFZizlJ1VlzwnWfnSZPgtqhf35ZP0Tmb0BCvoOs/cKXr2VO9mIE3D
         p1dwU+kkFZgzuMhaExLDfk6yHbooURx1kCKnWZD2Hili63YTHLLvUrJ5F6UmiyHEpA
         vK6uw4FjeMdpNpJMelaZfXuLh4RS6+6XU5yqC/2g/uSZDkgrxxH7SGWhaRLI/FHPNN
         QCDPDKqJX+87aZTQCsEAgc6JzVvuDcC32ucKwRp2+pdySuf9/uZ/U6jzvWpaXtp+Sy
         IFT7xTSUyjlyFUwqPq2d8qfqbANS+xR4ZsFwSvXvNbxDIzvWrkltQMwYySRyoD1POn
         3fynKncB/FPkg==
Date:   Mon, 13 Mar 2023 12:09:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Message-ID: <20230313120942.75599b8e@kernel.org>
In-Reply-To: <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
        <20230309131319.2531008-2-shayagr@amazon.com>
        <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
        <20230309225326.2976d514@kernel.org>
        <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
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

On Sun, 12 Mar 2023 14:41:39 +0200 Gal Pressman wrote:
> On 10/03/2023 8:53, Jakub Kicinski wrote:
> > On Thu, 9 Mar 2023 19:15:43 +0200 Gal Pressman wrote:  
> >> I know Jakub prefers the new parameter, but the description of this
> >> still sounds extremely similar to TX copybreak to me..
> >> TX copybreak was traditionally used to copy packets to preallocated DMA
> >> buffers, but this could be implemented as copying the packet to the
> >> (preallocated) WQE's inline part. That usually means DMA memory, but
> >> could also be device memory in this ENA LLQ case.
> >>
> >> Are we drawing a line that TX copybreak is the threshold for DMA memory
> >> and tx_push_buf_len is the threshold for device memory?  
> > 
> > Pretty much, yes. Not an amazing distinction but since TX copybreak can
> > already mean two different things (inline or DMA buf) I'd err on 
> > the side of not overloading it with another one.   
> 
> Can we document that please?

Shay, could you add a paragraph in the docs regarding copybreak in v5?
