Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58E0296AF2
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460476AbgJWIKP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Oct 2020 04:10:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:57963 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S460447AbgJWIHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 04:07:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-32-B96nT0NvMB-A0-9L2WMrAQ-1; Fri, 23 Oct 2020 09:07:45 +0100
X-MC-Unique: B96nT0NvMB-A0-9L2WMrAQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 23 Oct 2020 09:07:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 23 Oct 2020 09:07:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>
CC:     Francis Laniel <laniel_francis@privacyrequired.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Thread-Topic: [RFC][PATCH v3 3/3] Rename nla_strlcpy to nla_strscpy.
Thread-Index: AQHWqMfnfkchSqyLt0CdfVpg7HsLY6mk05XA
Date:   Fri, 23 Oct 2020 08:07:44 +0000
Message-ID: <b55d502089c44b3589973fa4e0d90617@AcuMS.aculab.com>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
        <20201020164707.30402-4-laniel_francis@privacyrequired.com>
        <202010211649.ABD53841B@keescook>        <2286512.66XcFyAlgq@machine>
        <202010221302.5BA047AC9@keescook>
 <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022160551.33d85912@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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

From: Jakub Kicinski
> Sent: 23 October 2020 00:06
> 
> On Thu, 22 Oct 2020 13:04:32 -0700 Kees Cook wrote:
> > > > > From: Francis Laniel <laniel_francis@privacyrequired.com>
> > > > >
> > > > > Calls to nla_strlcpy are now replaced by calls to nla_strscpy which is the
> > > > > new name of this function.
> > > > >
> > > > > Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
> > > >
> > > > The Subject could also be: "treewide: Rename nla_strlcpy to nla_strscpy"
> > > >
> > > > But otherwise, yup, easy mechanical change.
> > >
> > > Should I submit a v4 for this change?
> >
> > I'll say yes. :) Drop the RFC, bump to v4, and send it to netdev (along
> > with all the other CCs you have here already), and add the Reviewed-bys
> > from v3.
> 
> Maybe wait until next week, IIRC this doesn't fix any bugs, so it's
> -next material. We don't apply anything to net-next during the merge
> window.

Is this just a rename, or have you changed the result value?
In the latter case the subject is really right.

FWIW I suspect  the 'return -ERR on overflow' is going to bite us.
Code that does p += strsxxx(p, ..., lim - p, ...) assuming (or not
caring) about overflow goes badly wrong.

To my mind returning the full buffer length (ie include the '\0')
on overflow still allows overflow be checked but makes writes
outside the buffer very unlikely.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

