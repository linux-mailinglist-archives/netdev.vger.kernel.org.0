Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB1287CEC
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgJHURN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:17:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbgJHURN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:17:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KFi99019273
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=YzCW17HvF28kHl210+6Yn/DL47BhC9bM5ymnBPKfbPM=;
 b=d6dKbQ71XLQVN39DTvJshXgmxCL8krPZSwWkNBUmzI9LOBoCUcqk/YJ/DoRzXAXIjkrb
 q+++Wl7UID4nqcOjTNWv+XDGrbqRuyBCPIocn+vammGu9kd4UUSMWIoRooh5PnD9fPxQ
 dNeQf1cmc9d4/g2AijBmxRmENtIrQjDVTMlG4oiCAL92zp3uZxkyPcAw46zRBTpIcraD
 bTJrOaSCihti6m14CQXBfRK3HK0o8BPLpVwkL81FBGGpfnOMNILLMtpA4DyJwo7y1deX
 UgVPO/kABOpg1tPDStlfwags/XrvMsi8rpqy4lGoQir+2DeCj8gXj0NvYAm+7BYVf2t5 jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3429jmg17j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:17:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098KC2YB044334
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:15:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3429kk02hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:15:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098KFAnD030876
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 20:15:10 GMT
Received: from oracle.com (/10.129.135.37)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 13:15:10 -0700
From:   rao.shoaib@oracle.com
To:     netdev@vger.kernel.org
Cc:     Rao Shoaib <rao.shoaib@oracle.com>
Subject: [RFC net-next af_unix v1 0/1] Allow delivery of SIGURG on AF_UNIX streams socket
Date:   Thu,  8 Oct 2020 13:03:57 -0700
Message-Id: <1602187438-12464-1-git-send-email-rao.shoaib@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010080141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=1
 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010080142
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

