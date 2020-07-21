Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58238227CAB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgGUKO1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jul 2020 06:14:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45333 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729130AbgGUKOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:14:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-138-nfvRhVVmO1WenzQxH6ebBA-1; Tue, 21 Jul 2020 11:14:21 +0100
X-MC-Unique: nfvRhVVmO1WenzQxH6ebBA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Jul 2020 11:14:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Jul 2020 11:14:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
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
Subject: RE: [PATCH 03/24] net: add a new sockptr_t type
Thread-Topic: [PATCH 03/24] net: add a new sockptr_t type
Thread-Index: AQHWXznVP/p0ivee+U2FmRNemPQri6kRzhiA
Date:   Tue, 21 Jul 2020 10:14:20 +0000
Message-ID: <6727969f2f6e467fa2d43f9773cefa27@AcuMS.aculab.com>
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-4-hch@lst.de>
In-Reply-To: <20200720124737.118617-4-hch@lst.de>
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

From: Christoph Hellwig
> Sent: 20 July 2020 13:47
> 
> Add a uptr_t type that can hold a pointer to either a user or kernel
> memory region, and simply helpers to copy to and from it.  For
> architectures like x86 that have non-overlapping user and kernel
> address space it just is a union and uses a TASK_SIZE check to
> select the proper copy routine.  For architectures with overlapping
> address spaces a flag to indicate the address space is used instead.
> 
...
> +#else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
> +typedef struct {
> +	union {
> +		void		*kernel;
> +		void __user	*user;
> +	};
> +	bool		is_kernel : 1;
> +} sockptr_t;

If you need to do that you might as well make it a struct
where either the kernel or user address is defined.
Far safer for all architectures.

Indeed you could add the length (to save passing an
extra parameter through the layers).

The system call code could even copy the code into a
kernel buffer (setting both pointers).
So that code that didn't need to access beyond the end
of the implied buffer (most of it) could just access the
kernel buffer.

For getsockopt() you'd need some way of supressing the
'default' copy back of the user buffer.

This would also allow some of the sctp getsockopt to
read (usually 4 bytes) from the 'user' buffer without
the wrapper code always having to read in the entire
user buffer.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

