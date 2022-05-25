Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1653460F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbiEYVvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 17:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiEYVu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 17:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5309AAF313;
        Wed, 25 May 2022 14:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA1C961AB2;
        Wed, 25 May 2022 21:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68EFC385B8;
        Wed, 25 May 2022 21:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653515457;
        bh=RJBqCEbCNY0ooTTHUDW8T5ccFZ9a+R65ZzhmVt+2S44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8xzes5UjWb8BqqxzRNWgPf7cEHyaAbeSDj+v3F0k3sq8Asguyz6Vmo/uMlX6uzmY
         8HryaeniW2c258rIiLOGG2MjKsnv6NbBuzhNNsrGT4ET41NSmI5sqMNPKOc8It7ZVv
         QGSPkTQx3i5p9WrHix2LggCVXiwA2BU9p5l/o92c=
Date:   Wed, 25 May 2022 14:50:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kernel test robot <lkp@intel.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-Id: <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
In-Reply-To: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
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

On Thu, 26 May 2022 05:35:20 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 8cb8311e95e3bb58bd84d6350365f14a718faa6d  Add linux-next specific files for 20220525
> 
> Error/Warning reports:
> 
> ...
>
> Unverified Error/Warning (likely false positive, please contact us if interested):

Could be so.

> mm/shmem.c:1948 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?

I've been seeing this one for a while.  And from this report I can't
figure out what tool emitted it.  Clang?

>
> ...
>
> |-- i386-randconfig-m021
> |   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type

If you're going to use randconfig then shouldn't you make the config
available?  Or maybe quote the KCONFIG_SEED - presumably there's a way
for others to regenerate.

Anyway, the warning seems wrong to me.


#define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)

#define BLOCKS_PER_PAGE  (PAGE_SIZE/512)

	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);

so the RHS here should have unsigned long type.  Being able to generate
the cpp output would be helpful.  That requires the .config.

