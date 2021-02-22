Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D94A3220EC
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhBVUqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:46:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230240AbhBVUqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614026696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xo3BkZUPCSrnk6shCSRP5lxpzR1HyhCLg05skymvAiw=;
        b=Z3/PAD8vX/drf+eL+2krLbLnc21yatBfrNXYva7R/xGEZRrLR9TsW5wlCtvAOJSUKdSOlb
        P5eREWlFtuUikd/ppws+KA7UWJQjPbktwUcaGz2/KpAmOm4Mtl5Q4xIUzbD5vTVWIOjMCb
        ygUL2XiTSeDc1FVvu2jYaeHRxI703Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-OhUVGzqmOPKApVLE2i8xDQ-1; Mon, 22 Feb 2021 15:34:31 -0500
X-MC-Unique: OhUVGzqmOPKApVLE2i8xDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C40BF107ACE3;
        Mon, 22 Feb 2021 20:34:30 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5BC5D9D0;
        Mon, 22 Feb 2021 20:34:29 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] ip: lwtunnel: seg6: bail out if table ids are invalid
Date:   Mon, 22 Feb 2021 21:23:01 +0100
Message-Id: <7c781ea7fd56aab0d7a000ccb6b7c0aac33ef7fb.1614022321.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When table and vrftable are used in SRv6, ip should bail out if table
ids are not valid, and return a proper error message to the user.

Achieve this simply checking rtnl_rttable_a2n return value, as we
already do in the rest of iproute.

Fixes: 0486388a877a ("add support for table name in SRv6 End.DT* behaviors")
Fixes: 69629b4e43c4 ("seg6: add support for vrftable attribute in SRv6 End.DT4/DT6 behaviors")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/iproute_lwtunnel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 1ab95cd2..566fc7ea 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -891,13 +891,15 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 			NEXT_ARG();
 			if (table_ok++)
 				duparg2("table", *argv);
-			rtnl_rttable_a2n(&table, *argv);
+			if (rtnl_rttable_a2n(&table, *argv))
+				invarg("invalid table id\n", *argv);
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_TABLE, table);
 		} else if (strcmp(*argv, "vrftable") == 0) {
 			NEXT_ARG();
 			if (vrftable_ok++)
 				duparg2("vrftable", *argv);
-			rtnl_rttable_a2n(&vrftable, *argv);
+			if (rtnl_rttable_a2n(&vrftable, *argv))
+				invarg("invalid vrf table id\n", *argv);
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_VRFTABLE,
 					    vrftable);
 		} else if (strcmp(*argv, "nh4") == 0) {
-- 
2.29.2

