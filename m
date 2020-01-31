Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4130A14EA97
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 11:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgAaK00 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 Jan 2020 05:26:26 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:23589 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728071AbgAaK00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 05:26:26 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-213-YCgl78x1PKeLx9KdC7yCLA-1; Fri, 31 Jan 2020 10:26:21 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 31 Jan 2020 10:26:21 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 31 Jan 2020 10:26:21 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     netdev <netdev@vger.kernel.org>
Subject: Freeing 'temporary' IPv4 route table entries.
Thread-Topic: Freeing 'temporary' IPv4 route table entries.
Thread-Index: AdXXj93DZx0FEI6/TbeS56CZssFH8A==
Date:   Fri, 31 Jan 2020 10:26:21 +0000
Message-ID: <bee231ddc34142d2a96bfdc9a6a2f57c@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: YCgl78x1PKeLx9KdC7yCLA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If I call sendmsg() on a raw socket (or probably
an unconnected UDP one) rt_dst_alloc() is called
in the bowels of ip_route_output_flow() to hold
the remote address.

Much later __dev_queue_xmit() calls dst_release()
to delete the 'dst' referenced from the skb.

Prior to f8864972 it did just that.
Afterwards the actual delete is 'laundered' through the
rcu callbacks.
This is probably ok for dst that are actually attached
to sockets or tunnels (which aren't freed very often).
But it leads to horrid long rcu callback sequences
when a lot of messages are sent.
(A sample of 1 gave nearly 100 deletes in one go.)
There is also the additional cost of deferring the free
(and the extra retpoline etc).

ISTM that the dst_alloc() done during a send should
set a flag so that the 'dst' can be immediately
freed since it is known that no one can be picking up
a reference as it is being freed.

Thoughts?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

