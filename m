Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12A44A534A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiAaXeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiAaXeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:34:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91664C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 15:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D729060C20
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 23:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004FCC340E8;
        Mon, 31 Jan 2022 23:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643672043;
        bh=AN1BJv/Q0Otv3fJDu3WXU2qjq4k7+D5iDka9zvIs3B4=;
        h=From:To:Cc:Subject:Date:From;
        b=NcvbkCTdIrOfGTQBndQeWxAYOfs3dmeI5zOQtts3uK+P4cN6pwf7JZt5b0JO0HJu6
         sYiYiPUCWHIdktQ1TjOr5jXzSUAtuvI+vKA6h/8V7tXlP/lxVBJSWdAwZsczCNJLU+
         onp9nhJ1nZkfdBhaxfi0m7gvDQ6HxPA8LkD2fZqG2td0c63N3cTBgqmp8JJxdek3ao
         TKHI+2b/SKhGWNvF6IiS8d1CrUKd8Xj0paEzHg1hk3H9CJFsPgHHFicCgaBM2kbB8M
         bw67gLLVdz5/J98694DND9NfQsdd9mNlgw6dGpxCeTpYBWbB8mxJSEzqYH3Gq+/xdS
         BR8HOXdxbeFdQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, maze@google.com
Subject: [PATCH net-next] net: allow SO_MARK with CAP_NET_RAW via cmsg
Date:   Mon, 31 Jan 2022 15:33:57 -0800
Message-Id: <20220131233357.52964-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's not reason SO_MARK would be allowed via setsockopt()
and not via cmsg, let's keep the two consistent. See
commit 079925cce1d0 ("net: allow SO_MARK with CAP_NET_RAW")
for justification why NET_RAW -> SO_MARK is safe.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: maze@google.com
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index d6804685f17f..09d31a7dc68f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2625,7 +2625,8 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 
 	switch (cmsg->cmsg_type) {
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
+		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
-- 
2.34.1

