Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4AF4DB839
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbiCPSya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347174AbiCPSy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94D7117AAE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 11:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647456791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFYQgbUaK1aZg3cOzI5aHCcCLIOT7GBuzvxqyh4ivpo=;
        b=PpMogZtJ4czyd7AnlZdk//P2QNOG4BXiyp+3+uEI//fUhqk9X5gp3A2FzPYgAUC2Vv36c0
        Uo8M7ZTB4E6xWt+TrlrZ4FPz0YbMHYgSuQ74V1I2ZDt6eBWPYh1x5NjNqBkE9a7+x2H/5b
        RytRwgq6JXrbW5EVRrWLbjvdV+knnpE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-EW34B9qROeu0PKX6vMYMcA-1; Wed, 16 Mar 2022 14:53:10 -0400
X-MC-Unique: EW34B9qROeu0PKX6vMYMcA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E5E5101AA49;
        Wed, 16 Mar 2022 18:53:10 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3465055431F;
        Wed, 16 Mar 2022 18:53:09 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next 1/2] configure: add check_libtirpc()
Date:   Wed, 16 Mar 2022 19:52:13 +0100
Message-Id: <f9b76fcbbae5d54e8093e250def8b6baa29cda4b.1647455133.git.aclaudi@redhat.com>
In-Reply-To: <cover.1647455133.git.aclaudi@redhat.com>
References: <cover.1647455133.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a configure function to check if libtirpc is installed
on the build system. If this is the case, it makes iproute2 to compile
with libtirpc support.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/configure b/configure
index 8ddff43c..440facb7 100755
--- a/configure
+++ b/configure
@@ -395,6 +395,19 @@ check_selinux()
 	fi
 }
 
+check_tirpc()
+{
+	if ${PKG_CONFIG} libtirpc --exists; then
+		echo "HAVE_RPC:=y" >>$CONFIG
+		echo "yes"
+
+		echo 'LDLIBS +=' `${PKG_CONFIG} --libs libtirpc` >>$CONFIG
+		echo 'CFLAGS += -DHAVE_RPC' `${PKG_CONFIG} --cflags libtirpc` >>$CONFIG
+	else
+		echo "no"
+	fi
+}
+
 check_mnl()
 {
 	if ${PKG_CONFIG} libmnl --exists; then
@@ -600,6 +613,9 @@ check_name_to_handle_at
 echo -n "SELinux support: "
 check_selinux
 
+echo -n "libtirpc support: "
+check_tirpc
+
 echo -n "libbpf support: "
 check_libbpf
 
-- 
2.35.1

