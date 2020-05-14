Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503D91D2FC4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgENMa1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 08:30:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:29434 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgENMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 08:30:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-254-IsdhEyj2MaapF7FHDwegSA-1; Thu, 14 May 2020 13:30:18 +0100
X-MC-Unique: IsdhEyj2MaapF7FHDwegSA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 14 May 2020 13:30:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 14 May 2020 13:30:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>,
        'Christoph Hellwig' <hch@lst.de>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Eric Dumazet' <edumazet@google.com>,
        'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        "'Vlad Yasevich'" <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'Jon Maloy'" <jmaloy@redhat.com>,
        'Ying Xue' <ying.xue@windriver.com>,
        "'drbd-dev@lists.linbit.com'" <drbd-dev@lists.linbit.com>,
        "'linux-block@vger.kernel.org'" <linux-block@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvme@lists.infradead.org'" <linux-nvme@lists.infradead.org>,
        "'target-devel@vger.kernel.org'" <target-devel@vger.kernel.org>,
        "'linux-afs@lists.infradead.org'" <linux-afs@lists.infradead.org>,
        "'linux-cifs@vger.kernel.org'" <linux-cifs@vger.kernel.org>,
        "'cluster-devel@redhat.com'" <cluster-devel@redhat.com>,
        "'ocfs2-devel@oss.oracle.com'" <ocfs2-devel@oss.oracle.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'ceph-devel@vger.kernel.org'" <ceph-devel@vger.kernel.org>,
        "'rds-devel@oss.oracle.com'" <rds-devel@oss.oracle.com>,
        "'linux-nfs@vger.kernel.org'" <linux-nfs@vger.kernel.org>
Subject: RE: [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
Thread-Topic: [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
Thread-Index: AQHWKVDpRRlTTX4YZEat3HB6AYvqqainVRxwgAAtMyA=
Date:   Thu, 14 May 2020 12:30:17 +0000
Message-ID: <c66e0309572345f5b0f32d078701f2d7@AcuMS.aculab.com>
References: <20200513062649.2100053-1-hch@lst.de>
 <20200513062649.2100053-33-hch@lst.de>
 <20200513180302.GC2491@localhost.localdomain>
 <d112e18bfbdd40dfb219ed2c1f2082d4@AcuMS.aculab.com>
In-Reply-To: <d112e18bfbdd40dfb219ed2c1f2082d4@AcuMS.aculab.com>
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

From: David Laight
> Sent: 14 May 2020 10:51
> From: Marcelo Ricardo Leitner
> > Sent: 13 May 2020 19:03
> >
> > On Wed, May 13, 2020 at 08:26:47AM +0200, Christoph Hellwig wrote:
> > > Add a helper to directly get the SCTP_PRIMARY_ADDR sockopt from kernel
> > > space without going through a fake uaccess.
> >
> > Same comment as on the other dlm/sctp patch.
> 
> Wouldn't it be best to write sctp_[gs]etsockotp() that
> use a kernel buffer and then implement the user-space
> calls using a wrapper that does the copies to an on-stack
> (or malloced if big) buffer.

Actually looking at __sys_setsockopt() it calls
BPF_CGROUP_RUN_PROG_SETSOCKOPT() which (by the look of it)
can copy the user buffer into malloc()ed memory and
cause set_fs(KERNEL_DS) be called.

The only way to get rid of that set_fs() is to always
have the buffer in kernel memory when the underlying
setsockopt() code is called.

The comment above __sys_[sg]etsockopt() about not knowing
the length is just wrong.
It probably applied to getsockopt() in the dim and distant
past before it was made read-update.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

