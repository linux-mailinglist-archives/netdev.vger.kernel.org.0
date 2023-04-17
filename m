Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AC06E536D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjDQU6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjDQU6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:58:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDC3118ED;
        Mon, 17 Apr 2023 13:56:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9A4762A71;
        Mon, 17 Apr 2023 20:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F80C433D2;
        Mon, 17 Apr 2023 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681764960;
        bh=q90+u87m3wUu+Fg6qEnvdX/mkRJR5IxIH+69ZC9pncI=;
        h=From:To:Cc:Subject:Date:From;
        b=Yx/ebFoesBk8zWG2ppjw3XKCaVeJ2vKIcePzvjJurU5ReyFJj9mRsOx0zsYUVaHWQ
         w7afQvyS48RXdmqbfYVku8tUeGmiz3AS3Uam5F4bSUs6UExOsUi21UefIEvC3u3Bvt
         Az7LjvfhTTme9D+vtyz/5Y8nuRSJA81Z8M1tznIU8wYvIMucm6v1bBrh2jG8urrQa1
         uOyYgIzqSO9F4DAs5yRVc/sIJLJqWrxytpj2K69OWZXl6Hb4kcZdj/hSjmRVekWeif
         XXxh/Rslpm8LD+mFjpDdzo2UUJl99CqyYvMaNbIIxFrNQ3Q7KiGTgoPFkBdiYXsf4F
         ge8i8cNNnfmLQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hyperv: select CONFIG_NLS for mac address setting
Date:   Mon, 17 Apr 2023 22:55:48 +0200
Message-Id: <20230417205553.1910749-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A rare randconfig build error happens when this driver is
enabled, but nothing else enables NLS support:

x86_64-linux-ld: drivers/net/hyperv/rndis_filter.o: in function `rndis_filter_set_device_mac':
rndis_filter.c:(.text+0x1536): undefined reference to `utf8s_to_utf16s'

This is normally selected by PCI, USB, ACPI, or common file systems.
Since the dependency on ACPI is now gone, NLS has to be selected
here directly.

Fixes: 38299f300c12 ("Driver: VMBus: Add Devicetree support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hyperv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hyperv/Kconfig b/drivers/net/hyperv/Kconfig
index ca7bf7f897d3..924dad26ad47 100644
--- a/drivers/net/hyperv/Kconfig
+++ b/drivers/net/hyperv/Kconfig
@@ -2,6 +2,7 @@
 config HYPERV_NET
 	tristate "Microsoft Hyper-V virtual network driver"
 	depends on HYPERV
+	select NLS
 	select UCS2_STRING
 	help
 	  Select this option to enable the Hyper-V virtual network driver.
-- 
2.39.2

