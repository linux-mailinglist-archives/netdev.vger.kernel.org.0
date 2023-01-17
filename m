Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7861766D8D7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbjAQI4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbjAQIz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:55:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D154C2C;
        Tue, 17 Jan 2023 00:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945754; x=1705481754;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WROUCb8ntrKety6kZXKtQ1SdfnKnooXCndT+0soShOg=;
  b=BLbubivxSeU5T2OtQL7Wgw+PjQVHnGmU0rfR7/utflobYgWaDTlTYjhR
   fj5m697pjzY0868ADBKrQOYV7EjhUPmNj9ax1SIQX5MBXpn0qdsZgMh6y
   WHpnr6tdZsTvRM8FDCrHsXBFKfsKM+/Ew70Utdz1aVsBqddhPy67UWjXL
   ydQRY56UMzOk9mAIYT7xkbilqhRi3tRpYLhIbjhxZTOt0hrbTd1CwuBeY
   Lk1PFTusAlT6a4AyHlWOfUrjjNgoTHMehbLz/k+hEt1SC6skszk7NiDj8
   z9j+XraWqsBYnDmMIhlNbYJm5Hwfm/DI9mYalObljdIwU3Pl4IDswyG2/
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="196960283"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:55:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:55:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:55:47 -0700
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
Subject: [PATCH net-next 0/5] Improve locking in the VCAP API
Date:   Tue, 17 Jan 2023 09:55:39 +0100
Message-ID: <20230117085544.591523-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
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

This improves the VCAP cache and the VCAP rule list protection against
access from different sources.

The VCAP Admin lock protects the list of rules for the VCAP instance as
well as the cache used for encoding and decoding rules.

This series provides dedicated functions for accessing rule statistics,
decoding rule content, verifying if a rule exists and getting a rule with
the lock held, as well as ensuring the use of the lock when the list of
rules or the cache is accessed.

Steen Hegelund (5):
  net: microchip: sparx5: Add support for rule count by cookie
  net: microchip: sparx5: Add support to check for existing VCAP rule id
  net: microchip: sparx5: Add VCAP admin locking in debugFS
  net: microchip: sparx5: Improve VCAP admin locking in the VCAP API
  net: microchip: sparx5: Add lock initialization to the KUNIT tests

 .../microchip/sparx5/sparx5_tc_flower.c       |  34 +--
 .../net/ethernet/microchip/vcap/vcap_api.c    | 234 ++++++++++++------
 .../ethernet/microchip/vcap/vcap_api_client.h |   2 +
 .../microchip/vcap/vcap_api_debugfs.c         |  14 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c   |   1 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |   1 +
 .../microchip/vcap/vcap_api_private.h         |   3 +
 7 files changed, 175 insertions(+), 114 deletions(-)

-- 
2.39.0

