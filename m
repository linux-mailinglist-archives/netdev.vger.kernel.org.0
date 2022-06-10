Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8BA546B4F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350008AbiFJREB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349949AbiFJRD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:03:58 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ECA3669E;
        Fri, 10 Jun 2022 10:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654880637; x=1686416637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SoQbox9LXcyX3/Opr6a2M/n8V2iom3/0Vp+el7IRj5A=;
  b=YE6XCiHHPJcPZoXawu4urpWvRzZmLt3FnJNzFz5zpkWCXT2uPcJjKYDN
   r+CUN3MHARVyFdeSwd+hVxutXbg2eWjmLu7jjmqvBS2OjTYCFBJrpseXn
   N8eEkJwAMOUCvUukI42Bqo2erELHUFxITLljyD8O4/wdeGUTS4jIjQmph
   01rOfCdSFiNNH1aQ+M8D9SxpH4fxvr18O+0/boANTj/u88TH8/+meflfl
   cVoPvW1nBaJLMu81iSST95+wcKJiax5cL/xxWJfx0SnLlzsxR7bQLyqgl
   /fB+mOyVZTjyzw2/K7PjH7TNajIptVTQQ0X/z0u57wYkLV4ubq5KYdkj6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="266452759"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="266452759"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638218747"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:03:55 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH v2 1/6] net/ncsi: Fix value of NCSI_CAP_VLAN_ANY
Date:   Sat, 11 Jun 2022 00:59:35 +0800
Message-Id: <20220610165940.2326777-2-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the NCSI specification (DSP0222) [1], the value of allow
Any VLAN + non-VLAN mode in Enable VLAN command should be 0x03.

[1] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 net/ncsi/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 03757e76bb6b..bc4a00e41695 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -47,7 +47,7 @@ enum {
 	NCSI_CAP_AEN_MASK                = 0x07,
 	NCSI_CAP_VLAN_ONLY               = 0x01, /* Filter VLAN packet only  */
 	NCSI_CAP_VLAN_NO                 = 0x02, /* Filter VLAN and non-VLAN */
-	NCSI_CAP_VLAN_ANY                = 0x04, /* Filter Any-and-non-VLAN  */
+	NCSI_CAP_VLAN_ANY                = 0x03, /* Filter Any-and-non-VLAN  */
 	NCSI_CAP_VLAN_MASK               = 0x07
 };
 
-- 
2.34.1

