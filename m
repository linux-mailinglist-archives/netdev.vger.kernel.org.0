Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1295B51202A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbiD0Qaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243564AbiD0Q26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:28:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867025AED4;
        Wed, 27 Apr 2022 09:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651076655; x=1682612655;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nObokQIoYpRw/WHE7DGQWpfFGZTCam2DoGA1QQvbnLI=;
  b=TP5h2TLLEjRuZwJ6fACkWQCF4AbfDVrEf324XUCLf/8GiHMnU5r+b0Hm
   INivHzXhu74Q60OZN+7IXgm8riBFormSGmQlmHVePkTh4r7yflOYytyGs
   j2Pixo+WMk7FPDcPYXnu/OH8cLsZz05p2u+fxObunqyjt2WOcjRjscGwj
   CUPNTtbVldH8wb56g3H0ki8mmqmAMJjGIaf9qDBg79tmAei1+a6bosyfR
   KCvboPwKf9Df0t+wt7B5XdtxqjkadWeiZq1+4xbuskZteC8LsJwrdh1Kj
   X68rnr9NX+efGdlIVTJv8ilhelGr0P651FhZA/S9lSXWRJ7Rh38TI4pNq
   A==;
X-IronPort-AV: E=Sophos;i="5.90,293,1643698800"; 
   d="scan'208";a="161536278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 09:24:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 09:24:01 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 09:23:51 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC patch net-next 0/3] net: dsa: ksz: generic port mirror function for ksz9477 based switch
Date:   Wed, 27 Apr 2022 21:53:40 +0530
Message-ID: <20220427162343.18092-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series updates the ksz9477 port_mirror_add and port_mirror_del as
per the LAN937x patch submission. It allows only one port to be sniffing port.
Then moves the function to ksz_common.c file, to have it referenced by LAN937x
based switch. And add new header file ksz_reg.h which has common register
address between them.

Arun Ramadoss (3):
  net: dsa: ksz9477: port mirror sniffing limited to one port
  net: dsa: ksz: remove duplicate ksz_cfg and ksz_port_cfg
  net: dsa: ksz: moved ksz9477 port mirror to ksz_common.c

 drivers/net/dsa/microchip/ksz8795.c     | 12 -----
 drivers/net/dsa/microchip/ksz9477.c     | 56 +------------------
 drivers/net/dsa/microchip/ksz9477_reg.h | 15 ------
 drivers/net/dsa/microchip/ksz_common.c  | 72 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  | 18 +++++++
 drivers/net/dsa/microchip/ksz_reg.h     | 29 ++++++++++
 6 files changed, 121 insertions(+), 81 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_reg.h


base-commit: 03fa8fc93e443e6caa485cc741328a1386c63630
-- 
2.33.0

