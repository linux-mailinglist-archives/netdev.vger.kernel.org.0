Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12BF2686AA
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgINH7F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Sep 2020 03:59:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52353 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgINH7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:59:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-215-wJUKj1CvOB2KCgXzcGT9iA-1; Mon, 14 Sep 2020 08:58:55 +0100
X-MC-Unique: wJUKj1CvOB2KCgXzcGT9iA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 14 Sep 2020 08:58:54 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 14 Sep 2020 08:58:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Greg KH' <greg@kroah.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com" 
        <syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: RE: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in
 __sys_sendmmsg
Thread-Topic: [Linux-kernel-mentees] [PATCH] net: fix uninit value error in
 __sys_sendmmsg
Thread-Index: AQHWiZUUFtyl13ctBkOLZWcXDFPGWKlnweqA
Date:   Mon, 14 Sep 2020 07:58:54 +0000
Message-ID: <346bcf816616429abb01a475dd8d87fc@AcuMS.aculab.com>
References: <20200913055639.15639-1-anant.thazhemadam@gmail.com>
 <20200913061351.GA585618@kroah.com>
In-Reply-To: <20200913061351.GA585618@kroah.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg KH
> Sent: 13 September 2020 07:14
> On Sun, Sep 13, 2020 at 11:26:39AM +0530, Anant Thazhemadam wrote:
> > The crash report showed that there was a local variable;
> >
> > ----iovstack.i@__sys_sendmmsg created at:
> >  ___sys_sendmsg net/socket.c:2388 [inline]
> >  __sys_sendmmsg+0x6db/0xc90 net/socket.c:2480
> >
> >  that was left uninitialized.
> >
> > The contents of iovstack are of interest, since the respective pointer
> > is passed down as an argument to sendmsg_copy_msghdr as well.
> > Initializing this contents of this stack prevents this bug from happening.
> >
> > Since the memory that was initialized is freed at the end of the function
> > call, memory leaks are not likely to be an issue.
> >
> > syzbot seems to have triggered this error by passing an array of 0's as
> > a parameter while making the initial system call.
> >
> > Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> > Tested-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
> > Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > ---
> >  net/socket.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/socket.c b/net/socket.c
> > index 0c0144604f81..d74443dfd73b 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -2396,6 +2396,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
> >  {
> >  	struct sockaddr_storage address;
> >  	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
> > +	memset(iov, 0, UIO_FASTIOV);
> >  	ssize_t err;
> >
> >  	msg_sys->msg_name = &address;
> 
> I don't think you built this code change, otherwise you would have seen
> that it adds a build warning to the system, right?

Also it can't be the right 'fix' for whatever sysbot found.
(I can't find the sysbot report.)

Zeroing iov[] just slows down a path that is already too slow because
of the contorted functions used to read in iov[].

If it does need to be zerod then it would be needed in a lot
of other code paths that read in iov[].

If a zero length iov[] needs converting into a single entity
with a zero length - then that needs to be done elsewhere.

I've a patch series I might redo that changes the code that
reads in iov[] to return the address of any buffer that
needed to be malloced (more than UIV_FASTIO buffers) rather
than using the iov parameter to pass in the cache and
return the buffer to free.
It would be less confusing and error prone.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

