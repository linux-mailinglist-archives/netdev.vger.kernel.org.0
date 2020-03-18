Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596CB1894A3
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgCRDzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:55:55 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:42729 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgCRDzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 23:55:54 -0400
Received: by mail-qv1-f66.google.com with SMTP id ca9so12193848qvb.9;
        Tue, 17 Mar 2020 20:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4w0fVuhtcWUrWrEECdk2qkWG8xGkG11mQX5K+KieeCg=;
        b=U7g4r8lFCvt3Z7d9CMTwyuOKIPtDFDsXdLFXgbkLDuO5hV2zFuFmKbdzb2DS83a+Pv
         7RZMASrPmhL2C3+EUH8urNDPMt3Fb3QuowBcea3l+Ihqiwnd02uWvQ4tE1G0x8i7/gqL
         o4Nzjpe68ER5PXAynfkZxELUqXWi+fq+8lHhpuj+4OxcUCDACuUu1ueB2EPvF3AHVDW4
         dvqImW1EoOpDJzSYqdrFkeeidMIe67MdE6tzdrELEUbe63vtcORFETYow1IHw8i5TQO6
         WCwubo2kpuyChIOOdQESHygGyGIGEbcjw8wXdQOIiWYMGFVHmUo+qkdak/ii4Dt4EUtF
         W87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4w0fVuhtcWUrWrEECdk2qkWG8xGkG11mQX5K+KieeCg=;
        b=UII4nG6tMbq2r0TFPrFcN15x/zSBtSEurlrpTcYP5ByAw35+ZJl7//S7J3qeu8QsW8
         TPY3bB1fDstgjiLv0FHnCheGNVtNCVIf03hIT8LLU4TOfjwqjOycYZD8PVqPMTe9fFWG
         hwwR3HRSK/W8G8+C6DGZ0mKdx5WVu1sOz8AXfpDGxtvB9eJ3MKwA57kKTkWTMtQnuBka
         nshPhJ76sMr7vMYOsIQ+HpiSm1jzpf4h7qJHS81ssiazKhKxf3vKrP13LgqvJGf0XFyT
         qfL0gmQqTpSDbn43IARqtmyW1lSsJPj7T1HoP5zIz+2K8mxWE5dSIAkp6sM60ujC3t0A
         Bvsg==
X-Gm-Message-State: ANhLgQ2C93wFtWqrMKghMEfdfgXSONM+oHDEsolLp9fNPELuXpQDpRD6
        JHm5/cod01adgwtV4AmqSOY=
X-Google-Smtp-Source: ADFU+vsBEvZq/VSmCYpryFG8+yqe1CqMSCYGxnfsasmZm6OuNkNGUUqEOM++LKgciXgMQY1z7xc7Lg==
X-Received: by 2002:ad4:5642:: with SMTP id bl2mr2430914qvb.11.1584503752892;
        Tue, 17 Mar 2020 20:55:52 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:bfaf:5636:cd03:74f7:34b0])
        by smtp.gmail.com with ESMTPSA id f26sm3338754qkl.119.2020.03.17.20.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 20:55:52 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DA47BC550F; Wed, 18 Mar 2020 00:55:49 -0300 (-03)
Date:   Wed, 18 Mar 2020 00:55:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200318035549.GC3756@localhost.localdomain>
References: <20200317155536.10227-1-hqjagain@gmail.com>
 <20200317173039.GA3828@localhost.localdomain>
 <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:45:51AM +0800, Qiujun Huang wrote:
> On Wed, Mar 18, 2020 at 1:30 AM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > Hi,
> >
> > On Tue, Mar 17, 2020 at 11:55:36PM +0800, Qiujun Huang wrote:
> > > Do accounting for skb's real sk.
> > > In some case skb->sk != asoc->base.sk:
> > >
> > > migrate routing        sctp_check_transmitted routing
> > > ------------                    ---------------
> >                                  sctp_close();
> >                                    lock_sock(sk2);
> >                                  sctp_primitive_ABORT();
> >                                  sctp_do_sm();
> >                                  sctp_cmd_interpreter();
> >                                  sctp_cmd_process_sack();
> >                                  sctp_outq_sack();
> >                                  sctp_check_transmitted();
> >
> >   lock_sock(sk1);
> >   sctp_getsockopt_peeloff();
> >   sctp_do_peeloff();
> >   sctp_sock_migrate();
> > > lock_sock_nested(sk2);
> > >                                mv the transmitted skb to
> > >                                the it's local tlist
> >
> >
> > How can sctp_do_sm() be called in the 2nd column so that it bypasses
> > the locks in the left column, allowing this mv to happen?
> >
> > >
> > > sctp_for_each_tx_datachunk(
> > > sctp_clear_owner_w);
> > > sctp_assoc_migrate();
> > > sctp_for_each_tx_datachunk(
> > > sctp_set_owner_w);
> > >
> > >                                put the skb back to the
> > >                                assoc lists
> > > ----------------------------------------------------
> > >
> > > The skbs which held bysctp_check_transmitted were not changed
> > > to newsk. They were not dealt with by sctp_for_each_tx_datachunk
> > > (sctp_clear_owner_w/sctp_set_owner_w).
> >
> > It would make sense but I'm missing one step earlier, I'm not seeing
> > how the move to local list is allowed/possible in there. It really
> > shouldn't be possible.
> 
> I totally agree that.
> My mistake. So I added some log in my test showing the case:
> The backtrace:
> sctp_close
> sctp_primitive_ABORT
> sctp_do_sm
> sctp_association_free
> __sctp_outq_teardown
>      /* Throw away unacknowledged chunks. */
>     list_for_each_entry(transport, &q->asoc->peer.transport_addr_list,
>     transports) {
>     printk("[%d]deal with transmitted %#llx from transport %#llx  %s,
> %d\n", raw_smp_processor_id(),
>    &transport->transmitted, transport, __func__, __LINE__);
>    while ((lchunk = sctp_list_dequeue(&transport->transmitted)) != NULL) {
> 
> The trouble skb is from another peer sk in the same asoc, but
> accounted to the base.sk.

Hmm, not sure how you got that out of that debug msg, but okay.
Even if so, how would this trouble skb be accounted on the wrong sk by
then?

Asking because the fix that we want may be a better locking, to
prevent this situation from happening, than compensating for it in
sctp_wfree(). But for that we need to understand how this happened.

  Marcelo
