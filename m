Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF1152E4B8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245362AbiETGJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiETGJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283C15BD10
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C54F7B829D7
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F124C385AA;
        Fri, 20 May 2022 06:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653026950;
        bh=Y4R9g6Ks5tebihGO/Itnv/kcluFbuA8WyZkbi46LlpM=;
        h=From:To:Cc:Subject:Date:From;
        b=P5xJhvvQEldr5JEXlr1OwrzWLNlYssK/mjMaxeQERdUqaAWaJjEijN5MmZN85pGyZ
         M8VSyAHXooqXNYayNSOUOYVosyl6xvc9Iinv5mX11Gs1pcKtX5nQM5o1yYXjxj47XO
         Takb0MdiH1X52jxannT3lynLaM1XA/k8TNesSoh9j4tEJq8pGEChwmwWI5+fS5XCyg
         IC+rGIkw6Cby384O6NcgNB3TY/YW0cVycQvrYrolwz5t6DekDkl9TH8w461Fhudm2X
         fNf+x9tHPg3fFK0GHHnYn0hKED+2AY9+LiIrKniB390CqvivWICf6TZVxo4zZW1gij
         TsCIpGY2xTwZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next] eth: ice: silence the GCC 12 array-bounds warning
Date:   Thu, 19 May 2022 23:09:06 -0700
Message-Id: <20220520060906.2311308-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
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
index 9183d480b70b..588b6e8c7920 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -47,3 +47,8 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1 builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_ice_switch.o += $(call cc-disable-warning, array-bounds)
+endif
-- 
2.34.3

