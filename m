Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F22CE246
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgLCXCw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 18:02:52 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:49427 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgLCXCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:02:52 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-213-lMlV4Ow3NduhgVn87rEWKA-1; Thu, 03 Dec 2020 23:01:11 +0000
X-MC-Unique: lMlV4Ow3NduhgVn87rEWKA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 3 Dec 2020 23:01:11 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 3 Dec 2020 23:01:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stephen Hemminger' <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "arjunroy@google.com" <arjunroy@google.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>
Subject: RE: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
Thread-Topic: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data
 for TCP Rx. zerocopy.
Thread-Index: AQHWyQnnIy5Nhf4BLE+JcVO2pr+xUKnl/WUA
Date:   Thu, 3 Dec 2020 23:01:11 +0000
Message-ID: <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
        <20201202220945.911116-2-arjunroy.kdev@gmail.com>
 <20201202161527.51fcdcd7@hermes.local>
In-Reply-To: <20201202161527.51fcdcd7@hermes.local>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger
> Sent: 03 December 2020 00:15
> 
> On Wed,  2 Dec 2020 14:09:38 -0800
> Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> 
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index cfcb10b75483..62db78b9c1a0 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
> >  	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
> >  	__u32 inq; /* out: amount of bytes in read queue */
> >  	__s32 err; /* out: socket error */
> > +	__u64 copybuf_address;	/* in: copybuf address (small reads) */
> > +	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */

You need to swap the order of the above fields to avoid padding
and differing alignments for 32bit and 64bit apps.

> >  };
> >  #endif /* _UAPI_LINUX_TCP_H */
> 
> You can't safely grow the size of a userspace API without handling the
> case of older applications.  Logic in setsockopt() would have to handle
> both old and new sizes of the structure.

You also have to allow for old (working) applications being recompiled
with the new headers.
So you cannot rely on the fields being zero even if you are passed
the size of the structure.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

