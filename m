Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4F189C64
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCRMzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:55:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726864AbgCRMzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:55:24 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ICXD9R136294
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:23 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yu861rh04-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 08:55:22 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Mar 2020 12:55:20 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Mar 2020 12:55:17 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02ICtGvw40435978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 12:55:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61C26A405B;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2027EA4064;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Mar 2020 12:55:16 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 01/11] s390/qeth: use memory reserves to back RX buffers
Date:   Wed, 18 Mar 2020 13:54:45 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031812-0016-0000-0000-000002F332BA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031812-0017-0000-0000-00003356B7BD
Message-Id: <20200318125455.5838-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_05:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=654 mlxscore=0 suspectscore=2 adultscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003180061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_alloc_page() for backing the RX buffers with pages. This way we
pick up __GFP_MEMALLOC.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6caa78d51bd1..be3f6295309b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -244,7 +244,7 @@ static struct qeth_buffer_pool_entry *qeth_alloc_pool_entry(unsigned int pages)
 		return NULL;
 
 	for (i = 0; i < pages; i++) {
-		entry->elements[i] = alloc_page(GFP_KERNEL);
+		entry->elements[i] = __dev_alloc_page(GFP_KERNEL);
 
 		if (!entry->elements[i]) {
 			qeth_free_pool_entry(entry);
@@ -2654,7 +2654,7 @@ static struct qeth_buffer_pool_entry *qeth_find_free_buffer_pool_entry(
 			struct qeth_buffer_pool_entry, list);
 	for (i = 0; i < QETH_MAX_BUFFER_ELEMENTS(card); ++i) {
 		if (page_count(entry->elements[i]) > 1) {
-			struct page *page = alloc_page(GFP_ATOMIC);
+			struct page *page = dev_alloc_page();
 
 			if (!page)
 				return NULL;
-- 
2.17.1

