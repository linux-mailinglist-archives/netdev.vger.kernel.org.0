Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BADA2B3205
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 04:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgKODKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 22:10:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40698 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKODKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 22:10:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF36ftU122819;
        Sun, 15 Nov 2020 03:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=YzCW17HvF28kHl210+6Yn/DL47BhC9bM5ymnBPKfbPM=;
 b=L+bHigze/SYnMDKzJH9OeinaoI8ZYzpDhSXZeQBBQDEojb1mFaLnLBlk2ElGsKOqzlpM
 dIe6lt0y6Zrtw+viJWjs835/HCQlA3uXgvLsacphHIZMUrDQWXCJG2yMN7dQ1ubIdd2E
 pQzk0u4ASkjuLbDr8lq1u8a9d17Z/5SWkvSDAtxa6KRYNGGu7dMYntWS/YlmS2/+PjSm
 GLvsVepEFCJIEvxFq5aI4SJxdVJWFKU4ABLpMbDtFty73x4x1FUJ9Gby6jGjdjZMNH1w
 tBZwr4LFZ1KG/B4zIut/Msh4lD//a8BguShMcaX4qiJvheJn7Z6ACCg2aHUhxbPIdJku Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rahpb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 15 Nov 2020 03:10:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AF35QqT073101;
        Sun, 15 Nov 2020 03:10:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34trtjbp2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Nov 2020 03:10:15 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AF3ADQq011935;
        Sun, 15 Nov 2020 03:10:14 GMT
Received: from oracle.com (/10.129.135.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 19:10:13 -0800
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>
Subject: [RFC net-next af_unix v1 0/1] Allow delivery of SIGURG on AF_UNIX streams socket
Date:   Sat, 14 Nov 2020 18:58:04 -0800
Message-Id: <1605409085-20294-1-git-send-email-rao.shoaib@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011150017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011150017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

The use of AF_UNIX sockets is on the rise. We have a case where thousands
of processes connect locally to a database and issue queries that are
serviced by a pool of threads. Communication is done over AF_UNIX
sockets. Currently, there is no way for the submitter to signal the
servicing thread about an urgent condition such as abandoning
the query. This patch addresses that requirement by adding support for
MSG_OOB flag for AF_UNIX sockets. On receipt of such a flag,
the kernel sends a SIGURG to the peer.

Rao Shoaib (1):
  af_unix: Allow delivery of SIGURG on AF_UNIX streams socket

 net/unix/af_unix.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
1.8.3.1

