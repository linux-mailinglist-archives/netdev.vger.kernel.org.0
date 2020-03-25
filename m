Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75FD1928EB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgCYMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727400AbgCYMxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCoOKX009178;
        Wed, 25 Mar 2020 05:52:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MZu/pZK/mY+5Sc6p0LZu+RbZTjbxW2KMCE8pifDTjU8=;
 b=oIJ1SWDzJA3iK3B/4Iksse5rI3dDu0vbSaOnMg7v32Lf/aI7kGzEouvcnciy55kV2IvY
 N3ES2jygKAQvUAgE73a2BzEom+g8+ffwSRMlLHDyDfLPt0DOauDT+9AwmvKSy6EN7pnI
 Nez70D34b2K+hsZbblub0McaxmqTTdO3eeARBXKYwQrUkaS1un65Mpx6njRfzx95nX+9
 cpjKV2Ouzaef96Vyh1cKMb2Cyy89bnpOkt2iGaRAiWumbi6OtYRFMi09fvkd90juBJyN
 yL5V5QVcR67mxLyaEQ9KEWVM1aJ0HjuNqhRXJwT3/29pDujNo743/LEOI7WvUlchfX4y 3Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nrgfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:52:58 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:52:57 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:52:57 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id C8B133F7041;
        Wed, 25 Mar 2020 05:52:55 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 02/17] net: add a reference to MACsec ops in net_device
Date:   Wed, 25 Mar 2020 15:52:31 +0300
Message-ID: <20200325125246.987-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch adds a reference to MACsec ops to the net_device structure,
allowing net device drivers to implement offloading operations for
MACsec.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 654808bfad83..b521500b244d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -53,6 +53,8 @@ struct netpoll_info;
 struct device;
 struct phy_device;
 struct dsa_port;
+struct macsec_context;
+struct macsec_ops;
 
 struct sfp_bus;
 /* 802.11 specific */
@@ -1819,6 +1821,8 @@ enum netdev_priv_flags {
  *				that follow this device when it is moved
  *				to another network namespace.
  *
+ *	@macsec_ops:    MACsec offloading ops
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2113,6 +2117,11 @@ struct net_device {
 	unsigned		wol_enabled:1;
 
 	struct list_head	net_notifier_list;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec management functions */
+	const struct macsec_ops *macsec_ops;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
-- 
2.17.1

