Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844E15A02D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfF1QDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:03:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfF1QDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 12:03:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 683DF30593D8;
        Fri, 28 Jun 2019 16:03:39 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 972836013A;
        Fri, 28 Jun 2019 16:03:38 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next] utils: move parse_percent() to tc_util
Date:   Fri, 28 Jun 2019 18:03:45 +0200
Message-Id: <e9e070178cdd26588800b43938647b7b338c2142.1561737608.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 28 Jun 2019 16:03:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As parse_percent() is used only in tc.

This reduces ip, bridge and genl binaries size:

$ bloat-o-meter -t bridge/bridge bridge/bridge.new
add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
Total: Before=50973, After=50864, chg -0.21%

$ bloat-o-meter -t genl/genl genl/genl.new
add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
Total: Before=30298, After=30189, chg -0.36%

$ bloat-o-meter ip/ip ip/ip.new
add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
Total: Before=674164, After=674055, chg -0.02%

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 include/utils.h |  1 -
 lib/utils.c     | 16 ----------------
 tc/tc_util.c    | 16 ++++++++++++++++
 tc/tc_util.h    |  1 +
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index ec0231f9772d0..1d9c11276bbe6 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -146,7 +146,6 @@ int get_addr_rta(inet_prefix *dst, const struct rtattr *rta, int family);
 int get_addr_ila(__u64 *val, const char *arg);
 
 int read_prop(const char *dev, char *prop, long *value);
-int parse_percent(double *val, const char *str);
 int get_hex(char c);
 int get_integer(int *val, const char *arg, int base);
 int get_unsigned(unsigned *val, const char *arg, int base);
diff --git a/lib/utils.c b/lib/utils.c
index be0f11b00280d..5da9a47848966 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -101,22 +101,6 @@ out:
 	return -1;
 }
 
-/* Parse a percent e.g: '30%'
- * return: 0 = ok, -1 = error, 1 = out of range
- */
-int parse_percent(double *val, const char *str)
-{
-	char *p;
-
-	*val = strtod(str, &p) / 100.;
-	if (*val == HUGE_VALF || *val == HUGE_VALL)
-		return 1;
-	if (*p && strcmp(p, "%"))
-		return -1;
-
-	return 0;
-}
-
 int get_hex(char c)
 {
 	if (c >= 'A' && c <= 'F')
diff --git a/tc/tc_util.c b/tc/tc_util.c
index e5d15281581df..53d15e08e9734 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -190,6 +190,22 @@ static const struct rate_suffix {
 	{ NULL }
 };
 
+/* Parse a percent e.g: '30%'
+ * return: 0 = ok, -1 = error, 1 = out of range
+ */
+int parse_percent(double *val, const char *str)
+{
+	char *p;
+
+	*val = strtod(str, &p) / 100.;
+	if (*val == HUGE_VALF || *val == HUGE_VALL)
+		return 1;
+	if (*p && strcmp(p, "%"))
+		return -1;
+
+	return 0;
+}
+
 static int parse_percent_rate(char *rate, size_t len,
 			      const char *str, const char *dev)
 {
diff --git a/tc/tc_util.h b/tc/tc_util.h
index 825fea36a0809..eb4b60db3fdd7 100644
--- a/tc/tc_util.h
+++ b/tc/tc_util.h
@@ -101,6 +101,7 @@ int print_tc_classid(char *buf, int len, __u32 h);
 char *sprint_tc_classid(__u32 h, char *buf);
 
 int tc_print_police(FILE *f, struct rtattr *tb);
+int parse_percent(double *val, const char *str);
 int parse_police(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n);
 
 int parse_action_control(int *argc_p, char ***argv_p,
-- 
2.20.1

