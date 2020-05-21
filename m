Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9882D1DD2D2
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgEUQJV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 12:09:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52855 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728517AbgEUQJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 12:09:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-10-w8zL2Av5PV6Q9IGz5_uUcw-1; Thu, 21 May 2020 17:09:16 +0100
X-MC-Unique: w8zL2Av5PV6Q9IGz5_uUcw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 May 2020 17:09:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 May 2020 17:09:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH net-next] sctp: Pull the user copies out of the individual
 sockopt functions.
Thread-Topic: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Thread-Index: AdYut/UmmYS4izffR6iTi1nqaxYM2QAxWVeAAAKhTeA=
Date:   Thu, 21 May 2020 16:09:15 +0000
Message-ID: <a681d1dc056a412bba24b9b4cde37785@AcuMS.aculab.com>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
 <20200521153729.GB74252@localhost.localdomain>
In-Reply-To: <20200521153729.GB74252@localhost.localdomain>
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
> Sent: 21 May 2020 16:37
> On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:
...
> > Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> > It is also the only getsockopt() that wants to return a buffer
> > and an error code. It is also definitely abusing getsockopt().
> 
> It should have been a linear buffer. The secondary __user access is
> way worse than having the application to do another allocation. But
> too late..

I think that is SCTP_SOCKOPT_CONNECTX ?

> Other than the comments here, this patch LGTM.

Thanks.

> Assuming a v2 is coming, to appease the buildbot :)

I'd got an definition in sctp.h and an EXPORT() but took them out.
I'll also increase the setsockopt limit.

...
> > +	if (optlen < sizeof (param_buf)) {
> > +		if (copy_from_user(&param_buf, u_optval, optlen))
> > +			return -EFAULT;
> > +		optval = param_buf;
> > +	} else {
> > +		if (optlen > USHRT_MAX)
> > +			optlen = USHRT_MAX;
> 
> There are functions that can work with and expect buffers larger than
> that, such as sctp_setsockopt_auth_key:

I'd assumed the maximums were silly.
But a few more than 64k is enough, the lengths are in bytes.
OTOH 128k is a nice round limit - and plenty AFAICT.

...
> > +	if (len < sizeof (param_buf)) {
> > +		/* Zero first bytes to stop KASAN complaining. */
> > +		param_buf[0] = 0;
> > +		if (copy_from_user(&param_buf, u_optval, len))
> > +			return -EFAULT;
> > +		optval = param_buf;
> > +	} else {
> > +		if (len > USHRT_MAX)
> > +			len = USHRT_MAX;
> 
> This limit is not present today for sctp_getsockopt_local_addrs()
> calls (there may be others).  As is, it will limit it and may mean
> that it can't dump all addresses.  We have discussed this and didn't
> come to a conclusion on what is a safe limit to use here, at least not
> on that time.

It needs some limit. memdup_user() might limit at 32MB.
I couldn't decide is some of the allocators limit it further.
In any case an IPv6 address is what? under 128 bytes.
64k is 512 address, things are going to explode elsewhere first.

I didn't see 'get' requests that did 64k + a bit.

It should be possible to loop using a larger kernel buffer if the
data won't fit.
Doable as a later patch to avoid complications.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

