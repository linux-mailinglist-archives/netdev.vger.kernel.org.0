Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECFE4F5F6F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiDFN3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbiDFN2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:28:01 -0400
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [IPv6:2a01:e0c:1:1599::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE55A1BE116;
        Wed,  6 Apr 2022 03:25:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a01:e35:39f2:1220:b493:280e:6d0b:57ec])
        by smtp1-g21.free.fr (Postfix) with ESMTPS id 6577AB0052C;
        Wed,  6 Apr 2022 12:22:18 +0200 (CEST)
From:   Yann Droneaud <ydroneaud@opteya.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] af_unix: Escape abstract unix socket address
Date:   Wed,  6 Apr 2022 12:22:13 +0200
Message-Id: <20220406102213.2020784-1-ydroneaud@opteya.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract unix socket address are bytes sequences up to
108 bytes (UNIX_PATH_MAX == sizeof(struct sockaddr_un) -
offsetof(struct sockaddr_un, sun_path)).

As with any random string of bytes, printing them in
/proc/net/unix should be done with caution to prevent
misbehavior.

It would have been great to use seq_escape_mem() to escape
the control characters in a reversible way.

Unfortunately userspace might expect that NUL bytes are
replaced with '@' characters as it's done currently.

So this patch implements the following scheme: any control
characters, including NUL, in the abstract unix socket
addresses is replaced by '@' characters.

Sadly, with such non reversible escape scheme, abstract
addresses such as "\0\0", "\0\a", "\0\b", "\0\t", etc.
will have the same representation: "@@".

But will prevent "cat /proc/net/unix" from messing with
terminal, and will prevent "\n" in abstract address from
messing with parsing the list of Unix sockets.

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 net/unix/af_unix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e71a312faa1e..8021efd92301 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3340,7 +3340,8 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 				i++;
 			}
 			for ( ; i < len; i++)
-				seq_putc(seq, u->addr->name->sun_path[i] ?:
+				seq_putc(seq, !iscntrl(u->addr->name->sun_path[i]) ?
+					 u->addr->name->sun_path[i] :
 					 '@');
 		}
 		unix_state_unlock(s);
-- 
2.32.0

