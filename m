Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6EC230E66
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgG1PwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jul 2020 11:52:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:49115 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730977AbgG1PwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:52:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-21-iN6_25BuPYi1h2pKBjyQ3w-1; Tue, 28 Jul 2020 16:52:18 +0100
X-MC-Unique: iN6_25BuPYi1h2pKBjyQ3w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 28 Jul 2020 16:52:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 28 Jul 2020 16:52:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@inai.de>,
        Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Thread-Topic: [PATCH 4/4] net: improve the user pointer check in
 init_user_sockptr
Thread-Index: AQHWZPZzs5VC5NQ+wkaZAWC1DM32c6kdI/Tg
Date:   Tue, 28 Jul 2020 15:52:17 +0000
Message-ID: <7d86d2067f9d4196a4fe4fecf27eec1f@AcuMS.aculab.com>
References: <20200728063643.396100-1-hch@lst.de>
        <20200728063643.396100-5-hch@lst.de>
 <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728084746.06f52878@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 28 July 2020 16:48
> On Tue, 28 Jul 2020 08:36:43 +0200 Christoph Hellwig wrote:
> > Make sure not just the pointer itself but the whole range lies in
> > the user address space.  For that pass the length and then use
> > the access_ok helper to do the check.
> >
> > Fixes: 6d04fe15f78a ("net: optimize the sockptr_t for unified kernel/user address spaces")
> > Reported-by: David Laight <David.Laight@ACULAB.COM>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> > diff --git a/net/ipv4/bpfilter/sockopt.c b/net/ipv4/bpfilter/sockopt.c
> > index 94f18d2352d007..8b132c52045973 100644
> > --- a/net/ipv4/bpfilter/sockopt.c
> > +++ b/net/ipv4/bpfilter/sockopt.c
> > @@ -65,7 +65,7 @@ int bpfilter_ip_get_sockopt(struct sock *sk, int optname,
> >
> >  	if (get_user(len, optlen))
> >  		return -EFAULT;
> > -	err = init_user_sockptr(&optval, user_optval);
> > +	err = init_user_sockptr(&optval, user_optval, *optlen);
> >  	if (err)
> >  		return err;
> >  	return bpfilter_mbox_request(sk, optname, optval, len, false);
> 
> Appears to cause these two new warnings, sadly:
> 
> net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression
> net/ipv4/bpfilter/sockopt.c:68:56: warning: dereference of noderef expression

Not surprising - 'optlen' is a user pointer.
It should be passing 'len'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

