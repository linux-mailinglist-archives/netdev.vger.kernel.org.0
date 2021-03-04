Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435FF32C9C9
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbhCDBMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:44731 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1392389AbhCDBGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 20:06:37 -0500
IronPort-SDR: xzV5JUK6dHBs8Z+lBxK+9MIRynOBy91ZSnvfbr8ODKm3A8S7+J/MYGtGcPY2eWf/sHStN+kkkZ
 FjWaYZeiwDqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="183934475"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="183934475"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 17:05:38 -0800
IronPort-SDR: PyqnfJZBf8nQ8LD1iLj9I/PuOsjMfzN+qiXWzrTTdUZ1n7itvn1P2MywMFOlPBrQpqE+dpTUn3
 9PXi6WYWdnkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="367809982"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2021 17:05:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antony Antony <antony@phenome.org>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Shannon Nelson <snelson@pensando.io>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/3] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA
Date:   Wed,  3 Mar 2021 17:06:48 -0800
Message-Id: <20210304010649.1858916-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
References: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony@phenome.org>

Based on talks and indirect references ixgbe IPsec offlod do not
support IPsec tunnel mode offload. It can only support IPsec transport
mode offload. Now explicitly fail when creating non transport mode SA
with offload to avoid false performance expectations.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Antony Antony <antony@phenome.org>
Acked-by: Shannon Nelson <snelson@pensando.io>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 5 +++++
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index eca73526ac86..54d47265a7ac 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -575,6 +575,11 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (ixgbe_ipsec_check_mgmt_ip(xs)) {
 		netdev_err(dev, "IPsec IP addr clash with mgmt filters\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 5170dd9d8705..caaea2c920a6 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -272,6 +272,11 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		struct rx_sa rsa;
 
-- 
2.26.2

