Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C0D2F359E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406600AbhALQYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:24:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406223AbhALQYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:24:18 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CG5xc4108378;
        Tue, 12 Jan 2021 11:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rn+ySfhXnGu8/YCaffC4V1KWNwNa23AcT8SmxKYW96E=;
 b=rC2qvKPlo7RgywN4AxsxI7TnTHfZDQYoLstvrT+WDLwdvaTWuRGWDeXkXz5s6aZONxYn
 /u6W4hAALLHNLtScDDlSfpE2PHZdMMDb92bOffGqXDdYBx417UePcPpLPt5P01O6tMPa
 rdlvLv4+8fjeW50qUuuuTSJKS4eN9ISXoWjdyWznh413Z++uzDT8YpKRxHsybnV7QZLp
 +E7vWYQz2peW5CdS8Lt/35vvKKbTAQa+KrSubKFUSYsEanXwXxpSn32kBKf7hCl7p6iT
 /sTRAYklxtpBxyxLApSbqT4vOR8EtPtbewBbksKh4iiDURkcTzIA5V9Co6iPgrgdKfTl fw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361e7yswb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:21:32 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGIEC5024447;
        Tue, 12 Jan 2021 16:21:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448bvdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:21:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGLSnW42074618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:21:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 227E6A4051;
        Tue, 12 Jan 2021 16:21:28 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A98AFA404D;
        Tue, 12 Jan 2021 16:21:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:21:27 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net 1/2] smc: fix out of bound access in smc_nl_get_sys_info()
Date:   Tue, 12 Jan 2021 17:21:21 +0100
Message-Id: <20210112162122.26832-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112162122.26832-1-kgraul@linux.ibm.com>
References: <20210112162122.26832-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

smc_clc_get_hostname() sets the host pointer to a buffer
which is not NULL-terminated (see smc_clc_init()).

Reported-by: syzbot+f4708c391121cfc58396@syzkaller.appspotmail.com
Fixes: 099b990bd11a ("net/smc: Add support for obtaining system information")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 59342b519e34..8d866b4ed8f6 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -246,7 +246,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		goto errattr;
 	smc_clc_get_hostname(&host);
 	if (host) {
-		snprintf(hostname, sizeof(hostname), "%s", host);
+		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
+		hostname[SMC_MAX_HOSTNAME_LEN] = 0;
 		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname))
 			goto errattr;
 	}
-- 
2.17.1

