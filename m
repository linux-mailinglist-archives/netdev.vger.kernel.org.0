Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D123D153
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgHET6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgHEQmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:42:12 -0400
X-Greylist: delayed 574 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Aug 2020 05:40:14 PDT
Received: from magratgarlick.emantor.de (magratgarlick.emantor.de [IPv6:2a01:4f8:c17:c88::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F570C034603;
        Wed,  5 Aug 2020 05:40:10 -0700 (PDT)
Received: by magratgarlick.emantor.de (Postfix, from userid 114)
        id 4C73A10D01B; Wed,  5 Aug 2020 14:25:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        magratgarlick.emantor.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (200116b828fb3e0270a11fb9006029e2.dip.versatel-1u1.de [IPv6:2001:16b8:28fb:3e02:70a1:1fb9:60:29e2])
        by magratgarlick.emantor.de (Postfix) with ESMTPSA id BC6D710D014;
        Wed,  5 Aug 2020 14:25:30 +0200 (CEST)
From:   Rouven Czerwinski <r.czerwinski@pengutronix.de>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: tls: allow MSG_CMSG_COMPAT in sendmsg
Date:   Wed,  5 Aug 2020 14:25:04 +0200
Message-Id: <20200805122501.4856-2-r.czerwinski@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805122501.4856-1-r.czerwinski@pengutronix.de>
References: <20200805122501.4856-1-r.czerwinski@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MSG_CMSG_COMPAT flag is valid if the system has CONFIG_COMPAT
enabled and a 32bit userspace.

Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
---
 net/tls/tls_sw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 24f64bc0de18..a332ae123bda 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -935,7 +935,8 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int ret = 0;
 	int pending;
 
-	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&tls_ctx->tx_lock);
-- 
2.27.0

