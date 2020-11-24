Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0E2C2C2E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390124AbgKXQCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:02:00 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:52936 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390118AbgKXQCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:02:00 -0500
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0AOG1w4Y013814;
        Tue, 24 Nov 2020 11:01:58 -0500
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 34xwxksspc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 11:01:58 -0500
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 24 Nov 2020 11:01:56 -0500
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 24 Nov 2020 11:01:56 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
Date:   Tue, 24 Nov 2020 11:01:26 -0500
Message-ID: <1606233686-22785-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxlogscore=925 adultscore=0
 spamscore=0 suspectscore=4 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240099
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Feed kstrtou8 with NULL terminated string.

Changes since v1:
-Use sscanf to get rid of adhoc string parse.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 53 +++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index e020faf..12d939f 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -103,43 +103,26 @@ static int timespec_to_char_array(struct timespec64 const *ts,
 	return 0;
 }
 
-static int idtcm_strverscmp(const char *ver1, const char *ver2)
+static int idtcm_strverscmp(const char *version1, const char *version2)
 {
-	u8 num1;
-	u8 num2;
-	int result = 0;
-
-	/* loop through each level of the version string */
-	while (result == 0) {
-		/* extract leading version numbers */
-		if (kstrtou8(ver1, 10, &num1) < 0)
-			return -1;
-
-		if (kstrtou8(ver2, 10, &num2) < 0)
-			return -1;
-
-		/* if numbers differ, then set the result */
-		if (num1 < num2)
-			result = -1;
-		else if (num1 > num2)
-			result = 1;
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
-		}
+	u8 ver1[3], ver2[3];
+	int i;
+
+	if (sscanf(version1, "%hhu.%hhu.%hhu",
+		   &ver1[0], &ver1[1], &ver1[2]) < 0)
+		return -1;
+	if (sscanf(version2, "%hhu.%hhu.%hhu",
+		   &ver2[0], &ver2[1], &ver2[2]) < 0)
+		return -1;
+
+	for (i = 0; i < 3; i++) {
+		if (ver1[i] > ver2[i])
+			return 1;
+		if (ver1[i] < ver2[i])
+			return -1;		
 	}
-	return result;
+
+	return 0;		
 }
 
 static int idtcm_xfer_read(struct idtcm *idtcm,
-- 
2.7.4

