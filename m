Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C579E27AACD
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgI1Jdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:33:31 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:58863 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgI1Jda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:33:30 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 05:33:29 EDT
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kMpNh-000F2i-OQ; Mon, 28 Sep 2020 11:23:37 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kMpNf-000PNk-Qc; Mon, 28 Sep 2020 11:23:35 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 826B124004B;
        Mon, 28 Sep 2020 11:23:35 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 7495E240047;
        Mon, 28 Sep 2020 11:23:35 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 0EF50203F4;
        Mon, 28 Sep 2020 09:23:35 +0000 (UTC)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, xiyuyang19@fudan.edu.cn
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH] net/x25: Fix null-ptr-deref in x25_connect
Date:   Mon, 28 Sep 2020 11:23:27 +0200
Message-ID: <20200928092327.329-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-type: clean
X-purgate-ID: 151534::1601285016-000039ED-7D6A29AC/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a regression for blocking connects introduced by commit
4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect").

The x25->neighbour is already set to "NULL" by x25_disconnect() now,
while a blocking connect is waiting in
x25_wait_for_connection_establishment(). Therefore x25->neighbour must
not be accessed here again and x25->state is also already set to
X25_STATE_0 by x25_disconnect().

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconn=
ect")
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 0bbb283f23c9..0524a5530b91 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -820,7 +820,7 @@ static int x25_connect(struct socket *sock, struct so=
ckaddr *uaddr,
=20
 	rc =3D x25_wait_for_connection_establishment(sk);
 	if (rc)
-		goto out_put_neigh;
+		goto out;
=20
 	sock->state =3D SS_CONNECTED;
 	rc =3D 0;
--=20
2.20.1

