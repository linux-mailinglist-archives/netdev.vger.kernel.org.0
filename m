Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB85325645
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfEURAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 13:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbfEURAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 13:00:48 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1EB421850
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558458048;
        bh=9OojUtYA0LbZL0IhpfNco/9wKFwUCoXQNI7zcdJGSfw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0gl6NyxD+CezqGhCgUYDdISkwzLC9LT/TjqEDC7NKDw9fmLVIKRHEqm82nKW1csm3
         cE0HjimltJnBGVQQdoffgyP2IJ0TiD9IKvWxA96cOBzK3d0lDx8aoxwEBAIBJs3fxW
         /jGBD7ITYvyqevJV3g7a4BIzqpezsORPVZzudX8k=
Received: by mail-wr1-f50.google.com with SMTP id w8so19473712wrl.6
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 10:00:47 -0700 (PDT)
X-Gm-Message-State: APjAAAUrIYbfPvxB/gkTcSqDB1iwECUn3yjhtNPalADngXXMmeqXwFw5
        ew+Zm46ZM03wzORV0in4AHPli0x7U7RhzkU9Zhpqpw==
X-Google-Smtp-Source: APXvYqy0+HXvib4u95W6GDx3x8TJ88A00fWg0+I4MlCynnn4IjJhpkVLQ7CkvVvng88ywRDO2oq6ShUuw1AFJx7R3ko=
X-Received: by 2002:adf:f74a:: with SMTP id z10mr5273655wrp.291.1558458046385;
 Tue, 21 May 2019 10:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190520233841.17194-1-rick.p.edgecombe@intel.com>
 <20190520233841.17194-3-rick.p.edgecombe@intel.com> <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
 <4e353614f017c7c13a21d168992852dae1762aba.camel@intel.com>
In-Reply-To: <4e353614f017c7c13a21d168992852dae1762aba.camel@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 May 2019 10:00:34 -0700
X-Gmail-Original-Message-ID: <CALCETrXfnkLKv-jJzquj+547QWiwEBSxKtM3du3UqK80FNSSGg@mail.gmail.com>
Message-ID: <CALCETrXfnkLKv-jJzquj+547QWiwEBSxKtM3du3UqK80FNSSGg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vmalloc: Remove work as from vfree path
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "luto@kernel.org" <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "redgecombe.lkml@gmail.com" <redgecombe.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 9:51 AM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Tue, 2019-05-21 at 09:17 -0700, Andy Lutomirski wrote:
> > On Mon, May 20, 2019 at 4:39 PM Rick Edgecombe
> > <rick.p.edgecombe@intel.com> wrote:
> > > From: Rick Edgecombe <redgecombe.lkml@gmail.com>
> > >
> > > Calling vm_unmap_alias() in vm_remove_mappings() could potentially
> > > be a
> > > lot of work to do on a free operation. Simply flushing the TLB
> > > instead of
> > > the whole vm_unmap_alias() operation makes the frees faster and
> > > pushes
> > > the heavy work to happen on allocation where it would be more
> > > expected.
> > > In addition to the extra work, vm_unmap_alias() takes some locks
> > > including
> > > a long hold of vmap_purge_lock, which will make all other
> > > VM_FLUSH_RESET_PERMS vfrees wait while the purge operation happens.
> > >
> > > Lastly, page_address() can involve locking and lookups on some
> > > configurations, so skip calling this by exiting out early when
> > > !CONFIG_ARCH_HAS_SET_DIRECT_MAP.
> >
> > Hmm.  I would have expected that the major cost of vm_unmap_aliases()
> > would be the flush, and at least informing the code that the flush
> > happened seems valuable.  So would guess that this patch is actually
> > a
> > loss in throughput.
> >
> You are probably right about the flush taking the longest. The original
> idea of using it was exactly to improve throughput by saving a flush.
> However with vm_unmap_aliases() the flush will be over a larger range
> than before for most arch's since it will likley span from the module
> space to vmalloc. From poking around the sparc tlb flush history, I
> guess the lazy purges used to be (still are?) a problem for them
> because it would try to flush each page individually for some CPUs. Not
> sure about all of the other architectures, but for any implementation
> like that, using vm_unmap_alias() would turn an occasional long
> operation into a more frequent one.
>
> On x86, it shouldn't be a problem to use it. We already used to call
> this function several times around a exec permission vfree.
>
> I guess its a tradeoff that depends on how fast large range TLB flushes
> usually are compared to small ones. I am ok dropping it, if it doesn't
> seem worth it.

On x86, a full flush is probably not much slower than just flushing a
page or two -- the main cost is in the TLB refill.  I don't know about
other architectures.  I would drop this patch unless you have numbers
suggesting that it's a win.
