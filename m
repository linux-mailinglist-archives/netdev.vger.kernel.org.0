Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19AD63D844
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiK3Ocv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiK3OcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:32:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127046177A;
        Wed, 30 Nov 2022 06:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669818724; x=1701354724;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xNeeYKcuuL17q/h3xuxpvAFdAFsSZaH6f0KB/erzzB0=;
  b=oxCRsjXMXpGU2Jb0FDeL7UvACygGvcA7+OrAOyTOweNiGgB+FW1b0gpA
   j44I7pT92glRUo4/c120QIE4mTmhnycfnsc985YVGcabeso31xLuL/OLL
   n8CznLJPGkcvNIHR0Kgr+psiikcktz7cIy44DDIiBpwriOMgd8K8Xyg98
   WGLm+m9SEdXw01vWGKtQ/H0TptdPQMcYT9xuLV+LeHJ+QMB80o6PlHPhI
   4DafXul2h55wJQAl3qBokonaTkrBJn3b4n64vQ1dzuBGqux53rxXnymkb
   sp8oFbXaluA/YB8PXx2AgEvfyQp3onyuHJ9Rn3YDaVXK8HwikZXDIwP9m
   A==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191144748"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 07:30:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 07:30:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 07:30:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/4] net: lan966x: Enable PTP on bridge interfaces 
Date:   Wed, 30 Nov 2022 15:35:21 +0100
Message-ID: <20221130143525.934906-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Horatiu Vultur (4):
  net: microchip: vcap: Add vcap_get_rule
  net: microchip: vcap: Add vcap_mod_rule
  net: microchip: vcap: Add vcap_rule_get_key_u32
  net: lan966x: Add ptp trap rules

 .../ethernet/microchip/lan966x/lan966x_main.c |  19 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  14 +
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 237 ++++-
 .../microchip/lan966x/lan966x_tc_flower.c     |   8 -
 .../microchip/lan966x/lan966x_vcap_impl.c     |  11 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 824 ++++++++++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |   8 +
 .../microchip/vcap/vcap_api_debugfs.c         | 492 ++---------
 .../microchip/vcap/vcap_api_private.h         |  14 +
 9 files changed, 1172 insertions(+), 455 deletions(-)

-- 
2.38.0

