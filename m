Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA701D2A14
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgENIbC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 04:31:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:43060 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgENIbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:31:02 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-41-3XJ_vbSSOB-Mdnc0632Mfw-1; Thu, 14 May 2020 09:29:32 +0100
X-MC-Unique: 3XJ_vbSSOB-Mdnc0632Mfw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 14 May 2020 09:29:31 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 14 May 2020 09:29:31 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Vlad Yasevich" <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: RE: remove kernel_setsockopt and kernel_getsockopt
Thread-Topic: remove kernel_setsockopt and kernel_getsockopt
Thread-Index: AQHWKU15LJmP4mOGDE2/GHhLszFt9KinP7aQ
Date:   Thu, 14 May 2020 08:29:30 +0000
Message-ID: <756758e8f0e34e2e97db470609f5fbba@AcuMS.aculab.com>
References: <20200513062649.2100053-1-hch@lst.de>
 <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
In-Reply-To: <ecc165c33962d964d518c80de605af632eee0474.camel@perches.com>
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

From: Joe Perches
> Sent: 13 May 2020 18:39
> On Wed, 2020-05-13 at 08:26 +0200, Christoph Hellwig wrote:
> > this series removes the kernel_setsockopt and kernel_getsockopt
> > functions, and instead switches their users to small functions that
> > implement setting (or in one case getting) a sockopt directly using
> > a normal kernel function call with type safety and all the other
> > benefits of not having a function call.
> >
> > In some cases these functions seem pretty heavy handed as they do
> > a lock_sock even for just setting a single variable, but this mirrors
> > the real setsockopt implementation - counter to that a few kernel
> > drivers just set the fields directly already.
> >
> > Nevertheless the diffstat looks quite promising:
> >
> >  42 files changed, 721 insertions(+), 799 deletions(-)

I missed this patch going through.
Massive NACK.

You need to export functions that do most of the socket options
for all protocols.
As well as REUSADDR and NODELAY SCTP has loads because a lot
of stuff that should have been extra system calls got piled
into setsockopt.

An alternate solution would be to move the copy_to/from_user()
into a wrapper function so that the kernel_[sg]etsockopt()
functions would bypass them completely.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

