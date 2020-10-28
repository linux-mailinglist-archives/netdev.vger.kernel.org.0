Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965F29E261
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgJ2CNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:13:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgJ1VgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:36:08 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S5X4Jo153190
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=3J51ROhNb8IZ7wUqakH3MoMC7GXFduu6ajKEZiYvJJ8=;
 b=q7O9EwsuV+DztoIF6TpiejM4OwNJzrC81Xw1uT9dZFtX8pdYgcvMzmALAO9yK5K7CN0p
 cy2bx89ndh3KkyGD+R07Z+4nSN4b9nTt8nXFUmofOMSENG3fFqcou/G0Hmr1vngQpm7z
 GwsXs6LXIudczE9epNnBVvk9vPeglffzvdY8FPAk9xuft5eI4ZNehImKJzkQU+fyyf9v
 GtzPbE9YiEUdnQRK0+uBvmgAjk0O3IP+pX3OYn9eKwpPB8iBNgS8lODtPYHH9xadb1tg
 GTU6Pgfzl8xLOkN8wXlDUQ2x//hhMbkRQAt6oFrPLUB+/CWUFx976/RIsaJi3hVUr71f GA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34endjfhc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 01:57:45 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S5uYlD018539
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:44 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 34ernqbgq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 05:57:44 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S5vZUQ28311986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 05:57:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A4D1136060;
        Wed, 28 Oct 2020 05:57:43 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9C08136051;
        Wed, 28 Oct 2020 05:57:42 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.105])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 05:57:42 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 0/2] ibmvnic: fixes in reset path
Date:   Wed, 28 Oct 2020 00:57:40 -0500
Message-Id: <20201028055742.74941-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=415 mlxscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0 suspectscore=1
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1/2 notifies peers in failover and migration reset.
Patch 2/2 skips timeout reset if it is already resetting.

Lijun Pan (2):
  ibmvnic: notify peers when failover and migration happen
  ibmvnic: skip tx timeout reset while in resetting

 drivers/net/ethernet/ibm/ibmvnic.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
2.23.0

