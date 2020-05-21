Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D461DCB40
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 12:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgEUKqj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 May 2020 06:46:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:60281 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728902AbgEUKqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 06:46:38 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-221-qFd0NAKZNGeARFK-F-oKaQ-1; Thu, 21 May 2020 11:46:34 +0100
X-MC-Unique: qFd0NAKZNGeARFK-F-oKaQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 21 May 2020 11:46:33 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 21 May 2020 11:46:33 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@lst.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
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
Subject: RE: remove kernel_setsockopt and kernel_getsockopt v2
Thread-Topic: remove kernel_setsockopt and kernel_getsockopt v2
Thread-Index: AQHWL0EWFDRlmpM/90uRt9jvD36P/KiyKtMAgAAFoACAACnvQA==
Date:   Thu, 21 May 2020 10:46:33 +0000
Message-ID: <b7c7cf98999f4167b821f4425896e4e8@AcuMS.aculab.com>
References: <20200520195509.2215098-1-hch@lst.de>
 <138a17dfff244c089b95f129e4ea2f66@AcuMS.aculab.com>
 <20200521091150.GA8401@lst.de>
In-Reply-To: <20200521091150.GA8401@lst.de>
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

From: 'Christoph Hellwig'
> Sent: 21 May 2020 10:12
...
> > I worried about whether getsockopt() should read the entire
> > user buffer first. SCTP needs the some of it often (including a
> > sockaddr_storage in one case), TCP needs it once.
> > However the cost of reading a few words is small, and a big
> > buffer probably needs setting to avoid leaking kernel
> > memory if the structure has holes or fields that don't get set.
> > Reading from userspace solves both issues.
> 
> As mention in the thread on the last series:  That was my first idea, but
> we have way to many sockopts, especially in obscure protocols that just
> hard code the size.  The chance of breaking userspace in a way that can't
> be fixed without going back to passing user pointers to get/setsockopt
> is way to high to commit to such a change unfortunately.

Right the syscall stubs probably can't do it.
But the per-protocol ones can for the main protocols.

I posted a patch for SCTP yesterday that removes 800 lines
of source and 8k of object code.
Even that needs a horrid bodge for one request where the
length returned has to be less than the data copied!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

