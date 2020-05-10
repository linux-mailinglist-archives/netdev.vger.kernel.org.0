Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC631CCC19
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgEJQAo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 10 May 2020 12:00:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48750 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728238AbgEJQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:00:44 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-230-UVwL_llEMQSFyZHjt5zKZA-1; Sun, 10 May 2020 17:00:41 +0100
X-MC-Unique: UVwL_llEMQSFyZHjt5zKZA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sun, 10 May 2020 17:00:41 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sun, 10 May 2020 17:00:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when IP_HDRINCL
 set.
Thread-Topic: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
Thread-Index: AdYm44GMpCoVm8MoQ+GQh1uj0J52IA==
Date:   Sun, 10 May 2020 16:00:41 +0000
Message-ID: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
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

The final routing for ipv4 packets may be done with the IP address
from the message header not that from the address buffer.
If the addresses are different FLOWI_FLAG_KNOWN_NH must be set so
that a temporary 'struct rtable' entry is created to send the message.
However the allocate + free (under RCU) is relatively expensive
and can be avoided by a quick check shows the addresses match.

Signed-off-by: David Laight <david.laight@aculab.com>
---

This makes a considerable difference when we are sending a lot
of RTP streams from a raw socket.
IP_HDRINCL has to be set so that the calculated UDP checksum is right.

 net/ipv4/raw.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 3183413..0a81376 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -495,6 +495,27 @@ static int raw_getfrag(void *from, char *to, int offset, int len, int odd,
 	return ip_generic_getfrag(rfv->msg, to, offset, len, odd, skb);
 }
 
+static bool raw_msg_addr_matches(struct msghdr *msg, __be32 daddr)
+{
+	const struct iovec *iov;
+	__be32 msg_daddr;
+
+	/* Check common case of user buffer with header in the first fragment.
+	 * If we return false the message is still sent.
+	 */
+
+	if (!iter_is_iovec(&msg->msg_iter))
+		return false;
+	iov = msg->msg_iter.iov;
+	if (!iov || iov->iov_len < 20)
+		return false;
+
+	if (get_user(msg_daddr, (__be32 __user *)(iov->iov_base + 16)))
+		return false;
+
+	return daddr == msg_daddr;
+}
+
 static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct inet_sock *inet = inet_sk(sk);
@@ -626,9 +647,14 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
 			   RT_SCOPE_UNIVERSE,
 			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
-			   inet_sk_flowi_flags(sk) |
-			    (hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
+			   inet_sk_flowi_flags(sk),
 			   daddr, saddr, 0, 0, sk->sk_uid);
+	/* The final message routing may be done with the destination address
+	 * in the user-supplied ipv4 header. If this differs from 'daddr' then
+	 * a temporary destination table entry has to be created.
+	 */ 
+	if (hdrincl && !raw_msg_addr_matches(msg, daddr))
+		fl4.flowi4_flags |= FLOWI_FLAG_KNOWN_NH;
 
 	if (!hdrincl) {
 		rfv.msg = msg;
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

