Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495922C1677
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgKWUU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:20:26 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:40016 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbgKWUUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:20:25 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0ANKGuI2005994;
        Mon, 23 Nov 2020 15:20:23 -0500
Received: from pbmxdp01.intersil.corp (pbmxdp01.pb.intersil.com [132.158.200.222])
        by pbmsgap02.intersil.com with ESMTP id 34xwxksbad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 15:20:23 -0500
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp01.intersil.corp (132.158.200.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Mon, 23 Nov 2020 15:20:22 -0500
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 23 Nov 2020 15:20:21 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
Date:   Mon, 23 Nov 2020 15:20:06 -0500
Message-ID: <1606162806-14589-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=833 adultscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230130
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Feed kstrtou8 with NULL terminated string.

Changes since v1:
-Use strscpy instead of strncpy for safety.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 60 ++++++++++++++++++++++++++++++-------------
 tools/bpf/example             | 12 +++++++++
 tools/bpf/novlan              |  7 +++++
 3 files changed, 61 insertions(+), 18 deletions(-)
 create mode 100644 tools/bpf/example
 create mode 100644 tools/bpf/novlan

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e020faf..d4e434b 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -103,42 +103,66 @@ static int timespec_to_char_array(struct timespec64 const *ts,
 	return 0;
 }
 
-static int idtcm_strverscmp(const char *ver1, const char *ver2)
+static int idtcm_strverscmp(const char *version1, const char *version2)
 {
 	u8 num1;
 	u8 num2;
 	int result = 0;
+	char ver1[16];
+	char ver2[16];
+	char *cur1;
+	char *cur2;
+	char *next1;
+	char *next2;
+
+	if (strscpy(ver1, version1, 16) < 0 ||
+	    strscpy(ver2, version2, 16) < 0)
+		return -1;
+	cur1 = ver1;
+	cur2 = ver2;
 
 	/* loop through each level of the version string */
 	while (result == 0) {
+		next1 = strchr(cur1, '.');
+		next2 = strchr(cur2, '.');
+
+		/* kstrtou8 could fail for dot */
+		if (next1) {
+			*next1 = '\0';
+			next1++;
+		}
+
+		if (next2) {
+			*next2 = '\0';
+			next2++;
+		}
+
 		/* extract leading version numbers */
-		if (kstrtou8(ver1, 10, &num1) < 0)
+		if (kstrtou8(cur1, 10, &num1) < 0)
 			return -1;
 
-		if (kstrtou8(ver2, 10, &num2) < 0)
+		if (kstrtou8(cur2, 10, &num2) < 0)
 			return -1;
 
 		/* if numbers differ, then set the result */
 		if (num1 < num2)
+			return -1;
+		if (num1 > num2)
+			return 1;
+
+		/* if numbers are the same, go to next level */
+		if (!next1 && !next2)
+			break;
+		else if (!next1) {
 			result = -1;
-		else if (num1 > num2)
+		} else if (!next2) {
 			result = 1;
-		else {
-			/* if numbers are the same, go to next level */
-			ver1 = strchr(ver1, '.');
-			ver2 = strchr(ver2, '.');
-			if (!ver1 && !ver2)
-				break;
-			else if (!ver1)
-				result = -1;
-			else if (!ver2)
-				result = 1;
-			else {
-				ver1++;
-				ver2++;
-			}
+		} else {
+			cur1 = next1;
+			cur2 = next2;
 		}
 	}
+
 	return result;
 }
 
diff --git a/tools/bpf/example b/tools/bpf/example
new file mode 100644
index 0000000..a0ac81f
--- /dev/null
+++ b/tools/bpf/example
@@ -0,0 +1,12 @@
+  ldh [12]
+  jne #0x8100, nonvlan
+  ldh [16]
+  jne #0x88f7, bad
+  ldb [18]
+  ja test
+  nonvlan: jne #0x88f7, bad
+  ldb [14]
+  test: and #0x8
+  jeq #0, bad
+  good: ret #1500
+  bad: ret #0
diff --git a/tools/bpf/novlan b/tools/bpf/novlan
new file mode 100644
index 0000000..fe35288
--- /dev/null
+++ b/tools/bpf/novlan
@@ -0,0 +1,7 @@
+  ldh [12]
+  jne #0x88f7, bad
+  ldb [14]
+  and #0x8
+  jeq #0, bad
+  good: ret #1500
+  bad: ret #0
-- 
2.7.4

