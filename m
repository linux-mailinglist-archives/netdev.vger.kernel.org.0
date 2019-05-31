Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6869C31289
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfEaQh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:37:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42011 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfEaQh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:37:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so1585599qtk.9
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 09:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IB1CcVLA+id0oymPNYSnxcg3RQcynEpEXSg5YSOWCjQ=;
        b=BAR+b0mXCFX+FZAnJ8bZA1gO2ghV0MOYxbk434kcuGIa0pcC7EGf3ADNTnzQG4E4d8
         fh5Wh3/sHR77pOQQKCs5tFuoAVgIpoIBFsIje+cc4nxNnkWHYrSMfgErfHppQOk3lGmT
         z+BUwwqzU0h5cn247MffaXoKxjTK8oCdEs0gtw05fIGPPjo1xOb8qXJyh7M6QaOUYZgc
         QM/1kdyCSE2NNyuDdCOPKWmkekv7TRMryznlhEpqDwT8tTR796KcmCKrjpPkVTzMOOkP
         fl/+Rre/Vmjq+tu+ivDGVosSjk9Iy0W+vN7qg8UQqAndknrYupP1zZ5RWvOGmsj7SJep
         ws+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IB1CcVLA+id0oymPNYSnxcg3RQcynEpEXSg5YSOWCjQ=;
        b=bi2+fl6bCWDX73ESbmw3Lcn1jlL1LoAhpYs0hGDoKwvWt1r5mQ3idayYSwH1ejvuTT
         YSzcFEBHvliJL3N8Mooz+RQvLWij7x3HRP5xtYSfhIjt8SytMvLzhxHeaPxvdcwvzGQr
         0QCSsEV/3DIlFYsGAEJmprC70gO+ol2M5vUFgHusz671UV8kkWCJ+fUpCWKbLoCsijOM
         kPaep5HNgYDJJby7kh/X5S9IsFpWF3cjvhUCiG5w5QeKJmFsoOl4gvg2Vr2eVvvYKmt8
         uKGAt/y6tx89vGd5RbRWi8nCwro8Awpmkjm72iDyNHh/R1Ylj/Qb2baaOaTk4ESBSr1O
         twkg==
X-Gm-Message-State: APjAAAWRkYBTskdJPkx0qjfM3Ia/9mesiQqNhyiY9gmnQrywESBzaizT
        FJ5ED/jq9ZCZyIkhWlCVkIOd9UxR
X-Google-Smtp-Source: APXvYqzNhSfro+KcV6t/AaF69tvGxl/jd/TRYWCGrO4wHBxQFfDAuPGEYm5xsv0IG+pMGZKdFuIMYA==
X-Received: by 2002:aed:3a45:: with SMTP id n63mr9892240qte.109.1559320646570;
        Fri, 31 May 2019 09:37:26 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id 1sm3204933qtg.11.2019.05.31.09.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 09:37:25 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH net] packet: unconditionally free po->rollover
Date:   Fri, 31 May 2019 12:37:23 -0400
Message-Id: <20190531163723.191617-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Rollover used to use a complex RCU mechanism for assignment, which had
a race condition. The below patch fixed the bug and greatly simplified
the logic.

The feature depends on fanout, but the state is private to the socket.
Fanout_release returns f only when the last member leaves and the
fanout struct is to be freed.

Destroy rollover unconditionally, regardless of fanout state.

Fixes: 57f015f5eccf2 ("packet: fix crash in fanout_demux_rollover()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fbc775fbf7128..d4889bf7248e1 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3014,8 +3014,8 @@ static int packet_release(struct socket *sock)
 
 	synchronize_net();
 
+	kfree(po->rollover);
 	if (f) {
-		kfree(po->rollover);
 		fanout_release_data(f);
 		kfree(f);
 	}
-- 
2.22.0.rc1.257.g3120a18244-goog

