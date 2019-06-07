Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8F39741
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbfFGVEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:04:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730242AbfFGVED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:04:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x57L2LHL066138
        for <netdev@vger.kernel.org>; Fri, 7 Jun 2019 17:04:02 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sytmumax4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 17:04:02 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Fri, 7 Jun 2019 22:04:01 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e31.co.us.ibm.com (192.168.1.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 7 Jun 2019 22:04:00 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x57L3wAJ30081320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Jun 2019 21:03:58 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CA83C6059;
        Fri,  7 Jun 2019 21:03:58 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D53C2C605A;
        Fri,  7 Jun 2019 21:03:57 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.206.102])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  7 Jun 2019 21:03:57 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net 0/3] ibmvnic: Fixes for device reset handling
Date:   Fri,  7 Jun 2019 16:03:52 -0500
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19060721-8235-0000-0000-00000EA52B55
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011229; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01214693; UDB=6.00638533; IPR=6.00995777;
 MB=3.00027226; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-07 21:04:01
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060721-8236-0000-0000-000045EBB428
Message-Id: <1559941435-30124-1-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains three unrelated fixes to issues seen during
device resets. The first patch fixes an error when the driver requests
to deactivate the link of an uninitialized device, resulting in a 
failure to reset. Next, a patch to fix multicast transmission 
failures seen after a driver reset. The final patch fixes mishandling
of memory allocation failures during device initialization, which
caused a kernel oops.

Thomas Falcon (3):
  ibmvnic: Do not close unopened driver during reset
  ibmvnic: Refresh device multicast list after reset
  ibmvnic: Fix unchecked return codes of memory allocations

 drivers/net/ethernet/ibm/ibmvnic.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
1.8.3.1

