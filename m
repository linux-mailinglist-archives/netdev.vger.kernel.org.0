Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABA8363180
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhDQRbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236595AbhDQRbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 13:31:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF69613C7;
        Sat, 17 Apr 2021 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618680635;
        bh=ugaFr7ubcYoZlftrOW8+is8PkeVPg/pgdCmBuE+ol64=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pokeBsO6dVRMBkqi8/yu+5t2S6RsKZsuEFRWuOmUllxciYCV/hKsZJPlPIFAn+dFS
         Lhbp0UYxa+8GNR0jx5rxoIRI19RblhevJhFutJTxtVnnBXTDHcOBAJ9YrYRvhz/ZIQ
         L0jcpMc04X7RUawJc+GPJ09O1vUXNSxv8aJIKKiK0DnoePGq/How3WpglmniU4DxaZ
         aM3UgZ/ri2h3v7xS4jm9thXDeLzXtS9YuOOLqr9ghK8DfiZ0bXj/XZNQjjHq4NjZNU
         iM2DFOrqUDZJrOTKy/CU0rm/zjTn1+nt9fX5AHG1CX2cZw6XqnfgnhxJ9sHCr3nBMG
         5Yn65E7dZ6PvA==
Received: by mail-wm1-f43.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so5842261wmf.3;
        Sat, 17 Apr 2021 10:30:35 -0700 (PDT)
X-Gm-Message-State: AOAM532WacjqG1W1CR/OTHLlVHiB9SXyxDIDcXQQ4u9Jj1l5Fn56ekUb
        inVDMbtPWYl46i5ow8+z+wW7B96M3y3j+fc97oA=
X-Google-Smtp-Source: ABdhPJx5c7/qiwMYT0ir136uPjUzW1fYOXrUhmuWfobdjxZ7ZRW1mvPQs0zb5XctbTVKp2LKwzYcR2xXWnxiB9rv6sM=
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr13072983wmi.75.1618680634529;
 Sat, 17 Apr 2021 10:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org> <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org> <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org> <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon> <20210416152755.GL2531743@casper.infradead.org>
 <CAK8P3a2dekzohOrHpLq6yyuaoyC4UOxxucu6kX2oddeq5Jdqfg@mail.gmail.com> <20210417135642.GR2531743@casper.infradead.org>
In-Reply-To: <20210417135642.GR2531743@casper.infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 17 Apr 2021 19:30:21 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2M1fk-CAAjpLSNsobpOKKiHt_ffoKUNv3aqfie09d_PQ@mail.gmail.com>
Message-ID: <CAK8P3a2M1fk-CAAjpLSNsobpOKKiHt_ffoKUNv3aqfie09d_PQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Laight <David.Laight@aculab.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 3:58 PM Matthew Wilcox <willy@infradead.org> wrote:
> I wouldn't like to make that assumption.  I've come across IOMMUs (maybe
> on parisc?  powerpc?) that like to encode fun information in the top
> few bits.  So we could get it down to 52 bits, but I don't think we can
> get all the way down to 32 bits.  Also, we need to keep the bottom bit
> clear for PageTail, so that further constrains us.

I'd be surprised to find such an IOMMU on a 32-bit machine, given that
the main reason for using an IOMMU on these is to avoid the 32-bit
address limit in DMA masters.

I see that parisc32 does not enable 64-bit dma_addr_t, while powerpc32
does not support any IOMMU, so it wouldn't be either of those two.

I do remember some powerpc systems that encode additional flags
(transaction ordering, caching, ...) into the high bits of the physical
address in the IOTLB, but not the virtual address used for looking
them up.

> Anyway, I like the "two unsigned longs" approach I posted yesterday,
> but thanks for the suggestion.

Ok, fair enough. As long as there are enough bits in this branch of
'struct page', I suppose it is the safe choice.

        Arnd
