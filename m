Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CC21EA004
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFAI1N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jun 2020 04:27:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:34453 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728105AbgFAI1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 04:27:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-4-qyf_xz7jMHaz2OtF4B_ISQ-1;
 Mon, 01 Jun 2020 09:27:08 +0100
X-MC-Unique: qyf_xz7jMHaz2OtF4B_ISQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 1 Jun 2020 09:27:08 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 1 Jun 2020 09:27:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>,
        Christoph Hellwig <hch@lst.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Thread-Topic: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Thread-Index: AQHWNdMG2Q0k5UY/FEi3sQ5al/OVkajDcLLw
Date:   Mon, 1 Jun 2020 08:27:08 +0000
Message-ID: <ef0754831c294934b67f89fd8c5e1b5b@AcuMS.aculab.com>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-3-hch@lst.de>
 <20200529160544.GI2491@localhost.localdomain>
In-Reply-To: <20200529160544.GI2491@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 29 May 2020 17:06
> On Fri, May 29, 2020 at 02:09:41PM +0200, Christoph Hellwig wrote:
> > Split out a sctp_setsockopt_bindx_kernel that takes a kernel pointer
> > to the sockaddr and make sctp_setsockopt_bindx a small wrapper around
> > it.  This prepares for adding a new bind_add proto op.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> > ---
> >  net/sctp/socket.c | 61 ++++++++++++++++++++++-------------------------
> >  1 file changed, 28 insertions(+), 33 deletions(-)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 827a9903ee288..6e745ac3c4a59 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -972,23 +972,22 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
> >   * it.
> >   *
> >   * sk        The sk of the socket
> > - * addrs     The pointer to the addresses in user land
> > + * addrs     The pointer to the addresses
> >   * addrssize Size of the addrs buffer
> >   * op        Operation to perform (add or remove, see the flags of
> >   *           sctp_bindx)
> >   *
> >   * Returns 0 if ok, <0 errno code on error.
> >   */
> > -static int sctp_setsockopt_bindx(struct sock *sk,
> > -				 struct sockaddr __user *addrs,
> > -				 int addrs_size, int op)
> > +static int sctp_setsockopt_bindx_kernel(struct sock *sk,
                        const
> > +					struct sockaddr *addrs, int addrs_size,
> > +					int op)

The list of addresses ought to be 'const'.

IIRC that requires the test for 'port == 0' be moved down  a few layers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

