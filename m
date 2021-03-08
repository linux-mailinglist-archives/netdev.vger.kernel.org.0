Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E908B330980
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhCHIjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhCHIjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 03:39:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC40C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 00:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fEFuTC/t38hMP3UYlU+bTUNBztK0qNI/lvqZMRVI6Sw=; b=rA1dSaU8N7b/TC6Feik7JyK7bJ
        8N9xxMmw9xEWN0tguZBoyyIYOIbOvgg/0zr9sJRjpbMKdasvzndmIG8D/PT1TBvtCLhb51SRaCMVQ
        Gr+g+uKne3lxqcr/KeqTLxqEUe36FDuBjf/tUs/BP/ghZgxg1OwA+8m/adeTVrev1DFGseenwb4Yy
        FtJKYg5yIfPUNbwi2rmvmM1OCc+PD+D9oL8/AUjlVj0+5LuoDrt0Jpx8u6CTM+havG8x4WzdNsz4S
        bCgE0o4i6S14BvVicDmPjSIkkwvNg9EGCWapQM3ZtVJOlh7Nklw5eoFr912Kmbb7OWklfRC3hZK4X
        MCJVy4yg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJBPB-00FEXj-Vj; Mon, 08 Mar 2021 08:38:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 56B84300238;
        Mon,  8 Mar 2021 09:38:14 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 99B332BB25DDB; Mon,  8 Mar 2021 09:38:11 +0100 (CET)
Date:   Mon, 8 Mar 2021 09:38:11 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, erhard_f@mailbox.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: seqlock lockdep false positives?
Message-ID: <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YESayEskbtjEWjFd@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YESayEskbtjEWjFd@lx-t490>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 10:20:08AM +0100, Ahmed S. Darwish wrote:
> Hi Jakub,
> 
> On Wed, Mar 03, 2021 at 04:40:35PM -0800, Jakub Kicinski wrote:
> > Hi Ahmed!
> >
> > Erhard is reporting a lockdep splat in drivers/net/ethernet/realtek/8139too.c
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=211575
> >
> > I can't quite grasp how that happens it looks like it's the Rx
> > lock/syncp on one side and the Tx lock on the other side :S
> >
> > ================================
> > WARNING: inconsistent lock state
> > 5.12.0-rc1-Pentium4 #2 Not tainted
> > --------------------------------
> > inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> > swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> > c113c804 (&syncp->seq#2){?.-.}-{0:0}, at: rtl8139_poll+0x251/0x350
> > {IN-HARDIRQ-W} state was registered at:
> >   lock_acquire+0x239/0x2c5
> >   do_write_seqcount_begin_nested.constprop.0+0x1a/0x1f
> >   rtl8139_interrupt+0x346/0x3cb
> 
> That's really weird.
> 
> The only way I can see this happening is lockdep mistakenly treating
> both "tx_stats->syncp.seq" and "rx_stats->syncp.seq" as the same lockdep
> class key... somehow.
> 
> It is claiming that the softirq code path at rtl8139_poll() is acquiring
> the *tx*_stats sequence counter. But at rtl8139_poll(), I can only see
> the *rx*_stats sequence counter getting acquired.
> 
> I've re-checked where tx/rx stats sequence counters are initialized, and
> I see:
> 
>   static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
>   {
> 	...
> 	u64_stats_init(&tp->rx_stats.syncp);
> 	u64_stats_init(&tp->tx_stats.syncp);
> 	...
>   }
> 
> which means they should have different lockdep class keys.  The
> u64_stats sequence counters are also initialized way before any IRQ
> handlers are registered.

Indeed, that's one area where inlines are very much not equivalent to
macros. Static variables in inline functions aren't exact, but they very
much do not get to be one per invocation.

Something like the below ought to be the right fix I think.

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index c6abb79501b3..e81856c0ba13 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -115,12 +115,13 @@ static inline void u64_stats_inc(u64_stats_t *p)
 }
 #endif
 
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
+#else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
-	seqcount_init(&syncp->seq);
-#endif
 }
+#endif
 
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
