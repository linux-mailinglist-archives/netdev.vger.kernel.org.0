Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595972B695E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgKQQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:06:40 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:43068 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgKQQGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:06:40 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFuami023977;
        Tue, 17 Nov 2020 11:06:38 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 34ta9m1b6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:06:38 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 17 Nov 2020 11:06:36 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 17 Nov 2020 11:06:36 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net-next 1/5] ptp: clockmatrix: bug fix for idtcm_strverscmp
Date:   Tue, 17 Nov 2020 11:05:58 -0500
Message-ID: <1605629162-31876-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
References: <1605629162-31876-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 mlxlogscore=865
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170115
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Feed kstrtou8 with NULL terminated string.

Changes since v1:
-Only strcpy 15 characters to leave 1 space for '\0'

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 52 +++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e020faf..efe5639 100644
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
+	strncpy(ver1, version1, 15);
+	strncpy(ver2, version2, 15);
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
-		if (num1 < num2)
+		if (num1 < num2) {
 			result = -1;
-		else if (num1 > num2)
+		} else if (num1 > num2) {
 			result = 1;
-		else {
+		} else {
 			/* if numbers are the same, go to next level */
-			ver1 = strchr(ver1, '.');
-			ver2 = strchr(ver2, '.');
-			if (!ver1 && !ver2)
+			if (!next1 && !next2)
 				break;
-			else if (!ver1)
+			else if (!next1) {
 				result = -1;
-			else if (!ver2)
+			} else if (!next2) {
 				result = 1;
-			else {
-				ver1++;
-				ver2++;
+			} else {
+				cur1 = next1;
+				cur2 = next2;
 			}
 		}
 	}
+
 	return result;
 }
 
-- 
2.7.4

