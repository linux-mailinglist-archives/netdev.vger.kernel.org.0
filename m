Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCD828E212
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 16:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgJNOR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 10:17:57 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47309 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgJNOR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 10:17:56 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud9.xs4all.net with ESMTPSA
        id ShbAkBzM84gEjShbBkMGFZ; Wed, 14 Oct 2020 16:17:54 +0200
Date:   Wed, 14 Oct 2020 16:17:48 +0200
From:   Antony Antony <antony@phenome.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA
Message-ID: <20201014141748.GA4910@AntonyAntony.local>
References: <20200828111101.GA16518@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828111101.GA16518@AntonyAntony.local>
X-CMAE-Envelope: MS4xfM7tIBMXFrSidQkeXvTSVbRD8MrWZ/VMUtOkYRfQ6SuK8JzCAEBPyN7vXSx+Q0WnsawhC1JOZScmSW/aE+TkDKn2ApbWR1KwZxc26HqHO56BPML1oyqT
 HvM9PR/sWMeXj3lcCRx4z1eZXQ/d09YA4BF6dbiCe1LBLP23SSq8Nh3HBv/gNHId40wkzPwIUz6Mdw5glc80vZzoElBiohqaH3tFVH2SOgV95HUwbzlXltGO
 UON4JKAj6Hj5ZXSrXnt3SxaDyQsy6YfqfadIIZPc3GtRHiRgi5I2k797vEgJpOIY5UhPejnahJMbaDEmyhAVA/YUq5MW3Qq+OcnXPqEjfe31ATaSEKqPmYtw
 sDxtACkGcQC1xCvYCnTqvm8P+bNZ9XcNTTvJvIUU3Kla5an2yTfN0uD5RlM96HlQUkCo99kEMTADX4BKMHxZR0hazM7aTw4D/0xdYekBhz0Tu7VIf7vufTRS
 CApweuCJ9LNxhwxc7CjG1GXJRLfCq53QurErTlG4N53kwslkmdWsGIFV/fqidrJNTlFiqR0coUh7CKSH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on talks and indirect references ixgbe IPsec offlod do not
support IPsec tunnel mode offload. It can only support IPsec transport
mode offload. Now explicitly fail when creating non transport mode SA
 with offload to avoid false performance expectations.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Antony Antony <antony@phenome.org>
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
2.21.3

