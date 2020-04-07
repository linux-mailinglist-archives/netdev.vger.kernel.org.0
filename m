Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3F31A08C9
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 10:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgDGIAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 04:00:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:35104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgDGIAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 04:00:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A711AC37;
        Tue,  7 Apr 2020 08:00:12 +0000 (UTC)
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches as
 usercopy caches
To:     Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>,
        David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <201911121313.1097D6EE@keescook> <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
 <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <7d810f6d-8085-ea2f-7805-47ba3842dc50@suse.cz>
Date:   Tue, 7 Apr 2020 10:00:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/20 1:03 PM, Jann Horn wrote:

> I think dma-kmalloc slabs should be handled the same way as normal
> kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
> just normal kernel memory - even if it might later be used for DMA -,
> and it should be perfectly fine to copy_from_user() into such
> allocations at that point, and to copy_to_user() out of them at the
> end. If you look at the places where such allocations are created, you
> can see things like kmemdup(), memcpy() and so on - all normal
> operations that shouldn't conceptually be different from usercopy in
> any relevant way.
 
So, let's do that?

----8<----
From d5190e4e871689a530da3c3fd327be45a88f006a Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 7 Apr 2020 09:58:00 +0200
Subject: [PATCH] usercopy: Mark dma-kmalloc caches as usercopy caches

We have seen a "usercopy: Kernel memory overwrite attempt detected to SLUB
object 'dma-kmalloc-1 k' (offset 0, size 11)!" error on s390x, as IUCV uses
kmalloc() with __GFP_DMA because of memory address restrictions.
The issue has been discussed [2] and it has been noted that if all the kmalloc
caches are marked as usercopy, there's little reason not to mark dma-kmalloc
caches too. The 'dma' part merely means that __GFP_DMA is used to restrict
memory address range.

As Jann Horn put it [3]:

"I think dma-kmalloc slabs should be handled the same way as normal
kmalloc slabs. When a dma-kmalloc allocation is freshly created, it is
just normal kernel memory - even if it might later be used for DMA -,
and it should be perfectly fine to copy_from_user() into such
allocations at that point, and to copy_to_user() out of them at the
end. If you look at the places where such allocations are created, you
can see things like kmemdup(), memcpy() and so on - all normal
operations that shouldn't conceptually be different from usercopy in
any relevant way."

Thus this patch marks the dma-kmalloc-* caches as usercopy.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1156053
[2] https://lore.kernel.org/kernel-hardening/bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz/
[3] https://lore.kernel.org/kernel-hardening/CAG48ez1a4waGk9kB0WLaSbs4muSoK0AYAVk8=XYaKj4_+6e6Hg@mail.gmail.com/

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5282f881d2f5..ae9486160594 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1303,7 +1303,8 @@ void __init create_kmalloc_caches(slab_flags_t flags)
 			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
 				kmalloc_info[i].name[KMALLOC_DMA],
 				kmalloc_info[i].size,
-				SLAB_CACHE_DMA | flags, 0, 0);
+				SLAB_CACHE_DMA | flags, 0,
+				kmalloc_info[i].size);
 		}
 	}
 #endif
-- 
2.26.0

