Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7903C23D705
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 08:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgHFGuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 02:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgHFGuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 02:50:23 -0400
Received: from magratgarlick.emantor.de (magratgarlick.emantor.de [IPv6:2a01:4f8:c17:c88::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C8C061574;
        Wed,  5 Aug 2020 23:50:22 -0700 (PDT)
Received: by magratgarlick.emantor.de (Postfix, from userid 114)
        id D7DC510C96B; Thu,  6 Aug 2020 08:50:14 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        magratgarlick.emantor.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (200116b82871d502e89ff5a9718d1cab.dip.versatel-1u1.de [IPv6:2001:16b8:2871:d502:e89f:f5a9:718d:1cab])
        by magratgarlick.emantor.de (Postfix) with ESMTPSA id 84D9410C5FB;
        Thu,  6 Aug 2020 08:50:11 +0200 (CEST)
From:   Rouven Czerwinski <r.czerwinski@pengutronix.de>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kernel@pengutronix.de,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net/tls: allow MSG_CMSG_COMPAT in sendmsg
Date:   Thu,  6 Aug 2020 08:49:06 +0200
Message-Id: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to use ktls on a system with 32-bit userspace and 64-bit kernel
results in a EOPNOTSUPP message during sendmsg:

  setsockopt(3, SOL_TLS, TLS_TX, …, 40) = 0
  sendmsg(3, …, msg_flags=0}, 0) = -1 EOPNOTSUPP (Operation not supported)

The tls_sw implementation does strict flag checking and does not allow
the MSG_CMSG_COMPAT flag, which is set if the message comes in through
the compat syscall.

This patch adds MSG_CMSG_COMPAT to the flag check to allow the usage of
the TLS SW implementation on systems using the compat syscall path.

Note that the same check is present in the sendmsg path for the TLS
device implementation, however the flag hasn't been added there for lack
of testing hardware.

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

base-commit: c1055b76ad00aed0e8b79417080f212d736246b6
-- 
2.27.0

