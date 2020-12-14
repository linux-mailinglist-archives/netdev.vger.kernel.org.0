Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2242DA286
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503539AbgLNVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:20:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387738AbgLNVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:20:14 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEL312W137107
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=9Zw87r9LZoIgIVSdzJohfX1rAzPpUbVjgqzVAlRrC+0=;
 b=GC5zQFkhV/QLkxKjTylqbkw2JT2DI6B8+vcQCwLMJSdoHdG4s1PQM7Q0a02bFzozKaDU
 +t3kzzL2Qd2+4229dNwmZ66epKdHgdd+DXT/DFsHc1DQ+W2e/o6WUwmS3B7pYvqAP1Pn
 7RWOY1pWWjpmUnmCCbFm3HBbkWcNKnNKthcFf3vW+aML+OovFpmRXT9hnx/O6o+55Yd2
 hOHx5vz8dbn9KJ1YjGllaL7mNHiGY2zpcM3uOwv5wNfN4lGIIutJguFDN5/NFPVtwwje
 txCl5AlBGOujGQSPl6563ru0ArO5F/ytBuchDG4mA0Xi+iH/1M38tFMmoO/jgK46AgFG yw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35e2dv7bjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 16:19:32 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BELHEab030314
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 35cng8yeqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 21:19:32 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BELJVao30081318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:19:31 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3418F28058;
        Mon, 14 Dec 2020 21:19:31 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E370228059;
        Mon, 14 Dec 2020 21:19:30 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.237.30])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 21:19:30 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next v2 0/3] lockless version of netdev_notify_peers
Date:   Mon, 14 Dec 2020 15:19:27 -0600
Message-Id: <20201214211930.80778-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=856 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012140140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce the lockless version of netdev_notify_peers
and then apply it to the relevant drivers.

In v1, a more appropriate name __netdev_notify_peers is used;
netdev_notify_peers is converted to call the new helper.
In v2, patch 3 calls the new helper where notify variable used
to be set true.

Lijun Pan (3):
  net: core: introduce __netdev_notify_peers
  use __netdev_notify_peers in ibmvnic
  use __netdev_notify_peers in hyperv

 drivers/net/ethernet/ibm/ibmvnic.c |  9 +++------
 drivers/net/hyperv/netvsc_drv.c    | 11 ++++-------
 include/linux/netdevice.h          |  1 +
 net/core/dev.c                     | 22 ++++++++++++++++++++--
 4 files changed, 28 insertions(+), 15 deletions(-)

-- 
2.23.0

