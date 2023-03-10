Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5606B4C5D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjCJQNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjCJQMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4F1184F4
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//zLnPtP7ffouA+rSDdqgf7g3qQX7GQTNEvg0EWo8xg=;
        b=ACZBuVXnQFxX1R3MUAwHvwn1e5U58RCbVSPawL5Q1acYz3agocgVyZhkqON6pGZmSCOmBn
        idyi52YXSo93f66Ptp/oDgzeNODLWWyWkitEoRnVQQXx2AZCOohWqkVyctFJ9SPo+hybQV
        kNjDVgFRGKRPVNsineD9MTkPmlf7mVI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-afljF5ZuNkeaMFMQAyeZBQ-1; Fri, 10 Mar 2023 11:08:08 -0500
X-MC-Unique: afljF5ZuNkeaMFMQAyeZBQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97EDA80418A;
        Fri, 10 Mar 2023 16:08:06 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB616492C3E;
        Fri, 10 Mar 2023 16:08:04 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 2/5] Move ep_take_care_of_epollwakeup() to fs/eventpoll.c
Date:   Fri, 10 Mar 2023 17:07:54 +0100
Message-Id: <20230310160757.199253-3-thuth@redhat.com>
In-Reply-To: <20230310160757.199253-1-thuth@redhat.com>
References: <20230310160757.199253-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Palmer Dabbelt <palmer@dabbelt.com>

This doesn't make any sense to expose to userspace, so it's been moved
to the one user.  This was introduced by commit 95f19f658ce1 ("epoll:
drop EPOLLWAKEUP if PM_SLEEP is disabled").

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
Message-Id: <1447119071-19392-7-git-send-email-palmer@dabbelt.com>
[thuth: Rebased to fix contextual conflicts]
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 fs/eventpoll.c                 | 13 +++++++++++++
 include/uapi/linux/eventpoll.h | 12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 64659b110973..e2a5d2cc9051 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2042,6 +2042,19 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 	return do_epoll_create(0);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+		epev->events &= ~EPOLLWAKEUP;
+}
+#else
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	epev->events &= ~EPOLLWAKEUP;
+}
+#endif
+
 static inline int epoll_mutex_lock(struct mutex *mutex, int depth,
 				   bool nonblock)
 {
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index e687658843b1..cfbcc4cc49ac 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -85,16 +85,4 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
-#ifdef CONFIG_PM_SLEEP
-static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
-{
-	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
-		epev->events &= ~EPOLLWAKEUP;
-}
-#else
-static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
-{
-	epev->events &= ~EPOLLWAKEUP;
-}
-#endif
 #endif /* _UAPI_LINUX_EVENTPOLL_H */
-- 
2.31.1

