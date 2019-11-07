Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8981BF39B1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKGUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:44:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42690 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGUo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:44:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id q17so2727956pgt.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YknM6fFCF8e0j4TWGuwlJuiUFneXRP0vedkCIJ4TRls=;
        b=lVG/ns7colpNwDtCgyq6NTV079wL7G7CIkieWIHyJW22recTdWYIEFnWL7b7WJvjA0
         4lPlQHWwe4YsG9nE3CVYMQ1/zLnVJdd4Te1gbryi9tvHbGKKOwJZcReA04ZCSLxB6lWU
         JfLnwPW9RUUtJT7t56R72mMHXzhSbzjkEBXGlb4CR0l3PXC241KvMbrkm4S4bVqoDbn0
         k8K64K7EtmIqAbscLatQ8USn42gCTFYbbcGXhLAj5JfbNdRMnT2Eit4p/YPV6oNNtooZ
         lHpBt2g5hOgzFJIPXP6aSRXExT7b3Gp9tBYRWjQG+EceXoCH1KE+n8aS0N5weHliRK6h
         YMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=YknM6fFCF8e0j4TWGuwlJuiUFneXRP0vedkCIJ4TRls=;
        b=k7jFpLVHh0e5y2Ee9f5pdDdrbmxKGrQljajSfKGTlzUTMV+PTIoLEvBVH7iidihLrs
         bWwUVPLzzMXBmZubn3N7PNmYD1+3rdFhCwY7roxk5nORXSfppFAvv50TEBs360Gev+dT
         8p6YuFbAmPKHtrYz1S72OV5V9nW0DES4I5GWnqtyp1qdxB0zWHpotZWCB4l4KA/zgXaq
         PpzFlKJGujY9Tgcy9CLClLmzGvdVuPe/weIPAWg3X+czf5QynwApPJCkbR8vMj1MtI3n
         3bTt9DlpSAbhGAbYG1OiRm6wQ1fHQyhOvPlcUi3oLI+bAYz4qRWCb1lg1iP7yLEefeW3
         HCIg==
X-Gm-Message-State: APjAAAUGkTN7j+Sb30bfrvMzgYIyYfXblW4B5owgzrZgoOH1YF4cieSh
        CsHakQSzlVPqxeW/u2qZuFyK7w==
X-Google-Smtp-Source: APXvYqwKGjVvXz6FodHFSQ9WZOZlEAZi7/qsWmZr31ZLesRW8FCSMaKRyheeQSq2yHTQ30yaLbBIFg==
X-Received: by 2002:aa7:83c2:: with SMTP id j2mr6845841pfn.225.1573159495441;
        Thu, 07 Nov 2019 12:44:55 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id c13sm4679779pfi.0.2019.11.07.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 12:44:54 -0800 (PST)
Date:   Thu, 7 Nov 2019 12:44:54 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Laura Abbott <labbott@redhat.com>
cc:     Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, clipos@ssi.gouv.fr,
        Vlastimil Babka <vbabka@suse.cz>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Subject: Re: [PATCH] mm: slub: Really fix slab walking for init_on_free
In-Reply-To: <20191106222208.26815-1-labbott@redhat.com>
Message-ID: <alpine.DEB.2.21.1911071244410.88963@chino.kir.corp.google.com>
References: <20191106222208.26815-1-labbott@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Nov 2019, Laura Abbott wrote:

> Commit 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
> fixed one problem with the slab walking but missed a key detail:
> When walking the list, the head and tail pointers need to be updated
> since we end up reversing the list as a result. Without doing this,
> bulk free is broken. One way this is exposed is a NULL pointer with
> slub_debug=F:
> 
> =============================================================================
> BUG skbuff_head_cache (Tainted: G                T): Object already free
> -----------------------------------------------------------------------------
> 
> INFO: Slab 0x000000000d2d2f8f objects=16 used=3 fp=0x0000000064309071 flags=0x3fff00000000201
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> RIP: 0010:print_trailer+0x70/0x1d5
> Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 20 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
> RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
> RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
> RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
> RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
> R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
> R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  free_debug_processing.cold.37+0xc9/0x149
>  ? __kfree_skb_flush+0x30/0x40
>  ? __kfree_skb_flush+0x30/0x40
>  __slab_free+0x22a/0x3d0
>  ? tcp_wfree+0x2a/0x140
>  ? __sock_wfree+0x1b/0x30
>  kmem_cache_free_bulk+0x415/0x420
>  ? __kfree_skb_flush+0x30/0x40
>  __kfree_skb_flush+0x30/0x40
>  net_rx_action+0x2dd/0x480
>  __do_softirq+0xf0/0x246
>  irq_exit+0x93/0xb0
>  do_IRQ+0xa0/0x110
>  common_interrupt+0xf/0xf
>  </IRQ>
> 
> Given we're now almost identical to the existing debugging
> code which correctly walks the list, combine with that.
> 
> Link: https://lkml.kernel.org/r/20191104170303.GA50361@gandi.net
> Reported-by: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
> Fixes: 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
