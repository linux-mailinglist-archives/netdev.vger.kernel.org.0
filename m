Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A618350699
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhCaSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:43:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47960 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbhCaSni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:43:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIOrjp180569;
        Wed, 31 Mar 2021 18:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Sgw2w+kgVfvTr68L4+Fag7PR6Rntmywf8u7lTr7+rQs=;
 b=CwjSWA5zvaihKo2shVtnGcUUPN0zrAvRpY4vndKU+deMseJ8Og0oTBSAA/MkasmGMBm8
 1R/0LEuJ7LFHSB6zFd/NTRv36h4uqEVUiGGRTvPt2Liu/RKkKHQKNGO5Nbi2qZKQurwc
 etTU+eXQc76XpM7JjWq6d/hGXl0kJ10Zy7sWe09IF+Xkvmbu7SR5VXdaKxr+mhzhDISI
 DJf6mga0VosihXPq0/X70BA1gWCc26CHEWY3nj1YiBiMeObGxHiEfh2iM9JSYLITXPyV
 6V0usFK2cM+JPI/105clT3Sn5ja1D2wRzfs2venwr1SmwfGYjSelLawYqLrkji+TGsnI lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37mp06srf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VIPXHx134962;
        Wed, 31 Mar 2021 18:43:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 37mabmk9vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:30 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 12VIh0wM196416;
        Wed, 31 Mar 2021 18:43:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 37mabmk9vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 18:43:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12VIhSA7012148;
        Wed, 31 Mar 2021 18:43:28 GMT
Received: from lab02.no.oracle.com (/10.172.144.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Mar 2021 11:43:27 -0700
From:   =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and use it in RDS
Date:   Wed, 31 Mar 2021 20:43:12 +0200
Message-Id: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-IMR: 1
X-Proofpoint-ORIG-GUID: rq5vfdvUlRtfDysJlDaV4EuTC2ISjSbg
X-Proofpoint-GUID: rq5vfdvUlRtfDysJlDaV4EuTC2ISjSbg
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 malwarescore=0 mlxlogscore=985 mlxscore=0 clxscore=1015 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ib_modify_qp() is an expensive operation on some HCAs running
virtualized. This series removes two ib_modify_qp() calls from RDS.

I am sending this as a v3, even though it is the first sent to
net. This because the IB Core commit has reach v3.

Håkon Bugge (2):
  IB/cma: Introduce rdma_set_min_rnr_timer()
  rds: ib: Remove two ib_modify_qp() calls

 drivers/infiniband/core/cma.c      | 41 ++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/cma_priv.h |  2 ++
 include/rdma/rdma_cm.h             |  2 ++
 net/rds/ib_cm.c                    | 35 +-------------------------------
 net/rds/rdma_transport.c           |  1 +
 5 files changed, 47 insertions(+), 34 deletions(-)

--
1.8.3.1

