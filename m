Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483DB85632
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 00:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbfHGWua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 18:50:30 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45038 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbfHGWua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 18:50:30 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so67150743qke.11
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lJ7a/2k+Tuqr68+mO05d6MJDNw/BHF9g2vQmMFJlUOk=;
        b=Impmxmwj0oSNd3mf429qRhMEF4T+7Tmx6hO5JqCD8WNbj/SiBs/agzY2Je4JJQ+Hl+
         fgnPgxjjwLw31o8/X7grs7qjr07W9u9JpP2NHIzeU6CWR3EYqmmuIDV/j7a48MNCbJWO
         enP2InIzSlLTOn6kkUSRUjAOXvt22cgUCmMRsgsqhDEDTxgqd4jOxrEM3tqcXb3/aguE
         QfE+S5UyGCOvFNwoBVXOUzObs9qEEtxckzWgT8jWM7plTB1B1UoWYM7AdD1O9SezUerr
         2iMM1Y0AxnRIIRc8DratXYoH2p3dYfGQN9iPse6FK8COXMBImRbjWTaM2M6KTi65QKgX
         dk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lJ7a/2k+Tuqr68+mO05d6MJDNw/BHF9g2vQmMFJlUOk=;
        b=CCQxvHiPTAMdB1U5O9mDT9vaVqpsHBXmvulK2Gnj8QHWKsAX+7jvC9ALzf+Q8C4sX2
         qXj24HRUilyPApeqDnWoAJPL8gOsRJ+WBh81ffxFX0tc6m2JYHHCBkD1SEXetTlQnmt3
         jus0CaXSaKi8V9ISt3m1GOLNU7ZHw7FelgP9AH13CB+3crgZAHoXjmJ5Iinc3RUvOWeL
         YOlUueNKrGEjW2/k/kr2XGc94kyLkTgfRMLIog1mw5jjgmbGDl/337HCK1QaY6x/5pRN
         EbWB3+M25hLrPYD0otxFQgRe1e5XWuBG+N0jqPbXRjLhPDD5mo6IHwaIhkktLJvLDeCK
         zuYA==
X-Gm-Message-State: APjAAAVPpN2u2OZx4kEMA7qlwo7mMW00d9HdOsQThTyUfmyTfuJWvCD7
        12yVjxdvx+mz7TgXqw0WpHZwEA==
X-Google-Smtp-Source: APXvYqx8s9n2HLXydx+w2D8tM48ExlIWjk6ZYY2/YY/ejkwX/MGnQSAP6IaAEH3W5vNohYOfRWV+jw==
X-Received: by 2002:a37:717:: with SMTP id 23mr8827411qkh.267.1565218229450;
        Wed, 07 Aug 2019 15:50:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c20sm33493190qkk.69.2019.08.07.15.50.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 15:50:29 -0700 (PDT)
Date:   Wed, 7 Aug 2019 15:49:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH net v2] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
Message-ID: <20190807154959.67f30851@cakuba.netronome.com>
In-Reply-To: <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
References: <20190807060612.19397-1-jakub.kicinski@netronome.com>
        <CA+FuTScYkHho4hqrGf9q6=4iao-f2P2s258rjtQTCgn+nF-CYg@mail.gmail.com>
        <20190807110042.690cf50a@cakuba.netronome.com>
        <CA+FuTSeR1QqAZVTLQ-mJ8iHi+h+ghbrGyT6TWATTecQSbQP6sA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 14:46:23 -0400, Willem de Bruijn wrote:
> > > > @@ -984,6 +984,9 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
> > > >                         if (!skb)
> > > >                                 goto wait_for_memory;
> > > >
> > > > +#ifdef CONFIG_TLS_DEVICE
> > > > +                       skb->decrypted = !!(flags & MSG_SENDPAGE_DECRYPTED);
> > > > +#endif  
> > >
> > > Nothing is stopping userspace from passing this new flag. In send
> > > (tcp_sendmsg_locked) it is ignored. But can it reach do_tcp_sendpages
> > > through tcp_bpf_sendmsg?  
> >
> > Ah, I think you're right, thanks for checking that :( I don't entirely
> > follow how 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through
> > ULP") is safe then.
> >
> > One option would be to clear the flags kernel would previously ignore
> > in tcp_bpf_sendmsg(). But I feel like we should just go back to marking
> > the socket, since we don't need the per-message flexibility of a flag.
> >
> > WDYT?  
> 
> I don't feel strongly either way. Passing flags from send through
> tcp_bpf_sendmsg is probably unintentional, so should probably be
> addressed anyway? Then this is a bit simpler.

FWIW I had a closer look at the tcp_bpf_sendmsg() flags, and
MSG_SENDPAGE_NOPOLICY should be okay to let though there.

That flag is only meaningful to tls in case sockmap is layered 
on top of tls and we'd always set it before calling tls.

v3 coming soon..
