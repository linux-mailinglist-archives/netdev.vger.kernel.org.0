Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEB52BB933
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgKTWkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:40:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1066 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgKTWkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:40:18 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMW48V110297
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=WPu3zj29MDGiTIrLcB5SMclP8U3bqc9SxpLFBFkj8pA=;
 b=qbSGvUXONgYlsPz8NyZWecLjCYSlz8ALDTTQdg2IOvEudbvohPV5Iann4mrdwxqcLbcb
 VVLtmDlXBUymVEY8914a4OkOCPPDbvv5hvqlh7te8oWgWz64xltiTI1qwHdaMeEvat02
 RJ7INzr9AleV02KA0vFLTR/k6ty6dqI7iUlKnoLv8NshiduMvEgHhUUXMagBWS6DsJVN
 Xb3WYrFxGFk1N18jGLWyF5ec70H1jqC7a5nU74Y/bpxZhh0uwlI81HX5Z0iyJ5yBxq1W
 aPbnQFdSSnr2e2c9iqPPdm4iywcLHIIqDoZmC+MKnuXxIrjBcLYuKI/jPIz8hy6F1fIh eQ== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xgf540xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:40:17 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMbPuA024842
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 34t6v9sr6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:40:16 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMe6Za40370552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:06 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 299246E059;
        Fri, 20 Nov 2020 22:40:15 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FBF16E052;
        Fri, 20 Nov 2020 22:40:14 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:14 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net v2 0/3] ibmvnic: fixes in reset path
Date:   Fri, 20 Nov 2020 16:40:10 -0600
Message-Id: <20201120224013.46891-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=488 suspectscore=1 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1/3 and 2/3 notify peers in failover and migration reset.
Patch 3/3 skips timeout reset if it is already resetting.

Lijun Pan (3):
  ibmvnic: fix call_netdevice_notifiers in do_reset
  ibmvnic: notify peers when failover and migration happen
  ibmvnic: skip tx timeout reset while in resetting

 drivers/net/ethernet/ibm/ibmvnic.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
2.23.0

