Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7653BE5B0
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhGGJho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhGGJhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:37:43 -0400
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Jul 2021 02:35:04 PDT
Received: from smtp.gentoo.org (dev.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209CBC061574;
        Wed,  7 Jul 2021 02:35:04 -0700 (PDT)
Received: by sf.home (Postfix, from userid 1000)
        id 52CD42EEC616; Wed,  7 Jul 2021 10:27:41 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH] net: core: fix SO_TIMESTAMP_* option setting
Date:   Wed,  7 Jul 2021 10:27:31 +0100
Message-Id: <20210707092731.2499-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed the problem as a systemd-timesyncd (and ntpsec) sync failures:

    systemd-timesyncd[586]: Timed out waiting for reply from ...
    systemd-timesyncd[586]: Invalid packet timestamp.

Bisected it down to commit 371087aa476
("sock: expose so_timestamp options for mptcp").

The commit should be a no-op but it accidentally reordered option type
and option value:

    +void sock_set_timestamp(struct sock *sk, int optname, bool valbool);
    ...
    -     __sock_set_timestamps(sk, valbool, true, true);
    +     sock_set_timestamp(sk, valbool, optname);

Tested the fix on systemd-timesyncd. The sync failures went away.

CC: Paolo Abeni <pabeni@redhat.com>
CC: Florian Westphal <fw@strlen.de>
CC: Mat Martineau <mathew.j.martineau@linux.intel.com>
CC: David S. Miller <davem@davemloft.net>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index ba1c0f75cd45..060892372ac5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1068,7 +1068,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_TIMESTAMP_NEW:
 	case SO_TIMESTAMPNS_OLD:
 	case SO_TIMESTAMPNS_NEW:
-		sock_set_timestamp(sk, valbool, optname);
+		sock_set_timestamp(sk, optname, valbool);
 		break;
 
 	case SO_TIMESTAMPING_NEW:
-- 
2.32.0

