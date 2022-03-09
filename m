Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8074D35A5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiCIRLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbiCIRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E40313AA0E
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646845419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4TRWn9YT8+UHhjElFHm/pTgu+XuvfDhYXf7Cm7RNNUo=;
        b=F8vElWsan1HZM96I8EZewowLYIexWglP4JyXtp36DirNPhJv7fAarHtolfKdM/Fv+8n8h8
        Ux/WXIUDeio+DkNPr5NBxPAUP7usz2k5V25lN8wDrDrU1AcA/oiKjjZAJ7lna1h/PMiqv1
        931f2h8Mm4IKTPx43fL9P+l5l4fbouw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-PT3IlqGtPjaT70HSS9_aaA-1; Wed, 09 Mar 2022 12:03:34 -0500
X-MC-Unique: PT3IlqGtPjaT70HSS9_aaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83AD55200;
        Wed,  9 Mar 2022 17:03:31 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.39.195.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE4D106F949;
        Wed,  9 Mar 2022 17:03:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next] Makefile: move HAVE_MLN check to top-level Makefile
Date:   Wed,  9 Mar 2022 18:03:26 +0100
Message-Id: <814bc876484374530642f61f999a0c136a6a492c.1646845304.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dcb, devlink, rdma, tipc and vdpa rely on libmnl to compile, so they
check for libmnl to be installed on their Makefiles.

This moves HAVE_MNL check from the tools to top-level Makefile, thus
avoiding to call their Makefiles if libmnl is not present.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 Makefile         | 5 ++++-
 dcb/Makefile     | 6 ------
 devlink/Makefile | 6 ------
 rdma/Makefile    | 4 ----
 tipc/Makefile    | 6 ------
 vdpa/Makefile    | 6 ------
 6 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index f6214534..8a17d614 100644
--- a/Makefile
+++ b/Makefile
@@ -65,7 +65,10 @@ WFLAGS += -Wmissing-declarations -Wold-style-definition -Wformat=2
 CFLAGS := $(WFLAGS) $(CCOPTS) -I../include -I../include/uapi $(DEFINES) $(CFLAGS)
 YACCFLAGS = -d -t -v
 
-SUBDIRS=lib ip tc bridge misc netem genl tipc devlink rdma dcb man vdpa
+SUBDIRS=lib ip tc bridge misc netem genl man
+ifeq ($(HAVE_MNL),y)
+SUBDIRS += tipc devlink rdma dcb vdpa
+endif
 
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)
diff --git a/dcb/Makefile b/dcb/Makefile
index 3a2e5d4c..ca65d467 100644
--- a/dcb/Makefile
+++ b/dcb/Makefile
@@ -1,10 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../config.mk
 
-TARGETS :=
-
-ifeq ($(HAVE_MNL),y)
-
 DCBOBJ = dcb.o \
          dcb_app.o \
          dcb_buffer.o \
@@ -15,8 +11,6 @@ DCBOBJ = dcb.o \
 TARGETS += dcb
 LDLIBS += -lm
 
-endif
-
 all: $(TARGETS) $(LIBS)
 
 dcb: $(DCBOBJ) $(LIBNETLINK)
diff --git a/devlink/Makefile b/devlink/Makefile
index d37a4b4d..1a1eed7e 100644
--- a/devlink/Makefile
+++ b/devlink/Makefile
@@ -1,16 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../config.mk
 
-TARGETS :=
-
-ifeq ($(HAVE_MNL),y)
-
 DEVLINKOBJ = devlink.o mnlg.o
 TARGETS += devlink
 LDLIBS += -lm
 
-endif
-
 all: $(TARGETS) $(LIBS)
 
 devlink: $(DEVLINKOBJ) $(LIBNETLINK)
diff --git a/rdma/Makefile b/rdma/Makefile
index 9154efeb..37d904a7 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -1,16 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 include ../config.mk
 
-TARGETS :=
-
-ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
 	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o res-ctx.o res-srq.o
 
 TARGETS += rdma
-endif
 
 all:	$(TARGETS) $(LIBS)
 
diff --git a/tipc/Makefile b/tipc/Makefile
index a10debe0..4f0aba7e 100644
--- a/tipc/Makefile
+++ b/tipc/Makefile
@@ -1,10 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../config.mk
 
-TARGETS :=
-
-ifeq ($(HAVE_MNL),y)
-
 TIPCOBJ=bearer.o \
     cmdl.o link.o \
     media.o misc.o \
@@ -14,8 +10,6 @@ TIPCOBJ=bearer.o \
 
 TARGETS += tipc
 
-endif
-
 all: $(TARGETS) $(LIBS)
 
 tipc: $(TIPCOBJ)
diff --git a/vdpa/Makefile b/vdpa/Makefile
index 253e20a7..86f7221e 100644
--- a/vdpa/Makefile
+++ b/vdpa/Makefile
@@ -1,16 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 include ../config.mk
 
-TARGETS :=
-
-ifeq ($(HAVE_MNL),y)
-
 CFLAGS += -I./include/uapi/
 VDPAOBJ = vdpa.o
 TARGETS += vdpa
 
-endif
-
 all: $(TARGETS) $(LIBS)
 
 vdpa: $(VDPAOBJ)
-- 
2.35.1

