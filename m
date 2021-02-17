Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DB031DF3F
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhBQSuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhBQSuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:50:50 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02401C061574;
        Wed, 17 Feb 2021 10:50:11 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id t25so9066240pga.2;
        Wed, 17 Feb 2021 10:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7oIUj3r8BxsFmJaSw1nh70Ej/VN6R/q+ROJC0MVOM+w=;
        b=rumPC0zb9rt43N+U3HRnoTi2SDr7KFxE+60QH4hXpdo86oQo5G//dLfTUp3B0KRelC
         pNsptm0H72gYHBlI8NVvtZs3qkUKnz9Ogn+dhqCMbvJcpQbv4PFm/WnyUcE/CRRLQ1Qr
         48vYyvzDZrv0Sflvaifh/RX75yxdwAP8S7maS92OATwG3osYzbMAMsDn+Ahyl5Z3msa+
         1MzAJ4Okbi8/jR5TXWexBKjHy5vOVjTrRXvB/Rm0YR/h+NyUA0E0a+oSME/sok2bUda/
         39hhvleTB4JVmxln9nlQECsnEcHDGQUUGLOlTb9UDbmM+2xdkEhNLIhIYKLkVoW5EYq/
         KeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7oIUj3r8BxsFmJaSw1nh70Ej/VN6R/q+ROJC0MVOM+w=;
        b=oZBRLatJeJplHNDvUvsOvmNZyrj5heyQ5CBOEt7B/zV8nVXbwvWwyNRR7p6XVpa6F+
         SHHOb6WTYEjo03CmEMpuTsCPs7scp3qDeZmGXpBrs0G7oYJSoTP4aeJIgWBKTpqIBfpf
         Ji8zyrjxeFx4ozqbd+oOMc3iAzWfjtb6eX2HL5ctUug97waw3NpB7PGCOHsRYBxyWc9M
         eXscwtHFZl8A4Xq5fqZuCQmulfDHBGk7Bk/8XYZZrUgi278UFoezXNRiBP7lnwz1HdAX
         gYMefZCTzw42C0nAzwF2ntBAQoKO2K0Djsn2kFancEHRDGtaCTmBXgFt2ZF6xpheRLdL
         Tppg==
X-Gm-Message-State: AOAM533yI+wTfgl3R7C3xZzysL64sV7yYmyl3uTNJ3U995Om25/PuKbQ
        YdJOrkNEFmfOAhk1ZN/VSjkfR8xji1xkhZAAVb4=
X-Google-Smtp-Source: ABdhPJw+bnnZVwm1tzLuk03FP9MxicqJi6bFsBFr/OUQ98PDy4p4SxfWb068DoypiBVcjNXTVIF0GLD4ZZ9lbU9Z1zE=
X-Received: by 2002:a62:ed01:0:b029:1c8:c6c:16f0 with SMTP id
 u1-20020a62ed010000b02901c80c6c16f0mr629266pfh.80.1613587810571; Wed, 17 Feb
 2021 10:50:10 -0800 (PST)
MIME-Version: 1.0
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
 <20210216064250.38331-5-xiyou.wangcong@gmail.com> <602d631877e40_aed9208bc@john-XPS-13-9370.notmuch>
In-Reply-To: <602d631877e40_aed9208bc@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 17 Feb 2021 10:49:59 -0800
Message-ID: <CAM_iQpXBC49FBAf2LLANz94OFnVKoJADc9yePJBUuvMARbfq7w@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 4/5] skmsg: move sk_redir from TCP_SKB_CB to skb
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 10:40 AM John Fastabend
<john.fastabend@gmail.com> wrote:
> > @@ -802,9 +809,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
> >                * TLS context.
> >                */
> >               skb->sk = psock->sk;
> > -             tcp_skb_bpf_redirect_clear(skb);
> > +             skb_dst_drop(skb);
> > +             skb_bpf_redirect_clear(skb);
>
> Do we really need the skb_dst_drop() I thought we would have already dropped this here
> but I've not had time to check yet.

Yes, I got some serious complaints from dst_release() when I didn't
add skb_dst_drop().

Thanks.
