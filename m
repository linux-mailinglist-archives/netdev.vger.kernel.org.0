Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE43327794F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbgIXT2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:28:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728758AbgIXT2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:28:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600975683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aIojZ/R8vH9rsjdmoutCPlVLGB4yUkhagiFAMXUflws=;
        b=D1rwaa7aS+RnKUze8c9atdPVGJtDPa+GCg4wX4HDEsO1rraxhPWJge8y9M+hMWd2rXTw1f
        olfPgh8J83GttsYURZBQkYQCLvHBLm33jkr0obJHILkB5M4U8XulBy1zc3Pgz8TlW219Af
        JV1ezlasDXxNwzAZDyPCk8P0GS3Dz2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-MBbwkCBAPjiCpOm19CTUAg-1; Thu, 24 Sep 2020 15:28:01 -0400
X-MC-Unique: MBbwkCBAPjiCpOm19CTUAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB0AA1005E76;
        Thu, 24 Sep 2020 19:28:00 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD5D160BF3;
        Thu, 24 Sep 2020 19:27:59 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/2] netlink: return -ENOMEM when calloc fails
Date:   Thu, 24 Sep 2020 21:27:57 +0200
Message-Id: <20200924192758.577595-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: f2c17e107900 ("netlink: add netlink handler for gfeatures (-k)")

Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 netlink/features.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/netlink/features.c b/netlink/features.c
index 3f1240437350..b2cf57eea660 100644
--- a/netlink/features.c
+++ b/netlink/features.c
@@ -112,16 +112,17 @@ int dump_features(const struct nlattr *const *tb,
 	unsigned int *feature_flags = NULL;
 	struct feature_results results;
 	unsigned int i, j;
-	int ret;
+	int ret = 0;
 
 	ret = prepare_feature_results(tb, &results);
 	if (ret < 0)
 		return -EFAULT;
 
-	ret = -ENOMEM;
 	feature_flags = calloc(results.count, sizeof(feature_flags[0]));
-	if (!feature_flags)
+	if (!feature_flags) {
+		ret = -ENOMEM;
 		goto out_free;
+	}
 
 	/* map netdev features to legacy flags */
 	for (i = 0; i < results.count; i++) {
@@ -184,7 +185,7 @@ int dump_features(const struct nlattr *const *tb,
 
 out_free:
 	free(feature_flags);
-	return 0;
+	return ret;
 }
 
 int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
-- 
2.26.2

