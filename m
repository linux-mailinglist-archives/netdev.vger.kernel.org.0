Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B516F52DF5D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiESVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiESVdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:33:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F300CED79B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gMaZg626PoKNZ5fGv2+JEwLThBYwmU/J4azc+2rMXF0=; b=pQip2X5A6xqU8yi3hhp9JQSdBA
        XmWD5Fj4q6JcMsfzuKH2M0nO7XxJNf6cfwgk+IH9FFIOc9OvGNm70WCf+UH47XlpxfjCoCwy8SCei
        J27V5iC71T/1hOf+WTEg0t8CN7poXAlkdT3JBkBIj4mms6D695kEJxopmtY3FKUiTsLLJ6CD1eI81
        J2r+4+7mD8BAtvv7FEU4qjlIxDjwvsPEOTipuzUhVxEfwuyCA0YZMqnCJLn3MskzEx9cdKRcmvwn0
        uCa7l3CP1SZN5TXVSyRDs6cw2KqSmWfghmZUlsKXeUuUVhMpyjbIwAugaKD7XhM1pQLgw4lm2ptxY
        boMX6IEA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrnmK-009RRi-CB; Thu, 19 May 2022 21:33:52 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Date:   Thu, 19 May 2022 14:33:51 -0700
Message-Id: <20220519213351.9020-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kconfig 'select' does not follow dependency chains, if symbol KSA
selects KSB, then KSA should also depend on the same symbols that KSB
depends on, in order to prevent Kconfig warnings and possible build
errors.

Change NET_DSA_SMSC_LAN9303_I2C so that it is limited to VLAN_8021Q if
the latter is enabled and results in changing NET_DSA_SMSC_LAN9303_I2C
from =y to =m and eliminating the kconfig warning.

WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
  Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
  Selected by [y]:
  - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]

Fixes: be4e119f9914 ("net: dsa: LAN9303: add I2C managed mode support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Juergen Borleis <jbe@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/dsa/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -82,6 +82,7 @@ config NET_DSA_SMSC_LAN9303
 config NET_DSA_SMSC_LAN9303_I2C
 	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
 	depends on I2C
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_SMSC_LAN9303
 	select REGMAP_I2C
 	help
