Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442D02C2E79
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 18:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbgKXR0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 12:26:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390777AbgKXR0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 12:26:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOH4ZIs159506;
        Tue, 24 Nov 2020 12:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=vTB1+f0FDreX/k8U727Z/d3cLYhfd2XTM4Dj4d7tRzY=;
 b=SvUGd9qbIK1bRJA7RYE91sPGx2O5WgL0LDXhbZJNc10sjIAM4GCC5UYyXhhZbF+9AW1w
 8ckbwZMrT5Qg+p8g58Vjxs457Xw9fxPDz/kTltr7kTCXOPAkdfszNa8e/xWBKD0x2jal
 eJeH+HIVORM14lcx8OD7h4m0H2Tuc6CZgMMKq/Ng8wt7R8JPWy3TW0jREG1+aJUowNxb
 C2zDCTCnUVARiqW7mmbzlZ1bqzMcd2vsJMxsyKPDzWdkka9D5v52xpXGoPL6Dtukk1Ka
 SGQphRAq5uIcTwOF3jXN/lDjtUBha1tuesAf4A7c9Mw3As7iOJSr651M02VTJF48dCre Bw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350fe1e62t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 12:26:26 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOHN9df004578;
        Tue, 24 Nov 2020 17:26:25 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 35133nsg7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 17:26:25 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOHQOtS47317342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 17:26:24 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26DE76A04F;
        Tue, 24 Nov 2020 17:26:24 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF50D6A04D;
        Tue, 24 Nov 2020 17:26:21 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.17.166])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 17:26:21 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, cforno12@linux.ibm.com,
        ljp@linux.vnet.ibm.com, ricklind@linux.ibm.com,
        dnbanerg@us.ibm.com, drt@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        tlfalcon@linux.ibm.com
Subject: [PATCH net 0/2] ibmvnic: Bug fixes for queue descriptor processing
Date:   Tue, 24 Nov 2020 11:26:14 -0600
Message-Id: <1606238776-30259-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_05:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=937
 phishscore=0 impostorscore=0 suspectscore=1 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series resolves a few issues in the ibmvnic driver's
RX buffer and TX completion processing. The first patch
includes memory barriers to synchronize queue descriptor
reads. The second patch fixes a memory leak that could
occur if the device returns a TX completion with an error
code in the descriptor, in which case the respective socket
buffer and other relevant data structures may not be freed
or updated properly.

Thomas Falcon (2):
  ibmvnic: Ensure that SCRQ entry reads are correctly ordered
  ibmvnic: Fix TX completion error handling

 drivers/net/ethernet/ibm/ibmvnic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
1.8.3.1

