Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D792119B2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgGBBjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgGBBjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 21:39:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78416C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 18:39:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 13so6582244qkk.10
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 18:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gUQC8YYpwnxkEm+Ul9IJlxd+/VtpOkLtPhbw8JeMQjU=;
        b=svefvy+zIqIMNSlCkAl+TG3m7urU0d3LYdGGBggLePjKZo22WnRwrttUYGygbn6Tfj
         jtvt7nyPOjoNq7ECM/IRlMArgTkA1t83svyiWa1V0BkgChfBUNNJ8dALoj3u0Ykchk1e
         R3lZev7MUEzmklYYBg4VdhOduLSJ+Rp2CTzydrejSx4UfW9X+3csnsC5a4hwIHXdT66H
         ir/g93uZqfKEvSRRnMN/LHxzIbOe1hPbDMjrVhs/Djf0kMyWAh8EiHer3/bhXJLNAQte
         NVlVe3y0w50Yoykv944uWZts3tU2RgeXIaK+ofI80iR1QbXxhI2gvWg9XQb2eJQA3QJF
         aMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gUQC8YYpwnxkEm+Ul9IJlxd+/VtpOkLtPhbw8JeMQjU=;
        b=YG4W3mi9D1kguGadv9L45pQeOlEtn9ZYlHc6t7Uuz3Roe1zbQ5P9UiFaMzS9rvAVH0
         2OTfyficsrYWR1109NMcLOlm333CttnVi+JH344bwEi2bCsOQ76DtL49AF+wNX/GIOmR
         B3DDw3X5+V/V7nhr+JZSrnWyIs56A/wwYaXkx9AKqa9IVITVLdFhE12vaJMfRPKewi3a
         I/5QuaPl+zCtj7w/KOd1EKyv8ZnxmDZuqL0z9O/B9hclF0dJ2eOf84I+Fal79N2Pf8AD
         R+OnXcjWeZJPFjoQkhjoaX/nJ1C3bwVpaU2G7mWtm5+X87mJ5Z3hRx3kk5gzOECY12nh
         WVHw==
X-Gm-Message-State: AOAM533/goDIxPRHn4UMwLUefcg/vnUKjuE5pA2sbwWeSnHU+4yfI4WL
        JIdHXLExwz5v6jB2tpa7KQooh3qFLs702A==
X-Google-Smtp-Source: ABdhPJyB3CbNepyOuE/z4DrBwqQq0+j0/IgOcUVQR8+Tx9BL2h9Gf4IkaNsDajuTclCJS2m0wbAk95vepklqoA==
X-Received: by 2002:a0c:a992:: with SMTP id a18mr18396015qvb.211.1593653975634;
 Wed, 01 Jul 2020 18:39:35 -0700 (PDT)
Date:   Wed,  1 Jul 2020 18:39:33 -0700
Message-Id: <20200702013933.4157053-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net] tcp: md5: allow changing MD5 keys in all socket states
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This essentially reverts commit 721230326891 ("tcp: md5: reject TCP_MD5SIG
or TCP_MD5SIG_EXT on established sockets")

Mathieu reported that many vendors BGP implementations can
actually switch TCP MD5 on established flows.

Quoting Mathieu :
   Here is a list of a few network vendors along with their behavior
   with respect to TCP MD5:

   - Cisco: Allows for password to be changed, but within the hold-down
     timer (~180 seconds).
   - Juniper: When password is initially set on active connection it will
     reset, but after that any subsequent password changes no network
     resets.
   - Nokia: No notes on if they flap the tcp connection or not.
   - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
     both sides are ok with new passwords.
   - Meta-Switch: Expects the password to be set before a connection is
     attempted, but no further info on whether they reset the TCP
     connection on a change.
   - Avaya: Disable the neighbor, then set password, then re-enable.
   - Zebos: Would normally allow the change when socket connected.

We can revert my prior change because commit 9424e2e7ad93 ("tcp: md5: fix potential
overestimation of TCP option space") removed the leak of 4 kernel bytes to
the wire that was the main reason for my patch.

While doing my investigations, I found a bug when a MD5 key is changed, leading
to these commits that stable teams want to consider before backporting this revert :

 Commit 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
 Commit e6ced831ef11 ("tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers")

Fixes: 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 net/ipv4/tcp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c33f7c6aff8eea81d374644cd251bd2b96292651..861fbd84c9cf58af4126c80a27925cd6f70f300d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3246,10 +3246,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
-		if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
-			err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
-		else
-			err = -EINVAL;
+		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
 		break;
 #endif
 	case TCP_USER_TIMEOUT:
-- 
2.27.0.212.ge8ba1cc988-goog

