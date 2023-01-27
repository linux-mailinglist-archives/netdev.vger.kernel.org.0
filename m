Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231AB67F0FA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjA0WNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjA0WNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:13:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4770684FBF;
        Fri, 27 Jan 2023 14:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF7EEB821FE;
        Fri, 27 Jan 2023 22:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C53BC433D2;
        Fri, 27 Jan 2023 22:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674857609;
        bh=erjVZPguZWWRU7zYaS/0T0cYT+4Oqh4S2R3jRj0Wtes=;
        h=From:To:Cc:Subject:Date:From;
        b=GsvgBSO99BxV+RsUDHX+W1o5oWOHGb2vzyYK1Fbip5D3/HVfrxz3qT32sIeZLbK2w
         Iy+e5TegkffYOpK/DLerZCL4WYDdX3stH4dD8eDtRD/3mwvZ5J4tFKu8YfPbyitAMy
         zPThVY6Zl4xrN5Y+t5nFKbza5dU0fnFSKH8qarz+lfbxjKkdll6FZolZyTD9pyPLia
         /P98DZuhvVapAhPiGQGPgBFXwtqDNO6uFf8D+lD2yRfmddzBNjhzlVxGD/MT0lOMUp
         c35C+e9jiflhVPOGVN/JeOYQ7jF7vg1QHRgtkkdoqw0w3Rd7iN64/LwN6zY80k/MqP
         PgOw00JwRymRQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: microchip: ptp: add one more PTP dependency
Date:   Fri, 27 Jan 2023 23:13:03 +0100
Message-Id: <20230127221323.2522421-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When only NET_DSA_MICROCHIP_KSZ8863_SMI is built-in but
PTP is a loadable module, the ksz_ptp support still causes
a link failure:

ld.lld-16: error: undefined symbol: ptp_clock_index
>>> referenced by ksz_ptp.c
>>>               drivers/net/dsa/microchip/ksz_ptp.o:(ksz_get_ts_info) in archive vmlinux.a

Add the same dependency here that exists with the KSZ9477_I2C
and KSZ_SPI drivers.

Fixes: eac1ea20261e ("net: dsa: microchip: ptp: add the posix clock support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/microchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 0546c573668a..11920939b6d8 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_MICROCHIP_KSZ_PTP
 config NET_DSA_MICROCHIP_KSZ8863_SMI
 	tristate "KSZ series SMI connected switch driver"
 	depends on NET_DSA_MICROCHIP_KSZ_COMMON
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO_BITBANG
 	help
 	  Select to enable support for registering switches configured through
-- 
2.39.0

