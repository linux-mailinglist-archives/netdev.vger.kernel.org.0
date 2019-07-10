Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB7D640B7
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfGJFdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:33:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39682 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfGJFdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:33:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5SjAm118081;
        Wed, 10 Jul 2019 05:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=AQvJksmkJSuTO90b0QLTlf9OoKCwtJjX5Qt1Vdp+B34=;
 b=c4ABPQ42iXKSaZ0DVPNtovdidRIwPMUM2a3WtbZ7xRfUcn4nXtPEyWMQObE7hhL5tAfk
 V/6jlq/Y1lhUqae79o3NmemUPlQyj24Cd/J4v62Q1AQVVKbAU0MVs+cEH/3Z4z863yqx
 783tPcuLn6dEv7ZpAdCEBTpd6TqGOW96sB3uFcKAZUHVgXhd7izGkJhf9WoAwYgd3L+P
 u7uY5PFUpD1T0AK1M69uS+K3mo1mIf1q+OszuRjAFAbuvNgkx7XbkLGG5vah22SmPFYC
 x5HWnunefS5ShIhoekAbZqv9R1YLuGrLNPeVOMvhD9zZ9H2K+jYgwA7/MNi7hb1674Fh 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkpqwfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6A5WvtG083657;
        Wed, 10 Jul 2019 05:33:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tmwgx9yap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 05:33:08 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6A5X8x1009422;
        Wed, 10 Jul 2019 05:33:08 GMT
Received: from localhost.localdomain (/10.159.154.151)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 22:33:08 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net][PATCH 4/5] rds: Return proper "tos" value to user-space
Date:   Tue,  9 Jul 2019 22:32:43 -0700
Message-Id: <1562736764-31752-5-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>

The proper "tos" value needs to be returned
to user-space (sockopt RDS_INFO_CONNECTIONS).

Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/connection.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7ea134f..ed7f213 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -736,6 +736,7 @@ static int rds_conn_info_visitor(struct rds_conn_path *cp, void *buffer)
 	cinfo->next_rx_seq = cp->cp_next_rx_seq;
 	cinfo->laddr = conn->c_laddr.s6_addr32[3];
 	cinfo->faddr = conn->c_faddr.s6_addr32[3];
+	cinfo->tos = conn->c_tos;
 	strncpy(cinfo->transport, conn->c_trans->t_name,
 		sizeof(cinfo->transport));
 	cinfo->flags = 0;
-- 
1.9.1

