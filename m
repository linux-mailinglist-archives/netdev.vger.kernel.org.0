Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BEA4875EC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 11:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbiAGKxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 05:53:53 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53544 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbiAGKxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 05:53:53 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207A0kPj014394;
        Fri, 7 Jan 2022 10:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=jMR9O+FM9qEWJpGAyuSKDdDsmxJsR9AVCqr0pHidOwo=;
 b=NhRSszZexyZmoHbLxUWBaCRi/zXrjPkJDCzF9xzokULus7+PwdbAizZnv7GdXWYjK9Zb
 XPZd94WpmNxRQFgHNI/uQQv4xIV1kdHHlwncerqWuyxpONHViKhZVnQ3O991pALkIiEg
 30DNatthZKdNqJx+/DC8pYaVU0FxPvYcV4Gwz+bQ8cO8xAV01Hm7LNn7FLMB/XJB9q9c
 JpTGZvuG84+5oqdzTHnwxYDUNFgCJMaGaIUk0IefGRQt1m9r7mX6izWdqb8c2vcObHrG
 UzsNS1EJ1RliiNM5YVtsivkw0NPg0ERM2+DKr3/BDNeLImc4y8szGAPmER2uPnV8kxde Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4v8hrav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 10:53:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207AVeaS127051;
        Fri, 7 Jan 2022 10:53:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3de4vngpdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 10:53:48 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 207AnTKY192863;
        Fri, 7 Jan 2022 10:53:47 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3020.oracle.com with ESMTP id 3de4vngpdk-1;
        Fri, 07 Jan 2022 10:53:47 +0000
From:   Aayush Agarwal <aayush.a.agarwal@oracle.com>
Cc:     aayush.a.agarwal@oracle.com, stable@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.14] phonet: refcount leak in pep_sock_accep
Date:   Fri,  7 Jan 2022 02:53:32 -0800
Message-Id: <20220107105332.61347-1-aayush.a.agarwal@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 32QdoMVOwQVHfzppnChfzo1Q79XUlUxF
X-Proofpoint-GUID: 32QdoMVOwQVHfzppnChfzo1Q79XUlUxF
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit bcd0f9335332 ("phonet: refcount leak in pep_sock_accep")
upstream.

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
---
 net/phonet/pep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index b0d958cd1823..4c4a8a42ee88 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -881,6 +881,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.27.0

