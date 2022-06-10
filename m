Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920E6546AD0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349811AbiFJQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241054AbiFJQrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:47:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C136DB224E;
        Fri, 10 Jun 2022 09:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879669; x=1686415669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nS9jBzEdJm76RP0LAjTlMRfAbVC9/X57Mw2W3mH7Yrc=;
  b=iqiAv1JLUbTJB+P08nlT41p9qJw2njftnqmFtFc1uta6MTQlP3tKQ9Y8
   SIRT4ndP4s48o/cyEsM6HjWnesKsu71GySJZei4sioGERHm8yQmHmLKhU
   RZxSs6enmReYAToXknjlIOHKj500mjlUojD4Tjos3O7NKTf9cHOnsRab6
   qoEaejSNIhao4CunQxgUKMNYGILL0ctSvzzfD5TjIlaG/k6agzcRdTkFu
   qgJkHAdWJyqbx7eucGKkvhCtdOf7hA+8mdbnEn0eMD1bvwIZ7fJwBW5+a
   Q5qmzeqr/6egtCwtfF/NUuLvjgqOUEurWmg92hc87qEAFQLrtYB0/U3t5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209620"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209620"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211044"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:48 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 3/6] net/ncsi: Enable VLAN filtering when callback is registered
Date:   Sat, 11 Jun 2022 00:45:52 +0800
Message-Id: <20220610164555.2322930-4-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
References: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

