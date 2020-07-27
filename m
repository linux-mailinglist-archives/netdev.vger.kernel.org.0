Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8655622E982
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgG0Jvw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 05:51:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37423 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgG0Jvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:51:51 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-157-rSG2T3OdNGGcdmdBioAAVQ-1; Mon, 27 Jul 2020 10:51:47 +0100
X-MC-Unique: rSG2T3OdNGGcdmdBioAAVQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 27 Jul 2020 10:51:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 27 Jul 2020 10:51:45 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Miller' <davem@davemloft.net>, "hch@lst.de" <hch@lst.de>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>
Subject: RE: get rid of the address_space override in setsockopt v2
Thread-Topic: get rid of the address_space override in setsockopt v2
Thread-Index: AQHWYgvqDt5Xt3HFu0u82UKLVqcKxKkbLTEQ
Date:   Mon, 27 Jul 2020 09:51:45 +0000
Message-ID: <8ae792c27f144d4bb5cbea0c1cce4eed@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200724.154342.1433271593505001306.davem@davemloft.net>
In-Reply-To: <20200724.154342.1433271593505001306.davem@davemloft.net>
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

From: David Miller
> Sent: 24 July 2020 23:44
> 
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 23 Jul 2020 08:08:42 +0200
> 
> > setsockopt is the last place in architecture-independ code that still
> > uses set_fs to force the uaccess routines to operate on kernel pointers.
> >
> > This series adds a new sockptr_t type that can contained either a kernel
> > or user pointer, and which has accessors that do the right thing, and
> > then uses it for setsockopt, starting by refactoring some low-level
> > helpers and moving them over to it before finally doing the main
> > setsockopt method.
> >
> > Note that apparently the eBPF selftests do not even cover this path, so
> > the series has been tested with a testing patch that always copies the
> > data first and passes a kernel pointer.  This is something that works for
> > most common sockopts (and is something that the ePBF support relies on),
> > but unfortunately in various corner cases we either don't use the passed
> > in length, or in one case actually copy data back from setsockopt, or in
> > case of bpfilter straight out do not work with kernel pointers at all.
> >
> > Against net-next/master.
> >
> > Changes since v1:
> >  - check that users don't pass in kernel addresses
> >  - more bpfilter cleanups
> >  - cosmetic mptcp tweak
> 
> Series applied to net-next, I'm build testing and will push this out when
> that is done.

Hmmm... this code does:

int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
		int optlen)
{
	sockptr_t optval;
	char *kernel_optval = NULL;
	int err, fput_needed;
	struct socket *sock;

	if (optlen < 0)
		return -EINVAL;

	err = init_user_sockptr(&optval, user_optval);
	if (err)
		return err;

And the called code does:
	if (copy_from_sockptr(&opt, optbuf, sizeof(opt)))
		return -EFAULT;


Which means that only the base of the user's buffer is checked
for being in userspace.

I'm sure there is code that processes options in chunks.
This probably means it is possible to put a chunk boundary
at the end of userspace and continue processing the very start
of kernel memory.

At best this faults on the kernel copy code and crashes the system.

Maybe there wasn't any code that actually incremented the user address.
But it is hardly robust.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

