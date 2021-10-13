Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10F742C688
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhJMQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhJMQkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:40:36 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D4BC061753;
        Wed, 13 Oct 2021 09:38:32 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id v195so8018044ybb.0;
        Wed, 13 Oct 2021 09:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G3sA9caxPGM4x8EBmsudver19e8pPfYKngLXfDu/Axk=;
        b=ERyD9piwvchicedir608WIPrj2YiGGNCbo1adskfiXwI3qUIJIwjoXFLUhMHhr62oj
         NjQnhf7tnQp6sndckyXq8eXa1qFOfaoBRxC3NhMKW8Fx4xkeLT1fl+jodSBKK69GBVV+
         i/h0Kg3qwHTXQaZofAbDEMj9tfyt9G0UrxRJz3BDpohCLevBCBbOuauRt9gMh4Jvyvtm
         nd6FKi1uG/lj2E3gy/y4Wx+aF1smfYGGi7YBxoKEVp3N5OYCFNkDcCNNwrGMoudpwl2z
         IBEzUE6/ilx8jeFpSYWkzynUu4UCGrM1JUILU6OUHn50UNYnV8KX19+k/hJZg114YKmm
         4/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G3sA9caxPGM4x8EBmsudver19e8pPfYKngLXfDu/Axk=;
        b=q2+jHTIrROnszDhHZUHclUGS/nTYiGm7TDCtZovNufVJswgnm4JlQoCbQea2Qj6xuQ
         CiSBoYjzNrjoQtZajyf3yQ27bJLNRY0ti9zKv7DzNRc0n8Xcni7hb1TNqxNlpSsvYtLA
         OpygfhMPr6aP7HYn93doNsx3oqEdtsrRZdyg83u3DSe753UGjPYGymFu98gozkt7uq9O
         vchLoG2FJFIMG7KOTdMh8aHN0HMG5AQagXf/7A7htuxbvLbABWenJB4WTjjntoCPiQNI
         18UAEVCo6ZygqqGB//6ABnemblFF9oioWPGg3IiJw1uJW2ScQZ7dOxGDynUCjg6JPIO9
         yeJA==
X-Gm-Message-State: AOAM531Br6KW1VYzRAeO+T7INX3XW3nQg8zqI49tgEXiuh3DQFXtdcQK
        PFXXrqFvCnixWKSjefSjHofhDbV/MeamFK7RSYg=
X-Google-Smtp-Source: ABdhPJxBYK2ykSxhcrE0OykXGuGrh8yEiTrl5se+OBs2a53M8IB3zXHsQADKTgiYqkOupxC334fUTVlFGDFts7pquP0=
X-Received: by 2002:a25:2586:: with SMTP id l128mr428355ybl.482.1634143111819;
 Wed, 13 Oct 2021 09:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211008204604.38014-1-xiyou.wangcong@gmail.com> <616517b9b7336_2215c208b2@john-XPS-13-9370.notmuch>
In-Reply-To: <616517b9b7336_2215c208b2@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 13 Oct 2021 09:38:20 -0700
Message-ID: <CAM_iQpXqCQ1BPwqokr6djGmGEHF5BXQDQEPygq16FHDJwxk=uA@mail.gmail.com>
Subject: Re: [Patch bpf] udp: validate checksum in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 10:06 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > It turns out the skb's in sock receive queue could have
> > bad checksums, as both ->poll() and ->recvmsg() validate
> > checksums. We have to do the same for ->read_sock() path
> > too before they are redirected in sockmap.
> >
> > Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> > Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> > Reported-by: John Fastabend <john.fastabend@gmail.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/ipv4/udp.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 8536b2a7210b..0ae8ab5e05b4 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1808,6 +1808,17 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >               skb = skb_recv_udp(sk, 0, 1, &err);
> >               if (!skb)
> >                       return err;
> > +
> > +             if (udp_lib_checksum_complete(skb)) {
> > +                     __UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
> > +                                     IS_UDPLITE(sk));
> > +                     __UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
> > +                                     IS_UDPLITE(sk));
> > +                     atomic_inc(&sk->sk_drops);
> > +                     kfree_skb(skb);
>
> We could use sock_drop() here? Otherwise looks good thanks.

sock_drop() is in include/linux/skmsg.h, I think we need to move it
to sock.h before using it here in net/ipv4/udp.c, right?

And there are other similar patterns which can be replaced with
sock_drop(), so we can do the replacement for all in a separate
patch.

Thanks.
