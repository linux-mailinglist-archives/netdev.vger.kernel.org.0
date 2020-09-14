Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830572694AD
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINSU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgINSUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:20:54 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67E9321D7B;
        Mon, 14 Sep 2020 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600107653;
        bh=BAjJTlDtrbfSxx3WpXifRRlUlkkL6nq/6bBLXSRWPJM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kPWTPtFmGeAcUwV2ZzcSWRLVUn+chuLd0NhGULBRQ+mOorNLZ19F5q/V2RhCj2MRj
         vN3hZ1c3c87HkfKtvIQpoAf/F7rrxQgnJ5PTgfWTl9lNtg4pqyVtSwWPubgfqOnNCI
         +zRYSUDpw8rpBpZQ/xk8gLHFcEZgPE+EE9CWAb5g=
Received: by mail-lf1-f47.google.com with SMTP id d15so266429lfq.11;
        Mon, 14 Sep 2020 11:20:53 -0700 (PDT)
X-Gm-Message-State: AOAM533aiOb13/7WyyO9G5jKLmSQHASmgMA6xp2fBHTuSKdSB4SlPY/M
        fGKSPkMoPt3UKHXR0B0u60htp59IdV1r96R3V8o=
X-Google-Smtp-Source: ABdhPJxoTxm1xcGm5mS9x2ZonnbPk6/jiP4lwuM2k2GJ8gJUA03fMwGd0MKe4URzQ/whPBokmgSVduJDna9EJ/Gucek=
X-Received: by 2002:a19:992:: with SMTP id 140mr4464849lfj.273.1600107651627;
 Mon, 14 Sep 2020 11:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
In-Reply-To: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 11:20:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW74oqvhySsVqLKrtz9r-EJxHrXza0gSGK2nm6GnKjmakQ@mail.gmail.com>
Message-ID: <CAPhsuW74oqvhySsVqLKrtz9r-EJxHrXza0gSGK2nm6GnKjmakQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] bpf: expose is_mptcp flag to bpf_tcp_sock
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 8:07 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> is_mptcp is a field from struct tcp_sock used to indicate that the
> current tcp_sock is part of the MPTCP protocol.
>
> In this protocol, a first socket (mptcp_sock) is created with
> sk_protocol set to IPPROTO_MPTCP (=262) for control purpose but it
> isn't directly on the wire. This is the role of the subflow (kernel)
> sockets which are classical tcp_sock with sk_protocol set to
> IPPROTO_TCP. The only way to differentiate such sockets from plain TCP
> sockets is the is_mptcp field from tcp_sock.
>
> Such an exposure in BPF is thus required to be able to differentiate
> plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OPS
> programs.
>
> The choice has been made to silently pass the case when CONFIG_MPTCP is
> unset by defaulting is_mptcp to 0 in order to make BPF independent of
> the MPTCP configuration. Another solution is to make the verifier fail
> in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
> '#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
> will not run if MPTCP is not set.
>
> An example use-case is provided in
> https://github.com/multipath-tcp/mptcp_net-next/tree/scripts/bpf/examples
>
> Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  net/core/filter.c              | 9 ++++++++-
>  tools/include/uapi/linux/bpf.h | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7dd314176df7..7d179eada1c3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4060,6 +4060,7 @@ struct bpf_tcp_sock {
>         __u32 delivered;        /* Total data packets delivered incl. rexmits */
>         __u32 delivered_ce;     /* Like the above but only ECE marked packets */
>         __u32 icsk_retransmits; /* Number of unrecovered [RTO] timeouts */
> +       __u32 is_mptcp;         /* Is MPTCP subflow? */

Shall we have an __u32 flags, and make is_mptcp a bit of it?

Thanks,
Song
[...]
