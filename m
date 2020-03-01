Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059E1174FE5
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgCAV0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 16:26:47 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38339 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgCAV0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 16:26:47 -0500
Received: by mail-lf1-f68.google.com with SMTP id w22so5320214lfk.5
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 13:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=9ChqPHQH4n+KZdKDaLvbA3opt3V3GK36fgbVk5eUyaw=;
        b=QG1FQ1WSUPpC1BKqu4S3LzB4MaSsyG4SaBm1uKbNf6uXXOsphx5tWjADzinWEFwZrA
         6IGJu7qmOCOtLlP3TkcOAZhwVUAroApkE/kBx5fpeKg1t1grhjmOF3hrfjb6/88uU6qk
         8I05sbn09Mg8+EaPphR5iU7H9lYNFHG04dvnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=9ChqPHQH4n+KZdKDaLvbA3opt3V3GK36fgbVk5eUyaw=;
        b=megtsPj9PW8RaYc7ekdbGrH5a5LLaIvT9+x6xwzRAlYQG4VquG1lzy20GkNU8uh9XX
         mCfP2k1fnNduaV+c4GBOkv5vOsWxdM0+Hkj8pcMBMu2mpA0lbisCmNTNgwElRS6I36BX
         Py4GP6/vYFqzPDADu1WKDG1CUlzMwgqm46EEujh+IXzkURwc1P9yrhynzZZaTWHjdyar
         nABH2JMLMsw2tEn9duLX34lAvIJ9NIJjrMSBTnFQ91Ckhn21RTag8I2woqX3exgK7tT3
         gbVI1oJ7VPeVnWAM3qhhgcI+LgCXzxty8emIbUzzcWry2yhDZvi5mfFmPbgsxKL8tVT+
         chJA==
X-Gm-Message-State: ANhLgQ2ClecoyINf3GoUxRxzQHXb+DuE/CZ046NWO+9ryIxVH8zEbKDm
        cZlnEDEXqzNQh6YpCdLNsHgEcQ==
X-Google-Smtp-Source: ADFU+vupC7v8Os2lX3z7yQH8PaugHzGwlvbsdW6JexF1dUKO7vyGmY0AWftVPTojH+98t+0VhuiwgA==
X-Received: by 2002:ac2:599e:: with SMTP id w30mr4964572lfn.80.1583098003137;
        Sun, 01 Mar 2020 13:26:43 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id z67sm9396409lfa.50.2020.03.01.13.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 13:26:42 -0800 (PST)
References: <20200228115344.17742-1-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/9] bpf: sockmap, sockhash: support storing UDP sockets
In-reply-to: <20200228115344.17742-1-lmb@cloudflare.com>
Date:   Sun, 01 Mar 2020 22:26:40 +0100
Message-ID: <875zfndawf.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 12:53 PM CET, Lorenz Bauer wrote:
> Thanks for all the reviews so far! I've fixed the identified bug and addressed
> feedback as much as possible.
>
> I've not taken up Jakub's suggestion to get rid of sk_psock_hooks_init. My
> intention is to encapsulate initializing both v4 and v6 protos. Really, it's
> down to personal preference, and I'm happy to remove it if others prefer
> Jakub's approach. I'm also still eager for a solution that requires less
> machinery.

I was going to do expenses but this seemed more fun. Challenge accepted.

I think we can massage tcp_bpf to extract sk_prot initialization bits
out of it into skmsg, and have skmsg call back into tcp/udp_bpf.

3 callbacks from skmsg back to tcp/udp_bpf would be needed to get there:

 - assert_proto_ops
 - check_v6_needs_rebuild
 - get_proto (akin to choose_proto in this series)

With that in place we could go for a direct dispatch based on sock type:

#define sk_psock_assert_proto_ops(sk, ops)		\
	(sk->sk_type == SOCK_STREAM			\
	 ? tcp_bpf_assert_proto_ops(ops)		\
	 : udp_bpf_assert_proto_ops(ops))

The steps to get there would be:

 1. extract tcp_bpf_get_proto
 2. fold tcp_bpf_update_sk_prot
 3. move tcp_bpf_init -> sk_psock_init_proto
 4. fold tcp_bpf_reinit_sk_prot
 5. move tcp_bpf_reinit -> sk_psock_reinit_proto
 6. add macros for callbacks into tcp_bpf
 7. add udp_bpf

... which I've given a shot at, mixing it into your patches:

  https://github.com/jsitnicki/linux/commits/extract-sk-psock-proto

Note, I didn't make an effort to share the code for rebuilding v6 proto
between tcp_bpf and udp_bpf. This construct seems hard to read already
as is without making it generic.

Final thought, I would probably place the bits common between tcp_bpf
and udp_bpf in skmsg under sk_psock_* namespace, instead of sockmap.

It is just my interpretation, but I think that was the idea outlined in
commit 604326b41a6f ("bpf, sockmap: convert to generic sk_msg
interface"):

    The code itself has been split and refactored into three bigger
    pieces: i) the generic sk_msg API which deals with managing the
    scatter gather ring, providing helpers for walking and mangling,
    transferring application data from user space into it, and preparing
    it for BPF pre/post-processing, ii) the plain sock map itself
    where sockets can be attached to or detached from; these bits
    are independent of i) which can now be used also without sock
    map, and iii) the integration with plain TCP as one protocol
    to be used for processing L7 application data (later this could
    e.g. also be extended to other protocols like UDP).

As skmsg already hosts some sk_psock_* functions used by tcp_bpf, and
they share the same build toggle NET_SK_MSG, that seems natural.

>
> Changes since v1:
> - Check newsk->sk_prot in tcp_bpf_clone
> - Fix compilation with BPF_STREAM_PARSER disabled
> - Use spin_lock_init instead of static initializer
> - Elaborate on TCPF_SYN_RECV
> - Cosmetic changes to TEST macros, and more tests
> - Add Jakub and me as maintainers
>
> Lorenz Bauer (9):
>   bpf: sockmap: only check ULP for TCP sockets
>   bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
>   bpf: sockmap: move generic sockmap hooks from BPF TCP
>   skmsg: introduce sk_psock_hooks
>   bpf: sockmap: allow UDP sockets
>   selftests: bpf: don't listen() on UDP sockets
>   selftests: bpf: add tests for UDP sockets in sockmap
>   selftests: bpf: enable UDP sockmap reuseport tests
>   bpf, doc: update maintainers for L7 BPF
>
>  MAINTAINERS                                   |   3 +
>  include/linux/bpf.h                           |   4 +-
>  include/linux/skmsg.h                         |  72 +++----
>  include/linux/udp.h                           |   4 +
>  include/net/tcp.h                             |  18 +-
>  net/core/skmsg.c                              |  55 +++++
>  net/core/sock_map.c                           | 160 ++++++++++----
>  net/ipv4/Makefile                             |   1 +
>  net/ipv4/tcp_bpf.c                            | 169 +++------------
>  net/ipv4/udp_bpf.c                            |  53 +++++
>  .../bpf/prog_tests/select_reuseport.c         |   6 -
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
>  12 files changed, 465 insertions(+), 284 deletions(-)
>  create mode 100644 net/ipv4/udp_bpf.c
