Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0734B195501
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0KTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:19:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgC0KTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:19:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02RABZtF104644
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:49 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywd8gs4rw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:19:49 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 27 Mar 2020 10:19:41 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 27 Mar 2020 10:19:37 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02RAJg6x26476904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 10:19:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C17254C04A;
        Fri, 27 Mar 2020 10:19:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89F1F4C040;
        Fri, 27 Mar 2020 10:19:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 27 Mar 2020 10:19:42 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/3] s390/qeth: phase out OSN support
Date:   Fri, 27 Mar 2020 11:19:34 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327101934.31040-1-jwi@linux.ibm.com>
References: <20200327101934.31040-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032710-0016-0000-0000-000002F90CA6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032710-0017-0000-0000-0000335CBD45
Message-Id: <20200327101934.31040-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-27_02:2020-03-26,2020-03-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OSN devices currently spend an awful long time in qeth_l2_set_online()
until various unsupported HW cmds time out. This has been broken for
over two years, ever since
commit d22ffb5a712f ("s390/qeth: fix IPA command submission race")
triggered a FW bug in cmd processing.
Prior to commit 782e4a792147 ("s390/qeth: don't poll for cmd IO completion"),
this wait for timeout would have even been spent busy-polling.

The offending patch was picked up by stable and all relevant distros,
and yet noone noticed.
OSN setups only ever worked in combination with an out-of-tree blob, and
the last machine that even offered HW with OSN support was released back
in 2015.

Rather than attempting to work-around this FW issue for no actual gain,
add a deprecation warning so anyone who still wants to maintain this
part of the code can speak up. Else rip it all out in 2021.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/Kconfig        | 1 +
 drivers/s390/net/qeth_l2_main.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index 36633387b952..3850a0f5f0bc 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -97,6 +97,7 @@ config QETH_OSN
 	depends on QETH
 	help
 	  This enables the qeth driver to support devices in OSN mode.
+	  This feature will be removed in 2021.
 	  If unsure, choose N.
 
 config QETH_OSX
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 974b4596b78d..0bd5b09e7a22 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -587,6 +587,9 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 	int rc;
 
+	if (IS_OSN(card))
+		dev_notice(&gdev->dev, "OSN support will be dropped in 2021\n");
+
 	qeth_l2_vnicc_set_defaults(card);
 	mutex_init(&card->sbp_lock);
 
-- 
2.17.1

