Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532F0640149
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiLBHwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiLBHve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:51:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A050AFCDD;
        Thu,  1 Dec 2022 23:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669967487; x=1701503487;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rbRgJC5OGOpM1O9o3ILlJTLdncz7C20gbr77o1yERhk=;
  b=btN4ZIgd2TfL+m1+8So/JfqilytDlEQ7QUhTfbj0qk9tVFTGNOA7Z5Zn
   gvOcQ2giqIMtVHOtL/cyiTt7+esU+1PN1HwWIRF3b/7QlP56Qbo2vlg8S
   RMCCCSYn+pIfSR65U/8Cr6B6lLMHWTEcU/W+I5sWOFZUAuZplNbBji5ox
   +tE4uyxtdPXkHqs88luJl7jdVAXfUq3oCQjKjkk7p/VUPXB4df8E34KYQ
   s365XpmggHn9Bt9fLyeN2Mz14pjEU2/chRnUgJWpX0Hi5bvlBW2Od119h
   ugIFADOqUcELyAtT3mSPqbM/XrhSVFcbo7C18pcwVw3ly230aXCzSuwSp
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="126141868"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 00:51:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 00:51:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 00:51:21 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/4] net: lan966x: Enable PTP on bridge interfaces
Date:   Fri, 2 Dec 2022 08:56:17 +0100
Message-ID: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before it was not allowed to run ptp on ports that are part of a bridge
because in case of transparent clock the HW will still forward the frames
so there would be duplicate frames.
Now that there is VCAP support, it is possible to add entries in the VCAP
to trap frames to the CPU and the CPU will forward these frames.
The first part of the patch series, extends the VCAP support to be able to
modify and get the rule, while the last patch uses the VCAP to trap the ptp
frames.

v1->v2:
- use PTP_EV_PORT and PTP_GEN_PORT instead of hardcoding the number
- small alignment adjustments

Horatiu Vultur (4):
  net: microchip: vcap: Add vcap_get_rule
  net: microchip: vcap: Add vcap_mod_rule
  net: microchip: vcap: Add vcap_rule_get_key_u32
  net: lan966x: Add ptp trap rules

 .../ethernet/microchip/lan966x/lan966x_main.c |  19 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  14 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 236 ++++-
 .../microchip/lan966x/lan966x_tc_flower.c     |   8 -
 .../microchip/lan966x/lan966x_vcap_impl.c     |  11 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 824 ++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |   8 +
 .../microchip/vcap/vcap_api_debugfs.c         | 492 ++---------
 .../microchip/vcap/vcap_api_private.h         |  14 +
 9 files changed, 1171 insertions(+), 455 deletions(-)

-- 
2.38.0

