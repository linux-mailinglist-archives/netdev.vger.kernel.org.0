Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977EE6940E3
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBMJYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBMJYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:24:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CBA14E8B;
        Mon, 13 Feb 2023 01:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280279; x=1707816279;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0cjmFjyZ0y5LsKhYMj2E4+r0Krs4C84DnjiMFk2+QdY=;
  b=noqTGe7+xtYLRZ8CYowRGqOrCkEGR2dAcj6KVuigauAbsAHs1JBlaLsQ
   mmwd/i97yOTs99geraz1xcJuY4/EG5uQogiUl+Ig+K/ihFKQCsjDJogX/
   zdLMRDN3YuBXX1dmES2rECwkyUiVUFs5GAziD5MtMHm3X+JgS69YMErzm
   ndYjecC5geY4ofqv1QWI9QFN7r1ZsMWZqMfGeOH3abGw9QldPAkY0018q
   RIjmvZH7Vx+UP86V3LQPvLLVqburAYpZUtjsVdO9DkZlxoc1m6jRbF9s7
   m6LkST9el46q66c5MO0rRnNx3/qj0V2v3uUvVB3ndXsQLAYhFb6YwmDRy
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="200188819"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:24:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:24:35 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:24:31 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 00/10] Adding Sparx5 ES0 VCAP support
Date:   Mon, 13 Feb 2023 10:24:16 +0100
Message-ID: <20230213092426.1331379-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
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

This provides the Egress Stage 0 (ES0) VCAP (Versatile Content-Aware
Processor) support for the Sparx5 platform.

The ES0 VCAP is an Egress Access Control VCAP that uses frame keyfields and
previously classified keyfields to add, rewrite or remove VLAN tags on the
egress frames, and is therefore often referred to as the rewriter.

The ES0 VCAP also supports trapping frames to the host.

The ES0 VCAP has 1 lookup accessible with this chain id:

- chain 10000000: ES0 Lookup 0

The ES0 VCAP does not do traffic classification to select a keyset, but it
does have two keysets that can be used on all traffic.  For now only the
ISDX keyset is used.

The ES0 VCAP can match on an ISDX key (Ingress Service Index) as one of the
frame metadata keyfields, similar to the ES2 VCAP.

The ES0 VCAP uses external counters in the XQS (statistics) group.

Steen Hegelund (10):
  net: microchip: sparx5: Discard frames with SMAC multicast addresses
  net: microchip: sparx5: Clear rule counter even if lookup is disabled
  net: microchip: sparx5: Egress VLAN TPID configuration follows IFH
  net: microchip: sparx5: Use chain ids without offsets when enabling
    rules
  net: microchip: sparx5: Improve the error handling for linked rules
  net: microchip: sparx5: Add ES0 VCAP model and updated KUNIT VCAP
    model
  net: microchip: sparx5: Updated register interface with VCAP ES0
    access
  net: microchip: sparx5: Add ES0 VCAP keyset configuration for Sparx5
  net: microchip: sparx5: Add TC support for the ES0 VCAP
  net: microchip: sparx5: Add TC vlan action support for the ES0 VCAP

 .../ethernet/microchip/sparx5/sparx5_main.c   |    1 +
 .../microchip/sparx5/sparx5_main_regs.h       | 1829 ++++++++++++-----
 .../ethernet/microchip/sparx5/sparx5_port.c   |    5 +
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |   74 +
 .../microchip/sparx5/sparx5_tc_flower.c       |  368 +++-
 .../microchip/sparx5/sparx5_vcap_ag_api.c     |  385 +++-
 .../microchip/sparx5/sparx5_vcap_debugfs.c    |   41 +
 .../microchip/sparx5/sparx5_vcap_impl.c       |  274 +++
 .../microchip/sparx5/sparx5_vcap_impl.h       |   25 +
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |    4 +-
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  174 +-
 .../net/ethernet/microchip/vcap/vcap_api.c    |   28 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |    4 +-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |    4 +-
 .../microchip/vcap/vcap_model_kunit.c         |  270 ++-
 .../microchip/vcap/vcap_model_kunit.h         |   10 +-
 drivers/net/ethernet/microchip/vcap/vcap_tc.c |    3 +
 drivers/net/ethernet/microchip/vcap/vcap_tc.h |    1 +
 18 files changed, 2758 insertions(+), 742 deletions(-)

-- 
2.39.1

