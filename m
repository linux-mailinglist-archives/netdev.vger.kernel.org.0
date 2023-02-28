Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8C6A60F6
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjB1VLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjB1VLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:11:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7DD2B619;
        Tue, 28 Feb 2023 13:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB3F611D5;
        Tue, 28 Feb 2023 21:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C6F4C4339B;
        Tue, 28 Feb 2023 21:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677618677;
        bh=IB9Sk6Sew2oBE0tBUuiuebk20E+C56Ut6PZLin772Nk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=emOgvl42vWzqzWChtKHzMHvotZsKDFOYMyzPq7CQAWnydVT3wCUftCrJgz4I96sVT
         J/p2OpBWB1Pfl7lM95qMXkEOuSSwV3OOY5QkIi4y4E4TMiphO/6LCFUrjcj6VtVV7y
         OqFAVUEOEE+LHNIKcVtUjyUQDYVHHnyUdND45alz0Hd9SkIYZjwDkf5s6BhiNivQ3t
         ooc1Zz4w4sfDqIRqmXhnwa/PPz8cRzyNIKX7rNjgeVdg9M8zNjUmOXtoCwjv3phgR8
         zgYKOqkEV/UonTYwYdQveKsTxgsF4XCJOJ+DHfzlb61xD21CVpekeZTvgvBIXth6Ct
         kGAa595muc6kQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50A4DC395EC;
        Tue, 28 Feb 2023 21:11:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm: remove zap_page_range and create zap_vma_pages
From:   patchwork-bot+linux-riscv@kernel.org
Message-Id: <167761867732.10135.11248419155612086016.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 21:11:17 +0000
References: <20230104002732.232573-1-mike.kravetz@oracle.com>
In-Reply-To: <20230104002732.232573-1-mike.kravetz@oracle.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-riscv@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        hch@infradead.org, david@redhat.com, mhocko@suse.com,
        peterx@redhat.com, nadav.amit@gmail.com, willy@infradead.org,
        vbabka@suse.cz, riel@surriel.com, will@kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, borntraeger@linux.ibm.com,
        dave.hansen@linux.intel.com, brauner@kernel.org,
        edumazet@google.com, akpm@linux-foundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to riscv/linux.git (for-next)
by Andrew Morton <akpm@linux-foundation.org>:

On Tue,  3 Jan 2023 16:27:32 -0800 you wrote:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas.  When
> crossing a vma boundary, a new mmu_notifier_range_init/end call pair
> with the new vma should be made.
> 
> [...]

Here is the summary with links:
  - mm: remove zap_page_range and create zap_vma_pages
    https://git.kernel.org/riscv/c/e9adcfecf572

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


