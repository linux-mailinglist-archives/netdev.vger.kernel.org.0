Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C35969B3D4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBQUYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBQUYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:24:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23D60FBD
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676665406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNwMQS2nb5Snx2PKXCZ6inX1tp7FOHWAWLevabGCm8U=;
        b=Ki3qJE/S/vtuF2jzTCXjOeSJTWQqrF9ZSMCCYM+2H8OzlMb92+kVVaYnpHwGMI642JyHos
        sMLw2UD2n+rMHqMB4Lgv1ZzJRcQ3nfMP0KWcp7ztwRqSNEkj+2KaQInaaUGfWUdn35sDgP
        ca8EvxuzdwD7HlbRlbqLCEtBgfE610U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-1e9Ia_q4NjmCzRE9jXbKHA-1; Fri, 17 Feb 2023 15:23:21 -0500
X-MC-Unique: 1e9Ia_q4NjmCzRE9jXbKHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4F601C05B03;
        Fri, 17 Feb 2023 20:23:20 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77C15C15BA0;
        Fri, 17 Feb 2023 20:23:17 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrew Waterman <waterman@eecs.berkeley.edu>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH 1/4] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Date:   Fri, 17 Feb 2023 21:22:58 +0100
Message-Id: <20230217202301.436895-2-thuth@redhat.com>
In-Reply-To: <20230217202301.436895-1-thuth@redhat.com>
References: <20230217202301.436895-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

