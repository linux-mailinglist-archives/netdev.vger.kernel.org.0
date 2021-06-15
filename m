Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27CE3A8416
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhFOPha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhFOPh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:37:28 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E836FC061767
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:35:22 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id c8so19422500ybq.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/TW++UaYH676wBlxAmC5epOAFhyC7J56lUkKh39lO7w=;
        b=i9s9QuGtGYUZIpHX1mDsmvAli3APV1bnEClSUAQuQkTp6lMS5FBJ3rNm6CHo/TmTky
         cCSQllfsfxI0Otq8jBh0LSthABYKt5wtuPiiV94lS9FfZfv4r1lfLRoVhAb7GhxdccOq
         G+3zUsMBML7/+CbFx0w6DlyLp7QCEhjfDX9USfwbFNXfrvhhT9Ph6kuW73CclrBFekDG
         6BI5skkWF91+i2He/zCobWaFuTzJi/4OTiOzg3WVcbBR4RUUJAl3+6IuctcpyAph+NoL
         xQkAhb5ENwOuhvhLnBxRTUtcEhe9pcpXPudD9XW/yYFi4NZO7+c3CxcpzDQrKKgMYm/k
         Bscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/TW++UaYH676wBlxAmC5epOAFhyC7J56lUkKh39lO7w=;
        b=T02+nycez8uQpYo01NSBin/iROW7DIcJH5uKMTCTBkXWAzOd9BA6hjg1n9xJs53Urp
         g1k73PYHG4cFg9XjJfN5VQDih+TRErwLRIDFSEmA3eoheDQgIRFlSMwvOqM14HpHOBOg
         lfecrlyhYrekucKkjS8ZbZtzRRUU0vFYR2Kp4QGfoXixTULLQ18helfyyVaAik6Z1WrU
         KB6ES1KrBAC5mXXAF8iD60SRWOlAVE3123i+HCMp0qFvSQttq6qPQenY6RFlPW9vd/zV
         xrQzmPbaDLqZSWxaBn2YdFajoIU0ocm5kqL4Z4sgKzICDBM5cPg1Ica+7Sx24l1LMEFR
         M+iQ==
X-Gm-Message-State: AOAM530vfwG1ZIQk3wgUvyJJSZKrJ3L3Ofy/tSPQvD095cw3m9BOpioy
        dsT1Gop18NE0Kc1gfnjQEwYy1jGMcRfzMHXNfR/fEw==
X-Google-Smtp-Source: ABdhPJyU4VoPOerwCdHdI/jGGLIbnbwrAkYWkiCKScaeblfZCVDF0S0kXo5eZbi0qJoHTNMn0naDL9ROsuN4+BIxc08=
X-Received: by 2002:a25:1fc6:: with SMTP id f189mr33298185ybf.452.1623771321743;
 Tue, 15 Jun 2021 08:35:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210612123224.12525-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210612123224.12525-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Jun 2021 17:35:10 +0200
Message-ID: <CANn89iLxZxGXaVxLkxTkmNPF7XZdb8DKGMBFuMJLBdtrJRbrsA@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 2:32 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>

>
>
> Changelog:
>  v8:
>   * Make reuse const in reuseport_sock_index()
>   * Don't use __reuseport_add_sock() in reuseport_alloc()
>   * Change the arg of the second memcpy() in reuseport_grow()
>   * Fix coding style to use goto in reuseport_alloc()
>   * Keep sk_refcnt uninitialized in inet_reqsk_clone()
>   * Initialize ireq_opt and ipv6_opt separately in reqsk_migrate_reset()
>
>   [ This series does not include a stats patch suggested by Yuchung Cheng
>     not to drop Acked-by/Reviewed-by tags and save reviewer's time. I will
>     post the patch as a follow up after this series is merged. ]
>

For the whole series.

Reviewed-by: Eric Dumazet <edumazet@google.com>
