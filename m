Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEF21F43ED
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgFIR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 13:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387671AbgFIR6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 13:58:35 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE67C05BD1E;
        Tue,  9 Jun 2020 10:58:34 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id e125so13043612lfd.1;
        Tue, 09 Jun 2020 10:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0JzUAxIlsQW/ouIYhILjNkmM8ALrEBKdaPizi9XIUts=;
        b=OmBAdQqVJo/UkEguvL0veslfTRmVGDkO+kCcUMFN8ZxxgjTZGwkCdldMGUK46cR/8C
         0NfmB7Y0ytbIgJn5WooEzSbY+yGIOdqRcBlj2CQpU+dbhY10/UcCMGUy0LKGQkfE44FF
         E8VnrAhi3nk9qvTWT1J7P2KS2xsSeQGkzUq3j94sQMYAlA+G9H9fGe7ICDa3g3mr/qHf
         IK42wAmjvN0QRwY72z439GBSp5YgihOyUxxRxvCRRwIP5KPQRVdFL+B7MAaWheIT51Mm
         0sFJrYbBpFEOCiV1fUyq/dncNYaDkpEN6CbsQ+VOd62qP7Y5Mq1nWk8l/QppEAt11QEm
         1paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0JzUAxIlsQW/ouIYhILjNkmM8ALrEBKdaPizi9XIUts=;
        b=DsRBP3ERiZrIlIn9m8bSyvt/IhWjN2qx0veBWllQlXnKbq/2dRDoGozHPbaRcaZ8VY
         b6fsD5MrKMTdbuWsTHLWvE9v0U3hjr+q9qiegVM7ZPYjGJrvuyTLdmI5HkbHyaB0aw47
         cWLEHrat97dYogeQN2PASJUQUnMlEfqZ1OgD3A4tohcNILAkN5CsrSyh1+aMSC9Pf7Tg
         zJIzPFo2D93nqqb1LqR82HaN1RRvRYgS/MhiXnMko/5C1ODir8txPR9U3V1JvKEq5HSy
         yu1GEEndK3+un9W4zxeYkonbZ0YAUgU7DlNQiJwqKFpW67mLxv7eGWD9u0RKzVWnZ3MM
         lyZg==
X-Gm-Message-State: AOAM532irvFydesgVr7MhGpf882GrJajakFreUT8ULxsq8OfPM2DvoVM
        vSlZLKEtlW9bZErHC9xZQw5wUs9SvD9+LFZ4Wgo=
X-Google-Smtp-Source: ABdhPJx4hAMylYWqsvOWovuEqBqM/loHIH21/XI5rH1uFSOQRP1lt0bTZtoR2Ml14/cy5k/DV95g1CRpu4qpGizjYck=
X-Received: by 2002:a19:103:: with SMTP id 3mr15580721lfb.196.1591725513341;
 Tue, 09 Jun 2020 10:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200605084625.9783-1-anny.hu@linux.alibaba.com> <874krk391q.fsf@cloudflare.com>
In-Reply-To: <874krk391q.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Jun 2020 10:58:21 -0700
Message-ID: <CAADnVQKOyfC8DmxvQuRNayxKErj7xVpZLQALNh+k+w9XrzuRCg@mail.gmail.com>
Subject: Re: [PATCH] bpf/sockmap: fix kernel panic at __tcp_bpf_recvmsg
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     dihu <anny.hu@linux.alibaba.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 2:04 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Fri, Jun 05, 2020 at 10:46 AM CEST, dihu wrote:
> > When user application calls read() with MSG_PEEK flag to read data
> > of bpf sockmap socket, kernel panic happens at
> > __tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
> > queue after read out under MSG_PEEK flag is set. Because it's not
> > judged whether sk_msg is the last msg of ingress_msg queue, the next
> > sk_msg may be the head of ingress_msg queue, whose memory address of
> > sg page is invalid. So it's necessary to add check codes to prevent
> > this problem.
> >
> > [20759.125457] BUG: kernel NULL pointer dereference, address:
> > 0000000000000008
> > [20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
> > 5.4.32 #1
> > [20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
> > 4.1.12 06/18/2017
> > [20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
> > [20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
> > [20759.276099] tcp_bpf_recvmsg+0x113/0x370
> > [20759.281137] inet_recvmsg+0x55/0xc0
> > [20759.285734] __sys_recvfrom+0xc8/0x130
> > [20759.290566] ? __audit_syscall_entry+0x103/0x130
> > [20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
> > [20759.301700] ? __audit_syscall_exit+0x1e4/0x290
> > [20759.307235] __x64_sys_recvfrom+0x24/0x30
> > [20759.312226] do_syscall_64+0x55/0x1b0
> > [20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Signed-off-by: dihu <anny.hu@linux.alibaba.com>
> > ---
> >  net/ipv4/tcp_bpf.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index 5a05327..b82e4c3 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -64,6 +64,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
> >               } while (i != msg_rx->sg.end);
> >
> >               if (unlikely(peek)) {
> > +                     if (msg_rx == list_last_entry(&psock->ingress_msg,
> > +                                                   struct sk_msg, list))
> > +                             break;
> >                       msg_rx = list_next_entry(msg_rx, list);
> >                       continue;
> >               }
>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied. Thanks
