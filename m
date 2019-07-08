Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9A361C7B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfGHJhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:37:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbfGHJhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 05:37:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51FE781F25;
        Mon,  8 Jul 2019 09:37:15 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71F1F2B9FA;
        Mon,  8 Jul 2019 09:37:14 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] ip-route: fix json formatting for metrics
Date:   Mon,  8 Jul 2019 11:36:42 +0200
Message-Id: <f1535e547aa6da8216ca2a0da7c06b645a132929.1562578533.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 08 Jul 2019 09:37:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting metrics for routes currently lead to non-parsable
json output. For example:

$ ip link add type dummy
$ ip route add 192.168.2.0 dev dummy0 metric 100 mtu 1000 rto_min 3
$ ip -j route | jq
parse error: ':' not as part of an object at line 1, column 319

Fixing this opening a json object in the metrics array and using
print_string() instead of fprintf().

This is the output for the above commands applying this patch:

$ ip -j route | jq
[
  {
    "dst": "192.168.2.0",
    "dev": "dummy0",
    "scope": "link",
    "metric": 100,
    "flags": [],
    "metrics": [
      {
        "mtu": 1000,
        "rto_min": 3
      }
    ]
  }
]

Fixes: 663c3cb23103f ("iproute: implement JSON and color output")
Fixes: 968272e791710 ("iproute: refactor metrics print")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/iproute.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 1669e0138259e..2f9b612b0b506 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -578,6 +578,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
 	int i;
 
 	open_json_array(PRINT_JSON, "metrics");
+	open_json_object(NULL);
 
 	parse_rtattr(mxrta, RTAX_MAX, RTA_DATA(rta), RTA_PAYLOAD(rta));
 
@@ -611,7 +612,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
 			print_rtax_features(fp, val);
 			break;
 		default:
-			fprintf(fp, "%u ", val);
+			print_uint(PRINT_ANY, mx_names[i], "%u ", val);
 			break;
 
 		case RTAX_RTT:
@@ -639,6 +640,7 @@ static void print_rta_metrics(FILE *fp, const struct rtattr *rta)
 		}
 	}
 
+	close_json_object();
 	close_json_array(PRINT_JSON, NULL);
 }
 
-- 
2.20.1

