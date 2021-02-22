Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D606321E82
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 18:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhBVRtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 12:49:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230177AbhBVRth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 12:49:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614016090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t1qEQctFvdeOdv7yfoXAbpMkhqeL9UTNI+v0C9mM7jA=;
        b=KohKZevnz8GOEMADRtGSWvY+MnmpOr5rM5TlVw2QtRC5mHHAkJTtK2h40Qy8PgmNQaehGG
        ZQ2STGj1xWSs2Od1Onrmzc8REpW55cQUkABRKtZE9eU83bgYgMQDXRt2ZOkzJPgg7pj5ku
        P3wuz/ph7HHzqxX1zssvd7+NrEEh+j0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484---Sk-t-iOYqm7IbsHgRrig-1; Mon, 22 Feb 2021 12:48:06 -0500
X-MC-Unique: --Sk-t-iOYqm7IbsHgRrig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFAFE8030BB;
        Mon, 22 Feb 2021 17:48:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFE6860C04;
        Mon, 22 Feb 2021 17:48:04 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] lib/bpf: Fix and simplify bpf_mnt_check_target()
Date:   Mon, 22 Feb 2021 18:43:10 +0100
Message-Id: <0ecd47fcb87e5d02b020dbf578272607468dc625.1613995541.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in commit ac3415f5c1b1 ("lib/fs: Fix and simplify make_path()"),
calling stat() before mkdir() is racey, because the entry might change in
between.

As the call to stat() seems to only check for target existence, we can
simply call mkdir() unconditionally and catch all errors but EEXIST.

Fixes: 95ae9a4870e7 ("bpf: fix mnt path when from env")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf_legacy.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index bc869c3f..8a03b9c2 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -510,20 +510,14 @@ static int bpf_mnt_fs(const char *target)
 
 static int bpf_mnt_check_target(const char *target)
 {
-	struct stat sb = {};
 	int ret;
 
-	ret = stat(target, &sb);
-	if (ret) {
-		ret = mkdir(target, S_IRWXU);
-		if (ret) {
-			fprintf(stderr, "mkdir %s failed: %s\n", target,
-				strerror(errno));
-			return ret;
-		}
-	}
+	ret = mkdir(target, S_IRWXU);
+	if (ret && errno != EEXIST)
+		fprintf(stderr, "mkdir %s failed: %s\n", target,
+			strerror(errno));
 
-	return 0;
+	return ret;
 }
 
 static int bpf_valid_mntpt(const char *mnt, unsigned long magic)
-- 
2.29.2

