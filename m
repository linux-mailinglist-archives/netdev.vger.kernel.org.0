Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE3133099
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfFCNHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:07:37 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35015 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFCNHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:07:37 -0400
Received: by mail-qk1-f194.google.com with SMTP id l128so322696qke.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSEdgqESlMSsojoD0L6U8hdhvYh8fKdpdX1m+uG6RFw=;
        b=DW+1tj6N1A9FAqtzap+AF6eatkOZTRTXTNwk0XFkECvmtI5lf6m5JH8zaLMoOV49Fe
         pfGivCOkFydNDnB4SiT8LQZ6a3GosrtEz6VufOBIGuvqSpKaUeuhErLpMIaew66tE23s
         1zMqpaUd/0fdVLdsdsKSrbXhbMa00wFK6fjAFYNiGY8mxd6HhoU3XUITgtfdfbPCfYMp
         4DNHJ1fEpUUQuVtENTeM5BuuXW2b+lCFQVKnZv4S/NJAaanDHpcsNRnd74Gjj8gtfhmz
         M4ncQGkj3SKmOcIvTfsXgD+lHz31scAjqrqxeoXoZhEw3V+t560vYe+odOzIPIEkw5UX
         WICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSEdgqESlMSsojoD0L6U8hdhvYh8fKdpdX1m+uG6RFw=;
        b=qgJSyav8w2pLPvqyh8+7IHOL6HBur3Ft0Owum/JvLUFQkjvIKUgvKE367243sM1sQV
         KJpWRbh6ytOoagzFyb2VFeGCq1XglEA9UgW0qMEwhUTYiuxn/+BGTnncJx+jdhQdrQMs
         QwvgNbPybqJSmbucvYlYjyV9XuR2dhA8alg6Pc5ptVL5AeMtzA3N8nWt2w006dD/Bf2x
         NXI8n6NpwGnFBKftCYhYi1zqFp2vUYw0QFaF+UPqN7ViCaG/2t2I775V2loCB8CI7nNL
         rCyJKaGa2Hs5dv/5t67/Qb4hw9FiLHYxrt+x1lsgssZedhWzlIODTCt2OnpaKoRaIgze
         NeSQ==
X-Gm-Message-State: APjAAAUoKOo8HyZazsNOWz7WzYMwjXkCisKJci5ui2PX6Y4+3s3Nvb64
        Ik0gLpAtctANp6KJEouA9rn4GEB7n4f0GS+fWSyJVgtS
X-Google-Smtp-Source: APXvYqyq3rUxBaOA0YTWzvW4UmUadCCZQDT1jRpuqGG7BQNosITRSlrgEDi9k3H2zgxs+fEv02BXOLT0hjqss3UsmnU=
X-Received: by 2002:a37:a9c9:: with SMTP id s192mr21560737qke.335.1559567256651;
 Mon, 03 Jun 2019 06:07:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190531222910.2499861-1-kafai@fb.com> <20190531222911.2500496-1-kafai@fb.com>
In-Reply-To: <20190531222911.2500496-1-kafai@fb.com>
From:   Craig Gallek <kraig@google.com>
Date:   Mon, 3 Jun 2019 09:07:33 -0400
Message-ID: <CAEfhGiyfydP4xggD-v5DCXyM0mtaEa5oPu39WLD7o8v_DgobAA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: udp: ipv6: Avoid running reuseport's
 bpf_prog from __udp6_lib_err
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 6:29 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> __udp6_lib_err() may be called when handling icmpv6 message. For example,
> the icmpv6 toobig(type=2).  __udp6_lib_lookup() is then called
> which may call reuseport_select_sock().  reuseport_select_sock() will
> call into a bpf_prog (if there is one).
>
> reuseport_select_sock() is expecting the skb->data pointing to the
> transport header (udphdr in this case).  For example, run_bpf_filter()
> is pulling the transport header.
>
> However, in the __udp6_lib_err() path, the skb->data is pointing to the
> ipv6hdr instead of the udphdr.
>
> One option is to pull and push the ipv6hdr in __udp6_lib_err().
> Instead of doing this, this patch follows how the original
> commit 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
> was done in IPv4, which has passed a NULL skb pointer to
> reuseport_select_sock().
>
> Fixes: 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
> Cc: Craig Gallek <kraig@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: Craig Gallek <kraig@google.com>
