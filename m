Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BDB2F35A0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406653AbhALQYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:24:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39024 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405066AbhALQYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:24:18 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CG1hQa126191;
        Tue, 12 Jan 2021 11:21:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=paLRmvM9tWH/aZucxaw80t62pU4jZGiL2uufSbH20ps=;
 b=cqvKAebD98i9vy7Sk0YEkWcw8URw1u8SyCNM55fMyIa1lXSUGq0tEVhRO4qZbUc1oWEC
 5mbzn8kuwg0XCLAzYjw72K8byDwBG0D90gumec6UMBjPfZRTkzrULZ4HWJvsBrWxv0Nb
 82fjScG1byPWenn5A1XjJS2wMLVPrYEDdgfas7FSRBBVOk8mhWSFRaLk3D3g5VnEvI0c
 o2tYRJ4lF5+ECjfc8vLbvwYe/vLNRnbRXJ3LNTN0HBYRI958szqF1EPTLdq3dXcx7Eeb
 DgR2BWm4+maYleQG7PWvpmcvZ/NTz2Pczvp4mm6ZJqBp5bPlABctBGk2PX1fG5Nncljw dw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361b5f0rc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:21:32 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CGIRcQ024466;
        Tue, 12 Jan 2021 16:21:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448bvdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:21:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CGLRMI44564880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:21:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CDD0A4053;
        Tue, 12 Jan 2021 16:21:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07310A4040;
        Tue, 12 Jan 2021 16:21:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:21:26 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH net 0/2] net/smc: fix out of bound access in netlink interface
Date:   Tue, 12 Jan 2021 17:21:20 +0100
Message-Id: <20210112162122.26832-1-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 phishscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please apply the following patch for smc to netdev's net tree.

Both patches fix possible out-of-bounds reads. The original code expected
that snprintf() reads len-1 bytes from source and appends the terminating
null, but actually snprintf() first copies len bytes and finally overwrites
the last byte with a null.
Fix this by using memcpy() and terminating the string afterwards.

Guvenc Gulce (1):
  net/smc: use memcpy instead of snprintf to avoid out of bounds read

Jakub Kicinski (1):
  smc: fix out of bound access in smc_nl_get_sys_info()

 net/smc/smc_core.c | 20 +++++++++++++-------
 net/smc/smc_ib.c   |  6 +++---
 net/smc/smc_ism.c  |  3 ++-
 3 files changed, 18 insertions(+), 11 deletions(-)

-- 
2.17.1

