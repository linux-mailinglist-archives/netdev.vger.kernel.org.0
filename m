Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF7D546B0A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349916AbiFJQuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiFJQt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:49:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDCD28733;
        Fri, 10 Jun 2022 09:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879798; x=1686415798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nS9jBzEdJm76RP0LAjTlMRfAbVC9/X57Mw2W3mH7Yrc=;
  b=YFYOWS/RTsmzUBbHumr/Bm2WN6tQGiBhLU3rIXSvzm4Lgkm3ow1sVMSr
   tuFpjsgKQgN/QtN+lT5qDR/tDFf0S79RViGXv3ttGjQOhIYEZwxpel4D+
   tQO99PVrKDotOH6Fc9TRGCUTB6pUI2FKw6F9+R460BfEKVbFrxBwQypUU
   NDkwO2LfrBQ8ot57Xs3ejRbzslzrUQXpBdmd/ZpQ8C+AjKCN2lD2pYeeJ
   L4FmpA+j+v6qxZugsmYP3Fjt2roEwH9uNBnrp+DY1plilTsV2fbfhJ0Nv
   iJj/wyEqtBrqyiBfol7EOQPrt5q91omniDO9KTb5YbaNlSEScDhd66Wfz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339432547"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="339432547"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="760587716"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:54 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 3/6] net/ncsi: Enable VLAN filtering when callback is registered
Date:   Sat, 11 Jun 2022 00:48:05 +0800
Message-Id: <20220610164808.2323340-4-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
References: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sets NETIF_F_HW_VLAN_CTAG_FILTER flag to enable hardware VLAN filtering
of NCSI when the ndo_vlan_rx_{add,kill}_vid callbacks are registered to
the NCSI handlers. Previously it was done in the mac driver, this patch
puts it to the NCSI drvier to make it more general.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 net/ncsi/ncsi-manage.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index a8f7a2ff52a0..3fb95f29e3e2 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1807,6 +1807,11 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 			ndp->mlx_multi_host = true;
 	}
 
+	/* Enable hardware VLAN filtering */
+	if (dev->netdev_ops->ndo_vlan_rx_add_vid == ncsi_vlan_rx_add_vid &&
+	    dev->netdev_ops->ndo_vlan_rx_kill_vid == ncsi_vlan_rx_kill_vid)
+		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+
 	return nd;
 }
 EXPORT_SYMBOL_GPL(ncsi_register_dev);
-- 
2.34.1

