Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533FF69B3DD
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBQUZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBQUY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:24:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D195CF0A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676665414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrWT4jn5+t1KTthhCnIcACsrevlB9KLW8lZHoH25D7E=;
        b=Rg2NGdCkhs8rVoLqQY1GzlayoE1lbLLsuHhAJMhSM+w9dReD3pCXuatP/pCcyscJ+AVcE/
        PZkiC2gcP71Te5ohrBNE9mfGhVPcj20g5ArhmT6L0OjYnAzMVW657WL0rVoWz5dKfcCcm8
        bqemsVX9ipB42IZG/umm1m9I51ZTR+Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-pmZtnAr6MMexPvheSjz2rg-1; Fri, 17 Feb 2023 15:23:28 -0500
X-MC-Unique: pmZtnAr6MMexPvheSjz2rg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 245503C0F68E;
        Fri, 17 Feb 2023 20:23:28 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4925CC15BA0;
        Fri, 17 Feb 2023 20:23:25 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrew Waterman <waterman@eecs.berkeley.edu>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH 3/4] Move bp_type_idx to include/linux/hw_breakpoint.h
Date:   Fri, 17 Feb 2023 21:23:00 +0100
Message-Id: <20230217202301.436895-4-thuth@redhat.com>
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

This has a "#ifdef CONFIG_*" that used to be exposed to userspace.

The names in here are so generic that I don't think it's a good idea
to expose them to userspace (or even the rest of the kernel).  There are
multiple in-kernel users, so it's been moved to a kernel header file.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
Message-Id: <1447119071-19392-10-git-send-email-palmer@dabbelt.com>
[thuth: Remove it also from tools/include/uapi/linux/hw_breakpoint.h]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/linux/hw_breakpoint.h            | 10 ++++++++++
 include/uapi/linux/hw_breakpoint.h       | 10 ----------
 tools/include/uapi/linux/hw_breakpoint.h | 10 ----------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index f319bd26b030..7fbb45911273 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -7,6 +7,16 @@
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 
+enum bp_type_idx {
+	TYPE_INST	= 0,
+#if defined(CONFIG_HAVE_MIXED_BREAKPOINTS_REGS)
+	TYPE_DATA	= 0,
+#else
+	TYPE_DATA	= 1,
+#endif
+	TYPE_MAX
+};
+
 extern int __init init_hw_breakpoint(void);
 
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
diff --git a/include/uapi/linux/hw_breakpoint.h b/include/uapi/linux/hw_breakpoint.h
index 965e4d8606d8..1575d3ca6f0d 100644
--- a/include/uapi/linux/hw_breakpoint.h
+++ b/include/uapi/linux/hw_breakpoint.h
@@ -22,14 +22,4 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
diff --git a/tools/include/uapi/linux/hw_breakpoint.h b/tools/include/uapi/linux/hw_breakpoint.h
index 965e4d8606d8..1575d3ca6f0d 100644
--- a/tools/include/uapi/linux/hw_breakpoint.h
+++ b/tools/include/uapi/linux/hw_breakpoint.h
@@ -22,14 +22,4 @@ enum {
 	HW_BREAKPOINT_INVALID   = HW_BREAKPOINT_RW | HW_BREAKPOINT_X,
 };
 
-enum bp_type_idx {
-	TYPE_INST 	= 0,
-#ifdef CONFIG_HAVE_MIXED_BREAKPOINTS_REGS
-	TYPE_DATA	= 0,
-#else
-	TYPE_DATA	= 1,
-#endif
-	TYPE_MAX
-};
-
 #endif /* _UAPI_LINUX_HW_BREAKPOINT_H */
-- 
2.31.1

