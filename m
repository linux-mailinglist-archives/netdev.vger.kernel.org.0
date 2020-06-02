Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C159D1EB392
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 05:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFBDCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 23:02:42 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:59169 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725841AbgFBDCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 23:02:41 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 1 Jun 2020 20:02:40 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.113.240])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 3A8D440A1D;
        Mon,  1 Jun 2020 20:02:41 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] vmxnet3: allow rx flow hash ops only when rss is enabled
Date:   Mon, 1 Jun 2020 20:02:39 -0700
Message-ID: <20200602030240.9858-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes sense to allow changes to get/set rx flow hash callback only
when rss is enabled. This patch restricts get_rss_hash_opts and
set_rss_hash_opts methods to allow querying and configuring different
Rx flow hash configurations only when rss is enabled

Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 6acaafe169de..def27afa1c69 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -899,6 +899,12 @@ vmxnet3_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info,
 			err = -EOPNOTSUPP;
 			break;
 		}
+#ifdef VMXNET3_RSS
+		if (!adapter->rss) {
+			err = -EOPNOTSUPP;
+			break;
+		}
+#endif
 		err = vmxnet3_get_rss_hash_opts(adapter, info);
 		break;
 	default:
@@ -919,6 +925,12 @@ vmxnet3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *info)
 		err = -EOPNOTSUPP;
 		goto done;
 	}
+#ifdef VMXNET3_RSS
+	if (!adapter->rss) {
+		err = -EOPNOTSUPP;
+		goto done;
+	}
+#endif
 
 	switch (info->cmd) {
 	case ETHTOOL_SRXFH:
-- 
2.11.0

