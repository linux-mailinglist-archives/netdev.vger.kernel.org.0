Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A3664160A
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLCKqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiLCKqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:46:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7F5442D3;
        Sat,  3 Dec 2022 02:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670064393; x=1701600393;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QdDUU9XATwS3yoxZ70z6vJGdkf6BMOnmv0FCA68ChZk=;
  b=Zv9nNqLx1N89sNW31bAZ20gSUdGn2fAK0zHcz9Bg3qVlxK2O+gITe5iv
   sS4sDU5JjRimBTNO7Gp1zL7G3IhTVdKFE6cXeodTHuKwp5QMT4HgKLHpe
   TZzBFaA1OnN8VoU4XBGVm0k0GjHb+CV3wtPyN+AsK5h7gxzrYL186irl6
   bORUwQfH/pNplMz2HO0T9L4APV6Xc5AcKfIthvPqe1MLTVXxBQrh4ikcv
   8VEo7CcIjZl8TejvsIJQAgUeXMAJqdUAnYMN6W+JIkaQazwpBMCu7cxWJ
   276/y2u0FEzck8tbqmjQTxTj/NQ2cKY6ebDMska0jp3KqSgm7LeeHDy0d
   g==;
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="189861152"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2022 03:46:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sat, 3 Dec 2022 03:46:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sat, 3 Dec 2022 03:46:29 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/4] net: lan966x: Enable PTP on bridge interfaces
Date:   Sat, 3 Dec 2022 11:43:44 +0100
Message-ID: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
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

v2->v3:
- rebase on net-next as it didn't apply anymore

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
 .../microchip/vcap/vcap_api_debugfs.c         | 498 ++---------
 .../microchip/vcap/vcap_api_private.h         |  14 +
 9 files changed, 1171 insertions(+), 461 deletions(-)

-- 
2.38.0

