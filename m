Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBC86B4C62
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjCJQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjCJQM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F7515559
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muvL1GJq5JhedIkX9pwejhGqATSkcNKw4maG4yGCMnc=;
        b=QcUhp13Opl6D8/0auRQFkkffn/3BFLwsDfsTsmkTD+uDJkM2MPqOwbY2HyfDZCvIqSCxsx
        uDc3agJLhecWWLr0I8rkk+FuUeRRQq0bk07O+qZ94KoiiXWt/IsPL+VK5FMylya+3Giw7u
        qD6cCbI0iuB6LBY+wmwdWui3ecPpG+8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-hRpnpB05NIajyxA6Omlh5Q-1; Fri, 10 Mar 2023 11:08:05 -0500
X-MC-Unique: hRpnpB05NIajyxA6Omlh5Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65E091C0758F;
        Fri, 10 Mar 2023 16:08:04 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69892492B00;
        Fri, 10 Mar 2023 16:08:02 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 1/5] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Date:   Fri, 10 Mar 2023 17:07:53 +0100
Message-Id: <20230310160757.199253-2-thuth@redhat.com>
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

This used to be behind an #ifdef COMPAT_COMPAT, so most of userspace
wouldn't have seen the definition before.  Unfortunately this header
file became visible to userspace, so the definition has instead been
moved to net/atm/svc.c (the only user).

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
Message-Id: <1447119071-19392-4-git-send-email-palmer@dabbelt.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/uapi/linux/atmdev.h | 4 ----
 net/atm/svc.c               | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/atmdev.h b/include/uapi/linux/atmdev.h
index a5c15cf23bd7..20b0215084fc 100644
--- a/include/uapi/linux/atmdev.h
+++ b/include/uapi/linux/atmdev.h
@@ -101,10 +101,6 @@ struct atm_dev_stats {
 					/* use backend to make new if */
 #define ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct atm_iobuf)
  					/* add party to p2mp call */
-#ifdef CONFIG_COMPAT
-/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
-#define COMPAT_ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct compat_atm_iobuf)
-#endif
 #define ATM_DROPPARTY 	_IOW('a', ATMIOC_SPECIAL+5,int)
 					/* drop party from p2mp call */
 
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 4a02bcaad279..d83556d8beb9 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -28,6 +28,11 @@
 #include "signaling.h"
 #include "addr.h"
 
+#ifdef CONFIG_COMPAT
+/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
+#define COMPAT_ATM_ADDPARTY _IOW('a', ATMIOC_SPECIAL + 4, struct compat_atm_iobuf)
+#endif
+
 static int svc_create(struct net *net, struct socket *sock, int protocol,
 		      int kern);
 
-- 
2.31.1

