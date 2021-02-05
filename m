Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C463114D7
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhBEWQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:16:16 -0500
Received: from mout.gmx.net ([212.227.17.21]:40779 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhBEOdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612541460;
        bh=JGYpDFHhSo4g9ugoufYI2NGUUGVLEggpA79m09ijH8M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=BSOiwWJZJD06yMPMjHmTgd8uAx30gAYDZLbwxLbY6KkMeXvnQelN8fa6m8UAMHiaH
         tEOJ118nyJnCzRvU7baqVOmh+ZSed6NS351aGkkDYuYfGX7Cl854MkgrcJoQ7XzzSV
         j+SvwYG03fbP2M1iOF/UaPOzW2wpqOgSqauhG6Kk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.123.206.138] ([87.123.206.138]) by web-mail.gmx.net
 (3c-app-gmx-bap12.server.lan [172.19.172.82]) (via HTTP); Fri, 5 Feb 2021
 15:25:17 +0100
MIME-Version: 1.0
Message-ID: <trinity-c2d6cede-bfb1-44e2-85af-1fbc7f541715-1612535117028@3c-app-gmx-bap12>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     sgarzare@redhat.com, alex.popov@linux.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/vmw_vsock: fix NULL pointer dereference
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 5 Feb 2021 15:25:17 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:HbQum5ZtedpsDyKZ2Rn4ubS1eAn1IHLXc1ch1/xQUAyZ/cTLAkDyJB0VQNwHxOpe23Ma+
 3YGvJ2i86CPcBaBqkQOdXezozMsDyOhEO0Tq8NM3mmyzjBjmkmF+8Hai9NBGglz6ob6hTB3jp6wR
 HMa63jBVZ8V59Qn6oI46cz+iQi873E1RutV0MF9JZTIvpfqCaT2t5mbeu7ZiaXmM3c4E+sc9FnfS
 ZmqFLuyYB7JTrUQTvaFXo9ri9iUe9RzcX4MHJR2zI+45JFSiLXO36S2wbHQU0T0NVN/ozt/XTX2O
 TA=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5GSD1l7eiag=:bSjbnb2PxchdaQivwBJrIw
 QIbwsWn596xjrRETKl5d3xZkXRm83khSEnbriWTv57fVehWV6Q8fe7hEbsnZ6cVj5006dXy/j
 walkK5gVN6d4bXW2rTT1W4sJLfH7SSFAodDSOAsLcYtwcocWXpbNrxNdgaHVVBdfqlQCAOeiz
 T64jMMpMCHyr2C9B5/1qyxG9jMTjoZmojOAsHhW2LWZH+zw6K8Mn/TFFq37iz36kbwoom1hHb
 cz4gQswgNCDc1VQN3pJt9PaKsIXEUDHwlYcVcdSGYt/9+0RJXIVq+Ud1QNdFNxDXCX58m4W6p
 gaU/2dPZbdSbYKV028vycYCvsBts8TQXjTiUvblOgwa2MbtZJsyKqFuUoymj8HwcJ8GZ51zMn
 OVc3z+/fJtzuojRvOEr7VXsWZf+NxKf5W9Zzmjc+NSbzVIfSfJ3EMAwsYHI4YzXg2ayW9F5q/
 XBZ+mMKl3uDTgthDXasmmQ6VbT01Ez3FCXdTqy0p/FSZnoE7scQs5htWOGNDH19u4EWMWHVze
 nHX0OeBOc76X8NVT6HsgZUj+65C/6L0P93c57FFkOkSQb8pt/8o6+HL5LETbEeTjmNAfGWLVj
 qldUxBGNJsNag=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>
Date: Fri, 5 Feb 2021 13:12:06 +0100
Subject: [PATCH] net/vmw_vsock: fix NULL pointer dereference

In vsock_stream_connect(), a thread will enter schedule_timeout().
While being scheduled out, another thread can enter vsock_stream_connect()
as well and set vsk->transport to NULL. In case a signal was sent, the
first thread can leave schedule_timeout() and vsock_transport_cancel_pkt()
will be called right after. Inside vsock_transport_cancel_pkt(), a null
dereference will happen on transport->cancel_pkt.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
=2D--
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 6894f21dc147..cb81cfb47a78 100644
=2D-- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1233,7 +1233,7 @@ static int vsock_transport_cancel_pkt(struct vsock_s=
ock *vsk)
 {
 	const struct vsock_transport *transport =3D vsk->transport;

-	if (!transport->cancel_pkt)
+	if (!transport || !transport->cancel_pkt)
 		return -EOPNOTSUPP;

 	return transport->cancel_pkt(vsk);
=2D-
2.30.0
