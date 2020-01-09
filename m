Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5151136192
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgAIUJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 15:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgAIUJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 15:09:11 -0500
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF00D20838;
        Thu,  9 Jan 2020 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578600550;
        bh=Big29PueexW7yE0BmPEfwB428xl5NVP9nUpTEaSYXmI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XZU+QzBYRCJJff3UULt68MW0T2xjrVqP0eW8OuMk1sgqUN1UKZnHRxlusbYtVKrnc
         UGYclMWcq1QOXVlCNgzJFVpZCXLzADUV8xGbocH6P8ewQkHykz0H0lyRxGlYI4+WXn
         oEFJX+IVPc/nHf3A323NrPGGbHQPeTLbnRMmDfRQ=
Received: by mail-qk1-f169.google.com with SMTP id t129so7227002qke.10;
        Thu, 09 Jan 2020 12:09:10 -0800 (PST)
X-Gm-Message-State: APjAAAWEvs5AFpVinHe1UBXpnAGvVaYuICQMzp+CBsewjc8YU+VgHFoD
        i+mjVYzMB0St9iRdVSjmpfwdK+nSxJxkMxXmeeA=
X-Google-Smtp-Source: APXvYqzVzRDsw2JT5BjOE4qWDaz2TxUmCrXlk+wS2W/VRQVdc+EYltHHjZDPxG2Vl+RYSPZVxxNLz44n5t/pfTUnk3o=
X-Received: by 2002:a05:620a:1324:: with SMTP id p4mr11508648qkj.497.1578600549816;
 Thu, 09 Jan 2020 12:09:09 -0800 (PST)
MIME-Version: 1.0
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2> <157851817088.1732.14988301389495595092.stgit@ubuntu3-kvm2>
In-Reply-To: <157851817088.1732.14988301389495595092.stgit@ubuntu3-kvm2>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Jan 2020 12:08:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW774z68g_Y-C1XU70H-x6S2mr+Hd0-qY02E9aZBJjepkA@mail.gmail.com>
Message-ID: <CAPhsuW774z68g_Y-C1XU70H-x6S2mr+Hd0-qY02E9aZBJjepkA@mail.gmail.com>
Subject: Re: [bpf PATCH 8/9] bpf: sockmap/tls, tls_push_record can not handle
 zero length skmsg
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:17 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> When passed a zero length skmsg tls_push_record() causes a NULL ptr
> deref. To resolve for fixes do a simple length check at start of
> routine.

Could you please include the stack dump for the NULL deref?

Thanks,
Song

>
> To create this case a user can create a BPF program to pop all the
> data off the message then return SK_PASS. Its not a very practical
> or useful thing to do so we mark it unlikely.
>
> Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/tls/tls_sw.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 21c7725d17ca..0326e916ab01 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -680,6 +680,9 @@ static int tls_push_record(struct sock *sk, int flags,
>         msg_pl = &rec->msg_plaintext;
>         msg_en = &rec->msg_encrypted;
>
> +       if (unlikely(!msg_pl->sg.size))
> +               return 0;
> +
>         split_point = msg_pl->apply_bytes;
>         split = split_point && split_point < msg_pl->sg.size;
>         if (unlikely((!split &&
>
