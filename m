Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06994115723
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfLFS1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:27:24 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:60324 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfLFS1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 13:27:24 -0500
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Dec 2019 13:27:22 EST
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xB6IC1wI028893
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 6 Dec 2019 19:12:01 +0100
From:   Paolo Lungaroni <paolo.lungaroni@cnit.it>
To:     netdev@vger.kernel.org
Cc:     Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: [PATCH iproute2 net-next] add support for table name in SRv6 End.DT* behaviors
Date:   Fri,  6 Dec 2019 19:11:54 +0100
Message-Id: <20191206181154.3740-1-paolo.lungaroni@cnit.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it allows to specify also the table name in addition to the table number in
SRv6 End.DT* behaviors.

To add an End.DT6 behavior route specifying the table by name:

    $ ip -6 route add 2001:db8::1 encap seg6local action End.DT6 table main dev eth0

The ip route show to print output this route:

    $ ip -6 route show 2001:db8::1
    2001:db8::1  encap seg6local action End.DT6 table main dev eth0 metric 1024 pref medium

The JSON output:
    $ ip -6 -j -p route show 2001:db8::1
    [ {
            "dst": "2001:db8::1",
            "encap": "seg6local",
            "action": "End.DT6",
            "table": "main",
            "dev": "eth0",
            "metric": 1024,
            "flags": [ ],
            "pref": "medium"
        } ]

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
---
 ip/iproute_lwtunnel.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 03217b8f..cc60a022 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -229,6 +229,8 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 	struct rtattr *tb[SEG6_LOCAL_MAX + 1];
 	int action;
 
+	SPRINT_BUF(b1);
+
 	parse_rtattr_nested(tb, SEG6_LOCAL_MAX, encap);
 
 	if (!tb[SEG6_LOCAL_ACTION])
@@ -246,8 +248,9 @@ static void print_encap_seg6local(FILE *fp, struct rtattr *encap)
 	}
 
 	if (tb[SEG6_LOCAL_TABLE])
-		print_uint(PRINT_ANY, "table",
-			   "table %u ", rta_getattr_u32(tb[SEG6_LOCAL_TABLE]));
+		print_string(PRINT_ANY, "table", "table %s ",
+			     rtnl_rttable_n2a(rta_getattr_u32(tb[SEG6_LOCAL_TABLE]),
+			     b1, sizeof(b1)));
 
 	if (tb[SEG6_LOCAL_NH4]) {
 		print_string(PRINT_ANY, "nh4",
@@ -654,7 +657,7 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 			NEXT_ARG();
 			if (table_ok++)
 				duparg2("table", *argv);
-			get_u32(&table, *argv, 0);
+			rtnl_rttable_a2n(&table, *argv);
 			ret = rta_addattr32(rta, len, SEG6_LOCAL_TABLE, table);
 		} else if (strcmp(*argv, "nh4") == 0) {
 			NEXT_ARG();
-- 
2.20.1

