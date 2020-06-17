Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118381FD119
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgFQPf0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 11:35:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:20151 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbgFQPfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 11:35:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-215-GEsm37XKMp2mEZ5ZJK8SRg-1; Wed, 17 Jun 2020 16:35:22 +0100
X-MC-Unique: GEsm37XKMp2mEZ5ZJK8SRg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 17 Jun 2020 16:35:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 17 Jun 2020 16:35:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        "Christoph Hellwig" <hch@lst.de>, Tycho Andersen <tycho@tycho.ws>,
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
Subject: RE: [PATCH v4 03/11] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Topic: [PATCH v4 03/11] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Thread-Index: AQHWQ44F2CX108LjrkCobo2loVeUYajc8NxQ
Date:   Wed, 17 Jun 2020 15:35:20 +0000
Message-ID: <6de12195ec3244b99e6026b4b46e5be2@AcuMS.aculab.com>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-4-keescook@chromium.org>
In-Reply-To: <20200616032524.460144-4-keescook@chromium.org>
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
> Sent: 16 June 2020 04:25
> 
> For both pidfd and seccomp, the __user pointer is not used. Update
> __fd_install_received() to make writing to ufd optional. (ufd
> itself cannot checked for NULL because this changes the SCM_RIGHTS
> interface behavior.) In these cases, the new fd needs to be returned
> on success.  Update the existing callers to handle it. Add new wrapper
> fd_install_received() for pidfd and seccomp that does not use the ufd
> argument.
...> 
>  static inline int fd_install_received_user(struct file *file, int __user *ufd,
>  					   unsigned int o_flags)
>  {
> -	return __fd_install_received(file, ufd, o_flags);
> +	return __fd_install_received(file, true, ufd, o_flags);
> +}

Can you get rid of the 'return user' parameter by adding
	if (!ufd) return -EFAULT;
to the above wrapper, then checking for NULL in the function?

Or does that do the wrong horrid things in the fail path?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

