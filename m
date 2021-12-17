Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F58478D3E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbhLQOSE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Dec 2021 09:18:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44772 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237065AbhLQOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 09:18:03 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-311-oAGq-R-3O8uuB1TWUrxb2w-1; Fri, 17 Dec 2021 14:17:59 +0000
X-MC-Unique: oAGq-R-3O8uuB1TWUrxb2w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Fri, 17 Dec 2021 14:17:58 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Fri, 17 Dec 2021 14:17:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lee Jones' <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and return
 incremented endpoint
Thread-Topic: [PATCH v2 1/2] sctp: export sctp_endpoint_{hold,put}() and
 return incremented endpoint
Thread-Index: AQHX80yDhnx49qqwrkWmSXPA3hUXMKw2ugEA
Date:   Fri, 17 Dec 2021 14:17:58 +0000
Message-ID: <1458e6e239e2493e9147fd95ec32d9fd@AcuMS.aculab.com>
References: <20211217134607.74983-1-lee.jones@linaro.org>
In-Reply-To: <20211217134607.74983-1-lee.jones@linaro.org>
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

From: Lee Jones
> Sent: 17 December 2021 13:46
> 
> net/sctp/diag.c for instance is built into its own separate module
> (sctp_diag.ko) and requires the use of sctp_endpoint_{hold,put}() in
> order to prevent a recently found use-after-free issue.
> 
> In order to prevent data corruption of the pointer used to take a
> reference on a specific endpoint, between the time of calling
> sctp_endpoint_hold() and it returning, the API now returns a pointer
> to the exact endpoint that was incremented.
> 
> For example, in sctp_sock_dump(), we could have the following hunk:
> 
> 	sctp_endpoint_hold(tsp->asoc->ep);
> 	ep = tsp->asoc->ep;
> 	sk = ep->base.sk
> 	lock_sock(ep->base.sk);
> 
> It is possible for this task to be swapped out immediately following
> the call into sctp_endpoint_hold() that would change the address of
> tsp->asoc->ep to point to a completely different endpoint.  This means
> a reference could be taken to the old endpoint and the new one would
> be processed without a reference taken, moreover the new endpoint
> could then be freed whilst still processing as a result, causing a
> use-after-free.
> 
> If we return the exact pointer that was held, we ensure this task
> processes only the endpoint we have taken a reference to.  The
> resultant hunk now looks like this:
> 
>         ep = sctp_endpoint_hold(tsp->asoc->ep);
> 	sk = ep->base.sk
> 	lock_sock(sk);

Isn't that just the same as doing things in the other order?
	ep = tsp->assoc->ep;
	sctp_endpoint_hold(ep);

But if tsp->assoc->ep is allowed to change, can't it also change to
something invalid?
So I've have thought you should be holding some kind of lock that
stops the data being changed before being 'allowed' to follow the pointers.
In which case the current code is just a missing optimisatoion.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

