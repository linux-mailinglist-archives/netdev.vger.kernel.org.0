Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93B414ECB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhIVRJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236697AbhIVRJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632330504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWqUMA4PsVlJ2pPT1/p24HsUIkcdO8iEjqhCU7s0cfo=;
        b=bkTLNgLBxGzHpFMHZ4g3GzBxJUpbhLg0u12UX9mW2L3nGFYFqH9xoLu/wL3ChgVAtoLXU2
        XpgQ9UmowW/2gulbe6v3JmPOnqbxQQxy7obcCRNxyLAx0r0t58uStxlDIYv9eCmOUnGA78
        rQXxHgTu3xBzfG5mEimB78S4ZOeTRNI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-cvVsLwseNbSDpF6hlEr-9A-1; Wed, 22 Sep 2021 13:08:20 -0400
X-MC-Unique: cvVsLwseNbSDpF6hlEr-9A-1
Received: by mail-wr1-f69.google.com with SMTP id j16-20020adfa550000000b0016012acc443so2761785wrb.14
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 10:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vWqUMA4PsVlJ2pPT1/p24HsUIkcdO8iEjqhCU7s0cfo=;
        b=E7AD9jworiKsC8G1ZFX2GcDRD5B6Qf4Dauql60uQ+KTV//mEWe8cURRqMVGRFKYMXO
         qEkURCaRaERjz9ic3GpX5QgHUTX3E5qYVi28whWN+BoFcRS/P/1rZikZH9kKkYGsJFq2
         AhVJPxi2NOfTpnxtbbCVjh596K2KXB3SmFUbwy2iImvvyK5gZpTT8qaRlPNOyA5KUsGS
         NImjT196/VWGQtAKGJv/CVHFDXvtyvg5Y3g4e9OjnMz9j+7d7fEAS9nDmVAxOJW/d74u
         NqBIGpatrRV1llSrZW+Vf4RSqWURaoxThfzrxZlrv3JdlYHNXjz+TfOLEJcrcI4Oop6W
         NAGA==
X-Gm-Message-State: AOAM5318hhwjR7SYCMpVHQJnePvSJUkDPDMOkhNtJcdkJ7BJUBPhY+8l
        5N424mdo/CTMw11tjNDw9etq7eRCqGGx4tdTZ7pkfQKE+S2HdLuY8kxHks1G0Zsrtj2HtnWJZNt
        +aXicvQBVEtG8PN7G
X-Received: by 2002:a5d:6545:: with SMTP id z5mr67133wrv.90.1632330499528;
        Wed, 22 Sep 2021 10:08:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEoCMdETBf0ZFsulv49iZD/disD0Q/Hgy56XYmufPeu3oyo6LTtFACq/qEWxa6hE3xyuys2Q==
X-Received: by 2002:a5d:6545:: with SMTP id z5mr67076wrv.90.1632330499184;
        Wed, 22 Sep 2021 10:08:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-102-46.dyn.eolo.it. [146.241.102.46])
        by smtp.gmail.com with ESMTPSA id g22sm6079241wmp.39.2021.09.22.10.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 10:08:18 -0700 (PDT)
Message-ID: <4e6db6e09ed2baa536f2badf2798daf3591bbd5a.camel@redhat.com>
Subject: Re: [syzbot] possible deadlock in mptcp_close
From:   Paolo Abeni <pabeni@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+1dd53f7a89b299d59eaf@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>
Date:   Wed, 22 Sep 2021 19:07:56 +0200
In-Reply-To: <87zgs4habc.ffs@tglx>
References: <0000000000005183b005cc74779a@google.com> <87zgs4habc.ffs@tglx>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-22 at 17:57 +0200, Thomas Gleixner wrote:
> On Mon, Sep 20 2021 at 15:04, syzbot wrote:
> > The issue was bisected to:
> > 
> > commit 2dcb96bacce36021c2f3eaae0cef607b5bb71ede
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Sat Sep 18 12:42:35 2021 +0000
> > 
> >     net: core: Correct the sock::sk_lock.owned lockdep annotations
> 
> Shooting the messenger...
> 
> > MPTCP: kernel_bind error, err=-98
> > ============================================
> > WARNING: possible recursive locking detected
> > 5.15.0-rc1-syzkaller #0 Not tainted
> > --------------------------------------------
> > syz-executor998/6520 is trying to acquire lock:
> > ffff8880795718a0 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x267/0x7b0 net/mptcp/protocol.c:2738
> > 
> > but task is already holding lock:
> > ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
> > ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x23/0x7b0 net/mptcp/protocol.c:2720
> 
> So this is a lock nesting issue and looking at the stack trace this
> comes from:
> 
> >  lock_sock_fast+0x36/0x100 net/core/sock.c:3229
> 
> which does not support lockdep nesting. So from a lockdep POV this is
> recursive locking the same lock class. And it's the case I was worried
> about that lockdep testing never takes the slow path. The original
> lockdep annotation would have produced exactly the same splat in the
> slow path case.
> 
> So it's not a new problem. It's just visible by moving the lockdep
> annotations to a place where they actually can detect issues which were
> not reported before.
> 
> See also https://lore.kernel.org/lkml/874kacu248.ffs@tglx/
> 
> There are two ways to address this mptcp one:
> 
>   1) Teach lock_sock_fast() about lock nesting
> 
>   2) Use lock_sock_nested() in mptcp_close() as that should not be
>      really a hotpath. See patch below.

Thank you for looking into this! I agree this specific case is not
fastpath, so definitely the proposed patch LGTM.

I fear there could be other similar cases in the MPTCP code, in more
time critical paths, and perhaps there are other relevant use-case, so
I'd like to experiment too with a lock_sock_fast_nested() variant - if
I find enough coffee ;)

Thanks,

Paolo

