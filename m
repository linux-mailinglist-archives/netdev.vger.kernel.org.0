Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BF8278116
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgIYHFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbgIYHFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 03:05:33 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601017532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zb1ssVZByN04zlO9IiBB22UJM2VmA0KjLXWuIOpvCBA=;
        b=b7NUMvgDHMAfCOCjLDSpTv4zOe+98VdrP4aORtMG7qJhRzmpFr8bctF5SljvzzOFbgwU88
        wHzpYn0zfWXCA3KDKPKKjw1Uh4Boo87vlGeWaSWILskRJLR5TaCIKKqs8BfF6/h1VpbFxl
        zfEmxIMQI9ViZ0GHNdqdZtqeFvf/N9Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-j2AuJUKsMNeMzwzkmyy-zA-1; Fri, 25 Sep 2020 03:05:30 -0400
X-MC-Unique: j2AuJUKsMNeMzwzkmyy-zA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83F3C64143;
        Fri, 25 Sep 2020 07:05:29 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.195.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97BF33C89;
        Fri, 25 Sep 2020 07:05:28 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/2] fix memory leaks in do_sfeatures()
Date:   Fri, 25 Sep 2020 09:05:26 +0200
Message-Id: <20200925070527.1001190-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory blocks referenced by new_state and old_state are never freed.
For efeatures there is no need to check pointer as free() can be called
with NULL parameter.

Fixes: 6042804cf6ec ("Change -k/-K options to use ETHTOOL_{G,S}FEATURES")

Cc: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 ethtool.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index ab9b4577cbce..f2d568722272 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2392,9 +2392,10 @@ static int do_sfeatures(struct cmd_context *ctx)
 	int any_changed = 0, any_mismatch = 0;
 	u32 off_flags_wanted = 0;
 	u32 off_flags_mask = 0;
-	struct ethtool_sfeatures *efeatures;
+	struct ethtool_sfeatures *efeatures = NULL;
+	struct feature_state *old_state = NULL;
+	struct feature_state *new_state = NULL;
 	struct cmdline_info *cmdline_features;
-	struct feature_state *old_state, *new_state;
 	struct ethtool_value eval;
 	unsigned int i, j;
 	int err, rc;
@@ -2418,8 +2419,6 @@ static int do_sfeatures(struct cmd_context *ctx)
 		memset(efeatures->features, 0,
 		       FEATURE_BITS_TO_BLOCKS(defs->n_features) *
 		       sizeof(efeatures->features[0]));
-	} else {
-		efeatures = NULL;
 	}
 
 	/* Generate cmdline_info for legacy flags and kernel-named
@@ -2578,9 +2577,11 @@ static int do_sfeatures(struct cmd_context *ctx)
 	rc = 0;
 
 err:
+	free(new_state);
+	free(old_state);
 	free(defs);
-	if (efeatures)
-		free(efeatures);
+	free(efeatures);
+
 	return rc;
 }
 
-- 
2.26.2

