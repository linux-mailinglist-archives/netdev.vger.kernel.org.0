Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9FED12DD1
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfECMkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:40:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47590 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfECMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:40:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43CSvHW090583;
        Fri, 3 May 2019 12:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=UJmvD0o/B9oyDPcYrbWR2azUVI51MGSO03s8OjAcdsI=;
 b=m7j+kJPBZeAYKBOJYTdxk6vn6fxr5/RrIKHWdA1LgV5LG1mzHQ+7tVe3FvHcF+8bvbWk
 7LvOOj7x5Zg8wETqaGypr+VXpetgUeE21UTHdTJbI+M8XUVSxHZokm8E28/yM88vEf4+
 wtgPWAsPDtaNDT31L6zmZ+GyNpKFGQgn9UhsV1xNglOpwB7B+DssWIPGLTrod4mnzplj
 aFuqSmIRYHXx6fCIcxzEYVaDYomz6G/YYztcXSOBLZSgA1V6UWEd5ablYssCN+43mQFB
 tBr1oW5RvUg38kQmpgoTA5wmnXiPS+9fBuK/oerUADBVpTZre329NGNGAtfwRvQ2t3QP XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2s6xhypeyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:40:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43Ccnmk083482;
        Fri, 3 May 2019 12:40:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2s7rtc8vmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 12:40:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43CdxGv027792;
        Fri, 3 May 2019 12:39:59 GMT
Received: from mwanda (/196.104.111.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 05:39:58 -0700
Date:   Fri, 3 May 2019 15:39:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: atm: clean up a range check
Message-ID: <20190503123948.GD29695@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030079
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code works fine but the problem is that check for negatives is a
no-op:

	if (arg < 0)
		i = 0;

The "i" value isn't used.  We immediately overwrite it with:

	i = array_index_nospec(arg, MAX_LEC_ITF);

The array_index_nospec() macro returns zero if "arg" is out of bounds so
this works, but the dead code is confusing and it doesn't look very
intentional.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This applies to net, but it's just a clean up.

 net/atm/lec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ad4f829193f0..a0311493b01b 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -726,9 +726,7 @@ static int lecd_attach(struct atm_vcc *vcc, int arg)
 	struct lec_priv *priv;
 
 	if (arg < 0)
-		i = 0;
-	else
-		i = arg;
+		arg = 0;
 	if (arg >= MAX_LEC_ITF)
 		return -EINVAL;
 	i = array_index_nospec(arg, MAX_LEC_ITF);
-- 
2.18.0

