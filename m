Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108F314A46B
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgA0ND0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:03:26 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37382 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0NDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:03:25 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so6133319lfc.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=VDyYhqW8q5Ak22YpLURiDz1wi+K6rv4J/LUbazxWPYs=;
        b=GAPCdOUUYv3Mo0M2HYvF7mHmqT1+90QUtscvLVOKuba0f9wPDvpHDgs9W0/X74xop+
         726ry5P6zg3sBMb2oJOP4lz7aGgsdQWzg6x5U4CWnhvJLqQJ0qBeCBbCx3lQvUzyioAd
         a8CNjukCsZSP3V7wy8LsQ1KVlsCB6TokRmowQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=VDyYhqW8q5Ak22YpLURiDz1wi+K6rv4J/LUbazxWPYs=;
        b=YRxqntJyORj89jTZGLF8gBYBQc4ajPrzU/1vKUPTjmGAARCND8yMJX74yogZlkDyh6
         GeqbHN2b4EYEwb4KbFJ5Ypuy+M+hK96WoIoPNRwlo17acpWafljQUIscMadkGpjtEuCl
         mZfG0mtWTAnvIePnUDt4gZE5HChFeRL+HCnT7WAJNGdj0GTY6h1AT3nLS/mRu235xhJf
         GeT90XdIwU7O7JDFvb+NrXq1Omh4NF4Vu4xcft/K6kYL/2qYG7Qu9HOx0rfKy/0x2wUn
         wfS8KsR2SU6oOc8SkmCckkNaz8wnAHN83xa8WU/+afLJ2sqgv6EoLgbySFyZT1vPTPKb
         wjdg==
X-Gm-Message-State: APjAAAUHWIXYj1hM3AobceAJ3/Hui9TAzcejBqaQHiLq0r4RJkRdEJLT
        zbGKh/un2YhetTq29d8kobC6Hre/HlBz/w==
X-Google-Smtp-Source: APXvYqzW5lUoX8CpDni33LG4u5BwSsBKkY+fAIGhsC7Gvqb7txl28YVOZ26kyOJlPoYh7OJVoXtr1Q==
X-Received: by 2002:a19:48c5:: with SMTP id v188mr8199626lfa.100.1580130203982;
        Mon, 27 Jan 2020 05:03:23 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n30sm10097363lfi.54.2020.01.27.05.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:03:23 -0800 (PST)
References: <20200123155534.114313-1-jakub@cloudflare.com> <f82cfdef-6674-d7c8-4173-cd6488dd4b9c@iogearbox.net>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 00/12] Extend SOCKMAP to store listening sockets
In-reply-to: <f82cfdef-6674-d7c8-4173-cd6488dd4b9c@iogearbox.net>
Date:   Mon, 27 Jan 2020 14:03:22 +0100
Message-ID: <87d0b5caqt.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 12:13 PM CET, Daniel Borkmann wrote:
> On 1/23/20 4:55 PM, Jakub Sitnicki wrote:
> [...]
>> Jakub Sitnicki (12):
>>    bpf, sk_msg: Don't clear saved sock proto on restore
>>    net, sk_msg: Annotate lockless access to sk_prot on clone
>>    net, sk_msg: Clear sk_user_data pointer on clone if tagged
>>    tcp_bpf: Don't let child socket inherit parent protocol ops on copy
>>    bpf, sockmap: Allow inserting listening TCP sockets into sockmap
>>    bpf, sockmap: Don't set up sockmap progs for listening sockets
>>    bpf, sockmap: Return socket cookie on lookup from syscall
>>    bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
>>    bpf: Allow selecting reuseport socket from a SOCKMAP
>>    net: Generate reuseport group ID on group creation
>>    selftests/bpf: Extend SK_REUSEPORT tests to cover SOCKMAP
>>    selftests/bpf: Tests for SOCKMAP holding listening sockets
>>
>>   include/linux/skmsg.h                         |   15 +-
>>   include/net/sock.h                            |   37 +-
>>   include/net/sock_reuseport.h                  |    2 -
>>   include/net/tcp.h                             |    7 +
>>   kernel/bpf/reuseport_array.c                  |    5 -
>>   kernel/bpf/verifier.c                         |    6 +-
>>   net/core/filter.c                             |   27 +-
>>   net/core/skmsg.c                              |    2 +-
>>   net/core/sock.c                               |   11 +-
>>   net/core/sock_map.c                           |  133 +-
>>   net/core/sock_reuseport.c                     |   50 +-
>>   net/ipv4/tcp_bpf.c                            |   17 +-
>>   net/ipv4/tcp_minisocks.c                      |    2 +
>>   net/ipv4/tcp_ulp.c                            |    3 +-
>>   net/tls/tls_main.c                            |    3 +-
>>   .../bpf/prog_tests/select_reuseport.c         |   60 +-
>>   .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
>>   .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
>>   tools/testing/selftests/bpf/test_maps.c       |    6 +-
>>   19 files changed, 1811 insertions(+), 107 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c
>>
>
> Unfortunately, the series needs one last rebase in order to be applied due
> to conflicts from John's earlier sockmap/tls fixes from Jan/11th [0].

If it's not too late, it has been now rebased [0].

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/87eevlcauo.fsf@cloudflare.com/T/#t
