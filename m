Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6070660FF9B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbiJ0R63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0R61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D141781C6;
        Thu, 27 Oct 2022 10:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1488623A7;
        Thu, 27 Oct 2022 17:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC3C433D6;
        Thu, 27 Oct 2022 17:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666893506;
        bh=5CHCNYh4rHVTPWKhbeifwNLikouiIV39GFNOmLjJyOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b8Uyrz4xrdSNdUZTKWhO81HsQENUaTUZFh4X2b3zePG/N2Qu08luPneNUfA7cVMY2
         +j3U+7BuhoH86ewnfvOYsXk1qZTUP2KDuARVfbhtFmzk0CbsCm6+SXZkzjMbzRumFO
         ptW7MQ992Z8kith8VQlIQx2Oqa6wGWZ9UMrII5/sb2WlPKEkGw+dXWjJ1+huFwsYGN
         H3YfKYeKA2YXPxZeUYpzdw3O7dyqddscQYDv1YLDH7x1suL2LiBwGmcKLOm0gSG6QR
         XZyN6VE7LIITSQRw1/GpaTuxIBpTngNAQXnBpnU6kL6SVJrpcwh7vv8KqNtMeyBw3h
         p7XhZB7vN9RfA==
Date:   Thu, 27 Oct 2022 10:58:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Message-ID: <20221027105824.1c2157a2@kernel.org>
In-Reply-To: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
References: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 15:13:30 +0300 Vladimir Oltean wrote:
> To fix this problem, memset the DMA coherent area used for RX buffer
> descriptors in enetc_dma_alloc_bdr(). This makes all BDs be "not ready"
> by default, which makes enetc_clean_rx_ring() exit early from the BD
> processing loop when there is no valid buffer available.

IIRC dma_alloc_coherent() always zeros, and I'd guess there is a cocci
script that checks this judging but the number of "fixes" we got for
this in the past.

scripts/coccinelle/api/alloc/zalloc-simple.cocci ?
