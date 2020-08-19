Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62859249E83
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgHSMrH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Aug 2020 08:47:07 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38998 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728559AbgHSMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 08:46:00 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-20-1_dRjE57NPqksr6P6Xk02Q-1; Wed, 19 Aug 2020 13:45:53 +0100
X-MC-Unique: 1_dRjE57NPqksr6P6Xk02Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 19 Aug 2020 13:45:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 19 Aug 2020 13:45:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
CC:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Subject: RE: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Topic: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ2Jpt5uFDQ+GlJS8asoZmPH8fG2Q==
Date:   Wed, 19 Aug 2020 12:45:52 +0000
Message-ID: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 1.001999
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of output and input streams was never being reduced, eg when
processing received INIT or INIT_ACK chunks.
The effect is that DATA chunks can be sent with invalid stream ids
and then discarded by the remote system.

Fixes: 2075e50caf5ea ("sctp: convert to genradix")
Signed-off-by: David Laight <david.laight@aculab.com>
---
 net/sctp/stream.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

This needs backporting to 5.1 and all later kernels.

Changes since v1:
- Fix 'Fixes' tag.
- Improve description.

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

