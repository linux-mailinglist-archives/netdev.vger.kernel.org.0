Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD1C5755DF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 21:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240519AbiGNTg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 15:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbiGNTg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 15:36:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5325885D;
        Thu, 14 Jul 2022 12:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657827414; x=1689363414;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=N6UfmHWJDPjWY4cZVCh9Mei1uB5VrRXjZABai9nWUuE=;
  b=pqj4QfMMSc/cqGuV28xXkUxmpgE+h/ZZ4gNzUh4weH1ngvY2qq+CDPlc
   bXJk/cyZEpNQOU9cC9s7QbjkFC8KNfWLG2JgLMwyLAlR6BxJ9wZLupc5T
   6IAOwknKAniDFBYVSXMUlHyFWoPrpYr9N7/TuOndgxDW871CN+6TPOOoq
   yYdQq3LoDMKoWx1PdrphmXb+QAwjbGt7KOSUeJmciUljtfaUDpar0Bpzw
   Sc/RsueqqOtq3qRFR2duxKSCha/Tbf59K5JDxO85NozQX6zNIGpUsJ539
   7y66LIqBwzxvu5nTbqfL50pTQ1zjltF6fHqiL5/u+mNtXNjeUHQo8D59+
   w==;
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="172375754"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 12:36:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 12:36:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 12:36:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 0/5] net: lan966x: Fix issues with MAC table
Date:   Thu, 14 Jul 2022 21:40:35 +0200
Message-ID: <20220714194040.231651-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch series fixes 2 issues:
- when an entry was forgotten the irq thread was holding a spin lock and then
  was talking also rtnl_lock.
- the access to the HW MAC table is indirect, so the access to the HW MAC
  table was not synchronized, which means that there could be race conditions.

Horatiu Vultur (5):
  net: lan966x: Fix taking rtnl_lock while holding spin_lock
  net: lan966x: Fix usage of lan966x->mac_lock when entry is added
  net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
  net: lan966x: Fix usage of lan966x->mac_lock inside
    lan966x_mac_irq_handler
  net: lan966x: Fix usage of lan966x->mac_lock when used by FDB

 .../ethernet/microchip/lan966x/lan966x_mac.c  | 112 +++++++++++++-----
 1 file changed, 80 insertions(+), 32 deletions(-)

-- 
2.33.0

