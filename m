Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B248B2487BC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 16:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHROhF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 10:37:05 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48660 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbgHROhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 10:37:03 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-92-_7XL0jprNV6MUUr_p6I3ng-1; Tue, 18 Aug 2020 15:36:59 +0100
X-MC-Unique: _7XL0jprNV6MUUr_p6I3ng-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 15:36:58 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 15:36:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
CC:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Subject: [PATCH] net: sctp: Fix negotiation of the number of data streams.
Thread-Topic: [PATCH] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ1bPXrgdZCqbhgQru55h+86tsQbg==
Date:   Tue, 18 Aug 2020 14:36:58 +0000
Message-ID: <46079a126ad542d380add5f9ba6ffa85@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of streams offered by the remote system was being ignored.
Any data sent on those streams would get discarded by the remote system.

Fixes 2075e50caf5ea.

Signed-off-by: David Laight <david.laight@aculab.com>
---
 net/sctp/stream.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

This needs backporting to 5.1 and all later kernels.

diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index bda2536dd740..6dc95dcc0ff4 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -88,12 +88,13 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
 	int ret;
 
 	if (outcnt <= stream->outcnt)
-		return 0;
+		goto out;
 
 	ret = genradix_prealloc(&stream->out, outcnt, gfp);
 	if (ret)
 		return ret;
 
+out:
 	stream->outcnt = outcnt;
 	return 0;
 }
@@ -104,12 +105,13 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
 	int ret;
 
 	if (incnt <= stream->incnt)
-		return 0;
+		goto out;
 
 	ret = genradix_prealloc(&stream->in, incnt, gfp);
 	if (ret)
 		return ret;
 
+out:
 	stream->incnt = incnt;
 	return 0;
 }
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

