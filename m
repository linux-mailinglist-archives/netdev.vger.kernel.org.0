Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49443ED59
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfD2Xhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:37:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729065AbfD2Xhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:37:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNYMjX189556;
        Mon, 29 Apr 2019 23:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=R4b/aXnANLbgB03RsAUPJ7vkeGgzs0Q1hSYdoj2f0Ys=;
 b=hCVPZ9+x8eHACgctSyPLl0Xoi1A39jA9TPR/MgwB0zPmnE4BdAuH++Y4Jg8HoJnObbmT
 qZZ+jEKYiDyUmHvkZguPzM1+f5NFWUlc+Wh4rzE1qc4wL6tRWZqLiB9YCEptR2ak88+C
 sC+GbecyXgpQXwQaLvC6jq+3UfeqFuQ6TYbKlJNe1DenMOuiUca2glqdw2CUysxmrFSO
 3JETXFsdaPjaFq+d9nNMP7Mhz76ScBv28IFvW17VTboAw+AX+pKo6Cv2G1klxTyujKyx
 X33pv5u8iMX8/EENiieQEtY6pBr29ZZngD1/x4f8IqUtUX3EX1RTMohBJCeEEkXiCN3i Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s4fqq1aub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNbT98164619;
        Mon, 29 Apr 2019 23:37:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2s4d4a71py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3TNbPRb022224;
        Mon, 29 Apr 2019 23:37:26 GMT
Received: from userv0022.oracle.com (/10.11.38.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 16:37:25 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net-next][PATCH v2 0/2] rds: handle unsupported rdma request to fs dax memory
Date:   Mon, 29 Apr 2019 16:37:18 -0700
Message-Id: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=894
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290153
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=925 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS doesn't support RDMA on memory apertures that require On Demand
Paging (ODP), such as FS DAX memory. User applications can try to use
RDS to perform RDMA over such memories and since it doesn't report any
failure, it can lead to unexpected issues like memory corruption when
a couple of out of sync file system operations like ftruncate etc. are
performed.

The patch adds a check so that such an attempt to RDMA to/from memory
apertures requiring ODP will fail. A sysctl is added to indicate
whether RDMA on ODP memory is supported.


Hans Westgaard Ry (1):
  rds: handle unsupported rdma request to fs dax memory

Santosh Shilimkar (1):
  rds: add sysctl for rds support of On-Demand-Paging

 net/rds/ib.h        | 1 +
 net/rds/ib_sysctl.c | 8 ++++++++
 net/rds/rdma.c      | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

-- 
1.9.1

