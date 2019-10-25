Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E62E4685
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408635AbfJYJAu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Oct 2019 05:00:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:45628 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404999AbfJYJAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:00:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-33-3ZvEoFwjNpyTSMbcjLQ4AQ-1; Fri, 25 Oct 2019 10:00:46 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 25 Oct 2019 10:00:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 25 Oct 2019 10:00:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock and
 asoc
Thread-Topic: [PATCHv3 net-next 2/5] sctp: add pf_expose per netns and sock
 and asoc
Thread-Index: AQHViuObUMLYfsY4SkimZzbsfLzKtKdrDrFA
Date:   Fri, 25 Oct 2019 09:00:45 +0000
Message-ID: <995e44322af74c41bbff2c77338f83bf@AcuMS.aculab.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <20191025032337.GC4326@localhost.localdomain>
In-Reply-To: <20191025032337.GC4326@localhost.localdomain>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 3ZvEoFwjNpyTSMbcjLQ4AQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcelo Ricardo Leitner
> Sent: 25 October 2019 04:24
...
> > @@ -5521,8 +5522,16 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> >
> >  	transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> >  					   pinfo.spinfo_assoc_id);
> > -	if (!transport)
> > -		return -EINVAL;
> > +	if (!transport) {
> > +		retval = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	if (transport->state == SCTP_PF &&
> > +	    transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
> > +		retval = -EACCES;
> > +		goto out;
> > +	}
> 
> As is on v3, this is NOT an UAPI violation. The user has to explicitly
> set the system or the socket into the disabled state in order to
> trigger this new check.

Only because the default isn't to be backwards compatible with the
old kernel and old applications.

An old application running on a system that has the protocol parts of
PF enabled mustn't see any PF events, states or obscure error returns.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

