Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46079415FC5
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbhIWNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhIWNaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C1861107;
        Thu, 23 Sep 2021 13:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632403725;
        bh=w0JufNshx/PXI2oi9FITKwYGXFUmV7b/kmCZtFIv61E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9Ezn/lBNXW73vjn6aYXvT1FJ+1Zc5vGGQPPaJx/RGjvMhhqlu0VXNVtw6Ia4nm17
         T/xbP3fcz59nbaknDSFRHCcorU0UQ00eBy1nDt3cgQarFyJDgW9n+4jlS0qKiGj++f
         SJdqhjw4NuvAT2VO0a1m9z8KL6UZ/j+UV7mw2CDi0UlX6KuXbgT25eF/3/5R3eWnyV
         gxjLBkJJoTBPMaWUiJDv1U5Uf2q3uKP6sosQWSxtZktMnS9R9prDGqJOuV46skqOvG
         +FK4DJCwUVqmpDO/YLNzDVb2JR/vJ5kiBp94pKZXu4cHj7pcB59gZ0yxK122ZaMa+E
         9Bjn+XKtVxuGw==
Date:   Thu, 23 Sep 2021 06:28:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <20210923062844.148e08fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <688e6750-87e9-fb44-ce40-943bad072e48@kernel.dk>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
        <ebea2af2-90d0-248f-8461-80f2e834dfea@kernel.dk>
        <20210922081906.GA78305@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
        <688e6750-87e9-fb44-ce40-943bad072e48@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 06:58:00 -0600 Jens Axboe wrote:
> > I considered only case 2) when writing code. Well, To support 1),
> > I think there are two ways:
> > 
> >  a) internally call kmem_cache_free when in_interrupt() is true
> >  b) caller must disable interrupt when freeing
> > 
> > I think a) is okay, how do you think?  
> 
> If the API doesn't support freeing from interrupts, then I'd make that
> the rule. Caller should know better if that can happen, and then just
> use kmem_cache_free() if in a problematic context. That avoids polluting
> the fast path with that check. I'd still make it a WARN_ON_ONCE() as
> described and it can get removed later, hopefully.

Shooting from the hip a little but if I'm getting the context right
this is all very similar to the skb cache so lockdep_assert_in_softirq()
may be useful:

/*
 * Acceptable for protecting per-CPU resources accessed from BH.
 * Much like in_softirq() - semantics are ambiguous, use carefully.
 */
#define lockdep_assert_in_softirq()					\
do {									\
	WARN_ON_ONCE(__lockdep_enabled			&&		\
		     (!in_softirq() || in_irq() || in_nmi()));		\
} while (0)
