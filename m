Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA654B4027
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 04:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiBNDPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 22:15:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbiBNDPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 22:15:52 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59EE517CF;
        Sun, 13 Feb 2022 19:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644808545; x=1676344545;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GTRNegXQUauvtRLOj+BmtQhaOlzhjrUHWPmhf7At00Q=;
  b=NmZyRaVo9zihP/Lu2Os895uuPagNSLpZmOaO8Ztj4EI3mzee1TGhL994
   KH6W1EAhNAIV3DT/cleONv9f7v2tNvZYJjTP6UQn51VJHh34De+rQkgjI
   QtkbnMUcP753zRciAtzSiUyd8UiI/+zNzsm2aa7ajcePeWYaKtNgPYXxs
   qxOz7w/J8uSJzaoNxvNw2e134tZQ8j6jstlapYX3kXmG6/FHSqxXgum6Q
   YgCHJuwmnwSkQ2ceO36FPZFeFkwxL72LlXCW8nMEJKct3dytyL6ZGEj5L
   po5GvYGIdxaZAdnIrjNR/NM4kxwIyk+QgwRf2uoWUq9S1dGILGyFdugn0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="248833054"
X-IronPort-AV: E=Sophos;i="5.88,366,1635231600"; 
   d="scan'208";a="248833054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 19:15:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,366,1635231600"; 
   d="scan'208";a="543100685"
Received: from npg-dpdk-haiyue-2.sh.intel.com ([10.67.118.240])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2022 19:15:41 -0800
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     netdev@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>, Tao Liu <xliutaox@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Fraker <jfraker@google.com>,
        Yangchun Fu <yangchun@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] gve: fix zero size queue page list allocation
Date:   Mon, 14 Feb 2022 10:41:29 +0800
Message-Id: <20220214024134.223939-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the two functions 'gve_num_tx/rx_qpls', only the queue with
GVE_GQI_QPL_FORMAT format has queue page list.

The 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero sized
memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.

The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
address, so the driver can run successfully. Also the code still checks
the queue page list number firstly, then accesses the allocated memory,
so zero number queue page list allocation will not lead to access fault.

Use the queue page list number to detect no QPLs, it can avoid zero size
queue page list memory allocation.

Fixes: a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`")
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

