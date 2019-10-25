Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E111E445F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393347AbfJYH1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:27:12 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:46869 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389667AbfJYH1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:27:11 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MNbxN-1id7L519cB-00P8aS; Fri, 25 Oct 2019 09:27:00 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Mao Wenan <maowenan@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: sja1105: improve NET_DSA_SJA1105_TAS dependency
Date:   Fri, 25 Oct 2019 09:26:35 +0200
Message-Id: <20191025072654.2860705-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:h1VgGfUU1DXRVft0/mll3FnC14dAvqdBRJeJvlRH1rdPVsMM8yi
 5dtnnHHNpUPBqqkmxSQr5LrHBaHbneRyL5yGl0ewMVCu6LVEiIleuNU0KL0PDrcXtxGG4S+
 nLon47qtOU3fdT3x8RVTEo4Yx3XUDq3NM8wToKW5QA9UF3VP9IuTwr9zpC0S0jN78F1ABla
 2f8KMxSIqWHP/ztB1IAZQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:C7X5cOwiq2o=:ImT0kAVjbWxKk5ZyNCvp+O
 nhZsqKrVFJskLQCL+6miXsnb2XuGevt4LXVWuQZ/XtiYXfhgdMJhUpfHtRUrFQftsdTmTnEsT
 hx7J4qyyaytoPF/FKCP/KCFwlFBrxGq+L6KNAL4rB/PHh8JCHZSixx5lwe+2bJ7P/OaKhFSG8
 2MRIoZcvfq2wS5Pnf4e0QxhtqEK7uv+3Ej9fS0qTvWwaFS9jC97gBKgFaIrefdCxAaWuRVP96
 xa2DwfaJKOigQtU/fjih+t39yky9KRWjjM9GTtdabE2mTMVi45ItWw8ySqLm2PDzsIie6aTbI
 wTGinSFvzcGBBDMta9gx/xeS9OgHKvu9wsQ935H1ggurJYVb0US/5+Et55eRXaL0WoIoo/Hpn
 XZHwTTzByNXw6wJFxOktaEltvckO2HsEKH3GL6VQAvcIUWbcxYCr8A56Gugit3HofzwChHptX
 /CGDSFUdKhD4Gu2zFDG/FbHkpM9Xzylz+xTTvTwjIVkJeGoshSWcXHnURbOHefR7cUTOTkyks
 kPiIQxxmopwQOG9jwZ8Mw7pEfNViX67tDGAxWKBXwjgLi5ocSII0QV0/QjIicEwisajk5dSeK
 1d4cmoieptP1SyJ0qdKY0ZNmIRIr4ccV1UqKRfDIaqGRnSmoBWPBYi1bluDNrq+ImJHBHBpJY
 2rVcqWiR1ZugemGTlWNNGtz61ngECNyyLmD43f4twAhhhPK4ekygvavglOZGjcwZH0SEqYJqz
 vpO+S3sZyKpRx328QmemIVml0DRgJEEsOZHX6keYl9lVW3LxlQAH7OukTVTHQWMiBGNWhOLgE
 97A8Bk2a5+rICdVoinXlRnADJwelwLmBqsYkEZMVQZHxt2sSj4Gjh2BRfS+q8D1QLRzPz65rr
 aCr328awhq71stCyuQdA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An earlier bugfix introduced a dependency on CONFIG_NET_SCH_TAPRIO,
but this missed the case of NET_SCH_TAPRIO=m and NET_DSA_SJA1105=y,
which still causes a link error:

drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_setup_tc_taprio':
sja1105_tas.c:(.text+0x5c): undefined reference to `taprio_offload_free'
sja1105_tas.c:(.text+0x3b4): undefined reference to `taprio_offload_get'
drivers/net/dsa/sja1105/sja1105_tas.o: In function `sja1105_tas_teardown':
sja1105_tas.c:(.text+0x6ec): undefined reference to `taprio_offload_free'

Change the dependency to only allow selecting the TAS code when it
can link against the taprio code.

Fixes: a8d570de0cc6 ("net: dsa: sja1105: Add dependency for NET_DSA_SJA1105_TAS")
Fixes: 317ab5b86c8e ("net: dsa: sja1105: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/sja1105/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index f40b248f0b23..ffac0ea4e8d5 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -26,8 +26,8 @@ config NET_DSA_SJA1105_PTP
 
 config NET_DSA_SJA1105_TAS
 	bool "Support for the Time-Aware Scheduler on NXP SJA1105"
-	depends on NET_DSA_SJA1105
-	depends on NET_SCH_TAPRIO
+	depends on NET_DSA_SJA1105 && NET_SCH_TAPRIO
+	depends on NET_SCH_TAPRIO=y || NET_DSA_SJA1105=m
 	help
 	  This enables support for the TTEthernet-based egress scheduling
 	  engine in the SJA1105 DSA driver, which is controlled using a
-- 
2.20.0

