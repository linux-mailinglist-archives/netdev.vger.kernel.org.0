Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA7D35E93F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbhDMWtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:49:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344446AbhDMWts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:49:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618354167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iem9PTrd0+rkk3Vftx/yxzybaMQQNqsa0A0RKO6QsL0=;
        b=b7ODPSdhXA3tsWuc6eklhH5wd9aR5EsLt4qQkc99ESOzkyFobpIcwcM/t7E6ZDusU+wZEo
        gurxJFErxD5UlOsCtjURsl7VQyx77Ckqd3W9EZRW+gzTbp2JwEXkBWbsAiiXJKHdCQmxeT
        ZdC8QHpOAkVw7oH0eSPiyMdEgP20dvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-MiiNqQbiOLWtDymgkPG_KA-1; Tue, 13 Apr 2021 18:49:23 -0400
X-MC-Unique: MiiNqQbiOLWtDymgkPG_KA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 657D083DD22;
        Tue, 13 Apr 2021 22:49:22 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94A825C239;
        Tue, 13 Apr 2021 22:49:21 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] devlink: always check strslashrsplit() return value
Date:   Wed, 14 Apr 2021 00:48:37 +0200
Message-Id: <09890143926c494e1cc3939a84eded4c55c27d9e.1618350667.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strslashrsplit() return value is not checked in __dl_argv_handle(),
despite the fact that it can return EINVAL.

This commit fix it and make __dl_argv_handle() return error if
strslashrsplit() return an error code.

Fixes: 2f85a9c53587 ("devlink: allow to parse both devlink and port handle in the same time")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 devlink/devlink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index c6e85ff9..faa87b3d 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -965,7 +965,13 @@ static int strtobool(const char *str, bool *p_val)
 
 static int __dl_argv_handle(char *str, char **p_bus_name, char **p_dev_name)
 {
-	strslashrsplit(str, p_bus_name, p_dev_name);
+	int err;
+
+	err = strslashrsplit(str, p_bus_name, p_dev_name);
+	if (err) {
+		pr_err("Devlink identification (\"bus_name/dev_name\") \"%s\" is invalid\n", str);
+		return err;
+	}
 	return 0;
 }
 
-- 
2.30.2

