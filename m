Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2131B3BDE60
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhGFUVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 16:21:24 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7503 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230255AbhGFUVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 16:21:15 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 6 Jul 2021 13:03:28 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id D7CC420287;
        Tue,  6 Jul 2021 13:03:30 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id D3416AA0C5; Tue,  6 Jul 2021 13:03:30 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 4/7] vmxnet3: add support for ESP IPv6 RSS
Date:   Tue, 6 Jul 2021 13:03:08 -0700
Message-ID: <20210706200312.29777-5-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210706200312.29777-1-doshir@vmware.com>
References: <20210706200312.29777-1-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vmxnet3 version 4 added support for ESP RSS. However, only IPv4 was
supported. With vmxnet3 version 6, this patch enables RSS for ESP
IPv6 packets as well.

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index efb59f13227e..43122893e13c 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -769,6 +769,10 @@ vmxnet3_get_rss_hash_opts(struct vmxnet3_adapter *adapter,
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
@@ -853,6 +857,22 @@ vmxnet3_set_rss_hash_opt(struct net_device *netdev,
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

