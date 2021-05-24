Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F61738F06D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 18:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhEXQDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 12:03:13 -0400
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:28142 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235232AbhEXQCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 12:02:11 -0400
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
        by mx0b-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14OFv7WJ009692;
        Mon, 24 May 2021 10:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=PODMain02222019;
 bh=vya4tQLbOwdXYjjpNFcaCOnKgB/GZnuuq+u5BiZuNrM=;
 b=ZA3TB9e13K1Swbd2ErvVaCHFoH0BVnchWUS5IxSkP9LY2/gkGL82Nam7ya7OoM3RVXn0
 YB4oDv7fq91Ix78+QMvR/4U+yilORnVE7xDes3Lg0+jYqpuGm9OrDwgZhMsFFJF7xe8X
 x2TWk5wkL2qGqooEjzZ6HRzwFf1ikJulWE0rtJrpw9X7UITHSDgM8VQODbi7cZwIGHMV
 872QthIS6G/eww74vhWKqHXcbJY7ES6BWU0M1ecojtQTDkSbW3Y4SaXR5KYBYy5nm/SS
 i58h1Zo/IKdQI21g6aGiZ39L+VT1JkaRCxqt/R9Y48b+tFcLTL2PM0T9+QTXEOOKyAzd bQ== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0b-001ae601.pphosted.com with ESMTP id 38r28v0qh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 May 2021 10:59:45 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Mon, 24 May
 2021 16:59:43 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Mon, 24 May 2021 16:59:43 +0100
Received: from AUSNPC0LSNW1-debian.cirrus.com (AUSNPC0LSNW1.ad.cirrus.com [198.61.64.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id B8C6F11CD;
        Mon, 24 May 2021 15:59:42 +0000 (UTC)
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
To:     <pmladek@suse.com>, <rostedt@goodmis.org>,
        <sergey.senozhatsky@gmail.com>,
        <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
        <w@1wt.eu>, <lkml@sdf.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH 1/2] lib: test_scanf: Fix incorrect use of type_min() with unsigned types
Date:   Mon, 24 May 2021 16:59:40 +0100
Message-ID: <20210524155941.16376-2-rf@opensource.cirrus.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210524155941.16376-1-rf@opensource.cirrus.com>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BXgNFNGFSfi7bYzPz7h4MwZLLSXRtKus
X-Proofpoint-GUID: BXgNFNGFSfi7bYzPz7h4MwZLLSXRtKus
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=994 bulkscore=0 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse was producing warnings of the form:

 sparse: cast truncates bits from constant value (ffff0001 becomes 1)

The problem was that value_representable_in_type() compared unsigned types
against type_min(). But type_min() is only valid for signed types because
it is calculating the value -type_max() - 1. The minimum value of an
unsigned is obviously 0, so only type_max() need be tested.

This patch also takes the opportunity to clean up the implementation of
simple_numbers_loop() to use a common pattern for the positive and
negative test.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 17aadada455d ("lib: test_scanf: Add tests for sscanf number conversion")
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
-									\
-		test_one_number(T, gen_fmt, scan_fmt, numbers[i], fn);	\
+		if (value_representable_in_type(T, numbers[i]))		\
+			test_one_number(T, gen_fmt, scan_fmt,		\
+					numbers[i], fn);		\
 									\
-		if (is_signed_type(T))					\
+		if (value_representable_in_type(T, -numbers[i]))	\
 			test_one_number(T, gen_fmt, scan_fmt,		\
 					-numbers[i], fn);		\
 	}								\
-- 
2.20.1

