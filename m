Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A5E1DC7BD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 09:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEUHdX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 03:33:23 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47941 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728373AbgEUHdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 03:33:23 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-61-1H23FiuAM022CjKnvDidHA-1; Thu, 21 May 2020 08:32:15 +0100
X-MC-Unique: 1H23FiuAM022CjKnvDidHA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 May 2020 08:32:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 May 2020 08:32:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: RE: [PATCH net-next] sctp: Pull the user copies out of the individual
 sockopt functions.
Thread-Topic: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Index: AdYut/UmmYS4izffR6iTi1nqaxYM2QARN02AABEfr1A=
Date:   Thu, 21 May 2020 07:32:14 +0000
Message-ID: <e777874fbd0e4ccb813e08145f3c3359@AcuMS.aculab.com>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521001725.GW2491@localhost.localdomain>
In-Reply-To: <20200521001725.GW2491@localhost.localdomain>
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

From: 'Marcelo Ricardo Leitner'
> Sent: 21 May 2020 01:17
> On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
> ...
> > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > It is also the only getsockopt() that wants to return a buffer
> > and an error code. It is also definitely abusing getsockopt().
> ...
> > @@ -1375,11 +1350,11 @@ struct compat_sctp_getaddrs_old {
> >  #endif
> >
> >  static int sctp_getsockopt_connectx3(struct sock *sk, int len,
> > -				     char __user *optval,
> > -				     int __user *optlen)
> > +				     struct sctp_getaddrs_old *param,
> > +				     int *optlen)
> >  {
> > -	struct sctp_getaddrs_old param;
> >  	sctp_assoc_t assoc_id = 0;
> > +	struct sockaddr *addrs;
> >  	int err = 0;
> >
> >  #ifdef CONFIG_COMPAT
..
> >  	} else
> >  #endif
> >  	{
> > -		if (len < sizeof(param))
> > +		if (len < sizeof(*param))
> >  			return -EINVAL;
> > -		if (copy_from_user(&param, optval, sizeof(param)))
> > -			return -EFAULT;
> >  	}
> >
> > -	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
> > -					 param.addrs, param.addr_num,
> > +	addrs = memdup_user(param->addrs, param->addr_num);
> 
> I'm staring at this for a while now but I don't get this memdup_user.
> AFAICT, params->addrs is not __user anymore here, because
> sctp_getsockopt() copied the whole thing already, no?
> Also weird because it is being called from kernel_sctp_getsockopt(),
> which now has no knowledge of __user buffers.
> Maybe I didn't get something from the patch description.

The connectx3 sockopt buffer contains a pointer to the user buffer
that contains the actual addresses.
So a second copy_from_user() is needed.

This does mean that this option can only be actioned from userspace.

Kernel code can get the same functionality using one of the
other interfaces to connectx().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

