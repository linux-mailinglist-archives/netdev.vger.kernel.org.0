Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01B56A6067
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 21:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjB1Ubn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 15:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjB1Ubm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 15:31:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB8B33468
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 12:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 138EEB80E1A
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 20:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74382C433D2;
        Tue, 28 Feb 2023 20:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677616296;
        bh=G8m2430IqHEhAe2YQ8ZCfRTaZ0QkfVTDf4bVJPZTP48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pa7MqsNqHPx2mLvU3vv7n+8Ln6YHw3rc6DSBPVy4Mz6DK4Bvg2okKqXlySVV46/M1
         z0jzp8hj6EU2h1mi9vmPBudgeU7WRTPa2PWrMgWcnSgiRmLeLm0bCeX4ubGK7QYYvn
         l4WEVq4mmzK3rUuMWV9YDPoW7IWuqqQiG52x4O+PbTyZOlPRFD4yChJ4Waa+so2nK8
         E4Pc4ZMtsTazfyTSL0vXjQhvWoG/EBO86CvwKpZ/2thqHWxw4wEB3i3ejvmm71cDXJ
         fMfeA/DHygg0jCoUNb93ipNdcahMAynBVeoJB/HrJObndmm8pAtSzodKDpq2qSvjoD
         U94dsC2Ej2KFw==
Date:   Tue, 28 Feb 2023 12:31:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Geoff Levand <geoff@infradead.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
Message-ID: <20230228123135.251edc25@kernel.org>
In-Reply-To: <03f987ab-2cc1-21f6-a4cb-2df1273a8560@intel.com>
References: <cover.1677377639.git.geoff@infradead.org>
        <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
        <20230227182040.75740bb6@kernel.org>
        <03f987ab-2cc1-21f6-a4cb-2df1273a8560@intel.com>
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

On Tue, 28 Feb 2023 16:47:25 +0100 Alexander Lobakin wrote:
> >> +		return -ENOMEM;
> >> +	}  
> > 
> > And generally reshuffling the code.
> > 
> > Once again - please don't do any of that in a bug fix.
> > Describe precisely what the problem is and fix that problem,  
> 
> IIRC the original problem is that the skb linear parts are not always
> aligned to a boundary which this particular HW requires. So initially
> there was something like "allocate len + alignment - 1, then
> PTR_ALIGN()",

Let's focus on where the bug is. At a quick look I'm guessing that 
the bug is that we align the CPU buffer instead of the DMA buffer.
We should pass the entire allocate len + alignment - 1 as length 
to dma_map() and then align the dma_addr. dma_addr is what the device
sees. Not the virtual address of skb->data.

If I'm right the bug is not in fact directly addressed by the patch.
I'm guessing the patch helps because at least the patch passes the
aligned length to the dma_map(), rather than GELIC_NET_MAX_MTU (which
is not a multiple of 128).

> but I said that it's a waste of memory and we shouldn't do
> that, using napi_alloc_frag_align() instead.
> I guess if that would've been described, this could go as a fix? I don't
> think wasting memory is a good fix, even if we need to change the
> allocation scheme...

In general doing such a rewrite may be fine, if the author is an expert
and the commit message is very precise. Here we are at v6 already and
IMHO the problem is not even well understood.

Let's focus on understanding the problem and writing a _minimal_ fix.

The waste of memory claim can't be taken seriously when the MTU define
is bumped by 500 with no mention in the commit msg, as you also noticed.

Minimal fix, please.
