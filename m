Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEAF28050B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgJARVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:21:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32288 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732791AbgJARVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:21:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H1K17104086;
        Thu, 1 Oct 2020 13:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=pDBXy4XwCSXPXo7K45yqwj7bmISKGmFYGdEZA9nSnEs=;
 b=GI4RUKJI0O/4EmqmIwiN0q/wCy3g3Gha2fcC2st8c3TMMn7gLcIehstkmpn6b7Gcd1Za
 7fPimO5Cnimpls4/Cs5Ue36Nqg7wqgHSekHXk0+R5BdenIMAUkfdflBanS2zfBczH2GV
 4vfUURkrFBCk8d5qDW6jO9d50fwt4FrfWAtvv64dcnkk+zXmsX5z+hDlQKW4/Hy2e2Y8
 htp+7QS3WPShfNpjUq0Wr1XFatt0hgDfbdCJAZSANhYGea++ie6s4C81wa+BBSc64Q4m
 Je2sFTxFcN7HhJ1rGNmlzzBufWbyeJIDBHfwpLBYmxU+O6zhn1g0NW6wtDrSy0wmtMKw IA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33wjkehnpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:21:34 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H3e1d022865;
        Thu, 1 Oct 2020 17:21:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33sw983159-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:21:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HLTvx33489276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:21:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3763A4064;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8754EA4067;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/2] net/af_iucv: right-size the uid variable in iucv_sock_bind()
Date:   Thu,  1 Oct 2020 19:21:26 +0200
Message-Id: <20201001172127.98541-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001172127.98541-1-jwi@linux.ibm.com>
References: <20201001172127.98541-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 phishscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smatch complains about
net/iucv/af_iucv.c:624 iucv_sock_bind() error: memcpy() 'sa->siucv_user_id' too small (8 vs 9)

Which is absolutely correct - the memcpy() takes 9 bytes (sizeof(uid))
from an 8-byte field (sa->siucv_user_id).
Luckily the sockaddr_iucv struct contains more data after the
.siucv_user_id field, and we checked the size of the passed data earlier
on. So the memcpy() won't accidentally read from an invalid location.

Fix the warning by reducing the size of the uid variable to what's
actually needed, and thus reducing the amount of copied data.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/iucv/af_iucv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index a95af62acb52..d80572074667 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -588,11 +588,11 @@ static int iucv_sock_bind(struct socket *sock, struct sockaddr *addr,
 			  int addr_len)
 {
 	struct sockaddr_iucv *sa = (struct sockaddr_iucv *) addr;
+	char uid[sizeof(sa->siucv_user_id)];
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv;
 	int err = 0;
 	struct net_device *dev;
-	char uid[9];
 
 	/* Verify the input sockaddr */
 	if (addr_len < sizeof(struct sockaddr_iucv) ||
-- 
2.17.1

