Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E0823F887
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHHTEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 15:04:13 -0400
Received: from mx.sdf.org ([205.166.94.24]:59517 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHHTEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 15:04:13 -0400
Received: from sdf.org (IDENT:lkml@sdf.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 078J3hhi025147
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 8 Aug 2020 19:03:44 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 078J3hOR008124;
        Sat, 8 Aug 2020 19:03:43 GMT
Date:   Sat, 8 Aug 2020 19:03:43 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     netdev@vger.kernel.org, w@1wt.eu, aksecurity@gmail.com,
        torvalds@linux-foundation.org, edumazet@google.com,
        Jason@zx2c4.com, luto@kernel.org, keescook@chromium.org,
        tglx@linutronix.de, peterz@infradead.org, tytso@mit.edu,
        lkml.mplumb@gmail.com, stephen@networkplumber.org
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
Message-ID: <20200808190343.GB27941@SDF.ORG>
References: <20200808152628.GA27941@SDF.ORG>
 <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 10:07:51AM -0700, Andy Lutomirski wrote:
>>    - Cryptographically strong ChaCha, batched
>>    - Cryptographically strong ChaCha, with anti-backtracking.
> 
> I think we should just anti-backtrack everything.  With the "fast key 
> erasure" construction, already implemented in my patchset for the 
> buffered bytes, this is extremely fast.

The problem is that this is really *amorized* key erasure, and
requires large buffers to amortize the cost down to a reasonable
level.

E,g, if using 256-bit (32-byte) keys, 5% overhead would require generating
640 bytes at a time.

Are we okay with ~1K per core for this?  Which we might have to
throw away occasionally to incorporate fresh seed material?

You're right that the simplification in usage is a benefit.
