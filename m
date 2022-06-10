Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD5546AD7
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349751AbiFJQru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245336AbiFJQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:47:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB25AE27F;
        Fri, 10 Jun 2022 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879667; x=1686415667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SoQbox9LXcyX3/Opr6a2M/n8V2iom3/0Vp+el7IRj5A=;
  b=BoAvxnnXjQI9aKwZHrgQm0mT6i95+DGgjhG9VD0Uhkrmmh861CiLdS0Y
   rlDdD3qKMNeNp3S1Eo3RDBLtaD1HpAOdq3oBL/WZj+sPxTP4w1njDpyV1
   ObyjM+uRwISl9Dd9mbIWOFoEaN4z8mE5UuKKOnfPg3ScAL+Xz9LCeCUFw
   h+wol9Z1fUad3woIyiR+cXIp0MDml5qGrn/3fonNdLlCFmZ+fFdiIbmc8
   tAcxbmHWR2IEylYGvfMm3ngT3lDpQUSdjVzDH2byNV/4pB4enhiVaZbPc
   GnWEM6AziZWFHvY9Ts0zHf3MW/BSuNYfOsBF2fzTfzRzt0VOM8r3j2Brj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209606"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209606"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211027"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:44 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 1/6] net/ncsi: Fix value of NCSI_CAP_VLAN_ANY
Date:   Sat, 11 Jun 2022 00:45:50 +0800
Message-Id: <20220610164555.2322930-2-jiaqing.zhao@linux.intel.com>
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

