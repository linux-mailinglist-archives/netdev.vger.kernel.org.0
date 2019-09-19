Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF79B7E78
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390049AbfISPsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388805AbfISPsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 11:48:13 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C21208C0;
        Thu, 19 Sep 2019 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568908092;
        bh=4P4FwhJLYODe8QdVNpLynxMKcSlo0/LKh0hAB/5PEHg=;
        h=From:To:Cc:Subject:Date:From;
        b=Kkcg9ikv0FAV0ciXNIJD6gZECbI2fkgG6tjdHbfLFi/ohRkctWEfIkGkMG9EpWjQS
         QHmMNg4L0XQFkgEYSgF/tRrS0JoRnsw/s+SjJfz4K8Ja3LU4sTGuTxMFkgFfxLjWja
         g3mAojlxai5YD/NWv+2qARjbjWjqHq+j2/AxhkLU=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next] ip vrf: Add json support for show command
Date:   Thu, 19 Sep 2019 08:51:36 -0700
Message-Id: <20190919155136.23758-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add json support to 'ip vrf sh':
$ ip -j -p vrf ls
[ {
        "name": "mgmt",
        "table": 1001
    } ]

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/ipvrf.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 43366f6e25f0..b9a43675cbd6 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -566,9 +566,12 @@ static int ipvrf_print(struct nlmsghdr *n)
 		return 0;
 	}
 
-	printf("%-16s %5u", name, tb_id);
+	open_json_object(NULL);
+	print_string(PRINT_ANY, "name", "%-16s", name);
+	print_uint(PRINT_ANY, "table", " %5u", tb_id);
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	close_json_object();
 
-	printf("\n");
 	return 1;
 }
 
@@ -597,15 +600,21 @@ static int ipvrf_show(int argc, char **argv)
 	if (ip_link_list(ipvrf_filter_req, &linfo) == 0) {
 		struct nlmsg_list *l;
 		unsigned nvrf = 0;
-		int n;
 
-		n = printf("%-16s  %5s\n", "Name", "Table");
-		printf("%.*s\n", n-1, "-----------------------");
+		new_json_obj(json);
+
+		print_string(PRINT_FP, NULL, "%-16s", "Name");
+		print_string(PRINT_FP, NULL, "  %5s\n", "Table");
+		print_string(PRINT_FP, NULL, "%s\n",
+			     "-----------------------");
+
 		for (l = linfo.head; l; l = l->next)
 			nvrf += ipvrf_print(&l->h);
 
 		if (!nvrf)
-			printf("No VRF has been configured\n");
+			print_string(PRINT_FP, NULL, "%s\n",
+				     "No VRF has been configured");
+		delete_json_obj();
 	} else
 		rc = 1;
 
-- 
2.11.0

