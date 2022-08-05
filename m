Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D158A5FC
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 08:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiHEGlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 02:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiHEGlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 02:41:25 -0400
X-Greylist: delayed 1369 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 Aug 2022 23:41:23 PDT
Received: from mxout70.expurgate.net (mxout70.expurgate.net [194.37.255.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EC8193C9;
        Thu,  4 Aug 2022 23:41:23 -0700 (PDT)
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <prvs=1230fa8b07=ms@dev.tdt.de>)
        id 1oJqfF-000L0w-30; Fri, 05 Aug 2022 08:18:29 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1oJqfE-000D8k-28; Fri, 05 Aug 2022 08:18:28 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id A0153240049;
        Fri,  5 Aug 2022 08:18:27 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 2E793240040;
        Fri,  5 Aug 2022 08:18:27 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id AADA028738;
        Fri,  5 Aug 2022 08:18:26 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net] net/x25: fix call timeouts in blocking connects
Date:   Fri,  5 Aug 2022 08:18:10 +0200
Message-ID: <20220805061810.10824-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1659680308-95942F7B-D01DC08B/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a userspace application starts a blocking connect(), a CALL REQUEST
is sent, the t21 timer is started and the connect is waiting in
x25_wait_for_connection_establishment(). If then for some reason the t21
timer expires before any reaction on the assigned logical channel (e.g.
CALL ACCEPT, CLEAR REQUEST), there is sent a CLEAR REQUEST and timer
t23 is started waiting for a CLEAR confirmation. If we now receive a
CLEAR CONFIRMATION from the peer, x25_disconnect() is called in
x25_state2_machine() with reason "0", which means "normal" call
clearing. This is ok, but the parameter "reason" is used as sk->sk_err
in x25_disconnect() and sock_error(sk) is evaluated in
x25_wait_for_connection_establishment() to check if the call is still
pending. As "0" is not rated as an error, the connect will stuck here
forever.

To fix this situation, also check if the sk->sk_state changed form
TCP_SYN_SENT to TCP_CLOSE in the meantime, which is also done by
x25_disconnect().

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 6bc2ac8d8146..3b55502b2965 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -719,6 +719,11 @@ static int x25_wait_for_connection_establishment(str=
uct sock *sk)
 			sk->sk_socket->state =3D SS_UNCONNECTED;
 			break;
 		}
+		rc =3D -ENOTCONN;
+		if (sk->sk_state =3D=3D TCP_CLOSE) {
+			sk->sk_socket->state =3D SS_UNCONNECTED;
+			break;
+		}
 		rc =3D 0;
 		if (sk->sk_state !=3D TCP_ESTABLISHED) {
 			release_sock(sk);
--=20
2.20.1

