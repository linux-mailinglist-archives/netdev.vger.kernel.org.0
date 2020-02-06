Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFCD154B5D
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBFSnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:43:43 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:60369 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgBFSnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 13:43:43 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0f9268e8;
        Thu, 6 Feb 2020 18:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :content-transfer-encoding:in-reply-to; s=mail; bh=k/OVyrULSF/E2
        mtzHs8ojPxS/l0=; b=smx53BRLhnJ1EyJookJhS44+2t0uSJ4wEYlvj2YwBBsoM
        SMeW9CdQDf7OmnPqOkl9r0TJPdJabZrWaXJIpMyr7RKEng9oT6vCj1qftxPlu74C
        rNe714SS2dUkVJZ7tN4OMajjejerh2/CZHi0//PUYcxrhF7xKoFv1Xlm0a/sgbN8
        9SNlPq8Tsmo1+d2+H8h2h9p0IK9UBpdJe7E7T6wNIF/ByApfn5wWx6IFyitVU0Ki
        49HVara6Qygt2QitzJAJI8mjnsfOiqE0+k2oehpKJJlmws28fw8zL8bShG6yXs7j
        VbO9vg06qq0gy1s8b1sWNj4FYsQ7GjBVMhsiJlMfw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 86c03cff (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 6 Feb 2020 18:42:36 +0000 (UTC)
Date:   Thu, 6 Feb 2020 19:43:40 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     cai@lca.pw, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
Message-ID: <20200206184340.GA494766@zx2c4.com>
References: <1580841629-7102-1-git-send-email-cai@lca.pw>
 <20200206163844.GA432041@zx2c4.com>
 <453212cf-8987-9f05-ceae-42a4fc3b0876@gmail.com>
 <CAHmME9pGhQoY8MjR8uvEZpF66Y_DvReAjKBx8L4SRiqbL_9itw@mail.gmail.com>
 <495f79f5-ae27-478a-2a1d-6d3fba2d4334@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495f79f5-ae27-478a-2a1d-6d3fba2d4334@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 06, 2020 at 10:22:02AM -0800, Eric Dumazet wrote:
> On 2/6/20 10:12 AM, Jason A. Donenfeld wrote:
> > On Thu, Feb 6, 2020 at 6:10 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> Unfortunately we do not have ADD_ONCE() or something like that.
> > 
> > I guess normally this is called "atomic_add", unless you're thinking
> > instead about something like this, which generates the same
> > inefficient code as WRITE_ONCE:
> > 
> > #define ADD_ONCE(d, s) *(volatile typeof(d) *)&(d) += (s)
> > 
> 
> Dmitry Vyukov had a nice suggestion few months back how to implement this.
> 
> https://lkml.org/lkml/2019/10/5/6

That trick appears to work well in clang but not gcc:

#define ADD_ONCE(d, i) ({ \
       typeof(d) *__p = &(d); \
       __atomic_store_n(__p, (i) + __atomic_load_n(__p, __ATOMIC_RELAXED), __ATOMIC_RELAXED); \
})

gcc 9.2 gives:

  0:   8b 47 10                mov    0x10(%rdi),%eax
  3:   83 e8 01                sub    $0x1,%eax
  6:   89 47 10                mov    %eax,0x10(%rdi)

clang 9.0.1 gives:

   0:   81 47 10 ff ff ff ff    addl   $0xffffffff,0x10(%rdi)

But actually, clang does equally as well with:

#define ADD_ONCE(d, i) *(volatile typeof(d) *)&(d) += (i)

And testing further back, it generates the same code with your original
WRITE_ONCE.

If clang's optimization here is technically correct, maybe we should go
talk to the gcc people about catching this case?
