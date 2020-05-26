Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589211E274D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388740AbgEZQlW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:41:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:59929 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388705AbgEZQlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:41:22 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-115-n6cUUkX4OBOwTBYrrCbVDQ-1; Tue, 26 May 2020 17:40:12 +0100
X-MC-Unique: n6cUUkX4OBOwTBYrrCbVDQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:11 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:11 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 4/8] sctp: getsockopt, rename some locals.
Thread-Topic: [PATCH v3 net-next 4/8] sctp: getsockopt, rename some locals.
Thread-Index: AdYzez5Xxz4UOL45TDysyGgxO5oM3w==
Date:   Tue, 26 May 2020 16:40:11 +0000
Message-ID: <72071d4c0a854a099821df3b5e0d81ef@AcuMS.aculab.com>
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

Rename locals to avoid clash with structure fields in the next patch.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b8068da..ae916ad 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6434,7 +6434,7 @@ static int sctp_getsockopt_nodelay(struct sock *sk, int len,
 static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 				char __user *optval,
 				int __user *optlen) {
-	struct sctp_rtoinfo rtoinfo;
+	struct sctp_rtoinfo params;
 	struct sctp_association *asoc;
 
 	if (len < sizeof (struct sctp_rtoinfo))
@@ -6442,33 +6442,33 @@ static int sctp_getsockopt_rtoinfo(struct sock *sk, int len,
 
 	len = sizeof(struct sctp_rtoinfo);
 
-	if (copy_from_user(&rtoinfo, optval, len))
+	if (copy_from_user(&params, optval, len))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, rtoinfo.srto_assoc_id);
+	asoc = sctp_id2assoc(sk, params.srto_assoc_id);
 
-	if (!asoc && rtoinfo.srto_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.srto_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values corresponding to the specific association. */
 	if (asoc) {
-		rtoinfo.srto_initial = jiffies_to_msecs(asoc->rto_initial);
-		rtoinfo.srto_max = jiffies_to_msecs(asoc->rto_max);
-		rtoinfo.srto_min = jiffies_to_msecs(asoc->rto_min);
+		params.srto_initial = jiffies_to_msecs(asoc->rto_initial);
+		params.srto_max = jiffies_to_msecs(asoc->rto_max);
+		params.srto_min = jiffies_to_msecs(asoc->rto_min);
 	} else {
 		/* Values corresponding to the endpoint. */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		rtoinfo.srto_initial = sp->rtoinfo.srto_initial;
-		rtoinfo.srto_max = sp->rtoinfo.srto_max;
-		rtoinfo.srto_min = sp->rtoinfo.srto_min;
+		params.srto_initial = sp->rtoinfo.srto_initial;
+		params.srto_max = sp->rtoinfo.srto_max;
+		params.srto_min = sp->rtoinfo.srto_min;
 	}
 
 	if (put_user(len, optlen))
 		return -EFAULT;
 
-	if (copy_to_user(optval, &rtoinfo, len))
+	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
 	return 0;
@@ -6490,7 +6490,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 				     int __user *optlen)
 {
 
-	struct sctp_assocparams assocparams;
+	struct sctp_assocparams params;
 	struct sctp_association *asoc;
 	struct list_head *pos;
 	int cnt = 0;
@@ -6500,37 +6500,37 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 
 	len = sizeof(struct sctp_assocparams);
 
-	if (copy_from_user(&assocparams, optval, len))
+	if (copy_from_user(&params, optval, len))
 		return -EFAULT;
 
-	asoc = sctp_id2assoc(sk, assocparams.sasoc_assoc_id);
+	asoc = sctp_id2assoc(sk, params.sasoc_assoc_id);
 
-	if (!asoc && assocparams.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
+	if (!asoc && params.sasoc_assoc_id != SCTP_FUTURE_ASSOC &&
 	    sctp_style(sk, UDP))
 		return -EINVAL;
 
 	/* Values correspoinding to the specific association */
 	if (asoc) {
-		assocparams.sasoc_asocmaxrxt = asoc->max_retrans;
-		assocparams.sasoc_peer_rwnd = asoc->peer.rwnd;
-		assocparams.sasoc_local_rwnd = asoc->a_rwnd;
-		assocparams.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
+		params.sasoc_asocmaxrxt = asoc->max_retrans;
+		params.sasoc_peer_rwnd = asoc->peer.rwnd;
+		params.sasoc_local_rwnd = asoc->a_rwnd;
+		params.sasoc_cookie_life = ktime_to_ms(asoc->cookie_life);
 
 		list_for_each(pos, &asoc->peer.transport_addr_list) {
 			cnt++;
 		}
 
-		assocparams.sasoc_number_peer_destinations = cnt;
+		params.sasoc_number_peer_destinations = cnt;
 	} else {
 		/* Values corresponding to the endpoint */
 		struct sctp_sock *sp = sctp_sk(sk);
 
-		assocparams.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
-		assocparams.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
-		assocparams.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
-		assocparams.sasoc_cookie_life =
+		params.sasoc_asocmaxrxt = sp->assocparams.sasoc_asocmaxrxt;
+		params.sasoc_peer_rwnd = sp->assocparams.sasoc_peer_rwnd;
+		params.sasoc_local_rwnd = sp->assocparams.sasoc_local_rwnd;
+		params.sasoc_cookie_life =
 					sp->assocparams.sasoc_cookie_life;
-		assocparams.sasoc_number_peer_destinations =
+		params.sasoc_number_peer_destinations =
 					sp->assocparams.
 					sasoc_number_peer_destinations;
 	}
@@ -6538,7 +6538,7 @@ static int sctp_getsockopt_associnfo(struct sock *sk, int len,
 	if (put_user(len, optlen))
 		return -EFAULT;
 
-	if (copy_to_user(optval, &assocparams, len))
+	if (copy_to_user(optval, &params, len))
 		return -EFAULT;
 
 	return 0;
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

