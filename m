Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9E3E4195
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhHIIcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:32:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233677AbhHIIb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 04:31:59 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17984F5K143755;
        Mon, 9 Aug 2021 04:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qHzsKy2DHHYwJaK9WEdoVlvpnfRA2AuXx41hLYP+LZc=;
 b=hvmyl3Lxu/ajvRUBUQk2QAwPQo9JcJ6MQyhsXkNsN9h8F5HVNDkYAoUmCMIYr3RQTB8A
 HQvd3R6LOcCwq1EW3NBPNz09NpauilUFN+k1aeMcboVlL2xKcZIx1ykiOSQzayXWuR72
 EPwSTzAcag7jo21XJF0JgRJNidXeMtZznHkPOgDDLI3sdgfBLX95oURtLKfgO6Vm9EZs
 aaE365+3k7j8aIP/L4fnsTwTl79VZrc9dDPSLoHmCcV4hfDlgTK2W12wuBoquCiXf3kI
 LmtmHcdWWKkV4IZZ6ormJr7XjEYLjhy91xeXfGBE68eStzfJVR/W7HitEjCkbOf0P16M 0g== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aa7qagf99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 04:31:34 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1798R9cK025651;
        Mon, 9 Aug 2021 08:31:32 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3a9ht8un2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Aug 2021 08:31:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1798VRTp52560250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Aug 2021 08:31:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72815A4078;
        Mon,  9 Aug 2021 08:31:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C655A405B;
        Mon,  9 Aug 2021 08:31:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Aug 2021 08:31:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 2/5] net/af_iucv: clean up a try_then_request_module()
Date:   Mon,  9 Aug 2021 10:30:47 +0200
Message-Id: <20210809083050.2328336-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809083050.2328336-1-kgraul@linux.ibm.com>
References: <20210809083050.2328336-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0NZmGPNfjeJ96P-7XNG0dulmn-R1lLHa
X-Proofpoint-ORIG-GUID: 0NZmGPNfjeJ96P-7XNG0dulmn-R1lLHa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-09_01:2021-08-06,2021-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 phishscore=0 clxscore=1015 mlxlogscore=989 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Use IS_ENABLED(CONFIG_IUCV) to determine whether the iucv_if symbol
is available, and let depmod deal with the module dependency.

This was introduced back with commit 6fcd61f7bf5d ("af_iucv: use
loadable iucv interface"). And to avoid sprinkling IS_ENABLED() over
all the code, we're keeping the indirection through pr_iucv->...().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/af_iucv.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index c8fbfc0be2e5..4bff26f7faff 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2278,7 +2278,7 @@ static int __init afiucv_init(void)
 {
 	int err;
 
-	if (MACHINE_IS_VM) {
+	if (MACHINE_IS_VM && IS_ENABLED(CONFIG_IUCV)) {
 		cpcmd("QUERY USERID", iucv_userid, sizeof(iucv_userid), &err);
 		if (unlikely(err)) {
 			WARN_ON(err);
@@ -2286,11 +2286,7 @@ static int __init afiucv_init(void)
 			goto out;
 		}
 
-		pr_iucv = try_then_request_module(symbol_get(iucv_if), "iucv");
-		if (!pr_iucv) {
-			printk(KERN_WARNING "iucv_if lookup failed\n");
-			memset(&iucv_userid, 0, sizeof(iucv_userid));
-		}
+		pr_iucv = &iucv_if;
 	} else {
 		memset(&iucv_userid, 0, sizeof(iucv_userid));
 		pr_iucv = NULL;
@@ -2324,17 +2320,13 @@ static int __init afiucv_init(void)
 out_proto:
 	proto_unregister(&iucv_proto);
 out:
-	if (pr_iucv)
-		symbol_put(iucv_if);
 	return err;
 }
 
 static void __exit afiucv_exit(void)
 {
-	if (pr_iucv) {
+	if (pr_iucv)
 		afiucv_iucv_exit();
-		symbol_put(iucv_if);
-	}
 
 	unregister_netdevice_notifier(&afiucv_netdev_notifier);
 	dev_remove_pack(&iucv_packet_type);
-- 
2.25.1

