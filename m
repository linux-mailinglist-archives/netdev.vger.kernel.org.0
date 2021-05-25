Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A938FFC0
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhEYLJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:09:14 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:60156 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229589AbhEYLJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:09:14 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PAwx1f026449;
        Tue, 25 May 2021 06:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PODMain02222019;
 bh=sMXRfFxxDe5sgWm8F/W9+A5OjMQbgNJ3yswWataFJos=;
 b=EudGp/MxoHFH2u8muCVtwWMYUFPhB5dguashSsy76doi1k51y3ljtVX/8Pu9KeDkhcwn
 EZfharGrcecTlYavBIglVHGq8AB9GRBfSQNrRKsw1N+dfUVYkPY7DHtXg/rY5u5QNtVo
 /sn98fgYv72tMmfXjCS0qYE0Xlmxz3Op61tCjAE/DML8G+aKnvNqiEZczuGeMAc9nROj
 uc27w1QCt6rsdo00nvdruVq9W7krmGrIdbTZwZ4u1txIwhX1+2GpJtg1/k2fbVyEjFxw
 KodRnuk75XldDYNDho8Y82ZyR/R4oFLC2MCOcNsGpjtZjPJq37cc1if0ruskzkFvDJhI QQ== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 38r7ck9hjj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 May 2021 06:05:50 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 25 May
 2021 12:05:48 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Tue, 25 May 2021 12:05:48 +0100
Received: from AUSNPC0LSNW1-debian.cirrus.com (AUSNPC0LSNW1.ad.cirrus.com [198.61.64.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id D6CA611CD;
        Tue, 25 May 2021 11:05:47 +0000 (UTC)
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
To:     <pmladek@suse.com>, <rostedt@goodmis.org>,
        <sergey.senozhatsky@gmail.com>,
        <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
        <w@1wt.eu>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH v2 1/2] lib: test_scanf: Remove pointless use of type_min() with unsigned types
Date:   Tue, 25 May 2021 12:05:45 +0100
Message-ID: <20210525110546.6223-2-rf@opensource.cirrus.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525110546.6223-1-rf@opensource.cirrus.com>
References: <20210525110546.6223-1-rf@opensource.cirrus.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: TrTyJdK0cLXj_yEVg_luexfqZOBYsM1P
X-Proofpoint-ORIG-GUID: TrTyJdK0cLXj_yEVg_luexfqZOBYsM1P
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=978
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse was producing warnings of the form:

 sparse: cast truncates bits from constant value (ffff0001 becomes 1)

There is no actual problem here. Using type_min() on an unsigned type
results in an (expected) truncation.

However, there is no need to test an unsigned value against type_min().
The minimum value of an unsigned is obviously 0, and any value cast to
an unsigned type is >= 0, so for unsigneds only type_max() need be tested.

This patch also takes the opportunity to clean up the implementation of
simple_numbers_loop() to use a common pattern for the positive and
negative test.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
---
 lib/test_scanf.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/test_scanf.c b/lib/test_scanf.c
index 8d577aec6c28..48ff5747a4da 100644
--- a/lib/test_scanf.c
+++ b/lib/test_scanf.c
@@ -187,8 +187,8 @@ static const unsigned long long numbers[] __initconst = {
 #define value_representable_in_type(T, val)					 \
 (is_signed_type(T)								 \
 	? ((long long)(val) >= type_min(T)) && ((long long)(val) <= type_max(T)) \
-	: ((unsigned long long)(val) >= type_min(T)) &&				 \
-	  ((unsigned long long)(val) <= type_max(T)))
+	: ((unsigned long long)(val) <= type_max(T)))
+
 
 #define test_one_number(T, gen_fmt, scan_fmt, val, fn)			\
 do {									\
@@ -204,12 +204,11 @@ do {									\
 	int i;								\
 									\
 	for (i = 0; i < ARRAY_SIZE(numbers); i++) {			\
-		if (!value_representable_in_type(T, numbers[i]))	\
-			continue;					\
+		if (value_representable_in_type(T, numbers[i]))		\
+			test_one_number(T, gen_fmt, scan_fmt,		\
+					numbers[i], fn);		\
 									\
-		test_one_number(T, gen_fmt, scan_fmt, numbers[i], fn);	\
-									\
-		if (is_signed_type(T))					\
+		if (value_representable_in_type(T, -numbers[i]))	\
 			test_one_number(T, gen_fmt, scan_fmt,		\
 					-numbers[i], fn);		\
 	}								\
-- 
2.20.1

