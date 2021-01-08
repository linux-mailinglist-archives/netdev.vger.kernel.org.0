Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86472EEDBB
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbhAHHNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 02:13:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13124 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbhAHHNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 02:13:21 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10873wm5041518
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 02:12:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lAfxwWr1ESakrSc/oO/rRd8hcqyaznH3DN9IpLF5xIk=;
 b=PCqr2vdzUyy9upYQqoKG8Uq9WCojN1a5wBGIxbWEllo45Ihzl617F0gesy9z4Exz9Jjx
 i53bPkQIfHWey35dQKfMYS737Q9biLl8zqJe6n/QLLmvrSuLS5Umv28ykp0Ho037yLGW
 tyFFi+OL++3WL7uQYTmQkMEY2LSgGkYYmFzpxr4xbRIVK9c8LJqR5xqX+0s3fOuxHbK0
 sttP35bC4VdUmvriZkok6Po7A6pJFPSB3aI0lkMc0KOc0CZwID3ssqOMX0LjYvx/iTsV
 2rIzMzNYgOcDQX7C8e7FnLaEav1H37O/6/nyhLS2oo1Yl0finrtsgddIXu2eX+SaZ9NV 9w== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35xjhr0eep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:12:40 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1087BpXV013487
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 07:12:39 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 35tgf9j4x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 07:12:39 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1087CcbN23658888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jan 2021 07:12:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 939B078066;
        Fri,  8 Jan 2021 07:12:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC86E7805E;
        Fri,  8 Jan 2021 07:12:37 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.139.161])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jan 2021 07:12:37 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com
Subject: [PATCH 0/7] ibmvnic: Use more consistent locking
Date:   Thu,  7 Jan 2021 23:12:29 -0800
Message-Id: <20210108071236.123769-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_04:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 mlxlogscore=366 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use more consistent locking when reading/writing the adapter->state
field. This patch set fixes a race condition during ibmvnic_open()
where the adapter could be left in the PROBED state if a reset occurs
at the wrong time. This can cause networking to not come up during
boot and potentially require manual intervention in bringing up
applications that depend on the network.

Sukadev Bhattiprolu (7):
  ibmvnic: restore state in change-param reset
  ibmvnic: update reset function prototypes
  ibmvnic: avoid allocating rwi entries
  ibmvnic: switch order of checks in ibmvnic_reset
  ibmvnic: use a lock to serialize remove/reset
  ibmvnic: check adapter->state under state_lock
  ibmvnic: add comments about adapter->state_lock

 drivers/net/ethernet/ibm/ibmvnic.c | 351 ++++++++++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.h |  70 +++++-
 2 files changed, 308 insertions(+), 113 deletions(-)

-- 
2.26.2

