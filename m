Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F9825565
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 18:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfEUQRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 12:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727925AbfEUQRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 12:17:46 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C5521855
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558455465;
        bh=Juvw2oTsl7v6zhrOBSH0qNomQ4HvlznMN/IaJVfdTn0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JC7AGXUDVq3FTy3A+/lXnxigcduFvb+LMxDek6FPYHJMeqK7WhIhteEBt5gTBa+ud
         RBaUlKiedGNSLYxDH6SsmJHDQuSCToPhoHF/E6T5hxR5toqO7ZDloM0oBNwT/+jN9m
         0qr7gPE2JJrVZaIwFLqk31O4g1ap6Uzct8C9PKeA=
Received: by mail-wm1-f43.google.com with SMTP id n25so1671371wmk.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 09:17:45 -0700 (PDT)
X-Gm-Message-State: APjAAAUHQs18rdt5wSdWJp0oE9qlbwxt9a12/XWYqL82eJeSK+EndV7X
        XVBBmQ7KM4UR/4gLP9GgTBa1NojcOsRPk9cOOnae1w==
X-Google-Smtp-Source: APXvYqw8sn9wq3KdFkZAqNum4Cv+dMOPFZkN+KoAq+Xc+GMQ8ZNRfUNjsaGxcnTvUYv3S0FdA0yajee3UnadlfdWRKU=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr4280110wmc.47.1558455464072;
 Tue, 21 May 2019 09:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190520233841.17194-1-rick.p.edgecombe@intel.com> <20190520233841.17194-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20190520233841.17194-3-rick.p.edgecombe@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 May 2019 09:17:32 -0700
X-Gmail-Original-Message-ID: <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
Message-ID: <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vmalloc: Remove work as from vfree path
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Nadav Amit <namit@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rick Edgecombe <redgecombe.lkml@gmail.com>,
        Meelis Roos <mroos@linux.ee>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 4:39 PM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
> From: Rick Edgecombe <redgecombe.lkml@gmail.com>
>
> Calling vm_unmap_alias() in vm_remove_mappings() could potentially be a
> lot of work to do on a free operation. Simply flushing the TLB instead of
> the whole vm_unmap_alias() operation makes the frees faster and pushes
> the heavy work to happen on allocation where it would be more expected.
> In addition to the extra work, vm_unmap_alias() takes some locks including
> a long hold of vmap_purge_lock, which will make all other
> VM_FLUSH_RESET_PERMS vfrees wait while the purge operation happens.
>
> Lastly, page_address() can involve locking and lookups on some
> configurations, so skip calling this by exiting out early when
> !CONFIG_ARCH_HAS_SET_DIRECT_MAP.

Hmm.  I would have expected that the major cost of vm_unmap_aliases()
would be the flush, and at least informing the code that the flush
happened seems valuable.  So would guess that this patch is actually a
loss in throughput.

--Andy
