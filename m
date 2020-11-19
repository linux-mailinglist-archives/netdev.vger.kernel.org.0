Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B942B973B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgKSQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:00:01 -0500
Received: from novek.ru ([213.148.174.62]:49806 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgKSQAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:00:00 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 328DF501633;
        Thu, 19 Nov 2020 19:00:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 328DF501633
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605801611; bh=PWOOev45B7uKHeOlynqpTFh/CdCdx1xhWqg6fz5SgQo=;
        h=From:To:Cc:Subject:Date:From;
        b=mp3kOKsOLuaX/F+AoadAUAtDAtad36s2dp2YvZ03+vK7v81y3DU5ALYiOTBLWeqUh
         fc80TGgZ5IwSl1V8Iwv9FR8VmlWBF3u0lXxTcCKYUDseS2/vpc+qroHOUwYRG4n6/x
         +0BwEeRk/DIsm6RVmucb4BqyA8hu8OdWuznZSIX8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net v3] net/tls: missing received data after fast remote close
Date:   Thu, 19 Nov 2020 18:59:48 +0300
Message-Id: <1605801588-12236-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case when tcp socket received FIN after some data and the
parser haven't started before reading data caller will receive
an empty buffer. This behavior differs from plain TCP socket and
leads to special treating in user-space.
The flow that triggers the race is simple. Server sends small
amount of data right after the connection is configured to use TLS
and closes the connection. In this case receiver sees TLS Handshake
data, configures TLS socket right after Change Cipher Spec record.
While the configuration is in process, TCP socket receives small
Application Data record, Encrypted Alert record and FIN packet. So
the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
SK_DONE bit set. The received data is not parsed upon arrival and is
never sent to user-space.

Patch unpauses parser directly if we have unparsed data in tcp
receive queue.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2fe9e2c..845c628 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1295,6 +1295,12 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 			return NULL;
 		}
 
+		if (!skb_queue_empty(&sk->sk_receive_queue)) {
+			__strp_unpause(&ctx->strp);
+			if (ctx->recv_pkt)
+				return ctx->recv_pkt;
+		}
+
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return NULL;
 
-- 
1.8.3.1

