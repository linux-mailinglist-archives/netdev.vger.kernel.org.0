Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604BF1B94E2
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 03:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgD0BTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 21:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgD0BTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 21:19:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C98FC061A10
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 18:19:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h129so9841510ybc.3
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 18:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZxZOP+BlgtNuGg0nLTAk7RNFW1EfvAUNqQrCzJ2M174=;
        b=Pn9KmwJCoLA/dAchSkMRxbyxs8b1dK8xEXy263G1uF91hIvoLjjMcGCi2rgbYZ4153
         LipfNqOQsQWd8CtMS46GiHqNnLktOJzAvgUHFYd8NOlxXd5VFpzL+CnYMk4cdrnMBhDR
         6xwGwZiRG2qsNYkIukVRe+k5nVg7KxNV3x+vRCaLEMqf4szLkt+K6NL51w18IWzSMF1I
         V76F3TmNJHpaZcV1QPkGMRADMOnyi4CaynWjWKFuJXeUFvvg4xDCpUzrE3sUZN+gtVAZ
         MU1rOyy96e67xlNM8ucl2UDr3PZSJO4AFgUlz2uLzrbR2iuxCN41x6B93+XXjFhR7Nt4
         PK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZxZOP+BlgtNuGg0nLTAk7RNFW1EfvAUNqQrCzJ2M174=;
        b=l1wkAAZdUR2zVDpzCWHyZTsgb8mgaPBkB03XnPuaDUCj5UV+adL0+FuUEfGjPUo6oL
         0ZxLJnK0zdI2fZoQ34xDeIu9+hKcsFlXFyPl58uc26roD9SbhVq6AH6DBYNOBA6dtmfp
         6nLIV9+AoUNpfpld4qLcKW3ckJRRcOwvx47LIIzfSgFG2gRKGSbxA0FqSXLix2Evf8vw
         juT3KYk6UpZWFtlAwW2z/jvpK08tHVUHlvGJ2GVV0EN4bO+5VvBt/jKDsaNa5OjsfAEv
         tj7P9hDQtrgp4MxfqMxEzugzUlPKpwNuM32gwIn1p7a0ae6Sx7Pnk81hyS1iy1iZ6XE2
         UH9A==
X-Gm-Message-State: AGi0PubbNytHkqoavPkUyz5643icwepJjSMWGdqRoXJ1p13lYtcZOXWQ
        K19ro0eiYbUnS8GX6SzsxK5f9Am8/X4wJw==
X-Google-Smtp-Source: APiQypKfbYWIH7o4XSxXboLuE+Ts61HZTar6l76APRQCIJ464RmvhQcNab2nDRkFue1Pu1eqbU7xzNehaMRYTw==
X-Received: by 2002:a25:afd0:: with SMTP id d16mr33849077ybj.441.1587950350624;
 Sun, 26 Apr 2020 18:19:10 -0700 (PDT)
Date:   Sun, 26 Apr 2020 18:19:07 -0700
Message-Id: <20200427011907.160247-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net] sch_sfq: validate silly quantum values
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to set up sfq so that q->scaled_quantum was zero,
triggering an infinite loop in sfq_dequeue()

More generally, we must only accept quantum between 1 and 2^18 - 7,
meaning scaled_quantum must be in [1, 0x7FFF] range.

Otherwise, we also could have a loop in sfq_dequeue()
if scaled_quantum happens to be 0x8000, since slot->allot
could indefinitely switch between 0 and 0x8000.

Fixes: eeaeb068f139 ("sch_sfq: allow big packets and be fair")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/sched/sch_sfq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index c787d4d46017b4b41b8eb6d41f2b0a44560ff5bf..5a6def5e4e6df2e7b66c88aa877c7318270d48be 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -637,6 +637,15 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	if (ctl->divisor &&
 	    (!is_power_of_2(ctl->divisor) || ctl->divisor > 65536))
 		return -EINVAL;
+
+	/* slot->allot is a short, make sure quantum is not too big. */
+	if (ctl->quantum) {
+		unsigned int scaled = SFQ_ALLOT_SIZE(ctl->quantum);
+
+		if (scaled <= 0 || scaled > SHRT_MAX)
+			return -EINVAL;
+	}
+
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
 					ctl_v1->Wlog))
 		return -EINVAL;
-- 
2.26.2.303.gf8c07b1a785-goog

