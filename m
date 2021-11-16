Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574CC452EE4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhKPKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:22:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51486 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhKPKWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:22:23 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637057965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tmef5BxDew8mQ5tumKAD4FZtWpS8npOjZyM1kVOj4Uw=;
        b=R6XnQ837cXV36YauZrLhJ7mcb4dB7DxaDgpY0E6yCJ+Bpj/gRX3fZlpqj5bcgDhjcrjM8g
        tMLNGBSA9m9llridhOs+LhwgT34keT3P3EEDSvUxXUYqPm5ql5DZSxHF7alAvBf3ZP8KZm
        /WrQDwk9Q+2kT3WPB7kXCdClSpID5dDncjttgbDnpO7EzyHIyGEHdgbuyaHq5Db7kTk4RO
        L/camCVyYNnpcc2/EU+4Pp7spLE0+n7evkoblGPnD9Vg6l9lcoqHLKFfrBxcyIopYBBPzI
        7a3iGZFV4kDH6Lyl0ryTXkqly1AJqWiu6yctMYhVOHD/4la7KMZqSgwzpgd9cw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637057965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=tmef5BxDew8mQ5tumKAD4FZtWpS8npOjZyM1kVOj4Uw=;
        b=kfQhV4D6ptRcHR4h21mtVX0dnQLgp901RfzVER4WMw/ZNMjdSKY2JkdIoTdAqpK9Cu7Il7
        9AikHsembFp1WWCQ==
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: RFC: PTP Boundary Clock over UDPv4/UDPv6 on Linux bridge
Date:   Tue, 16 Nov 2021 11:19:24 +0100
Message-ID: <871r3gbdxv.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm currently trying to setup a PTP Boundary Clock over UDPv4 or UDPv6
on top of a switch using a Linux bridge. It works fine using PTP Layer 2
transport, but not for UDP. I'm wondering whether this is supported
using Linux or if I'm doing something wrong.

My setup looks like this:

Bridge (DSA):

|$ ip link set eth0 up
|$ ip link set lan0 up
|$ ip link set lan1 up
|$ ip link add name br0 type bridge
|$ ip link set dev lan0 master br0
|$ ip link set dev lan1 master br0
|$ ip link set br0 up
|$ dhclient br0

PTP:

|$ ptp4l -4 -i lan0 -i lan1 --tx_timestamp_timeout=3D40 -m

It seems like ptp4l cannot receive any PTP messages. Tx works fine.

The following hack solves the problem for me. However, I'm not sure
whether that's the correct approach or not. Any opinions, ideas,
comments?

Thanks,
Kurt

|From 2e8b429b3ebabda8e81693b9704dbe5e5205ab09 Mon Sep 17 00:00:00 2001
|From: Kurt Kanzenbach <kurt@linutronix.de>
|Date: Wed, 4 Aug 2021 09:33:12 +0200
|Subject: [PATCH] net: bridge: input: Handle PTP over UDPv4 and UDPv6
|
|PTP is considered management traffic. A time aware switch should intercept=
 all
|PTP messages and handle them accordingly. The corresponding Linux setup is=
 like
|this:
|
|         +-- br0 --+
|        / /   |     \
|       / /    |      \
|      /  |    |     / \
|     /   |    |    /   \
|   swp0 swp1 swp2 swp3 swp4
|
|ptp4l runs on all individual switch ports and needs full control over send=
ing
|and receiving messages on these ports.
|
|However, the bridge code treats PTP messages over UDP transport as regular=
 IP
|messages and forwards them to br0. This way, the running ptp4l instances c=
annot
|receive these frames on the individual switch port interfaces.
|
|Fix it by intercepting PTP UDP traffic in the bridge code and pass them to=
 the
|regular network processing.
|
|Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
|---
| net/bridge/br_input.c | 13 +++++++++++++
| 1 file changed, 13 insertions(+)
|
|diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
|index b50382f957c1..4e12be70a003 100644
|--- a/net/bridge/br_input.c
|+++ b/net/bridge/br_input.c
|@@ -271,6 +271,13 @@ static int br_process_frame_type(struct net_bridge_po=
rt *p,
| 	return 0;
| }
|=20
|+static const unsigned char ptp_ip_destinations[][ETH_ALEN] =3D {
|+	{ 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 }, /* IPv4 PTP */
|+	{ 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b }, /* IPv4 P2P */
|+	{ 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 }, /* IPv6 PTP */
|+	{ 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b }, /* IPv6 P2P */
|+};
|+
| /*
|  * Return NULL if skb is handled
|  * note: already called with rcu_read_lock
|@@ -280,6 +287,7 @@ static rx_handler_result_t br_handle_frame(struct sk_b=
uff **pskb)
| 	struct net_bridge_port *p;
| 	struct sk_buff *skb =3D *pskb;
| 	const unsigned char *dest =3D eth_hdr(skb)->h_dest;
|+	int i;
|=20
| 	if (unlikely(skb->pkt_type =3D=3D PACKET_LOOPBACK))
| 		return RX_HANDLER_PASS;
|@@ -360,6 +368,11 @@ static rx_handler_result_t br_handle_frame(struct sk_=
buff **pskb)
| 	if (unlikely(br_process_frame_type(p, skb)))
| 		return RX_HANDLER_PASS;
|=20
|+	/* Check for PTP over UDPv4 or UDPv6. */
|+	for (i =3D 0; i < ARRAY_SIZE(ptp_ip_destinations); ++i)
|+		if (ether_addr_equal(ptp_ip_destinations[i], dest))
|+			return RX_HANDLER_PASS;
|+
| forward:
| 	switch (p->state) {
| 	case BR_STATE_FORWARDING:
|--=20
|2.30.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGThawTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpqtJEAC/5q6nEuYpfxhRoSb/OvMHUEXIF+hR
IQFlPaxHAiar+LxWmxRF5O8We/YfpZNSDwj5OXhquPxYsfLLQzINB8RRBkagRgtk
oYOVlluR68iSQhpiG0SYMjlaGE4I0RSgHT2I+uVn2pWYhNznZrt1Nu8h+OMJfsgV
wATbnOWD33YiefUdl8eW43L2z0fIXuxRA5ad2SImvBSsE3gsZi10sF1BVowPmL4j
Ch3b6dNRU653455Q/M8ZJ0hEGIisblSVvV0msyjWgyLCtnPRHWXi1AmczqopODLQ
a9nPiPKTjY0Lu9dGhCPuM4TgZZrNJYuBUHBy6Twg4DBQp1I8DKI4esECH3g6vpFA
H+72cLplqPpIXfnF3C/d6NY7nLITVS5zKlvyCIbz0Igz7TCH0JzEJ9jMMY+zr4Cv
yp4/IoCqBicz1ZQN7eA4LnTjslzGPdQVcfWV7UNBbqtZ+AQ7pN6vhvIiLrhb09PI
woFC9lZP24ZV5a59EcbLbGjhHPz1BBu8jinP7FYXdbn9wsTzrk6aBPmr1u/djoN3
qJOhxxukultUyXiu9n9nWutoD+8LPTWWRNHFdcG4uzNd0UOQ4wKeVcSmgd4rKTFT
YnpEqjRm3WGFe5yQsrJb7J4ffLYa5o5R9XDD7k+WM60UbOoPjpSY7m7v0euuxBr5
DDN0N+s+Hpnayg==
=5oM/
-----END PGP SIGNATURE-----
--=-=-=--
