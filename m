Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252F758D142
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 02:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbiHIAO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 20:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiHIAOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 20:14:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA27F7;
        Mon,  8 Aug 2022 17:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA9461118;
        Tue,  9 Aug 2022 00:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB9AC433C1;
        Tue,  9 Aug 2022 00:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660004093;
        bh=s9p6n77wda0CikqJB7ybhXozw+JkQMq2Pby2cddT+uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B5JH0OqRDDRpkCD8xpBt/M1yyosH8jx8oAfeBOhuZrxbtP1Qf+qGQQXIDF7UvuBkd
         TAbwA1M621+alqShaa2kZ/WYzNdQ/iIwHPmomhM2X1bIh4E0u1YBC2wmeBKs9/1PkL
         s5s3m6++ktPT7RFR6KskMWssDCf8sGfVwPNnEdzs=
Date:   Mon, 8 Aug 2022 17:14:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     alexander.duyck@gmail.com, kuba@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        chen45464546@163.com
Subject: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the
 memory
Message-Id: <20220808171452.d870753e1494b92ba2142116@linux-foundation.org>
In-Reply-To: <20220715125013.247085-1-mlombard@redhat.com>
References: <20220715125013.247085-1-mlombard@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 14:50:13 +0200 Maurizio Lombardi <mlombard@redhat.com> wrote:

> A number of drivers call page_frag_alloc() with a
> fragment's size > PAGE_SIZE.
> In low memory conditions, __page_frag_cache_refill() may fail the order 3
> cache allocation and fall back to order 0;
> In this case, the cache will be smaller than the fragment, causing
> memory corruptions.
> 
> Prevent this from happening by checking if the newly allocated cache
> is large enough for the fragment; if not, the allocation will fail
> and page_frag_alloc() will return NULL.

Can we come up with a Fixes: for this?

Should this fix be backported into -stable kernels?
