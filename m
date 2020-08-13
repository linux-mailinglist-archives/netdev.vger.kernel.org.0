Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01E92438E5
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 12:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHMKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 06:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMKsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 06:48:24 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D86DC061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 03:48:23 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id m7so4741100qki.12
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 03:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wckpiyd4UXX/l56mjNxwaQdAsVC3oah1yE1D15P+LDM=;
        b=U62jX5GDrR87wpTw4w6JCpKsuKZCA0QE/KtfwqoigQBtKcm2I+zyQ/5H2Aes5WB2hX
         X0SFHu8fbF23fBo0CW61PpcEDTt/U4JnoV4bXbXLiBw+FQG3XNmTdKMTZC13VsXaQCOQ
         R9EvoyvkecLa2AHFSpe2qzKJrZXzeVtMZGr1MYCbuRppjexTz8Ikjd60sDRGEGE2g6OR
         6xFcN6XywT7o0ltFYi+PF5TXUCy8gkOMmkdWWDWFod+IDAMG3EDuvxdMX1cQew7ALuH8
         4s6XCUNPaxGoAKDyJi8541iOknzWF+X0MmOdDXR2IZTxt/qIXmgVyFMtF1Rx0JBf5HkP
         tbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wckpiyd4UXX/l56mjNxwaQdAsVC3oah1yE1D15P+LDM=;
        b=KoSZXcU49OqVOvIFFwuxpaO8YB6NlM3XCHjD7zgpSkpqfEr8QfoiMO2N2pPA174cB1
         ZCQo4ymW4WnlxYEjPt6EaCJmG54ewXvimdIde5zyzXARwLzi80sVTnOuiXXIeAY8X6K+
         LkUPX3IptHDC509eHZcX5LuAtKVaA3oBpvQQJ96mXLr9Sw3pyEnuoyJ8Nwlx9++7C+WW
         zBtkZDbZSYJejVbTcij+FxYRTyhPJPKa+sNS0SYoE+mo2z97TjxOqyLb9MCfILSU68KA
         OgkhHCXZio53+m8MPZh4Im1Wz6+m2FPfpqzyvQ6MMjzUN37gixGglIUqLbLAm5Z6UHBv
         PZeg==
X-Gm-Message-State: AOAM533uBQnf2GwhzhpAmHFsNz+bo/5uzBPOKB8888NR08y7GeYr6qcp
        SqjJ75LWFsU3dCA+y/HmXWBj8spAtjsPwj0ghNj/Aw==
X-Google-Smtp-Source: ABdhPJxJdMD8pmlZFjDm5M9DvZXUDOi6RweZpzLnkjP6V84PPt3H0EzY6SfXcoSPi6slvYG6IsHu49+A8n5WcpLhDfY=
X-Received: by 2002:a05:620a:21d2:: with SMTP id h18mr3521197qka.407.1597315702181;
 Thu, 13 Aug 2020 03:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200605120037.17427-1-willy@infradead.org> <9aa67df2-a539-29eb-c9e9-4dddcb73ec19@gmail.com>
In-Reply-To: <9aa67df2-a539-29eb-c9e9-4dddcb73ec19@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 13 Aug 2020 12:48:10 +0200
Message-ID: <CACT4Y+acrZ9VTEONRt1ui++fOO8Lao0r3581jknEKho8GfwYyg@mail.gmail.com>
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Necip Fazil Yildiran <necip@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 5, 2020 at 6:44 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 6/5/20 5:00 AM, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> >
> > The XArray interface is easier for this driver to use.  Also fixes a
> > bug reported by the improper use of GFP_ATOMIC.
> >
>
> This does not look stable candidate.
>
> If you try to add a Fixes: tag, you might discover that this bug is old,
> and I do not believe XArray has been backported to stable branches ?
>
>
> Please submit a fix suitable for old kernels (as old as v4.7)
>
> Then when net-next is open in ~2 weeks, the Xarray stuff can be proposed.
>
> Thanks.

Hello,

What is the status of this patch? Was it merged/superseded by another patch?
I don't see it in linux-next nor in net-net.

Thanks

> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
> >  1 file changed, 13 insertions(+), 26 deletions(-)
> >
> > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > index 2d8d6131bc5f..488f8f326ee5 100644
> > --- a/net/qrtr/qrtr.c
> > +++ b/net/qrtr/qrtr.c
> > @@ -20,6 +20,7 @@
> >  /* auto-bind range */
> >  #define QRTR_MIN_EPH_SOCKET 0x4000
> >  #define QRTR_MAX_EPH_SOCKET 0x7fff
> > +#define QRTR_PORT_RANGE      XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
> >
> >  /**
> >   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> > @@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
> >  static DEFINE_MUTEX(qrtr_node_lock);
> >
> >  /* local port allocation management */
> > -static DEFINE_IDR(qrtr_ports);
> > -static DEFINE_MUTEX(qrtr_port_lock);
> > +static DEFINE_XARRAY_ALLOC(qrtr_ports);
> >
> >  /**
> >   * struct qrtr_node - endpoint node
> > @@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
> >               port = 0;
> >
> >       rcu_read_lock();
> > -     ipc = idr_find(&qrtr_ports, port);
> > +     ipc = xa_load(&qrtr_ports, port);
> >       if (ipc)
> >               sock_hold(&ipc->sk);
> >       rcu_read_unlock();
> > @@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
> >
> >       __sock_put(&ipc->sk);
> >
> > -     mutex_lock(&qrtr_port_lock);
> > -     idr_remove(&qrtr_ports, port);
> > -     mutex_unlock(&qrtr_port_lock);
> > +     xa_erase(&qrtr_ports, port);
> >
> >       /* Ensure that if qrtr_port_lookup() did enter the RCU read section we
> >        * wait for it to up increment the refcount */
> > @@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  {
> >       int rc;
> >
> > -     mutex_lock(&qrtr_port_lock);
> >       if (!*port) {
> > -             rc = idr_alloc(&qrtr_ports, ipc,
> > -                            QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
> > -                            GFP_ATOMIC);
> > -             if (rc >= 0)
> > -                     *port = rc;
> > +             rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
> > +                             GFP_KERNEL);
> >       } else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
> >               rc = -EACCES;
> >       } else if (*port == QRTR_PORT_CTRL) {
> > -             rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
> > +             rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
> >       } else {
> > -             rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
> > -             if (rc >= 0)
> > -                     *port = rc;
> > +             rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
> >       }
> > -     mutex_unlock(&qrtr_port_lock);
> >
> > -     if (rc == -ENOSPC)
> > +     if (rc == -EBUSY)
> >               return -EADDRINUSE;
> >       else if (rc < 0)
> >               return rc;
> > @@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> >  static void qrtr_reset_ports(void)
> >  {
> >       struct qrtr_sock *ipc;
> > -     int id;
> > -
> > -     mutex_lock(&qrtr_port_lock);
> > -     idr_for_each_entry(&qrtr_ports, ipc, id) {
> > -             /* Don't reset control port */
> > -             if (id == 0)
> > -                     continue;
> > +     unsigned long index;
> >
> > +     rcu_read_lock();
> > +     xa_for_each_start(&qrtr_ports, index, ipc, 1) {
> >               sock_hold(&ipc->sk);
> >               ipc->sk.sk_err = ENETRESET;
> >               ipc->sk.sk_error_report(&ipc->sk);
> >               sock_put(&ipc->sk);
> >       }
> > -     mutex_unlock(&qrtr_port_lock);
> > +     rcu_read_unlock();
> >  }
> >
> >  /* Bind socket to address.
> >
