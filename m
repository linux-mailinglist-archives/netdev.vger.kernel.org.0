Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92EC6A1703
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBXHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXHWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:22:53 -0500
X-Greylist: delayed 243 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 23:22:50 PST
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EEF40D2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 23:22:50 -0800 (PST)
Received: from [2a02:169:59c5:0:3123:be7a:793e:68c4] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1pVSLq-003lG3-JC; Fri, 24 Feb 2023 08:18:42 +0100
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1pVSLS-0005Ot-1N;
        Fri, 24 Feb 2023 08:18:18 +0100
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
Date:   Fri, 24 Feb 2023 08:17:46 +0100
Message-Id: <20230224071745.20717-1-equinox@diac24.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

packet_recvmsg() whitelists a bunch of MSG_* flags, which notably does
not include MSG_NOSIGNAL.  Unfortunately, io_uring always sets
MSG_NOSIGNAL, meaning AF_PACKET sockets can't be used in io_uring
recvmsg().

As AF_PACKET sockets never generate SIGPIPE to begin with, MSG_NOSIGNAL
is a no-op and can simply be ignored.

Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4e76e2ae153..67c0a57e6dd8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3410,7 +3410,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	unsigned int origlen = 0;
 
 	err = -EINVAL;
-	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
+	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE|MSG_NOSIGNAL))
 		goto out;
 
 #if 0
-- 
2.39.2

