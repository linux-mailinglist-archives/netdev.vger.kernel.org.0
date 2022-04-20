Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF95088A5
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378692AbiDTNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353831AbiDTNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:02:52 -0400
X-Greylist: delayed 1132 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Apr 2022 06:00:05 PDT
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8784B13E0B;
        Wed, 20 Apr 2022 06:00:05 -0700 (PDT)
Received: from localhost.localdomain (36-229-224-240.dynamic-ip.hinet.net [36.229.224.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 8C4833FA42;
        Wed, 20 Apr 2022 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650458476;
        bh=/DaWrz00GeCdKC/jBwXJP0sO2B3OU8ZY2ztBd4prWu4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hkgJgkJJngylqyfUc6lVGz7ZtwxbhMpJRH1mg1fssA9wiI2Foi2AljyQJBE5tpCaG
         r7e0IKEs7EGbBNEA69/YwH2wDgRf0SMn/qar7CfKdQSTWc+r3GTu1Uf2DE//WDDNod
         ycynC+GkenJ3M4fEWWnr2U/7LJSNoTK3khWLUhfdXKr+axMEYhT4WftDLJlxQ5kS4I
         tt+0XxGNdMN7NEst41uXaok5EPrathr12ggX54NPw2YztJ1vfTZR4Lcb1PGve9Fy3O
         ISKI+NA3M8C4wf9XuBye1b+e7fe+umH8rh+gZyGJl26+VMohQedILkq3TkoupXHnO2
         s0c2w8BcG2iNQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] net: mdio: Add "use-firmware-led" firmware property
Date:   Wed, 20 Apr 2022 20:40:49 +0800
Message-Id: <20220420124053.853891-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420124053.853891-1-kai.heng.feng@canonical.com>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some system may prefer preset PHY LED setting instead of the one
hardcoded in the PHY driver, so adding a new firmware
property, "use-firmware-led", to cope with that.

On ACPI based system the ASL looks like this:

    Scope (_SB.PC00.OTN0)
    {
        Device (PHY0)
        {
            Name (_ADR, One)  // _ADR: Address
            Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
            {
                ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
                Package (0x01)
                {
                    Package (0x02)
                    {
                        "use-firmware-led",
                        One
                    }
                }
            })
        }

        Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
        {
            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
            Package (0x01)
            {
                Package (0x02)
                {
                    "phy-handle",
                    PHY0
                }
            }
        })
    }

Basically use the "phy-handle" reference to read the "use-firmware-led"
boolean.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/mdio/fwnode_mdio.c | 4 ++++
 include/linux/phy.h            | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1c1584fca6327..bfca67b42164b 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -144,6 +144,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	 */
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
+
+	phy->use_firmware_led =
+		fwnode_property_read_bool(child, "use-firmware-led");
+
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 36ca2b5c22533..53e693b3430ec 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -656,6 +656,7 @@ struct phy_device {
 	/* Energy efficient ethernet modes which should be prohibited */
 	u32 eee_broken_modes;
 
+	bool use_firmware_led;
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
 	unsigned int phy_num_led_triggers;
-- 
2.34.1

