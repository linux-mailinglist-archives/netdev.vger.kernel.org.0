Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4383155D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfEaTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:30:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEaTag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:30:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6c2SIvVpUk/yolgwoL1u4zazZACLHYstcfuHPby3v0w=; b=MFhL+uVt82Xmaiv+qttE1YiKC
        Kq6BN39GAA0SMvCPsDsCZWjHJXA+bwFxCXeyt8UeowoJzKJGqlDvPAuYKviH2ZL+7N+pP3GSd+6sF
        q61+o7w4qam0osKENO2S0xabwseOkmk56ebiEQaQKRWu5jctx+x4Qxbrc6PKWUX7U2qvYZczcrsVP
        40PJmyFek7yvWBOeZbn5dcpDFwRhAEPxqZGUgOaMOZrM2su0m5NBnbpbOua6eO/brjraXOYWxu6qc
        /BQP9CZydnU/XggsEfdVVGxxvrCSOqj3EzMEMIIYA9dehjShYv9ZBRN5y/llZZ4ntQLFwj/EtMLjj
        Z7V25dnLA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hWnEZ-0008Gt-9x; Fri, 31 May 2019 19:30:35 +0000
Date:   Fri, 31 May 2019 12:30:35 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     "Nagal, Amit               UTC CCS" <Amit.Nagal@utc.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "CHAWLA, RITU UTC CCS" <RITU.CHAWLA@utc.com>,
        netdev@vger.kernel.org
Subject: Re: linux kernel page allocation failure and tuning of page cache
Message-ID: <20190531193035.GB15496@bombadil.infradead.org>
References: <09c5d10e9d6b4c258b22db23e7a17513@UUSALE1A.utcmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09c5d10e9d6b4c258b22db23e7a17513@UUSALE1A.utcmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1) the platform is low memory platform having memory 64MB.
> 
> 2)  we are doing around 45MB TCP data transfer from PC to target using netcat utility .On Target , a process receives data over socket and writes the data to flash disk .

I think your network is faster than your disk ...

> 5) sometimes , we observed kernel memory getting exhausted as page allocation failure happens in kernel  with the backtrace is printed below :
> # [  775.947949] nc.traditional: page allocation failure: order:0, mode:0x2080020(GFP_ATOMIC)

We're in the soft interrupt handler at this point, so we have very
few options for freeing memory; we can't wait for I/O to complete,
for example.

That said, this is a TCP connection.  We could drop the packet silently
without such a noisy warning.  Perhaps just collect statistics on how
many packets we dropped due to a low memory situation.

> [  775.956362] CPU: 0 PID: 1288 Comm: nc.traditional Tainted: G           O    4.9.123-pic6-g31a13de-dirty #19
> [  775.966085] Hardware name: Generic R7S72100 (Flattened Device Tree)
> [  775.972501] [<c0109829>] (unwind_backtrace) from [<c010796f>] (show_stack+0xb/0xc)
> [  775.980118] [<c010796f>] (show_stack) from [<c0151de3>] (warn_alloc+0x89/0xba)
> [  775.987361] [<c0151de3>] (warn_alloc) from [<c0152043>] (__alloc_pages_nodemask+0x1eb/0x634)
> [  775.995790] [<c0152043>] (__alloc_pages_nodemask) from [<c0152523>] (__alloc_page_frag+0x39/0xde)
> [  776.004685] [<c0152523>] (__alloc_page_frag) from [<c03190f1>] (__netdev_alloc_skb+0x51/0xb0)
> [  776.013217] [<c03190f1>] (__netdev_alloc_skb) from [<c02c1b6f>] (sh_eth_poll+0xbf/0x3c0)
> [  776.021342] [<c02c1b6f>] (sh_eth_poll) from [<c031fd8f>] (net_rx_action+0x77/0x170)
> [  776.029051] [<c031fd8f>] (net_rx_action) from [<c011238f>] (__do_softirq+0x107/0x160)
> [  776.036896] [<c011238f>] (__do_softirq) from [<c0112589>] (irq_exit+0x5d/0x80)
> [  776.044165] [<c0112589>] (irq_exit) from [<c012f4db>] (__handle_domain_irq+0x57/0x8c)
> [  776.052007] [<c012f4db>] (__handle_domain_irq) from [<c01012e1>] (gic_handle_irq+0x31/0x48)
> [  776.060362] [<c01012e1>] (gic_handle_irq) from [<c0108025>] (__irq_svc+0x65/0xac)
> [  776.067835] Exception stack(0xc1cafd70 to 0xc1cafdb8)
> [  776.072876] fd60:                                     0002751c c1dec6a0 0000000c 521c3be5
> [  776.081042] fd80: 56feb08e f64823a6 ffb35f7b feab513d f9cb0643 0000056c c1caff10 ffffe000
> [  776.089204] fda0: b1f49160 c1cafdc4 c180c677 c0234ace 200e0033 ffffffff
> [  776.095816] [<c0108025>] (__irq_svc) from [<c0234ace>] (__copy_to_user_std+0x7e/0x430)
> [  776.103796] [<c0234ace>] (__copy_to_user_std) from [<c0241715>] (copy_page_to_iter+0x105/0x250)
> [  776.112503] [<c0241715>] (copy_page_to_iter) from [<c0319aeb>] (skb_copy_datagram_iter+0xa3/0x108)
> [  776.121469] [<c0319aeb>] (skb_copy_datagram_iter) from [<c03443a7>] (tcp_recvmsg+0x3ab/0x5f4)
> [  776.130045] [<c03443a7>] (tcp_recvmsg) from [<c035e249>] (inet_recvmsg+0x21/0x2c)
> [  776.137576] [<c035e249>] (inet_recvmsg) from [<c031009f>] (sock_read_iter+0x51/0x6e)
> [  776.145384] [<c031009f>] (sock_read_iter) from [<c017795d>] (__vfs_read+0x97/0xb0)
> [  776.152967] [<c017795d>] (__vfs_read) from [<c01781d9>] (vfs_read+0x51/0xb0)
> [  776.159983] [<c01781d9>] (vfs_read) from [<c0178aab>] (SyS_read+0x27/0x52)
> [  776.166837] [<c0178aab>] (SyS_read) from [<c0105261>] (ret_fast_syscall+0x1/0x54)
> [  776.174308] Mem-Info:
> [  776.176650] active_anon:2037 inactive_anon:23 isolated_anon:0
> [  776.176650]  active_file:2636 inactive_file:7391 isolated_file:32
> [  776.176650]  unevictable:0 dirty:1366 writeback:1281 unstable:0

Almost all the dirty pages are under writeback at this point.

> [  776.176650]  slab_reclaimable:719 slab_unreclaimable:724
> [  776.176650]  mapped:1990 shmem:26 pagetables:159 bounce:0
> [  776.176650]  free:373 free_pcp:6 free_cma:0

We have 373 free pages, but refused to allocate one of them to GFP_ATOMIC?
I don't understand why that failed.  We also didn't try to steal an
inactive_file or inactive_anon page, which seems like an obvious thing
we might want to do.

> [  776.209062] Node 0 active_anon:8148kB inactive_anon:92kB active_file:10544kB inactive_file:29564kB unevictable:0kB isolated(anon):0kB isolated(file):128kB mapped:7960kB dirty:5464kB writeback:5124kB shmem:104kB writeback_tmp:0kB unstable:0kB pages_scanned:0 all_unreclaimable? no
> [  776.233602] Normal free:1492kB min:964kB low:1204kB high:1444kB active_anon:8148kB inactive_anon:92kB active_file:10544kB inactive_file:29564kB unevictable:0kB writepending:10588kB present:65536kB managed:59304kB mlocked:0kB slab_reclaimable:2876kB slab_unreclaimable:2896kB kernel_stack:1152kB pagetables:636kB bounce:0kB free_pcp:24kB local_pcp:24kB free_cma:0kB
> [  776.265406] lowmem_reserve[]: 0 0
> [  776.268761] Normal: 7*4kB (H) 5*8kB (H) 7*16kB (H) 5*32kB (H) 6*64kB (H) 2*128kB (H) 2*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1492kB
> 10071 total pagecache pages
> [  776.284124] 0 pages in swap cache
> [  776.287446] Swap cache stats: add 0, delete 0, find 0/0
> [  776.292645] Free swap  = 0kB
> [  776.295532] Total swap = 0kB
> [  776.298421] 16384 pages RAM
> [  776.301224] 0 pages HighMem/MovableOnly
> [  776.305052] 1558 pages reserved
