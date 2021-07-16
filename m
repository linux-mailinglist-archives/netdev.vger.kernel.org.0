Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB793CBF55
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhGPWjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:39:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:55999 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237055AbhGPWjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:39:37 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Jul 2021 15:36:36 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id D09202034D;
        Fri, 16 Jul 2021 15:36:41 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id CD125AA043; Fri, 16 Jul 2021 15:36:41 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/7] vmxnet3: add support for ESP IPv6 RSS
Date:   Fri, 16 Jul 2021 15:36:23 -0700
Message-ID: <20210716223626.18928-5-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210716223626.18928-1-doshir@vmware.com>
References: <20210716223626.18928-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vmxnet3 version 4 added support for ESP RSS. However, only IPv4 was
supported. With vmxnet3 version 6, this patch enables RSS for ESP
IPv6 packets as well.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 1b483cf2b1ca..a3e2f2ba68b5 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -787,6 +787,10 @@ vmxnet3_get_rss_hash_opts(struct vmxnet3_adapter *adapter,
 	case AH_ESP_V6_FLOW:
 	case AH_V6_FLOW:
 	case ESP_V6_FLOW:
+		if (VMXNET3_VERSION_GE_6(adapter) &&
+		    (rss_fields & VMXNET3_RSS_FIELDS_ESPIP6))
+			info->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		fallthrough;
 	case SCTP_V6_FLOW:
 	case IPV6_FLOW:
 		info->data |= RXH_IP_SRC | RXH_IP_DST;
@@ -871,6 +875,22 @@ vmxnet3_set_rss_hash_opt(struct net_device *netdev,
 	case ESP_V6_FLOW:
 	case AH_V6_FLOW:
 	case AH_ESP_V6_FLOW:
+		if (!VMXNET3_VERSION_GE_6(adapter))
+			return -EOPNOTSUPP;
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			rss_fields &= ~VMXNET3_RSS_FIELDS_ESPIP6;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_fields |= VMXNET3_RSS_FIELDS_ESPIP6;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
 	case SCTP_V4_FLOW:
 	case SCTP_V6_FLOW:
 		if (!(nfc->data & RXH_IP_SRC) ||
-- 
2.11.0

