Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F32845A2
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgJFFqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:46:12 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:17110 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgJFFqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:46:12 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kPfnY-000SEu-CY; Tue, 06 Oct 2020 07:46:04 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kPfnW-000Mbe-W8; Tue, 06 Oct 2020 07:46:03 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1BC4824004B;
        Tue,  6 Oct 2020 07:46:02 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 0919E240047;
        Tue,  6 Oct 2020 07:46:02 +0200 (CEST)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id 85F5420370;
        Tue,  6 Oct 2020 07:46:01 +0200 (CEST)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, xiyuyang19@fudan.edu.cn
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH v2] net/x25: Fix null-ptr-deref in x25_connect
Date:   Tue,  6 Oct 2020 07:45:57 +0200
Message-ID: <20201006054558.19453-1-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate: clean
X-purgate-ID: 151534::1601963163-00014AFE-2FCB7BA5/0/0
X-purgate-type: clean
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

Change from v1:
also handle interrupting signals correctly

---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 0bbb283f23c9..046d3fee66a9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -825,7 +825,7 @@ static int x25_connect(struct socket *sock, struct so=
ckaddr *uaddr,
 	sock->state =3D SS_CONNECTED;
 	rc =3D 0;
 out_put_neigh:
-	if (rc) {
+	if (rc && x25->neighbour) {
 		read_lock_bh(&x25_list_lock);
 		x25_neigh_put(x25->neighbour);
 		x25->neighbour =3D NULL;
--=20
2.20.1

