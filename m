Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76C04B6328
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiBOFwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:52:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiBOFw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:52:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDA9DFF5;
        Mon, 14 Feb 2022 21:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644904336; x=1676440336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p/uMbZPPiZReXrMs+XWU+QXob/0etjYoC1lD26VUKfE=;
  b=IQOzleTGZbkrvx3Dv1/7Wvps8usCvgcXGjxV2+WY7OqwoWQKqbnn20J/
   nm+D2q8DpQz5LNnip8czwbkjTc8y4WzT/ktrI/4hzderZeQDKEntFgFaF
   gEjMTJEGya84bgXuRsS0MLP0zXFPgb/4KSMOdJWBqUyTUEap902mnDmya
   2bNARdlMQzA9LOEuQy1vYlZFOHr9sM+Vq+Nj06+1lhLKletQk3a5Uw/Xg
   QqAjAlSGkdhx4lJaCgW/fW0U0Q5dfX2bxRcer+XiWw1EmLKChklmdiX22
   +ijpIea0LedS/T2hbujpCRrds8O3wQQ+giGDisnCmjRib008ar67O0Gum
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="230218526"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="230218526"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 21:52:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="528642306"
Received: from npg-dpdk-haiyue-2.sh.intel.com ([10.67.118.240])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2022 21:52:12 -0800
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     netdev@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tao Liu <xliutaox@google.com>,
        John Fraker <jfraker@google.com>,
        Yangchun Fu <yangchun@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] gve: enhance no queue page list detection
Date:   Tue, 15 Feb 2022 13:17:49 +0800
Message-Id: <20220215051751.260866-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214024134.223939-1-haiyue.wang@intel.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit
a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`")
introduces three queue format type, only GVE_GQI_QPL_FORMAT queue has
page list. So it should use the queue page list number to detect the
zero size queue page list. Correct the design logic.

Using the 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero
sized memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.

The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
address, so the driver can run successfully. Also the code still checks
the queue page list number firstly, then accesses the allocated memory,
so zero number queue page list allocation will not lead to access fault.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 54e51c8221b8..6cafee55efc3 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -857,8 +857,7 @@ static int gve_alloc_qpls(struct gve_priv *priv)
 	int i, j;
 	int err;
 
-	/* Raw addressing means no QPLs */
-	if (priv->queue_format == GVE_GQI_RDA_FORMAT)
+	if (num_qpls == 0)
 		return 0;
 
 	priv->qpls = kvcalloc(num_qpls, sizeof(*priv->qpls), GFP_KERNEL);
@@ -901,8 +900,7 @@ static void gve_free_qpls(struct gve_priv *priv)
 	int num_qpls = gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv);
 	int i;
 
-	/* Raw addressing means no QPLs */
-	if (priv->queue_format == GVE_GQI_RDA_FORMAT)
+	if (num_qpls == 0)
 		return;
 
 	kvfree(priv->qpl_cfg.qpl_id_map);
-- 
2.35.1

