Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24F0534659
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 00:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345363AbiEYWUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 18:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345453AbiEYWUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 18:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F42A674FC;
        Wed, 25 May 2022 15:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08C7C60A2A;
        Wed, 25 May 2022 22:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0633C385B8;
        Wed, 25 May 2022 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653517207;
        bh=c7KzToDeUqtD99O2hzHK7o5kCE8vnxm1uZ6cI59st/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lc5Bswn5/mLgrZUzDGaOfcSNR02Mm/oMMFmAsk3PMUUgwWwgJa8zBW3fhkYeoBrs6
         zULKKPi/KMazKRvfEOpIG5mlq58qHM3l4UzEO0HxQt9EhuXQjV37+aQrktHPNlneq8
         f2dYK6/dz9JhOi+TYCUG0YZy8hrl37z6cFtGSZlg=
Date:   Wed, 25 May 2022 15:20:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jessica Clarke <jrtc27@jrtc27.com>
Cc:     kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-Id: <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
In-Reply-To: <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
        <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
        <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 23:07:35 +0100 Jessica Clarke <jrtc27@jrtc27.com> wrote:

> This is i386, so an unsigned long is 32-bit, but i_blocks is a blkcnt_t
> i.e. a u64, which makes the shift without a cast of the LHS fishy.

Ah, of course, thanks.  I remember 32 bits ;)

--- a/mm/shmem.c~mm-shmemc-suppress-shift-warning
+++ a/mm/shmem.c
@@ -1945,7 +1945,7 @@ alloc_nohuge:
 
 	spin_lock_irq(&info->lock);
 	info->alloced += folio_nr_pages(folio);
-	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
+	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
_

