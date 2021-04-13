Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F635E941
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347652AbhDMWvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232604AbhDMWvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:51:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618354254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XSwfJPSaoXSS02UTgrOYKtkoL9bFycp9OlDJbenfM3Y=;
        b=hrdZJR9cvR/JsFESNsQWprn3A1NmcAiFWPuJwD8bQtK2XAU7vakXnzd6mW5d8iAS5q1TKk
        6EEP4B5i/e5AUdzkOs+1/FsWWRg1C46OGGsA4/vbmSsVbRrGKAg1v81wE/8v5t1AeYPP99
        b59M+htBXTcmETXesg81lqn69OjvN90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-m36Ry9_pODuG5GYPFuzLew-1; Tue, 13 Apr 2021 18:50:52 -0400
X-MC-Unique: m36Ry9_pODuG5GYPFuzLew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B7AF6D24D;
        Tue, 13 Apr 2021 22:50:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AE605D9CA;
        Tue, 13 Apr 2021 22:50:50 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] nexthop: fix memory leak in add_nh_group_attr()
Date:   Wed, 14 Apr 2021 00:50:45 +0200
Message-Id: <6ce757a509dc88b90b029cd7e9c96bb0a245a313.1618350667.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

grps is dinamically allocated with a calloc, and not freed in a return
path in the for cycle. This commit fix it.

While at it, make the function use a single return point.

Fixes: 63df8e8543b0 ("Add support for nexthop objects")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipnexthop.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 20cde586..f0658a9c 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -277,8 +277,9 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 
 static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 {
-	struct nexthop_grp *grps;
+	struct nexthop_grp *grps = NULL;
 	int count = 0, i;
+	int err = -1;
 	char *sep, *wsep;
 
 	if (*argv != '\0')
@@ -292,11 +293,11 @@ static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 	}
 
 	if (count == 0)
-		return -1;
+		goto out;
 
 	grps = calloc(count, sizeof(*grps));
 	if (!grps)
-		return -1;
+		goto out;
 
 	for (i = 0; i < count; ++i) {
 		sep = strchr(argv, '/');
@@ -308,7 +309,7 @@ static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 			*wsep = '\0';
 
 		if (get_unsigned(&grps[i].id, argv, 0))
-			return -1;
+			goto out;
 		if (wsep) {
 			unsigned int w;
 
@@ -324,7 +325,10 @@ static int add_nh_group_attr(struct nlmsghdr *n, int maxlen, char *argv)
 		argv = sep + 1;
 	}
 
-	return addattr_l(n, maxlen, NHA_GROUP, grps, count * sizeof(*grps));
+	err = addattr_l(n, maxlen, NHA_GROUP, grps, count * sizeof(*grps));
+out:
+	free(grps);
+	return err;
 }
 
 static int ipnh_modify(int cmd, unsigned int flags, int argc, char **argv)
-- 
2.30.2

