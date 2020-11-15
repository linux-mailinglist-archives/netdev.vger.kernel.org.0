Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F462B321B
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 05:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKOEQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 23:16:16 -0500
Received: from novek.ru ([213.148.174.62]:39138 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgKOEQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 23:16:16 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id F23955010FE;
        Sun, 15 Nov 2020 07:16:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru F23955010FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605413781; bh=7h+mctl9RC+hvOoZDcuzFUCrdJWeJ3LyZ5pfzIdinNQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XsIL0vPEOkGzCzUg0BQQWiG6OQsE3DLKSM/XUGcAyTt4C2eqVoMwwyxrrh7iFr0LF
         RgtLZQ7K4+DN+nV7K2OA7g7mH0CZNfTRFO2KxWqZdiE7uXQWaHJhMAr6pRcm502TDh
         8Uz/cdCTftVctKQ5iHETgXMIqBAeEnpHnI0Y5TRc=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net v2] net/tls: fix corrupted data in recvmsg
Date:   Sun, 15 Nov 2020 07:16:00 +0300
Message-Id: <1605413760-21153-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tcp socket has more data than Encrypted Handshake Message then
tls_sw_recvmsg will try to decrypt next record instead of returning
full control message to userspace as mentioned in comment. The next
message - usually Application Data - gets corrupted because it uses
zero copy for decryption that's why the data is not stored in skb
for next iteration. Revert check to not decrypt next record if
current is not Application Data.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 95ab5545..2fe9e2c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1913,7 +1913,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			 * another message type
 			 */
 			msg->msg_flags |= MSG_EOR;
-			if (ctx->control != TLS_RECORD_TYPE_DATA)
+			if (control != TLS_RECORD_TYPE_DATA)
 				goto recv_end;
 		} else {
 			break;
-- 
1.8.3.1

