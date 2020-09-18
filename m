Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FD22708F0
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 00:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIRW0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 18:26:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgIRW0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 18:26:40 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787432220C;
        Fri, 18 Sep 2020 22:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600467999;
        bh=227oESQ7+B/CbICazXDivsh+4WfScaffUrrHgFBormI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wRxmOHLz4ne5weGrgPDeUE31uCGVB96M+oMZ58a5FhbBvbK+LHTbxPTE5PYGCJr2A
         9M/xm3Od4XJTSTmE4pMVe6XRMXvktxmSnZjyKG+hEQvUvxebKhiUc05sVEHNklQ25c
         NW4Ul3AOI9IIq/l3dAefySwxLPoWFZic1HJ22+Qs=
Received: by mail-lf1-f46.google.com with SMTP id b22so7690153lfs.13;
        Fri, 18 Sep 2020 15:26:39 -0700 (PDT)
X-Gm-Message-State: AOAM5333M5HTb2tKW/JMNUfnrmuq66PAdsz+sk+KtnbWcnc8qcvINGFO
        AvCLIkQZtNhOWYmel1MyzQDsmvrCfDPUZxctOes=
X-Google-Smtp-Source: ABdhPJyPMV28u/36HIp9uzNwpWJYYEcHG5pRT+AhxgIipClPww3MamLQTZcAsL7N5Bmpb5Xf7gpXpCSRyqSKQBtXEng=
X-Received: by 2002:a19:7902:: with SMTP id u2mr12710536lfc.515.1600467997762;
 Fri, 18 Sep 2020 15:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
In-Reply-To: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Sep 2020 15:26:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6=EDSwBvQzJUvc6uAytgp13bgfLXQgFnmBfsbFAgUzbQ@mail.gmail.com>
Message-ID: <CAPhsuW6=EDSwBvQzJUvc6uAytgp13bgfLXQgFnmBfsbFAgUzbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/5] bpf: expose is_mptcp flag to bpf_tcp_sock
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 5:13 AM Nicolas Rybowski
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

Acked-by: Song Liu <songliubraving@fb.com>
[...]
