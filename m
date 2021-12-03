Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36D467044
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378279AbhLCCvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243291AbhLCCvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:40 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FBAC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:17 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f125so1702182pgc.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fT2Qu6/ffgiG1NGeWHN8tdR6mwWo+LW/WTBHIOFKRSI=;
        b=izrdx+V/2GAhKrR6rFhXOrKem/B20UMkMEZiBfTN7d+PiGIzV2/EXIQ/5PnoR1aXMb
         wCNxLCCEhAsBOZSc6i8pUTfZ72ZnNQVJaghBi/W5F8+yaD9XXMnXhm7JINl9Gz0q/J3R
         pcOSs9xQsZG52Em8kfqE7+vl73wsvAC2oTEApYUSrSYI1kUZVAd9SRQntBrQsaCQLruW
         BY8k4mJjnVNxIXQJTS9xPeL5EiqK6F/23AnZLznwTZt22Bt+SJv89R+SpVdlQ5DdFfY4
         fE5L3kpVPFbNiaKlt2Aucri7+d6I1zer6iXZVXML6oBuXNUO/w7uyy3/bSLY3hvxKSDL
         yoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fT2Qu6/ffgiG1NGeWHN8tdR6mwWo+LW/WTBHIOFKRSI=;
        b=GafX7wn5zH5Pi5+ejRnOm8XTRUBvhId9Yz+wBbgG7fNpnEFivSX0tnU/1AioTA9lMl
         vTS7groc0VTQg3oL6uuGN67/Wv8WXS92u5NWxhossr/SAdoF0Pb9cY4ofEyp6ab4RhBH
         Q14OtpuaWzfzEkTgOyw1cywio4WWaSfwvVWaXKEC8eVDIzqC330tDRSacLM90E0hFkP3
         r2a2PacZBm3HPS9uht8qsZez7XIDZt0lOio9Xaidv8nHLLmU1ZAin3LlmfuQrKEonnN2
         x7xXUcX1tQkyavD0j4bqJ7giYJPlv+gTYdcyy8QYLXX7kZAuo6iLDORdIIcxUHJkYX1k
         Y95w==
X-Gm-Message-State: AOAM531GhiE8WboYbwcK93zJoQHVNTIEXPZPGHI02RF3HrtkH/OuxgpQ
        pXoGwvWsEAAi1p7l6jJ/jrE=
X-Google-Smtp-Source: ABdhPJxSUGTf+5a0kJR6ZtVMZXC8iYzn2sMSosnaP6wGwV7/RMCIIz+7JP9C2Bl8xRAJY4FKUn+yUA==
X-Received: by 2002:aa7:8886:0:b0:49f:fae6:c5f5 with SMTP id z6-20020aa78886000000b0049ffae6c5f5mr16473805pfe.8.1638499696843;
        Thu, 02 Dec 2021 18:48:16 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 19/23] net/sched: add net device refcount tracker to struct Qdisc
Date:   Thu,  2 Dec 2021 18:46:36 -0800
Message-Id: <20211203024640.1180745-20-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sch_generic.h | 2 +-
 net/sched/sch_generic.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 22179b2fda72a0a1c2fddc07eeda40716a443a46..dbf202bb1a0edad582dbaefe72aac1632e219fbd 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -125,7 +125,7 @@ struct Qdisc {
 	spinlock_t		seqlock;
 
 	struct rcu_head		rcu;
-
+	netdevice_tracker	dev_tracker;
 	/* private data */
 	long privdata[] ____cacheline_aligned;
 };
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d33804d41c5c5a9047c808fd37ba65ae8875fc79..8c8fbf2e385679e46a1b7af47eeac059fb8468cc 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -973,7 +973,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
-	dev_hold(dev);
+	dev_hold_track(dev, &sch->dev_tracker, GFP_KERNEL);
 	refcount_set(&sch->refcnt, 1);
 
 	return sch;
@@ -1073,7 +1073,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 		ops->destroy(qdisc);
 
 	module_put(ops->owner);
-	dev_put(qdisc_dev(qdisc));
+	dev_put_track(qdisc_dev(qdisc), &qdisc->dev_tracker);
 
 	trace_qdisc_destroy(qdisc);
 
-- 
2.34.1.400.ga245620fadb-goog

