Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E421FED75
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgFRIUO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 04:20:14 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:25992 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728401AbgFRIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:20:04 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-60-xqW0qJM9OuOmp_SMWmfb5w-1; Thu, 18 Jun 2020 09:20:00 +0100
X-MC-Unique: xqW0qJM9OuOmp_SMWmfb5w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 18 Jun 2020 09:19:59 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 18 Jun 2020 09:19:59 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sargun Dhillon" <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        "Tycho Andersen" <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [PATCH v4 03/11] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Topic: [PATCH v4 03/11] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Index: AQHWQ44F2CX108LjrkCobo2loVeUYajc8NxQgAA6eACAANyJYA==
Date:   Thu, 18 Jun 2020 08:19:59 +0000
Message-ID: <bed4dbb349cf4dbda78652f9c2bf1090@AcuMS.aculab.com>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-4-keescook@chromium.org>
 <6de12195ec3244b99e6026b4b46e5be2@AcuMS.aculab.com>
 <202006171141.4DA1174979@keescook>
In-Reply-To: <202006171141.4DA1174979@keescook>
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

From: Kees Cook
> Sent: 17 June 2020 20:58
> On Wed, Jun 17, 2020 at 03:35:20PM +0000, David Laight wrote:
> > From: Kees Cook
> > > Sent: 16 June 2020 04:25
> > >
> > > For both pidfd and seccomp, the __user pointer is not used. Update
> > > __fd_install_received() to make writing to ufd optional. (ufd
> > > itself cannot checked for NULL because this changes the SCM_RIGHTS
> > > interface behavior.) In these cases, the new fd needs to be returned
> > > on success.  Update the existing callers to handle it. Add new wrapper
> > > fd_install_received() for pidfd and seccomp that does not use the ufd
> > > argument.
> > ...>
> > >  static inline int fd_install_received_user(struct file *file, int __user *ufd,
> > >  					   unsigned int o_flags)
> > >  {
> > > -	return __fd_install_received(file, ufd, o_flags);
> > > +	return __fd_install_received(file, true, ufd, o_flags);
> > > +}
> >
> > Can you get rid of the 'return user' parameter by adding
> > 	if (!ufd) return -EFAULT;
> > to the above wrapper, then checking for NULL in the function?
> >
> > Or does that do the wrong horrid things in the fail path?
> 
> Oh, hm. No, that shouldn't break the failure path, since everything gets
> unwound in __fd_install_received if the ufd write fails.
> 
> Effectively this (I'll chop it up into the correct patches):

Yep, that's what i was thinking...

Personally I'm not sure that it matters whether the file is left
attached to a process fd when the copy_to_user() fails.
The kernel data structures are consistent either way.
So sane code relies on catching SIGSEGV, fixing thigs up,
and carrying on.
(IIRC the original /bin/sh code called sbrk() in its SIGSEGV
handler instead of doing the limit check in malloc()!)

The important error path is 'failing to get an fd number'.
In that case the caller needs to keep the 'file *' or close it.

I've not looked at the code, but I wonder if you need to pass
the 'file *' by reference so that you can consume it (write NULL)
and return an error.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

