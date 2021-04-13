Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5735E940
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhDMWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232604AbhDMWu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 18:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618354237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OUbqbG+V4PlNw2F34h4JJR5U5zq6GVDVMselcAGpAoM=;
        b=WoEDS4lF3kXnHaxOE8r/gvHdUmEL2TLHPQ6dovKBiJErTR8+FEtqKx91RO8CIdjYtYf0bb
        8SoytPpbZJ03kaFDbTls81z7ZKmgsTO3f6Mhr6dmA0pgwLfqnIV6+ku6cmZoG1QfRrLDMo
        rY3zHtYuoyQG2AuIYRgdSfj+nXzlYpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-5pn13xIiMrqSm2kBLTtO9A-1; Tue, 13 Apr 2021 18:50:36 -0400
X-MC-Unique: 5pn13xIiMrqSm2kBLTtO9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 172FE6D249;
        Tue, 13 Apr 2021 22:50:35 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-135.ams2.redhat.com [10.36.112.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45D815D9CA;
        Tue, 13 Apr 2021 22:50:34 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] q_cake: remove useless check on argv
Date:   Wed, 14 Apr 2021 00:50:20 +0200
Message-Id: <88d7da8d165406b5b633a1822064c9f315a23b51.1618350667.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cake_parse_opt(), *argv is checked not to be null when parsing for
overhead and mpu parameters. However this is useless, since *argv
matches right before for "overhead" or "mpu".

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/q_cake.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tc/q_cake.c b/tc/q_cake.c
index 4ff6056a..4cfc1c00 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -299,8 +299,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 
 			NEXT_ARG();
 			overhead = strtol(*argv, &p, 10);
-			if (!p || *p || !*argv ||
-			    overhead < -64 || overhead > 256) {
+			if (!p || *p || overhead < -64 || overhead > 256) {
 				fprintf(stderr,
 					"Illegal \"overhead\", valid range is -64 to 256\\n");
 				return -1;
@@ -312,7 +311,7 @@ static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 
 			NEXT_ARG();
 			mpu = strtol(*argv, &p, 10);
-			if (!p || *p || !*argv || mpu < 0 || mpu > 256) {
+			if (!p || *p || mpu < 0 || mpu > 256) {
 				fprintf(stderr,
 					"Illegal \"mpu\", valid range is 0 to 256\\n");
 				return -1;
-- 
2.30.2

