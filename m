Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 363AA2C8A4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfE1OY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:24:59 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:37090 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfE1OYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:24:44 -0400
Received: from ramsan ([84.194.111.163])
        by xavier.telenet-ops.be with bizsmtp
        id HqQS2000L3XaVaC01qQSyd; Tue, 28 May 2019 16:24:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00058J-3j; Tue, 28 May 2019 16:24:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00057Q-26; Tue, 28 May 2019 16:24:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/5] rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
Date:   Tue, 28 May 2019 16:24:21 +0200
Message-Id: <20190528142424.19626-3-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528142424.19626-1-geert@linux-m68k.org>
References: <20190528142424.19626-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With gcc 4.1:

    net/rxrpc/output.c: In function ‘rxrpc_send_data_packet’:
    net/rxrpc/output.c:338: warning: ‘ret’ may be used uninitialized in this function

Indeed, if the first jump to the send_fragmentable label is made, and
the address family is not handled in the switch() statement, ret will be
used uninitialized.

Fix this by initializing err to zero before the jump, like is already
done for the jump to the done label.

Fixes: 5a924b8951f835b5 ("rxrpc: Don't store the rxrpc header in the Tx queue sk_buffs")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
While this is not a real false-positive, I believe it cannot cause harm
in practice, as AF_RXRPC cannot be used with other transport families
than IPv4 and IPv6.
---
 net/rxrpc/output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 004c762c2e8d063c..1473d774d67100c5 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -403,8 +403,10 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 
 	/* send the packet with the don't fragment bit set if we currently
 	 * think it's small enough */
-	if (iov[1].iov_len >= call->peer->maxdata)
+	if (iov[1].iov_len >= call->peer->maxdata) {
+		ret = 0;
 		goto send_fragmentable;
+	}
 
 	down_read(&conn->params.local->defrag_sem);
 
-- 
2.17.1

