Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CCC203571
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgFVLPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:15:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728215AbgFVLPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:15:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB4TS7006545;
        Mon, 22 Jun 2020 04:15:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=TmPgcOEbZZLryZkT7gjyoSSvEgnovXaI76YL4tTdk08=;
 b=sFJoh8FZ5eG6EQPiXJOSlcXShYf+HP5+ft0o+m2U+w0HmvKr0f7UMv3KvD7duYQT+ssN
 FRUsF3cTAFQBQnC6aWqFuluqPseqsTo4k5hMLwhZgg6fzyQfaYyuenvq81dX5yxNJgAJ
 nl2/nqyF4bOjVCdYRFgwUSNV6GaxRyJR6Jpx/XMwQ61wiOtow/GTEamyO+bWk3zB0Y6F
 kETLYCGAgBN2kZ3TV3jkRYYnucJk/A5G/AlBW+aI0vnPS9FizxvBwNfbdzuNW6FzOr7L
 gQlzsxJWfOMZOrsTvJv92VvvpTzNok7P+eZYKNovVzdvsIw8DnE0LldJSEyHstQepAGa sQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpg5y2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:15:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:15:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:15:02 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 4A8BA3F703F;
        Mon, 22 Jun 2020 04:14:58 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 9/9] net: qed: fix "maybe uninitialized" warning
Date:   Mon, 22 Jun 2020 14:14:13 +0300
Message-ID: <20200622111413.7006-10-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'abs_ppfid' in qed_dev.c:qed_llh_add_mac_filter() always gets
printed, but is initialized only under 'ref_cnt == 1' condition. This
results in:

In file included from ./include/linux/kernel.h:15:0,
                 from ./include/asm-generic/bug.h:19,
                 from ./arch/x86/include/asm/bug.h:86,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/io.h:11,
                 from drivers/net/ethernet/qlogic/qed/qed_dev.c:35:
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_add_mac_filter':
./include/linux/printk.h:358:2: warning: 'abs_ppfid' may be used uninitialized
in this function [-Wmaybe-uninitialized]
  printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
drivers/net/ethernet/qlogic/qed/qed_dev.c:983:17: note: 'abs_ppfid' was declared
here
  u8 filter_idx, abs_ppfid;
                 ^~~~~~~~~

...under W=1+.

Fix this by initializing it with zero.

Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
offload protocols")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index b41ada668948..3aa51374e727 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -980,7 +980,7 @@ int qed_llh_add_mac_filter(struct qed_dev *cdev,
 	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
 	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
 	union qed_llh_filter filter = {};
-	u8 filter_idx, abs_ppfid;
+	u8 filter_idx, abs_ppfid = 0;
 	u32 high, low, ref_cnt;
 	int rc = 0;
 
-- 
2.21.0

