Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C30FD83E3D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfHGAVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:21:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfHGAVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:21:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7707rqS007591
        for <netdev@vger.kernel.org>; Tue, 6 Aug 2019 17:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=he/2Z0ENIriYPhFo9YJ+fTiLFe2HN0KKpsDTYLP2IlE=;
 b=fRpmoOPe2fDK3434gxhp9ipnXgFCXPsxdQKdWA3RTYtIfXvtsXpx9MCVgiQS5zglI30K
 etZS05UrYZpXprpa9IbXeew6qgWV4bLoZFdy+0aLQEuOtOTpU6viCZUqAZh8vC8O+y1r
 qiJ75OwnA4rWw3VKs+NXFo8cDdxWyORuQc8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7dfs1jh2-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 17:21:22 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 6 Aug 2019 17:21:21 -0700
Received: by devvm24792.prn1.facebook.com (Postfix, from userid 150176)
        id 8FFE818C66019; Tue,  6 Aug 2019 17:21:19 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Tao Ren <taoren@fb.com>
Smtp-Origin-Hostname: devvm24792.prn1.facebook.com
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
CC:     Tao Ren <taoren@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address offset
Date:   Tue, 6 Aug 2019 17:21:18 -0700
Message-ID: <20190807002118.164360-1-taoren@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=667 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently BMC's MAC address is calculated by adding 1 to NCSI NIC's base
MAC address when CONFIG_NCSI_OEM_CMD_GET_MAC option is enabled. The logic
doesn't work for platforms with different BMC MAC offset: for example,
Facebook Yamp BMC's MAC address is calculated by adding 2 to NIC's base
MAC address ("BaseMAC + 1" is reserved for Host use).

This patch adds NET_NCSI_MC_MAC_OFFSET config option to customize offset
between NIC's Base MAC address and BMC's MAC address. Its default value is
set to 1 to avoid breaking existing users.

Signed-off-by: Tao Ren <taoren@fb.com>
---
 net/ncsi/Kconfig    |  8 ++++++++
 net/ncsi/ncsi-rsp.c | 15 +++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ncsi/Kconfig b/net/ncsi/Kconfig
index 2f1e5756c03a..be8efe1ed99e 100644
--- a/net/ncsi/Kconfig
+++ b/net/ncsi/Kconfig
@@ -17,3 +17,11 @@ config NCSI_OEM_CMD_GET_MAC
 	---help---
 	  This allows to get MAC address from NCSI firmware and set them back to
 		controller.
+config NET_NCSI_MC_MAC_OFFSET
+	int
+	prompt "Offset of Management Controller's MAC Address"
+	depends on NCSI_OEM_CMD_GET_MAC
+	default 1
+	help
+	  This defines the offset between Network Controller's (base) MAC
+	  address and Management Controller's MAC address.
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 7581bf919885..24a791f9ebf5 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -656,6 +656,11 @@ static int ncsi_rsp_handler_oem_bcm_gma(struct ncsi_request *nr)
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	int ret = 0;
+#ifdef CONFIG_NET_NCSI_MC_MAC_OFFSET
+	int mac_offset = CONFIG_NET_NCSI_MC_MAC_OFFSET;
+#else
+	int mac_offset = 1;
+#endif
 
 	/* Get the response header */
 	rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
@@ -663,8 +668,14 @@ static int ncsi_rsp_handler_oem_bcm_gma(struct ncsi_request *nr)
 	saddr.sa_family = ndev->type;
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	memcpy(saddr.sa_data, &rsp->data[BCM_MAC_ADDR_OFFSET], ETH_ALEN);
-	/* Increase mac address by 1 for BMC's address */
-	eth_addr_inc((u8 *)saddr.sa_data);
+
+	/* Management Controller's MAC address is calculated by adding
+	 * the offset to Network Controller's (base) MAC address.
+	 * Note: negative offset is "ignored", and BMC will use the Base
+	 * MAC address in this case.
+	 */
+	while (mac_offset-- > 0)
+		eth_addr_inc((u8 *)saddr.sa_data);
 	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
 		return -ENXIO;
 
-- 
2.17.1

