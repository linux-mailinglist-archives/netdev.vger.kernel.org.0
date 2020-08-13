Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8E7243980
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHML44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 07:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgHMLzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 07:55:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B18CC061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XY78ZrubVKageylVNpjo2mmgcQjTd2nDUZ9LqIK6VG4=; b=Yv2xzQPcp8LII2iGt2zhxGMYJP
        0Y8ov2l46BnbFrWp7eRL0wioIpQKL1EF8oe0B6WrBgbdt1Gtmf5T+Qhq1t6NizlhfLn2AdDO38V/d
        K3n1k8H25VYTohq/qy+9UGoPQa90/9vE1o/lt63bpnAYzJPMbOSv1gPmGt/K+AP70pQ+atd7qEpGt
        m4/zmNTzJCKWhdlMVeZgCCuBc8IbFGa0oTCvAYQpmhWM42S9Jenen6sx3sxLz9UZO7ZTraT+krXJz
        p0YUK8pw9SB5/um8959qOnXxG3j7b6dNagEh2TAuJb6uuaWE5yJUsUGVFy8fICFeZkZ16WNTLF3nh
        fYXrHnbQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k6Bil-0002qK-ND; Thu, 13 Aug 2020 11:48:35 +0000
Date:   Thu, 13 Aug 2020 12:48:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Necip Fazil Yildiran <necip@google.com>
Subject: Re: [PATCH] qrtr: Convert qrtr_ports from IDR to XArray
Message-ID: <20200813114835.GG17456@casper.infradead.org>
References: <20200605120037.17427-1-willy@infradead.org>
 <9aa67df2-a539-29eb-c9e9-4dddcb73ec19@gmail.com>
 <CACT4Y+acrZ9VTEONRt1ui++fOO8Lao0r3581jknEKho8GfwYyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+acrZ9VTEONRt1ui++fOO8Lao0r3581jknEKho8GfwYyg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 12:48:10PM +0200, Dmitry Vyukov wrote:
> On Fri, Jun 5, 2020 at 6:44 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > On 6/5/20 5:00 AM, Matthew Wilcox wrote:
> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > >
> > > The XArray interface is easier for this driver to use.  Also fixes a
> > > bug reported by the improper use of GFP_ATOMIC.
> > >
> >
> > This does not look stable candidate.
> >
> > If you try to add a Fixes: tag, you might discover that this bug is old,
> > and I do not believe XArray has been backported to stable branches ?
> >
> >
> > Please submit a fix suitable for old kernels (as old as v4.7)
> >
> > Then when net-next is open in ~2 weeks, the Xarray stuff can be proposed.
> >
> > Thanks.
> 
> Hello,
> 
> What is the status of this patch? Was it merged/superseded by another patch?
> I don't see it in linux-next nor in net-net.

I don't know.  I didn't understand Eric's response.

> Thanks
> 
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > ---
> > >  net/qrtr/qrtr.c | 39 +++++++++++++--------------------------
> > >  1 file changed, 13 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> > > index 2d8d6131bc5f..488f8f326ee5 100644
> > > --- a/net/qrtr/qrtr.c
> > > +++ b/net/qrtr/qrtr.c
> > > @@ -20,6 +20,7 @@
> > >  /* auto-bind range */
> > >  #define QRTR_MIN_EPH_SOCKET 0x4000
> > >  #define QRTR_MAX_EPH_SOCKET 0x7fff
> > > +#define QRTR_PORT_RANGE      XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
> > >
> > >  /**
> > >   * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
> > > @@ -106,8 +107,7 @@ static LIST_HEAD(qrtr_all_nodes);
> > >  static DEFINE_MUTEX(qrtr_node_lock);
> > >
> > >  /* local port allocation management */
> > > -static DEFINE_IDR(qrtr_ports);
> > > -static DEFINE_MUTEX(qrtr_port_lock);
> > > +static DEFINE_XARRAY_ALLOC(qrtr_ports);
> > >
> > >  /**
> > >   * struct qrtr_node - endpoint node
> > > @@ -623,7 +623,7 @@ static struct qrtr_sock *qrtr_port_lookup(int port)
> > >               port = 0;
> > >
> > >       rcu_read_lock();
> > > -     ipc = idr_find(&qrtr_ports, port);
> > > +     ipc = xa_load(&qrtr_ports, port);
> > >       if (ipc)
> > >               sock_hold(&ipc->sk);
> > >       rcu_read_unlock();
> > > @@ -665,9 +665,7 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
> > >
> > >       __sock_put(&ipc->sk);
> > >
> > > -     mutex_lock(&qrtr_port_lock);
> > > -     idr_remove(&qrtr_ports, port);
> > > -     mutex_unlock(&qrtr_port_lock);
> > > +     xa_erase(&qrtr_ports, port);
> > >
> > >       /* Ensure that if qrtr_port_lookup() did enter the RCU read section we
> > >        * wait for it to up increment the refcount */
> > > @@ -688,25 +686,18 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > >  {
> > >       int rc;
> > >
> > > -     mutex_lock(&qrtr_port_lock);
> > >       if (!*port) {
> > > -             rc = idr_alloc(&qrtr_ports, ipc,
> > > -                            QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
> > > -                            GFP_ATOMIC);
> > > -             if (rc >= 0)
> > > -                     *port = rc;
> > > +             rc = xa_alloc(&qrtr_ports, port, ipc, QRTR_PORT_RANGE,
> > > +                             GFP_KERNEL);
> > >       } else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
> > >               rc = -EACCES;
> > >       } else if (*port == QRTR_PORT_CTRL) {
> > > -             rc = idr_alloc(&qrtr_ports, ipc, 0, 1, GFP_ATOMIC);
> > > +             rc = xa_insert(&qrtr_ports, 0, ipc, GFP_KERNEL);
> > >       } else {
> > > -             rc = idr_alloc(&qrtr_ports, ipc, *port, *port + 1, GFP_ATOMIC);
> > > -             if (rc >= 0)
> > > -                     *port = rc;
> > > +             rc = xa_insert(&qrtr_ports, *port, ipc, GFP_KERNEL);
> > >       }
> > > -     mutex_unlock(&qrtr_port_lock);
> > >
> > > -     if (rc == -ENOSPC)
> > > +     if (rc == -EBUSY)
> > >               return -EADDRINUSE;
> > >       else if (rc < 0)
> > >               return rc;
> > > @@ -720,20 +711,16 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
> > >  static void qrtr_reset_ports(void)
> > >  {
> > >       struct qrtr_sock *ipc;
> > > -     int id;
> > > -
> > > -     mutex_lock(&qrtr_port_lock);
> > > -     idr_for_each_entry(&qrtr_ports, ipc, id) {
> > > -             /* Don't reset control port */
> > > -             if (id == 0)
> > > -                     continue;
> > > +     unsigned long index;
> > >
> > > +     rcu_read_lock();
> > > +     xa_for_each_start(&qrtr_ports, index, ipc, 1) {
> > >               sock_hold(&ipc->sk);
> > >               ipc->sk.sk_err = ENETRESET;
> > >               ipc->sk.sk_error_report(&ipc->sk);
> > >               sock_put(&ipc->sk);
> > >       }
> > > -     mutex_unlock(&qrtr_port_lock);
> > > +     rcu_read_unlock();
> > >  }
> > >
> > >  /* Bind socket to address.
> > >
