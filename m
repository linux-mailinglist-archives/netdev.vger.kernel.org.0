Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B366652BB5
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 04:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiLUDPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 22:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLUDPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 22:15:13 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B6612629;
        Tue, 20 Dec 2022 19:15:11 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NcJTg0Mtbz4x3w;
        Wed, 21 Dec 2022 14:15:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1671592506;
        bh=eqAIBLUmcICy3LgEU8+CzGPHy97CiqYlcBozr88VRgM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nEnpH5yKCXg49RR2P2OgASyKUTK1v/Cpt25ZodcDuYQhuzTY4bfmiopmNdXaSJcxG
         aT2giTer1CXp4QrKyb0L3iEMExYYi45d6YNdHP/hsCuZ0ooVSZAHVP+TaH2VeP+mV0
         m7KqD7FQGyuOV2IM8pdQBoAydfWwg9TXYyD/1MwjCHXsflSyAQ9fUUg4pbm6i1ouBK
         SZjj31OHTFa/rSnU4LNO/R3FzH6Cmo/n1VbDuQf7YV3yJoyt+M/z7P9wZUe0G0LDmb
         GVN8E+MF/N6Cs5RWhwq5KdcguwthwmMBOOWoIsEsuVPmDTrbRkQpUSO0ShmLK7R0zK
         zzORrsjT0jX2g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [RFC PATCH] mm: remove zap_page_range and change callers to use
 zap_vma_page_range
In-Reply-To: <20221216192012.13562-1-mike.kravetz@oracle.com>
References: <20221216192012.13562-1-mike.kravetz@oracle.com>
Date:   Wed, 21 Dec 2022 14:15:02 +1100
Message-ID: <87tu1pih1l.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mike Kravetz <mike.kravetz@oracle.com> writes:
> zap_page_range was originally designed to unmap pages within an address
> range that could span multiple vmas.  While working on [1], it was
> discovered that all callers of zap_page_range pass a range entirely within
> a single vma.  In addition, the mmu notification call within zap_page
> range does not correctly handle ranges that span multiple vmas as calls
> should be vma specific.
>
> Instead of fixing zap_page_range, change all callers to use the new
> routine zap_vma_page_range.  zap_vma_page_range is just a wrapper around
> zap_page_range_single passing in NULL zap details.  The name is also
> more in line with other exported routines that operate within a vma.
> We can then remove zap_page_range.
>
> Also, change madvise_dontneed_single_vma to use this new routine.
>
> [1] https://lore.kernel.org/linux-mm/20221114235507.294320-2-mike.kravetz@oracle.com/
> Suggested-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  arch/arm64/kernel/vdso.c                |  4 ++--
>  arch/powerpc/kernel/vdso.c              |  2 +-
>  arch/powerpc/platforms/book3s/vas-api.c |  2 +-
>  arch/powerpc/platforms/pseries/vas.c    |  2 +-
  
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
