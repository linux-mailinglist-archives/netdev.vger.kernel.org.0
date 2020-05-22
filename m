Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62161DEC7B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgEVPws convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 May 2020 11:52:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:36451 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730647AbgEVPws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:52:48 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-18-22NYjMq_P5mJeq-ok_ESEQ-1; Fri, 22 May 2020 16:52:43 +0100
X-MC-Unique: 22NYjMq_P5mJeq-ok_ESEQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 22 May 2020 16:52:43 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 22 May 2020 16:52:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
CC:     'Christoph Hellwig' <hch@lst.de>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: do a single memdup_user in sctp_setsockopt
Thread-Topic: do a single memdup_user in sctp_setsockopt
Thread-Index: AQHWL5hibpEyDKsV4UyRPKuzFFnyuaizvkKggABehICAACJGcA==
Date:   Fri, 22 May 2020 15:52:43 +0000
Message-ID: <a599a1a6bed0412492bafdbeecf6bb4c@AcuMS.aculab.com>
References: <20200521174724.2635475-1-hch@lst.de>
 <348217b7a3e14c1fa4868e47362be9c5@AcuMS.aculab.com>
 <20200522143623.GA386664@localhost.localdomain>
In-Reply-To: <20200522143623.GA386664@localhost.localdomain>
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
> Sent: 22 May 2020 15:36
> 
> On Fri, May 22, 2020 at 08:02:09AM +0000, David Laight wrote:
> > From: Christoph Hellwig
> > > Sent: 21 May 2020 18:47
> > > based on the review of Davids patch to do something similar I dusted off
> > > the series I had started a few days ago to move the memdup_user or
> > > copy_from_user from the inidividual sockopts into sctp_setsockopt,
> > > which is done with one patch per option, so it might suit Marcelo's
> > > taste a bit better.  I did not start any work on getsockopt.
> >
> > I'm not sure that 49 patches is actually any easier to review.
> > Most of the patches are just repetitions of the same change.
> > If they were in different files it might be different.
> 
> It's subjective, yes, but we hardly have patches over 5k lines.
> In the case here, as changing the functions also requires changing
> their call later on the file, it helps to be able to check that is was
> properly updated. Ditto for chained functions.

Between them sparse and the compiler rather force you to find everything.
The main danger was failing to change sizeof(param) to sizeof(*param)
and I double-checked all the relevant lines/

...
> What if you two work on a joint patchset for this? The proposals are
> quite close. The differences around the setsockopt handling are
> minimal already. It is basically variable naming, indentation and one
> or another small change like:

If the changes match then the subfunctions are probably fine.

Because I've got at least 64 bytes I can convert in-situ and assume
(in getsockopt()) that I can action the request (if it only only a read)
and check the length later.
With only a memdup_user() you can't make those changes.


> From Christoph's to David's:
> @@ -2249,11 +2248,11 @@ static int sctp_setsockopt_autoclose(struct sock *sk, u32 *autoclose,
>                 return -EOPNOTSUPP;
>         if (optlen != sizeof(int))
>                 return -EINVAL;
> -
> -       if (*autoclose > net->sctp.max_autoclose)
> +
> +       sp->autoclose = *optval;
> +
> +       if (sp->autoclose > net->sctp.max_autoclose)
>                 sp->autoclose = net->sctp.max_autoclose;
> -       else
> -               sp->autoclose = *autoclose;

I was trying not to make extra changes.
(Apart from error path ones.)
Clearly that should be:
	sp->autoclose = min(*optval, net->sctp.max_autoclose);
But that requires additional thought.

> > If you try to do getsockopt() the same way it will be much
> > more complicated - you have to know whether the called function
> > did the copy_to_user() and then suppress it.
> 
> If it is not possible, then the setsockopt one already splited half of
> the lines of the patch. :-)

Apart from the getsockopt() that is really a setsockopt() (CONNECTX3).
That might tie you in real knots.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

