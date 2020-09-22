Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5E72742AA
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIVNIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:08:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgIVNIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:08:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MD6TQB021917;
        Tue, 22 Sep 2020 06:08:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=6wa6TQnds4To/blqpDE4MQd5qZXhirQSwikJ/CZLN/I=;
 b=YTOGnmoDrOi+D1K/jlBxpIJYvGdZLER6jJsqZWYkoAlfc8xQiPEffwDrZl1wjvBiH+1G
 u6RnM/FTht/ttgaSDDqp+rKOVd7XkhajXqEDh8ltntQBvx5uLLDKLJOytWXRlfqBGMy6
 iBcTxmfeNWqbOODTx7ES1AfdfGBayWpIE8utHjunftu0kvOT0uxz8JM83uJJA9CwWvVh
 1Iwp61qg5wWty8DFn0Oi5UYN2Gv3oeing4QifsieFmENs+Fz2Q7aY8gea8omJ6ufuMwo
 HcajW/qxsRwfY9fcMCweWSxX8hKMQkSQWW/WUS9Yo5fjNxachf61pzO/XvzlskCWCVoP iA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgna5es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 06:08:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 06:08:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 06:08:04 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Sep 2020 06:08:04 -0700
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 0E1EB3F703F;
        Tue, 22 Sep 2020 06:07:59 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     George Cherian <george.cherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sunil Kovvuri Goutham" <Sunil.Goutham@cavium.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "Tomasz Duszynski" <tduszynski@cavium.com>,
        Aleksey Makarov <amakarov@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        hariprasad <hari1219@gmail.com>
Subject: [net-next PATCH 2/2] octeontx2-pf: Support to change VLAN based RSS hash options via ethtool
Date:   Tue, 22 Sep 2020 18:37:27 +0530
Message-ID: <20200922130727.2350661-3-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200922130727.2350661-1-george.cherian@marvell.com>
References: <20200922130727.2350661-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_12:2020-09-21,2020-09-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to control rx-flow-hash based on VLAN.
By default VLAN plus 4-tuple based hashing is enabled.
Changes can be done runtime using ethtool

To enable 2-tuple plus VLAN based flow distribution
  # ethtool -N <intf> rx-flow-hash <prot> sdv
To enable 4-tuple plus VLAN based flow distribution
  # ethtool -N <intf> rx-flow-hash <prot> sdfnv

Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 820fc660de66..d2581090f9a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -355,7 +355,7 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	rss->flowkey_cfg = rss->enable ? rss->flowkey_cfg :
 			   NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
 			   NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
-			   NIX_FLOW_KEY_TYPE_SCTP;
+			   NIX_FLOW_KEY_TYPE_SCTP | NIX_FLOW_KEY_TYPE_VLAN;
 
 	ret = otx2_set_flowkey_cfg(pfvf);
 	if (ret)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 0341d9694e8b..662fb80dbb9d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -428,6 +428,8 @@ static int otx2_get_rss_hash_opts(struct otx2_nic *pfvf,
 
 	/* Mimimum is IPv4 and IPv6, SIP/DIP */
 	nfc->data = RXH_IP_SRC | RXH_IP_DST;
+	if (rss->flowkey_cfg & NIX_FLOW_KEY_TYPE_VLAN)
+		nfc->data |= RXH_VLAN;
 
 	switch (nfc->flow_type) {
 	case TCP_V4_FLOW:
@@ -477,6 +479,11 @@ static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
 	if (!(nfc->data & RXH_IP_SRC) || !(nfc->data & RXH_IP_DST))
 		return -EINVAL;
 
+	if (nfc->data & RXH_VLAN)
+		rss_cfg |=  NIX_FLOW_KEY_TYPE_VLAN;
+	else
+		rss_cfg &= ~NIX_FLOW_KEY_TYPE_VLAN;
+
 	switch (nfc->flow_type) {
 	case TCP_V4_FLOW:
 	case TCP_V6_FLOW:
-- 
2.25.1

