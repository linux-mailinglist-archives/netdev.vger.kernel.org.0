Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFE42DE9A7
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgLRTQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:16:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27093 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729767AbgLRTP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608318873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4u3SWKBFlG/AEJiLJT8+Dae8ugwuVSVipG1uT3APVu4=;
        b=PGQcQm8JBnFLqXnygX9RcXZKgzlF/PLO7pumgYLURI5SK7C04ZNLkh9Gvehllumunr5xuw
        UFUPMn91OEDQoXBNAY9F5mJbuAb/CihoZAwXNRGsb/9Gok4hL4WfbP1xD61cCyIHPN8ngr
        7DJb5UZ5H9RhFI8zvS5F6F61UwTqAQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-3uqKg5vTMuyQQP7n0o72cQ-1; Fri, 18 Dec 2020 14:14:32 -0500
X-MC-Unique: 3uqKg5vTMuyQQP7n0o72cQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BBF3809DC9;
        Fri, 18 Dec 2020 19:14:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-0.ams2.redhat.com [10.36.114.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4303F2C01B;
        Fri, 18 Dec 2020 19:14:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] lib/fs: avoid double call to mkdir on make_path()
Date:   Fri, 18 Dec 2020 20:09:22 +0100
Message-Id: <625c55227b1f4e03320940cb087e466f019ca67e.1608315719.git.aclaudi@redhat.com>
In-Reply-To: <cover.1608315719.git.aclaudi@redhat.com>
References: <cover.1608315719.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make_path() function calls mkdir two times in a row. The first one it
stores mkdir return code, and then it calls it again to check for errno.

This seems unnecessary, as we can use the return code from the first
call and check for errno if not 0.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/fs.c b/lib/fs.c
index 4b90a704..2ae506ec 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -253,7 +253,7 @@ int make_path(const char *path, mode_t mode)
 			*delim = '\0';
 
 		rc = mkdir(dir, mode);
-		if (mkdir(dir, mode) != 0 && errno != EEXIST) {
+		if (rc && errno != EEXIST) {
 			fprintf(stderr, "mkdir failed for %s: %s\n",
 				dir, strerror(errno));
 			goto out;
-- 
2.29.2

