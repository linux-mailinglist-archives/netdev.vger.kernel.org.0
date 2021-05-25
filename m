Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FFD3900C7
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhEYMWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:22:43 -0400
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:54352 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229896AbhEYMWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:22:41 -0400
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
        by mx0b-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14PCB0AX014965;
        Tue, 25 May 2021 07:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=PODMain02222019;
 bh=SYnmenIZ9zgOw2CHiZgZxkwihTFmJdiQtcHas3VnnSA=;
 b=JGY8Xmql5z96/G+gNmoi75lBDbcHqmApswoM6nQTVFTmnTktNe/Qb5LeStWLSmSQg44K
 NNWX/wRF7Rb4hPSiFcHBd5L2H+rLwg2nnejnHq+pefJthzPA9ZUm3zD0DACBCwyWavFB
 D2Ym+Ma/3tt46d3zhU2KFnoG1XutuVWpC6AXiYpRvqLWLbRQr3J4Sedch/Z9+AEJmRRx
 jsjGFRgE3LEseMEQzC+TWbxJ2r9Js33i5LvM1+ouuJ16uf9w1WCyfMBZGJjTjkn861Lf
 V8McDOnuCAPrbywr5YJaOUI5KYgkxWZpo5K96KbgiErQ7luuwNNTujfsAbyz8heU6q51 sw== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0b-001ae601.pphosted.com with ESMTP id 38r28v1u88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 May 2021 07:20:15 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 25 May
 2021 13:20:14 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.2242.4 via Frontend
 Transport; Tue, 25 May 2021 13:20:14 +0100
Received: from AUSNPC0LSNW1-debian.cirrus.com (AUSNPC0LSNW1.ad.cirrus.com [198.61.64.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id E20C911CD;
        Tue, 25 May 2021 12:20:12 +0000 (UTC)
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
To:     <pmladek@suse.com>, <rostedt@goodmis.org>,
        <sergey.senozhatsky@gmail.com>,
        <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
        <w@1wt.eu>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: [PATCH v2 0/2] Fix truncation warnings from building test_scanf.c
Date:   Tue, 25 May 2021 13:20:10 +0100
Message-ID: <20210525122012.6336-1-rf@opensource.cirrus.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BVnXRabOiOXNTqI9hqi731l8xINbs9bJ
X-Proofpoint-GUID: BVnXRabOiOXNTqI9hqi731l8xINbs9bJ
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=517 bulkscore=0 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250075
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

