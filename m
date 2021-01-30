Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9810B309431
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhA3KP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:15:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232847AbhA3BUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 20:20:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10U112RK087474
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9YED22CWtFd+6cT8x7MBowUup7yRKMdr4ncsqv/Lvt0=;
 b=CoZZSIOvTsVVauVCPezKMfdk0WGge/2qehFeplzGgYO3bpYYQiYT/g7V6iha28x7s82O
 zWAFQ6jqey49ghOrI7WxH9C3PudT2QdTUSZ2i+tGl3y3XP21CWihvO4nsjhgyjOtPfBb
 GH4O5y8aPT0SR6iAyUlizmfkdo+WauUmujy7tca1EkDqcTTh3m0sreYhoI5feHDGj1eK
 VD8gC3GqFua546bKF3semmD4Qr//PnCZN3XxeORufcrtfehr66Zsa+uJ39YsoaMeX1pc
 8LJ/0gyHMVg2DPd7OndpUgXlXZp0UsWb+0hOdgupsZ0wN2DW7unC+L2iQ6y4j0vguY+W IQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36cwct09um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 20:19:10 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10U1D0R7016405
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 36adtum0y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 01:19:10 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10U1J78h27984134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 01:19:07 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D2FEBE056;
        Sat, 30 Jan 2021 01:19:07 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D6D4BE04F;
        Sat, 30 Jan 2021 01:19:06 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.192.149])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 30 Jan 2021 01:19:06 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        brking@linux.vnet.ibm.com, dnbanerg@us.ibm.com,
        tlfalcon@linux.ibm.com, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 0/2] rework the memory barrier for SCRQ entry 
Date:   Fri, 29 Jan 2021 19:19:03 -0600
Message-Id: <20210130011905.1485-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-29_11:2021-01-29,2021-01-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=725
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series rework the memory barrier for SCRQ (Sub-Command-Response
Queue) entry.

v2: send to net-next.

Lijun Pan (2):
  ibmvnic: rework to ensure SCRQ entry reads are properly ordered
  ibmvnic: remove unnecessary rmb() inside ibmvnic_poll

 drivers/net/ethernet/ibm/ibmvnic.c | 31 +++++++++++-------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

-- 
2.23.0

