Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64F74BE95C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381609AbiBURUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:20:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381610AbiBURUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:20:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C208DA0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 09:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645463978; x=1676999978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mo135wmiyBV1MyO7OEFoIfk7OQwDjj5fc99hb7inUI0=;
  b=a8tjQcezn10X/9Oxme46lZolOrZEaeHFc/X1z7lF6ZYyAvdygv4AT2sH
   K+jzx2INK1lqUbl6wyJTyUMYtva2I5XOxE3AJQTOkZZqNKKnjVnDPCWlK
   geG8cS+exNqDfAcUoIPdOgCuMloiA11vvS9657Lm5C0pYZOMTOOzL83Il
   cFRNGra14hH9Uf7HLVYEbXijoP28dw7BzS2ZuuJ+Ze1biAyeZpksaRDlY
   MJKasD2ShXEtt4DpDK12tYXc+lhqCs4CFvR4qSAghOsq7XjoaMJQoXi0g
   XuSR6ybZfRc6h6ey0f48qhMu9S5KAGp8cSBighoJ/qmBjIJe2Eae+D/ld
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251302803"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251302803"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:19:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="778742859"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 21 Feb 2022 09:19:35 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21LHJBnS010069;
        Mon, 21 Feb 2022 17:19:34 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v7 5/7] gtp: Add support for checking GTP device type
Date:   Mon, 21 Feb 2022 11:14:23 +0100
Message-Id: <20220221101425.19776-6-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221101425.19776-1-marcin.szycik@linux.intel.com>
References: <20220221101425.19776-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Add a function that checks if a net device type is GTP.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Harald Welte <laforge@gnumonks.org>
---
 include/net/gtp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/gtp.h b/include/net/gtp.h
index 23c2aaae8a42..c1d6169df331 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -63,6 +63,12 @@ struct gtp_pdu_session_info {	/* According to 3GPP TS 38.415. */
 	u8	qfi;
 };
 
+static inline bool netif_is_gtp(const struct net_device *dev)
+{
+	return dev->rtnl_link_ops &&
+		!strcmp(dev->rtnl_link_ops->kind, "gtp");
+}
+
 #define GTP1_F_NPDU	0x01
 #define GTP1_F_SEQ	0x02
 #define GTP1_F_EXTHDR	0x04
-- 
2.35.1

