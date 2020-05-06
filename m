Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBCF1C6E2E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgEFKRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:17:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgEFKRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:17:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046ADRZh058915;
        Wed, 6 May 2020 10:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=eGWXt2HxEC5VC4G7DD9Y3OPmvrGqoHzoQT7MzoP3Vd0=;
 b=sGRyuNx5uXA8O0D+tX4rtdQQkyh5A2Nc994S/fBffJiyfhiOub2MAitTmLURC3vSjc4X
 9CdEnfkmrvn/e35qe0LTMQlF1h1N3+eM/FnkCmTI0DcqXHGdDAZRU/PRElBgiEAETisr
 wIUYQVt3rvqcbpxhNDM7uGUI737ce06poUu4XTd35OPJ65dBdYI7Pu0AqZ32GHNp2Evq
 zmrwLDRWqxa9tT6SNrdI7LQvqyJ3duVg6hHpLP/A04gvP/JT2kCp3Yz3qDPiBVkzEKQ+
 LZ5JHwqJO/b54orEiwKinjxiDGbbNBzL9ELMMl85kLyeZfqIpjy6KuzoSlZjvMbSrZLn BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30usgq0m0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:16:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046ACaVH157673;
        Wed, 6 May 2020 10:16:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30us7m8sx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:16:36 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046AGUiX002932;
        Wed, 6 May 2020 10:16:30 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 03:16:29 -0700
Date:   Wed, 6 May 2020 13:16:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net] net: mvpp2: prevent buffer overflow in
 mvpp22_rss_ctx()
Message-ID: <20200506101622.GB77004@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=922 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1011
 mlxlogscore=974 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "rss_context" variable comes from the user via  ethtool_get_rxfh().
It can be any u32 value except zero.  Eventually it gets passed to
mvpp22_rss_ctx() and if it is over MVPP22_N_RSS_TABLES (8) then it
results in an array overflow.

Fixes: 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1fa60e985b43a..2b5dad2ec650c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4329,6 +4329,8 @@ static int mvpp2_ethtool_get_rxfh_context(struct net_device *dev, u32 *indir,
 
 	if (!mvpp22_rss_is_supported())
 		return -EOPNOTSUPP;
+	if (rss_context >= MVPP22_N_RSS_TABLES)
+		return -EINVAL;
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_CRC32;
-- 
2.26.2

