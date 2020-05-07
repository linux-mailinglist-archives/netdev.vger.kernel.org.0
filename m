Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2B1C9716
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEGRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGRFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:05:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB88C05BD09
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 10:05:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 186so7817335ybq.1
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 10:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vjTiu29M15StubE1nGsA0nW9WroMOMJ/jE35AzB2EX8=;
        b=t+ZVa8QhcKvIhHWLbm4/jAsy5D+VeUPwfM3p8zC2LOJo3lerwjO0svPlDvoSwGAYbL
         lDVGJMqPauhPOYJkmEeYTkM3dWD7OtNlqqnLpFpONT7F6aSF66dG/LpfkUFXK2XtreT7
         /avZIim9+7+BMecispZAfeQmFjlB81W0cEiSXKxmf2ghC4ycOu45vGvv7jdv4R6+/ul+
         krUgRiwaU+SjKdCzWZw5216A5Y2ASsH5PN3+1ZU1dfK1/A/at9lpKyD2zxMTAFr1h9xW
         GI1G3D2J8pg5dwdw32zpVIE+biyOQwIBxih0N08V5rnu9IturTonirCO7mpnZjNPwoL2
         6jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vjTiu29M15StubE1nGsA0nW9WroMOMJ/jE35AzB2EX8=;
        b=shkQZzdjlNcRDgiiAk5AmsmT1wVu5KMFv7vEmV7Bl+wqt8dFnKf6cIPYTRc/0xyY4c
         GMaYKa+gzoqfKbVmc3vjg9UCLhvnJy5aehVekCYIe/DCo4bBIogSXbnHR0fx0BJFL9PN
         5CVafFpk/6yI/yzdp6jhCzsYiwHunzHJczF66+mQZM3yyM6MCbSaKYhOWmSFrsBXwNe1
         MINNdPK2ZRyC9kRTwrsQm3WQDC5fbn6F8CVAuuQJgiPV6qvf+Y3yYfuBZ7xqAb05zCxA
         VFJVW/lpJe358lWMJ09PnX2ryI0m7XhacwLr8xe+TZdi62K5paDnmekwbwLLPOPPbupW
         Xsmg==
X-Gm-Message-State: AGi0Pub8pX6ML7jI/MK8NUTLNk4Mq1zWR7I247JzXept3uUkEsYMkTbr
        29PBSZyFANWB6CJool8wT7fsAdtBerJakQ==
X-Google-Smtp-Source: APiQypKSFqMppMKAh38IqoGKqow7bgAup4a8YmZhuhKNA0Zw+XHJ9cTSL9H4aYA81ubfnyF8nno0oJt4/FFpiA==
X-Received: by 2002:a5b:44d:: with SMTP id s13mr13381940ybp.414.1588871142831;
 Thu, 07 May 2020 10:05:42 -0700 (PDT)
Date:   Thu,  7 May 2020 10:05:39 -0700
Message-Id: <20200507170539.157454-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next] net: relax SO_TXTIME CAP_NET_ADMIN check
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now sch_fq has horizon feature, we want to allow QUIC/UDP applications
to use EDT model so that pacing can be offloaded to the kernel (sch_fq)
or the NIC.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/core/sock.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index b714162213aeae98bfee24d8b457547fe7abab4f..fd85e651ce284b6987f0e8fae94f76ec2c432899 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1152,23 +1152,31 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TXTIME:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
-			ret = -EPERM;
-		} else if (optlen != sizeof(struct sock_txtime)) {
+		if (optlen != sizeof(struct sock_txtime)) {
 			ret = -EINVAL;
+			break;
 		} else if (copy_from_user(&sk_txtime, optval,
 			   sizeof(struct sock_txtime))) {
 			ret = -EFAULT;
+			break;
 		} else if (sk_txtime.flags & ~SOF_TXTIME_FLAGS_MASK) {
 			ret = -EINVAL;
-		} else {
-			sock_valbool_flag(sk, SOCK_TXTIME, true);
-			sk->sk_clockid = sk_txtime.clockid;
-			sk->sk_txtime_deadline_mode =
-				!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
-			sk->sk_txtime_report_errors =
-				!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
+			break;
 		}
+		/* CLOCK_MONOTONIC is only used by sch_fq, and this packet
+		 * scheduler has enough safe guards.
+		 */
+		if (sk_txtime.clockid != CLOCK_MONOTONIC &&
+		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
+		sock_valbool_flag(sk, SOCK_TXTIME, true);
+		sk->sk_clockid = sk_txtime.clockid;
+		sk->sk_txtime_deadline_mode =
+			!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
+		sk->sk_txtime_report_errors =
+			!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
 		break;
 
 	case SO_BINDTOIFINDEX:
-- 
2.26.2.526.g744177e7f7-goog

