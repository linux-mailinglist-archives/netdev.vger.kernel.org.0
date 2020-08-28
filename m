Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C11255949
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 13:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgH1LXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 07:23:42 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53721 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729052AbgH1LWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 07:22:48 -0400
Received: from cust-69a1f852 ([IPv6:fc0c:c154:b0a8:48a5:61f4:988:bf85:2ed5])
        by smtp-cloud9.xs4all.net with ESMTPSA
        id BcHdkdUtuecrdBcHskzy7X; Fri, 28 Aug 2020 13:11:19 +0200
Date:   Fri, 28 Aug 2020 13:11:01 +0200
From:   Antony Antony <antony@phenome.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Antony Antony <antony@phenome.org>, netdev@vger.kernel.org
Subject: [PATCH RFC] xfrm: fail to create ixgbe offload of IPsec tunnel mode
 sa
Message-ID: <20200828111101.GA16518@AntonyAntony.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CMAE-Envelope: MS4wfMhkVuCRrYSqhuV34ZvzEu3Vm10Yu8GVxWuRBAkp9vfBtrbjXvyRwI+GV6HsLES2rbrG8JZLVD9dO3rydCP4ztfWslPEnqk+eg9yHhlZ1S5V0BtCCWxQ
 2zQ4US2nCzH/FEKcZQY7VV/A6wYy8ogJ8i5osHSPBsmX8LjxTIfiVh6AdsMNjuhSPXyVeH7wyWfWl5S8u30NL/rGk0K5vJXXQ84n3DyATFDn5Og6bp5to50I
 J/LeGVodd2lAL6GZNYY28lSrpIq7tX7SIG/nVsK/SuPh+lQD4nyjTnz1fb8QuRQQFlRSSpOYAqCtXb26rJV1Ml0LpOSgD8v8beuAS+hEGfCxaDUdfLUP2xHm
 rzvDSqQu17ka9gsKEtitnigq+P+Ekb8+Ma+LfdYsWlSfLsgE0K0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on talks and indirect references ixgbe driver does not
support offloading IPsec tunnel mode. It only support transport mode.
Now explicitly fail to avoid when trying to offload.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Antony Antony <antony@phenome.org>
---
I haven't tested this fix as I have no access to the hardware.
This patch is based on a libreswan bug report.
https://github.com/libreswan/libreswan/issues/252
Is it useful to this bug report in kernel commit message?

 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 5 +++++
 drivers/net/ethernet/intel/ixgbevf/ipsec.c     | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index eca73526ac86..e2b978efcc5a 100644
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
index 5170dd9d8705..d11b3f3414ea 100644
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

