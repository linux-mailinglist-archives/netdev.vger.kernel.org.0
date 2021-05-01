Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9033707EA
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhEAQiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ya3wLOI6BKQPUQ26BNG5ZARIF5TltVg6MaqK6JTg6jo=;
        b=I/0aPnkrtqFb1sYo1HNER8Zsm4dsFMeujEbYRaNq9BNI6/Dcpk2/cXyRAry5f9O7UE8EGb
        xgN/L+5wOmGNoNeFA4VGWfvu5Mo7ERVz7WSYo2TarpbeSm4nodjJD8N2pGdVHjSEDgznUB
        2tYw5O7iyoWr3f+5gTV5KCPDjMZJva4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-pf5UWe--Oxe5acb9af8qgQ-1; Sat, 01 May 2021 12:37:55 -0400
X-MC-Unique: pf5UWe--Oxe5acb9af8qgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27BE51898297;
        Sat,  1 May 2021 16:37:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 560FC50C0B;
        Sat,  1 May 2021 16:37:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 1/2] tipc: bail out if algname is abnormally long
Date:   Sat,  1 May 2021 18:32:29 +0200
Message-Id: <0615f30dc0e11d25d61b48a65dfcb9e9f1136188.1619886329.git.aclaudi@redhat.com>
In-Reply-To: <cover.1619886329.git.aclaudi@redhat.com>
References: <cover.1619886329.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc segfaults when called with an abnormally long algname:

$ tipc node set key 0x1234 algname supercalifragilistichespiralidososupercalifragilistichespiralidoso
*** buffer overflow detected ***: terminated

Fix this returning an error if provided algname is longer than
TIPC_AEAD_ALG_NAME.

Fixes: 24bee3bf9752 ("tipc: add new commands to set TIPC AEAD key")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tipc/node.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tipc/node.c b/tipc/node.c
index ae75bfff..bf592a07 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -236,10 +236,15 @@ get_ops:
 
 	/* Get algorithm name, default: "gcm(aes)" */
 	opt_algname = get_opt(opts, "algname");
-	if (!opt_algname)
+	if (!opt_algname) {
 		strcpy(input.key.alg_name, "gcm(aes)");
-	else
+	} else {
+		if (strlen(opt_algname->val) > TIPC_AEAD_ALG_NAME) {
+			fprintf(stderr, "error, invalid algname\n");
+			return -EINVAL;
+		}
 		strcpy(input.key.alg_name, opt_algname->val);
+	}
 
 	/* Get node identity */
 	opt_nodeid = get_opt(opts, "nodeid");
-- 
2.30.2

