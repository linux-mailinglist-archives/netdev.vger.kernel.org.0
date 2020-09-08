Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA7261866
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbgIHRy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:54:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732122AbgIHRyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:54:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 088Hoa1X009311;
        Tue, 8 Sep 2020 17:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=3xDUhtBLfsA7NEvHxMCUa3zVSoan6n2BG1ksOyZRxT8=;
 b=R3TDlZmAJFjpafjnod2dnE/0g3g8OzQeuvpo4EIhcWYOZUM7pKDb7Iibc8MmT3zQRF3o
 gTD22EQu9VKUm4S8GQfBJtee6tXwdWMWptUXEhBCH+Hdt4BYP2ngaZkGZXkLVyZ82x+p
 5ybZuJM3GDVGhy9UVh3sHR65yQAQFxDH5aX319jmE31Hzhwrn/5+fqnYTSn5rxSO6ktE
 w+kb5BkHUrM6jZLcr+aW3pLK1u5qjXmtyEmnsfJE0qI3klQpI39WTf5y7MuPNOY1T3WZ
 JVRxdnFL5umiM8VbAgNWDIY7A2aZR6dIyMpEODeWDBlsuG5iACfG4Kz3SPl9nST9KO/1 Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mkw50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Sep 2020 17:54:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 088Hjaom023669;
        Tue, 8 Sep 2020 17:54:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33dacj7k1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Sep 2020 17:54:07 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 088Hs5DS014628;
        Tue, 8 Sep 2020 17:54:06 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 10:54:05 -0700
Date:   Tue, 8 Sep 2020 20:53:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Krzysztof Halasa <khc@pm.waw.pl>, nan chen <whutchennan@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, security@kernel.org,
        Greg KH <greg@kroah.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] hdlc_ppp: add range checks in ppp_cp_parse_cr()
Message-ID: <20200908175359.GA356675@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908153200.GB4165114@kroah.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were two bugs here:
1) If opt[1] is zero then this results in a forever loop.  If the value
   is less than 2 then it is invalid.
2) We assume that "len" is more than sizeof(valid_accm) or 6 which can
   result in memory corruption.

Reported-by: ChenNan Of Chaitin Security Research Lab  <whutchennan@gmail.com>
Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This was sent to the security list, but we normally just handle
networking driver bugs through the regular netdev list.

 drivers/net/wan/hdlc_ppp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 48ced3912576..4e906b79a85f 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -383,11 +383,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 	}
 
 	for (opt = data; len; len -= opt[1], opt += opt[1]) {
-		if (len < 2 || len < opt[1]) {
-			dev->stats.rx_errors++;
-			kfree(out);
-			return; /* bad packet, drop silently */
-		}
+		if (len < 2 || opt[1] < 2 || len < opt[1])
+			goto err_out;
 
 		if (pid == PID_LCP)
 			switch (opt[0]) {
@@ -395,6 +392,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 				continue; /* MRU always OK and > 1500 bytes? */
 
 			case LCP_OPTION_ACCM: /* async control character map */
+				if (len < sizeof(valid_accm))
+					goto err_out;
 				if (!memcmp(opt, valid_accm,
 					    sizeof(valid_accm)))
 					continue;
@@ -406,6 +405,8 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 				}
 				break;
 			case LCP_OPTION_MAGIC:
+				if (len < 6)
+					goto err_out;
 				if (opt[1] != 6 || (!opt[2] && !opt[3] &&
 						    !opt[4] && !opt[5]))
 					break; /* reject invalid magic number */
@@ -424,6 +425,11 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 		ppp_cp_event(dev, pid, RCR_GOOD, CP_CONF_ACK, id, req_len, data);
 
 	kfree(out);
+	return;
+
+err_out:
+	dev->stats.rx_errors++;
+	kfree(out);
 }
 
 static int ppp_rx(struct sk_buff *skb)
-- 
2.28.0

