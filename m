Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22FF646513
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLGX2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLGX2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:28:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B3F89AC7;
        Wed,  7 Dec 2022 15:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670455715; x=1701991715;
  h=from:to:subject:date:message-id:mime-version;
  bh=qz5rae1Q2S/l+fQL4xiiI1frvBOmHUOqX0qK9BuuZEs=;
  b=ucCf8/vqWCxwXijYIY1pwALnWWOsibsxPR7OAuAjRoGBmxNyqaf6WcBc
   xVewE9oKy23GDZT/9v6FDz73fkCEU9joYV9Yvu5iaFrFsxJLIzViahs3e
   j/UacuLdCZmhoW6JTyTGyR7fHTi1zLaupOuCGXQlrz4TVvIBB2g8YbvOv
   5JStBHGEdfaiPcFpqbh8J/gdAdrWo4uvBs5qtkSzBJfWIMj0kOtsBBwqM
   bz36ihkwLxFbs5xO7xEjNnG6P+enRYSFlDtxPOn7vBlts7WFtSNzQjDVs
   BMbc/h4mxon1cs0q9UpwRVaYin7EjW1tNXIPVo2AajJfvwEbhgDzAppTp
   g==;
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="127028534"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2022 16:28:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Dec 2022 16:28:29 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 7 Dec 2022 16:28:28 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v4 0/2] dsa: lan9303: Move to PHYLINK
Date:   Wed, 7 Dec 2022 17:28:26 -0600
Message-ID: <20221207232828.7367-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series moves the lan9303 driver to use the phylink
api away from phylib.

Note a preparatory patch addresses whitespace issues to make the
dsa_switch_ops code consistent.

Note the .port_max_mtu api patch is now removed from this series.  It
was unrelated and has little to no value if the api is never being
called for the cpu port.

Migrating to phylink means removing the .adjust_link api. The
functionality from the adjust_link is moved to the phylink_mac_link_up
api.  The code being removed only affected the cpu port.

---
v3-> v4:
  - Addressed whitespace issues as a separate patch.
  - Removed port_max_mtu api patch as it is unrelated to phylink migration.
  - Reworked the implementation to preserve the adjust_link functionality
    by including it in the phylink_mac_link_up api.

v2-> v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phyvsupported interfaces.
v1-> v2:
  corrected the reported mtu size, removing ETH_HLEN and ETH_FCS_LEN

 drivers/net/dsa/lan9303-core.c | 93 ++++++++++++--------
 1 file changed, 56 insertions(+), 37 deletions(-)

