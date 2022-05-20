Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8642952F412
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353350AbiETT4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiETT4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:56:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560F27C167
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04672B82B7F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84602C34118;
        Fri, 20 May 2022 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653076573;
        bh=VB00IrlHr7JPNEdd4z+wCHMiP1O8Kr75sg1R6LARQWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5xF9Mf1qgbJdf0wNIjwIBShTthIU2ydBzh42WKYBVkR0C8F/Udwq5SvOUtmwTDvT
         JockkQ0WMaayWrQCawWsI9/TkIBcY/QBPCq/rReFSDBTmU5cqPFP1o6vlAofBTcOq3
         QQMVEXrPjTFRORxt/E2a24rFCTkjJl+L07oqI6R/w7MZuhunTJbK/wqJpw/vn+Ijz6
         UwbG3PPxKfHtyzx5c2GJww7yflATFX4LRJj2uykr+iQ9JFus2xG2aIps4wZBQUvV+9
         mkyoZzqWixF+1hzm40MXOR6ZrUxqKGeWzI4K0K0kLKZwrSRR51KVvuwnvJNvQWbLAY
         QLybR+wOD8BbQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next v2 2/3] eth: ice: silence the GCC 12 array-bounds warning
Date:   Fri, 20 May 2022 12:56:04 -0700
Message-Id: <20220520195605.2358489-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520195605.2358489-1-kuba@kernel.org>
References: <20220520195605.2358489-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 gets upset because driver allocates partial
struct ice_aqc_sw_rules_elem buffers. The writes are
within bounds.

Silence these warnings for now, our build bot runs GCC 12
so we won't allow any new instances.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jesse.brandeburg@intel.com
CC: anthony.l.nguyen@intel.com
---
 drivers/net/ethernet/intel/ice/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 9183d480b70b..46f439641441 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -47,3 +47,8 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_ice_switch.o += -Wno-array-bounds
+endif
-- 
2.34.3

