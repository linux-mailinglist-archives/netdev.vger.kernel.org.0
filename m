Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9361350F2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 02:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgAIBVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 20:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgAIBVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 20:21:44 -0500
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04602070E;
        Thu,  9 Jan 2020 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578532903;
        bh=nkUAKjPo9sGjCXJAMdjezLZohnXHrZph9WGLCj0+iHU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Mo0WMzYJ6BuN10Nmz55IDnoR4hPnV7tiPy63qev0Ipf9lwDiWtXY3EjEnHrkU19Z7
         POgD1Rnpc6+tkzywtpR5oBhYXIO6Fb72gU15sRo8gyxcRq4pjSbCJESe+rQS5e1G+i
         qsnym77hmgBkTmCaqUJ10pixF4Fd4HisCZmTnZkE=
Received: by mail-qk1-f175.google.com with SMTP id w127so4517340qkb.11;
        Wed, 08 Jan 2020 17:21:43 -0800 (PST)
X-Gm-Message-State: APjAAAX0FR0KzGPkHRK97VRx7actz1RH8ei1g7iVMlOtyYXXfN9pnuzK
        Pqws7N7tGbP2oLgTWrs8GlXUMA+NANJnL1Nk2bw=
X-Google-Smtp-Source: APXvYqxxJfkPYyD3WDpyNUTzJo/txTUzWXs731MRMccvlZ7heH93oVSZfqoEnlBDj3j0Ppg3j2yyV00LQMI0a2zSpss=
X-Received: by 2002:ae9:e103:: with SMTP id g3mr7346318qkm.353.1578532902812;
 Wed, 08 Jan 2020 17:21:42 -0800 (PST)
MIME-Version: 1.0
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
In-Reply-To: <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 8 Jan 2020 17:21:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7tVhR1oFtsZ9t0bQdBQtgAKsRpGH9N5ir7JhMBTm81PQ@mail.gmail.com>
Message-ID: <CAPhsuW7tVhR1oFtsZ9t0bQdBQtgAKsRpGH9N5ir7JhMBTm81PQ@mail.gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required rcu_read_{un}lock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:36 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Now that we depend on rcu_call() and synchronize_rcu() to also wait
> for preempt_disabled region to complete the rcu read critical section
> in __dev_map_flush() is no longer relevant.
>
> These originally ensured the map reference was safe while a map was
> also being free'd. But flush by new rules can only be called from
> preempt-disabled NAPI context. The synchronize_rcu from the map free
> path and the rcu_call from the delete path will ensure the reference
> here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
> pair to avoid any confusion around how this is being protected.
>
> If the rcu_read_lock was required it would mean errors in the above
> logic and the original patch would also be wrong.
>
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
