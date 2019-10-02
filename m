Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3FC9318
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbfJBU5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:57:20 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44414 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfJBU5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:57:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so509619qth.11;
        Wed, 02 Oct 2019 13:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lBRtIu7khuvHqmEcKRJqmLxKD+g3RDOIkNxY/EmNt24=;
        b=kTWePzepNBi9G2bJZ8mA1g/rDGjH6Nk2yHtXNovG/ac0AAsLnQ8oVtVBXYJhzsFeXO
         gwrbvCKbzrU+A9z1ihqApJm8O0VVK+4j34UdCMm/rGhizVDe2LYuRyPulWKcX4eWY6kD
         qvWqZHOkKFeJmwhPN/DF44HPJR+sgQE6sax40WQAYxQDjYgVuiOODa56Xd/MO6ct8M2O
         g3u+M/J3wL2Ovt5DaGbbEhG5NfpD9bN0hL6MHIXsXodEzDovm7fOKP8CCgVLqZ9UTYBb
         KsVEg9eEXB44fQcqOi+PE4znXZrcCA44KS004PCeUX2miTbf7dJry5ee/8U+8NFgjYKN
         liVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lBRtIu7khuvHqmEcKRJqmLxKD+g3RDOIkNxY/EmNt24=;
        b=TF8ArF8XH8OClwGxxE+s8IXPzBL3Dad57ZHhBLzfYBAKQtTHU9DgyMA26H+8uqSIiP
         NBHwT+8WdtXx9Wt9tfiw+IXtLxa6ePIHAwgcgSX0KRAg7vOtDX21wEE5sW+KRLATqRa/
         sp50ltwsLugwUYdyc5LRsXjO0QmDIdfPnhyWg/YmZfGTCewJapjKtYFMdiQSxXmX33i+
         kiKB/NrLHGVxADILT5UXF00UKsUBE+cnGU88//jGETKyO0zWv4vDnx3ziftBa81ksdsI
         /H1nvoX+2MonNmVGs6bH6qr1OdgKgoiixGj0WWLvY//I0TK9GVEYyo8Zkl6o2ECMT5Zf
         I07Q==
X-Gm-Message-State: APjAAAXA5VvxCOA23X9PnVeL8tnQ/CENzTQl+w9k+xjFh1qp/EngJWaH
        G519iuttOhpO9skVDjpBuNcMHCwgZWWgpymaHbo=
X-Google-Smtp-Source: APXvYqxLTy1mtbVueW4MPazVD8PiMqUsG8g8EPrwshM1czo2mde/7BhrkkCX1p8q9TuGyK0Act2L4NSKiaTSp9yPjbY=
X-Received: by 2002:ac8:37cb:: with SMTP id e11mr6530720qtc.22.1570049838775;
 Wed, 02 Oct 2019 13:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191002173357.253643-1-sdf@google.com> <20191002173357.253643-2-sdf@google.com>
In-Reply-To: <20191002173357.253643-2-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 2 Oct 2019 13:57:07 -0700
Message-ID: <CAPhsuW6ywq5yySKjtdna8rXGBWdUyFgxQuy0+=2-gReXSTQ=ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf/flow_dissector: add mode to enforce
 global BPF flow dissector
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 10:36 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Always use init_net flow dissector BPF program if it's attached and fall
> back to the per-net namespace one. Also, deny installing new programs if
> there is already one attached to the root namespace.
> Users can still detach their BPF programs, but can't attach any
> new ones (-EPERM).
>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  Documentation/bpf/prog_flow_dissector.rst |  3 +++
>  net/core/flow_dissector.c                 | 11 ++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/bpf/prog_flow_dissector.rst b/Documentation/bpf/prog_flow_dissector.rst
> index a78bf036cadd..4d86780ab0f1 100644
> --- a/Documentation/bpf/prog_flow_dissector.rst
> +++ b/Documentation/bpf/prog_flow_dissector.rst
> @@ -142,3 +142,6 @@ BPF flow dissector doesn't support exporting all the metadata that in-kernel
>  C-based implementation can export. Notable example is single VLAN (802.1Q)
>  and double VLAN (802.1AD) tags. Please refer to the ``struct bpf_flow_keys``
>  for a set of information that's currently can be exported from the BPF context.
> +
> +When BPF flow dissector is attached to the root network namespace (machine-wide
> +policy), users can't override it in their child network namespaces.
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 7c09d87d3269..494e2016fe84 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -115,6 +115,11 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
>         struct bpf_prog *attached;
>         struct net *net;
>
> +       if (rcu_access_pointer(init_net.flow_dissector_prog)) {
> +               /* Can't override root flow dissector program */
> +               return -EPERM;

Maybe -EBUSY is more accurate?

Thanks,
Song
