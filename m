Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4620433200
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 11:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhJSJSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 05:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhJSJSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 05:18:45 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD85C061745
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 02:16:32 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z11so5995871lfj.4
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 02:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cxhBllE4qGFDGgzgKWWLi0zeBxQnDNBJTirScQAPH6k=;
        b=p54i6P06LTDaCPBW4CrsJWb73kTEh+TA89xUqk7Jd2oywEHlGVEYAsjKGLDBC2535y
         TsQn04umL7+y8g3xhdBTrAMEvv1rIBlUhpt1z2uVwQ+tRkjIIZrbn50cu8ZebudlbsM3
         GfhCeuIVGsmMF5jdROtkal/4I5S9nnNcdaV9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cxhBllE4qGFDGgzgKWWLi0zeBxQnDNBJTirScQAPH6k=;
        b=SF/uoDb4hn2RzpzYyiYzFmptqQHosN16t92zUKxLkRL8YfWzZqFLyiOLTSyk1Bis9x
         XbGeyhRfR5JIwaZQcOKSnEWNjY0+C+HMoa5vssC/vVheR5873KlfmC/kyNYY/bKYqkQr
         iuKau00utbX/jE2nmdLwBZIHpWIRjqAk9p2hn/tATCpYBZHA8FMDmrGZQ7I3xEmS+Vk6
         8mtd/RKbUuupfMS5loJz8DlJA4GwQWTL1Xy3N67JbPWHzaEyKk5/DdTQtKim/ry5RKG+
         MzDRb+J5E6ZpkLYi0IRRBzHAc54t82PpYXyJz1mltgEMpTv4sBR2UsiMvTXAtF1P0/X1
         LLqA==
X-Gm-Message-State: AOAM533Sx3Ymof2gl6Ga64r2qi7AnOjMKREzLm76NewYxCx2qxfQEzf8
        BVlDsiqpTn9VjXEcwXMMGFJuaw==
X-Google-Smtp-Source: ABdhPJxUeKr2wrSWuBx0TSBk2qJrKNOUCrH+GEBa8+DKn9RSfKsGBVi0ZH7xCQzy4XnMSpUOX1+y3g==
X-Received: by 2002:ac2:52a5:: with SMTP id r5mr5019056lfm.239.1634634991018;
        Tue, 19 Oct 2021 02:16:31 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-480d-6f00-ff34-bf12-0ef2-5071.aa.ipv6.supernova.orange.pl. [2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id h19sm1619568lfk.199.2021.10.19.02.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 02:16:30 -0700 (PDT)
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-3-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH bpf 2/4] bpf, sockmap: Fix race in ingress receive
 verdict with redirect to self
In-reply-to: <20211011191647.418704-3-john.fastabend@gmail.com>
Date:   Tue, 19 Oct 2021 11:16:29 +0200
Message-ID: <87sfwxfk7m.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
> A socket in a sockmap may have different combinations of programs
> attached depending on configuration. There can be no programs in which
> case the socket acts as a sink only. There can be a TX program in this
> case a BPF program is attached to sending side, but no RX program is
> attached. There can be an RX program only where sends have no BPF
> program attached, but receives are hooked with BPF. And finally,
> both TX and RX programs may be attached. Giving us the permutations,
>
>  None, Tx, Rx, and TxRx
>
> To date most of our use cases have been TX case being used as a fast
> datapath to directly copy between local application and a userspace
> proxy. Or Rx cases and TxRX applications that are operating an in
> kernel based proxy. The traffic in the first case where we hook
> applications into a userspace application looks like this,
>
>   AppA  redirect   AppB
>    Tx <-----------> Rx
>    |                |
>    +                +
>    TCP <--> lo <--> TCP
>
> In this case all traffic from AppA (after 3whs) is copied into the
> AppB ingress queue and no traffic is ever on the TCP recieive_queue.
>
> In the second case the application never receives, except in some
> rare error cases, traffic on the actual user space socket. Instead
> the send happens in the kernel.
>
>            AppProxy       socket pool
>        sk0 ------------->{sk1,sk2, skn}
>         ^                      |
>         |                      |
>         |                      v
>        ingress              lb egress
>        TCP                  TCP
>
> Here because traffic is never read off the socket with userspace
> recv() APIs there is only ever one reader on the sk receive_queue.
> Namely the BPF programs.
>
> However, we've started to introduce a third configuration where the
> BPF program on receive should process the data, but then the normal
> case is to push the data into the receive queue of AppB.
>
>        AppB
>        recv()                (userspace)
>      -----------------------
>        tcp_bpf_recvmsg()     (kernel)
>          |             |
>          |             |
>          |             |
>        ingress_msgQ    |
>          |             |
>        RX_BPF          |
>          |             |
>          v             v
>        sk->receive_queue
>
>
> This is different from the App{A,B} redirect because traffic is
> first received on the sk->receive_queue.
>
> Now for the issue. The tcp_bpf_recvmsg() handler first checks the
> ingress_msg queue for any data handled by the BPF rx program and
> returned with PASS code so that it was enqueued on the ingress msg
> queue. Then if no data exists on that queue it checks the socket
> receive queue. Unfortunately, this is the same receive_queue the
> BPF program is reading data off of. So we get a race. Its possible
> for the recvmsg() hook to pull data off the receive_queue before
> the BPF hook has a chance to read it. It typically happens when
> an application is banging on recv() and getting EAGAINs. Until
> they manage to race with the RX BPF program.
>
> To fix this we note that before this patch at attach time when
> the socket is loaded into the map we check if it needs a TX
> program or just the base set of proto bpf hooks. Then it uses
> the above general RX hook regardless of if we have a BPF program
> attached at rx or not. This patch now extends this check to
> handle all cases enumerated above, TX, RX, TXRX, and none. And
> to fix above race when an RX program is attached we use a new
> hook that is nearly identical to the old one except now we
> do not let the recv() call skip the RX BPF program. Now only
> the BPF program pulls data from sk->receive_queue and recv()
> only pulls data from the ingress msgQ post BPF program handling.
>
> With this resolved our AppB from above has been up and running
> for many hours without detecting any errors. We do this by
> correlating counters in RX BPF events and the AppB to ensure
> data is never skipping the BPF program. Selftests, was not
> able to detect this because we only run them for a short
> period of time on well ordered send/recvs so we don't get any
> of the noise we see in real application environments.
>
> Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
