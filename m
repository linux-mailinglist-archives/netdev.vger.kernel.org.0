Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2FBEF470
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 12:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfD3Kqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 06:46:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58772 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfD3Kqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 06:46:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UAdJt7083398;
        Tue, 30 Apr 2019 10:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=uL+fUIqFbcI2TUW4GUxAidr70o04zT98/FRTHJRRrTg=;
 b=flu2aNUZP/+7518N21y8hr2E9ekPxUMD289tdGK4PtwB/E7DQ855V7f8E3HehLvd1Aua
 T9VMtCGk+cfymuuhuYCnlZXf97GbXbFnHyxmOCO81CaGlN2mwrL9njquuJT07hJ2S5rN
 PW4XW3i2OwQuH91NErD3HIHAOhZpsu4kkadd5QG8aAtX5JTJld0g8XJxR4ann+U9jrMt
 Rp2YvTmeZGgSRltLNpXrApxRkQBq2HpPHaZPuzXCVlxjKfnZ06WeMX22FYZuTfZ5U88q
 HwfnO8x5InVhTFWXkQ8C3/s4tes8NUOGBxPRg4Wn27Z3TLv6x2riZctH1TxPBNJNhmY1 UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s4fqq3nfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 10:46:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UAh1Rx086933;
        Tue, 30 Apr 2019 10:44:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s5u50webc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 10:44:32 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3UAiSM9003493;
        Tue, 30 Apr 2019 10:44:29 GMT
Received: from mwanda (/196.97.65.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Apr 2019 03:44:28 -0700
Date:   Tue, 30 Apr 2019 13:44:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc
Message-ID: <20190430104419.GA9096@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=7 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300070
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "fs->location" is a u32 that comes from the user in ethtool_set_rxnfc().
We can't pass unclamped values to test_bit() or it results in an out of
bounds access beyond the end of the bitmap.

Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index e6234d209787..4212bc4a5f31 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -886,6 +886,9 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	     fs->m_ext.data[1]))
 		return -EINVAL;
 
+	if (fs->location != RX_CLS_LOC_ANY && fs->location >= CFP_NUM_RULES)
+		return -EINVAL;
+
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
@@ -974,6 +977,9 @@ static int bcm_sf2_cfp_rule_del(struct bcm_sf2_priv *priv, int port, u32 loc)
 	struct cfp_rule *rule;
 	int ret;
 
+	if (loc >= CFP_NUM_RULES)
+		return -EINVAL;
+
 	/* Refuse deleting unused rules, and those that are not unique since
 	 * that could leave IPv6 rules with one of the chained rule in the
 	 * table.
-- 
2.18.0
