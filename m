Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC6B227C34
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgGUJz1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Jul 2020 05:55:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:44006 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728209AbgGUJzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 05:55:24 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-262-05FU3YgoN0uQBLOw_0F_FQ-1; Tue, 21 Jul 2020 10:55:21 +0100
X-MC-Unique: 05FU3YgoN0uQBLOw_0F_FQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 21 Jul 2020 10:55:20 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 21 Jul 2020 10:55:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Biggers' <ebiggers@kernel.org>,
        Christoph Hellwig <hch@lst.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: RE: [PATCH 03/24] net: add a new sockptr_t type
Thread-Topic: [PATCH 03/24] net: add a new sockptr_t type
Thread-Index: AQHWXrQmuUX3yUokMEqukKul+fTtiakRycQA
Date:   Tue, 21 Jul 2020 09:55:20 +0000
Message-ID: <9b7ae3245bad474db2a3889bc1c1a329@AcuMS.aculab.com>
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-4-hch@lst.de> <20200720163748.GA1292162@gmail.com>
In-Reply-To: <20200720163748.GA1292162@gmail.com>
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

From: Eric Biggers
> Sent: 20 July 2020 17:38
...
> How does this not introduce a massive security hole when
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE?
> 
> AFAICS, userspace can pass in a pointer >= TASK_SIZE,
> and this code makes it be treated as a kernel pointer.

One thought I've had is that on 64-bit architectures there
is almost always some part of the KVA that can never be valid
and is larger than the maximum size of a user VA.

If the user address is offset into this invalid area
then it can always be distinguished from a kernel address.

Indeed it may be worth considering offsetting kernel
addresses as well.

This forces code to use the correct accessors.

It doesn't solve the problem for 32bit systems with
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE since
they are likely to have all 32bit addresses available
to both use and kernel.

If you end up with a 'fat pointer' then it may be worth
adding the length and making it a 'buffer descriptor'.
This can then be passed by address and the reduced
number of parameters will probably offset the cost
of the extra indirection.

The read/write functions could then take the 'buffer descriptor',
offset and length as parameters.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

