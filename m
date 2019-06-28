Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212FB5A722
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfF1Wsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:48:47 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44041 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1Wsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:48:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so8109437qtk.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=naoN9xO3VLnK7N3zhVakVrkwI0aVx9LZjd339bZJK3Y=;
        b=LidnyyQnRNJ6JFsbmuD2KzXLFYOUgkq2l1ZpwEa4/9d/TdoZVEZ1V4oK8h1etVHWRx
         AhxYE11BIWL5G3ltTqtbcGje62GIGrKDsEV4lQ40L5gQi5xliI/pTYgOEuuIGaEhKs2g
         eizKN7Bo++MU6DzxdTpniDrYHUcQDolyYR0vnDuhU3k2NeO+qyHTd01SsXt7KmK6zOmQ
         1b++0q3m9QcZEjrXsaZntDbombdBVTwjjrT9mWJLa9gekTQIBB5WZ4py/T9/1h3n6+oP
         vkfTPFXNtkhlYE/os2nTjOcPF2qqyGwu2Z1Xmmbtz2wDHtgE2Ea1PAi+XqypkTWscmPl
         9UGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=naoN9xO3VLnK7N3zhVakVrkwI0aVx9LZjd339bZJK3Y=;
        b=Up6P2O9NocUiLqN2PuPOd8Vr2/QMOgm+H8YA6mrJQwM1nje3K+GenHU87DPw8RixSw
         c7PZXnZQlO9IkOS4KR78HaneFYzGG1qoRT6gzQ77jXNkmNtZ9sg5WpRb0oL+I77PM8TT
         BPw61esgBrkPwK21ZYHZtRTu/+QlrbSEv9hHrPgiA3V/qpNdIIRCZRkaBttFTezUTTvx
         paOANVQxBhWcTpbsQuv1L13jyzSDssZ80WYUNHNlYzmid8YTscUwHFLfVsmElaO99m0s
         h9zeIZU7uCCIUPbcxtOABIDMIYyWvhwPBC8hdMcunoIUkZ5dPyrS7uJMvidP65Na7gBY
         19sQ==
X-Gm-Message-State: APjAAAVBpomj0oxtbHF8xjK/3alaRdppeMw0LbECJZor/0w3kj2lzoLr
        2VDjybMdS7AKYut371jwkX7x8Q==
X-Google-Smtp-Source: APXvYqxQm03vHRDTjjXInJLdprCbt2w9mLeFMxdlR/vcgfzYjvUlzdeWGHlBfh8DBiBmPLW9JxjyvQ==
X-Received: by 2002:a0c:d604:: with SMTP id c4mr10296987qvj.27.1561762125846;
        Fri, 28 Jun 2019 15:48:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q9sm1353291qkm.63.2019.06.28.15.48.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 15:48:45 -0700 (PDT)
Date:   Fri, 28 Jun 2019 15:48:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.io, ast@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tls: remove close callback sock unlock/lock and
 flush_sync
Message-ID: <20190628154841.32b96fb1@cakuba.netronome.com>
In-Reply-To: <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
References: <156165697019.32598.7171757081688035707.stgit@john-XPS-13-9370>
        <156165700197.32598.17496423044615153967.stgit@john-XPS-13-9370>
        <20190627164402.31cbd466@cakuba.netronome.com>
        <5d1620374694e_26962b1f6a4fa5c4f2@john-XPS-13-9370.notmuch>
        <20190628113100.597bfbe6@cakuba.netronome.com>
        <5d166d2deacfe_10452ad82c16e5c0a5@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 12:40:29 -0700, John Fastabend wrote:
> The lock() is already held when entering unhash() side so need to
> handle this case as well,
> 
> CPU 0 (free)          CPU 1 (wq)
> 
> lock(sk)              ctx = tls_get_ctx(sk) <- need to be check null ptr
> sk_prot->unhash()
>   set_bit()
>   cancel_work()
>   ...
>   kfree(ctx)
> unlock(sk)
> 
> but using cancel and doing an unlikely(!ctx) check should be
> sufficient to handle wq. 

I'm not sure we can kfree ctx, the work struct itself is in it, no?

> What I'm not sure how to solve now is
> in patch 2 of this series unhash is still calling strp_done
> with the sock lock. Maybe we need to do a deferred release
> like sockmap side?

Right, we can't do anything that sleeps in unhash, since we're holding
the spinlock there, not the "owner" lock.

> Trying to drop the lock and then grabbing it again doesn't
> seem right to me seems based on comment in tcp_abort we
> could potentially "race with userspace socket closes such
> as tcp_close". iirc I think one of the tls splats from syzbot
> looked something like this may have happened.
> 
> For now I'm considering adding a strp_cancel() op. Seeing
> we are closing() the socket and tearkng down we can probably
> be OK with throwing out strp results.

But don't we have to flush the work queues before we free ctx?  We'd
need to alloc a workqueue and schedule a work to flush the other works
and then free?

Why can't tls sockets exist outside of established state?  If shutdown
doesn't call close, perhaps we can add a shutdown callback?  It doesn't
seem to be called from BH?

Sorry for all the questions, I'm not really able to fully wrap my head
around this. I also feel like I'm missing the sockmap piece that may
be why you prefer unhash over disconnect.

FWIW Davide's ULP diag support patches will require us to most likely
free ctx with kfree_rcu(). diag only has a ref on struct sock, so if 
we want to access ctx we need RCU or to lock every socket. It's a
little bit of an abuse of RCU, because the data under our feet may
actually change, but the fields we dump will only get inited once
after ulp is installed.
