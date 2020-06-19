Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8BA2003B4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbgFSIXy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jun 2020 04:23:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47570 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731300AbgFSIVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:21:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-78-mkYMfPweOkGnJdWf_Vspzw-1; Fri, 19 Jun 2020 09:20:56 +0100
X-MC-Unique: mkYMfPweOkGnJdWf_Vspzw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 19 Jun 2020 09:20:55 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 19 Jun 2020 09:20:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christian Brauner" <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        "Christoph Hellwig" <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [PATCH v5 3/7] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Topic: [PATCH v5 3/7] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Index: AQHWRazi5O9oFyX6VkOfXGvu43vXPajfldBw
Date:   Fri, 19 Jun 2020 08:20:55 +0000
Message-ID: <c7d9f68d5dff4c54b4da0d96b03de2a0@AcuMS.aculab.com>
References: <20200617220327.3731559-1-keescook@chromium.org>
 <20200617220327.3731559-4-keescook@chromium.org>
 <20200618054918.GB18669@ircssh-2.c.rugged-nimbus-611.internal>
 <202006181305.01F1B08@keescook>
In-Reply-To: <202006181305.01F1B08@keescook>
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
> Sent: 18 June 2020 21:13
> On Thu, Jun 18, 2020 at 05:49:19AM +0000, Sargun Dhillon wrote:
> > On Wed, Jun 17, 2020 at 03:03:23PM -0700, Kees Cook wrote:
> > > [...]
> > >  static inline int fd_install_received_user(struct file *file, int __user *ufd,
> > >  					   unsigned int o_flags)
> > >  {
> > > +	if (ufd == NULL)
> > > +		return -EFAULT;
> > Isn't this *technically* a behvaiour change? Nonetheless, I think this is a much better
> > approach than forcing everyone to do null checking, and avoids at least one error case
> > where the kernel installs FDs for SCM_RIGHTS, and they're not actualy usable.
> 
> So, the only behavior change I see is that the order of sanity checks is
> changed.
> 
> The loop in scm_detach_fds() is:
> 
> 
>         for (i = 0; i < fdmax; i++) {
>                 err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
>                 if (err < 0)
>                         break;
>         }
> 
> Before, __scm_install_fd() does:
> 
>         error = security_file_receive(file);
>         if (error)
>                 return error;
> 
>         new_fd = get_unused_fd_flags(o_flags);
>         if (new_fd < 0)
>                 return new_fd;
> 
>         error = put_user(new_fd, ufd);
>         if (error) {
>                 put_unused_fd(new_fd);
>                 return error;
>         }
> 	...
> 
> After, fd_install_received_user() and __fd_install_received() does:
> 
>         if (ufd == NULL)
>                 return -EFAULT;
> 	...
>         error = security_file_receive(file);
>         if (error)
>                 return error;
> 	...
>                 new_fd = get_unused_fd_flags(o_flags);
>                 if (new_fd < 0)
>                         return new_fd;
> 	...
>                 error = put_user(new_fd, ufd);
>                 if (error) {
>                         put_unused_fd(new_fd);
>                         return error;
>                 }
> 
> i.e. if a caller attempts a receive that is rejected by LSM *and*
> includes a NULL userpointer destination, they will get an EFAULT now
> instead of an EPERM.

The 'user' pointer the fd is written to is in the middle of
the 'cmsg' buffer.
So to hit 'ufd == NULL' the program would have to pass a small
negative integer!

The error paths are strange if there are multiple fd in the message.
A quick look at the old code seems to imply that if the user doesn't
supply a big enough buffer then the extra 'file *' just get closed.
OTOH if there is an error processing one of the files the request
fails with the earlier file allocated fd numbers.

In addition most of the userspace buffer is written after the
loop - any errors there return -EFAULT (SIGSEGV) without
even trying to tidy up the allocated fd.

ISTM that the put_user(new_fd, ufd) could be done in __scm_install_fd()
after __fd_install_received() returns.

scm_detach_fds() could do the put_user(SOL_SOCKET,...) before actually
processing the first file - so that the state can be left unchanged
when a naff buffer is passed.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

