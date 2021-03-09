Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C1E332016
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 08:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCIHzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 02:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhCIHyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 02:54:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012DFC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 23:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kpx4Luu1iBhf/IcgYUZ3D1SBClMlWaIyenKizmpNovg=; b=EPvuBVHXj4d/NdNEfXaWmysZA0
        HMfaEgkjlp2hDnLJFF/kLrdp4KsuB/1lcWfxh7nt7A2pMylKavStNtofIpY+rW6wepFzo9EnDIBXx
        dQsZCuLYnKupFv3fzurqBlxclJlq7h/3G9XGm29CdpsZ0BwZCZGbH+qW6HJo0W3f30BlVqTDXKjnv
        ZUIOs0WU9Io/Sj6FcUCDudh3Vb4G6m2SdS5ZP0Bi8/DCza5m1XuwiilVDU8ac6jeKBTifq/1FpMTu
        TAuDBI3HDykP1W2bsTAm41BXD7E7znLpL3ktnvYoCkeiv2qWtv4v1RJIxCj2hKg8/T8nk2VRg8jwk
        GM2tLoPQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJXC8-000Cri-3s; Tue, 09 Mar 2021 07:54:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A964E3010CF;
        Tue,  9 Mar 2021 08:54:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9327C2D3E9B39; Tue,  9 Mar 2021 08:54:19 +0100 (CET)
Date:   Tue, 9 Mar 2021 08:54:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Erhard F." <erhard_f@mailbox.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: seqlock lockdep false positives?
Message-ID: <YEcpqwhQFMimu6Ml@hirez.programming.kicks-ass.net>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YESayEskbtjEWjFd@lx-t490>
 <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
 <20210308214208.42a5577f@yea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308214208.42a5577f@yea>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 09:42:08PM +0100, Erhard F. wrote:

> I can confirm that your patch on top of 5.12-rc2 makes the lockdep
> splat disappear (Ahmeds' 1st patch not installed).

Excellent, I'll queue the below in locking/urgent then.


---
Subject: u64_stats,lockdep: Fix u64_stats_init() vs lockdep
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 8 Mar 2021 09:38:12 +0100

Jakub reported that:

    static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
    {
	    ...
	    u64_stats_init(&tp->rx_stats.syncp);
	    u64_stats_init(&tp->tx_stats.syncp);
	    ...
    }

results in lockdep getting confused between the RX and TX stats lock.
This is because u64_stats_init() is an inline calling seqcount_init(),
which is a macro using a static variable to generate a lockdep class.

By wrapping that in an inline, we negate the effect of the macro and
fold the static key variable, hence the confusion.

Fix by also making u64_stats_init() a macro for the case where it
matters, leaving the other case an inline for argument validation
etc.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Debugged-by: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Erhard F." <erhard_f@mailbox.org>
Link: https://lkml.kernel.org/r/YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net
---
 include/linux/u64_stats_sync.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -115,12 +115,13 @@ static inline void u64_stats_inc(u64_sta
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
