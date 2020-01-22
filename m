Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F7145F42
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVXmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:42:33 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36653 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:42:32 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so313940pjb.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRm1capTgZQGh1d9fhFaNGFYKROBRUsvaby6BKtEmWQ=;
        b=d3UvMFJwHrqo8cymGybBWeh46XGRf5PCYZfBi/3ksl1legpV5v20TWVNDhwfIUBBDT
         bSG87Xn0UFkcZqy0ToI7IvKUK3ckbAZCclL6riEDQ98/z625YYHp+pTwHX09/Wi5NfSF
         cZG+nMPuDNqqNSCtimIu0jZ5neMm5Wj4tuVawdQ5x2kzFBVetaPbuTIzp9w8XBF4sUeo
         DVmgdV8htHv9sRAkA1nq4y7rTgot8mKcY0h0oIHgQQ8/ClGk0S/S0owbQBhTMeHeBr2k
         1usDKD8hCAbpwplTAaIEtwx0ROoL2uBCWPVpjiZ+qG11ei+yEr2JNvkc2zgrzZNII3og
         DlsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRm1capTgZQGh1d9fhFaNGFYKROBRUsvaby6BKtEmWQ=;
        b=uCi0tX+1l5EaseYTIVNx+QFN/e0yztAGVbIydpoDPnBkEIYwknOOETh/+YbtHCjIMW
         7pX5KftO27ykSP/ln9q6M23OiAa7iHWa5ORLFQjQgbLFB0D+6oBrOfHJlhIwR7pbS0m2
         kLYA5pMijPlm//obP+EbRcELLGPqShaR99I6/Kkc+RFBaP42Sj0htVV9VTJQZYw03tvP
         L3GHTpeEPddgRoJ7938epvSrtv9TsQDuVINz0cEYeBOw4tz+YORxzay4CjX5zUpFTq6r
         wPUiV2AtaqtNqHLgkY94sE9Pf7ZknGOlpjGzPvluWtMViEZKrMeUWLheElFieYFwYL4t
         +S0A==
X-Gm-Message-State: APjAAAXgO0N8vQol3ue6/mGvF6k4y7/YlX8MUKNy5F7POsoVaeryDLz1
        rqGHuTq8ASgQ0mWh2aonccn+EXdxRmY=
X-Google-Smtp-Source: APXvYqwSUTWYc0/h86V5pYOpqI5JOtdN/DQQg5SOeHs8WxEu07JQ95hT2vq2auR2hlubwyjOXDQ/iQ==
X-Received: by 2002:a17:90a:ac0f:: with SMTP id o15mr1079461pjq.133.1579736551684;
        Wed, 22 Jan 2020 15:42:31 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id h6sm36576pfo.175.2020.01.22.15.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 15:42:31 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com,
        syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [Patch net] net_sched: fix datalen for ematch
Date:   Wed, 22 Jan 2020 15:42:02 -0800
Message-Id: <20200122234203.15441-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported an out-of-bound access in em_nbyte. As initially
analyzed by Eric, this is because em_nbyte sets its own em->datalen
in em_nbyte_change() other than the one specified by user, but this
value gets overwritten later by its caller tcf_em_validate().
We should leave em->datalen untouched to respect their choices.

I audit all the in-tree ematch users, all of those implement
->change() set em->datalen, so we can just avoid setting it twice
in this case.

Reported-and-tested-by: syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com
Reported-by: syzbot+2f07903a5b05e7f36410@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/ematch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index 8f2ad706784d..d0140a92694a 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -263,12 +263,12 @@ static int tcf_em_validate(struct tcf_proto *tp,
 				}
 				em->data = (unsigned long) v;
 			}
+			em->datalen = data_len;
 		}
 	}
 
 	em->matchid = em_hdr->matchid;
 	em->flags = em_hdr->flags;
-	em->datalen = data_len;
 	em->net = net;
 
 	err = 0;
-- 
2.21.1

