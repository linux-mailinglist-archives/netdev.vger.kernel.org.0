Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04AF6A510A
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 03:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB1CUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 21:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB1CUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 21:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D4F144A3
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 18:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33BD0B80DDF
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5DCC433D2;
        Tue, 28 Feb 2023 02:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677550841;
        bh=PpxWKWltKjHBlPGQeZ0nRLchttFA3kP2HeBN6Zq0OFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hHXcE9lxIfHXN9KWUiEVhHtUXJ/ffnsjH/gMJa/6bNRVcmpwrJ1z/lw6mMCOBlvms
         i8U7NdxsSkSUhsgU9GKen9rucPGWDlPgAMgeEUngXR0cbwG5sLbxkwm6G7C+GS/Ixx
         lDGMgkHn8JVbeWujn15eW4Do+NhbL3nGCFWE05jrn8QDzdUqhrBNL20OXOjeAZDcj8
         cpWZiU7bEMlo3kTUOKiYxdXxkXsNH0+8jd9vTmY4ygl4eI+Yxmro1KS+wiT2AGXYLg
         Ls1hSybj8dDZVPzhUi0cB9wqy+I+Rw4p17wvK4vA/TR/45kgY99A0E7LLzu/OK1JMA
         zH+J6xu1HJFgQ==
Date:   Mon, 27 Feb 2023 18:20:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
Message-ID: <20230227182040.75740bb6@kernel.org>
In-Reply-To: <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
References: <cover.1677377639.git.geoff@infradead.org>
        <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Feb 2023 02:25:42 +0000 Geoff Levand wrote:
> +	napi_buff = napi_alloc_frag_align(GELIC_NET_MAX_MTU,
> +		GELIC_NET_RXBUF_ALIGN);

You're changing how the buffers are allocated.

> +	if (unlikely(!napi_buff)) {
> +		descr->skb = NULL;
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;

Wiping the descriptors on failure.

> +		return -ENOMEM;
> +	}

And generally reshuffling the code.

Once again - please don't do any of that in a bug fix.
Describe precisely what the problem is and fix that problem,
Once the fix is accepted you can send separate patches with 
other improvements.
