Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE5F38FFC2
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhEYLJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:09:18 -0400
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:9778 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231321AbhEYLJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 07:09:15 -0400
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PAwx1e026449;
        Tue, 25 May 2021 06:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=PODMain02222019;
 bh=SYnmenIZ9zgOw2CHiZgZxkwihTFmJdiQtcHas3VnnSA=;
 b=PtZq7/mzPHfHv95s+p5Nz9Y3t4ALom5C9tO5ac19XgdfsJ/oj7zJhrIXVafUmz/U2k2t
 54A5VicBtP+oLTBNZLLMmwTBTYuoo4sLg5dZcnBPB2RHYonEdKv1AX6jpaFeUDN0z8Fu
 OrKNuH30cEwfLhm20uFp1pjPSMzBhnvzr5LYeYnH3PK9mDaAgFlMlhb/IC50p+Iwbxel
 M1FSRU3uzdfaTwaFYAGy8z6XbGW4qzOwnz2xT+uTIZ0yMc944bDeY57us9vYYYhWXqvQ
 ubZNOKb5ram8LJfEnwapUh8k3xpmC4LKPd5I/e2up5VXzrvihYr+F/bjp+8VQ4ItIgMU 9g== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 38r7ck9hjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 May 2021 06:05:49 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 25 May
 2021 12:05:47 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Tue, 25 May 2021 12:05:47 +0100
Received: from AUSNPC0LSNW1-debian.cirrus.com (AUSNPC0LSNW1.ad.cirrus.com [198.61.64.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id A47AE11D6;
        Tue, 25 May 2021 11:05:46 +0000 (UTC)
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
To:     <pmladek@suse.com>, <rostedt@goodmis.org>,
        <sergey.senozhatsky@gmail.com>,
        <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
        <w@1wt.eu>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH v2 0/2] Fix truncation warnings from building test_scanf.c
Date:   Tue, 25 May 2021 12:05:44 +0100
Message-ID: <20210525110546.6223-1-rf@opensource.cirrus.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Ye2n17YzxIR7eOQ0pvihzd0q99S_Hm3v
X-Proofpoint-ORIG-GUID: Ye2n17YzxIR7eOQ0pvihzd0q99S_Hm3v
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=517
 adultscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot is reporting truncation warnings when building
lib/test_scanf.c:

1) lib/test_scanf.c:250:9: sparse: sparse: cast truncates bits from
   constant value (ffff0001 becomes 1)
   Reported on several lines.

2) include/linux/prandom.h:114:45: sparse: sparse: cast truncates bits
   from constant value (4f2e5357408c3c09 becomes 408c3c09)

(1) is caused by test_scanf.c using type_min() on an unsigned type. The
truncation is expected but the use of type_min() on an unsigned is
unnecessary because we know it is always 0.

(2) is caused by prandom_seed_state() storing a modified u64 seed value
into a u32 - sparse will warn that this causes a truncation. 

The two patches in this series fix these problems.

Richard Fitzgerald (2):
  lib: test_scanf: Remove pointless use of type_min() with unsigned
    types
  random32: Fix implicit truncation warning in prandom_seed_state()

 include/linux/prandom.h |  2 +-
 lib/test_scanf.c        | 13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.20.1

