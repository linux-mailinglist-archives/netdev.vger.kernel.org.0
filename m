Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994B311AB62
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfLKM5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:57:14 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:46431 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLKM5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:57:14 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MoOIi-1hugFE2B6e-00ol0h; Wed, 11 Dec 2019 13:56:48 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/2] net: ethernet: ti: select PAGE_POOL for switchdev driver
Date:   Wed, 11 Dec 2019 13:56:09 +0100
Message-Id: <20191211125643.1987157-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6xobw418PyXkV3CYCKrKrkqYW/pQBVgYt++7QWDd1Gfizh2agwO
 DVm/zQK2J9mYF45nZz9r+hJW5WNEs79PYMDjvnpCSaz+juIGroWBy+kCKJnkSjiwJe11xtJ
 k/+cxrj1Koa2WOT96iYKn1gdzuSDKeOI8MdVKGY93tjVmy1yqI1rjd3nnnrS9tPiOVyoTsC
 /UcNApcongbQFK1MvZ1Dg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o0oCe+1KPDY=:3I5WOPzsVQn/dZchhDjCqQ
 362M8WJcGI1zUSC5T1bN8rol0rStp2wLcrxKXY6cluhRZo5wN8Jvxk/QLnjxYIRVTXT2MpWbB
 EWbwwJcZWosRBqy0qiRQMiTBFxrugsUEJqMDUyVUUIv6bELxjsLUpQP38V/bEXfuZojr/e4Iz
 fAc5mEgni8MZvt3ZpoLAcf/oqzg4kSt4ozZCtHCqHaGwj5pNcwkjslkFFJ0sGmdOxH7JEN97b
 aRxht6GJ4K5+oIaIgxo4aAIgD2UCZQt++998LUrdGAAatwt/dOaMbVkp/Z+aVkqk/pHPHwDEj
 QhPae0wjGTMc3aDNNftsZlRkgIxIk8vvU0qjXxKt4NBgUpul0TNMgSlTYAd3EOCMH5F5orh/d
 47rul2ONxiLGR2eLHWxAyf/w6nP5CqBNuhYAftdpeBO8n8a2Iu1GDOJZTjMZmMxIt5G9CfdTb
 maj1cjiINatkodirADoJuRBBOWX8PXWMXTkkSET2JMv8mpcR/0V2GsjIRdLYHw4rPMEEoYuDP
 bkhtwEJMPj0JJfR6D/8UtHelmmEtbDaKcj+5m+I+k1zWE1Dom4Vih/NH4p4kYPBG2HyHEIDTF
 Jl5LLAYu1/lmyvi98ARkZ5znucnpkiSIlyTCQOi/jRs004JSUwSJli/V9/tZgsh/freQ2zvd8
 ef0/tcmcni0MQ0ich7AoLXGPcaP8m7jyCqc4XjmMA1xe3jrMQvyjTvVlp8rCCUmXAj91vkgkK
 H/DWKrdI8c9/HoHxzSRqoiNyK4wM3fh2VoWnYKVoVXAYPkHSgZc/sl/CEzHyBSZJjnNaFoHpj
 T/v3JsjU2qv8AfVVyBxCy0URjCrIguF4CeAodvrr90ebvLc5HAv9syu2r+E4dof+aqzWXB3XU
 gbVQZ0jxc2A8xn/jcMVw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new driver misses a dependency:

drivers/net/ethernet/ti/cpsw_new.o: In function `cpsw_rx_handler':
cpsw_new.c:(.text+0x259c): undefined reference to `__page_pool_put_page'
cpsw_new.c:(.text+0x25d0): undefined reference to `page_pool_alloc_pages'
drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_fill_rx_channels':
cpsw_priv.c:(.text+0x22d8): undefined reference to `page_pool_alloc_pages'
cpsw_priv.c:(.text+0x2420): undefined reference to `__page_pool_put_page'
drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_create_xdp_rxqs':
cpsw_priv.c:(.text+0x2624): undefined reference to `page_pool_create'
drivers/net/ethernet/ti/cpsw_priv.o: In function `cpsw_run_xdp':
cpsw_priv.c:(.text+0x2dc8): undefined reference to `__page_pool_put_page'

Other drivers use 'select' for PAGE_POOL, so do the same here.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index a46f4189fde3..bf98e0fa7d8b 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -63,6 +63,7 @@ config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
 	depends on NET_SWITCHDEV
+	select PAGE_POOL
 	select TI_DAVINCI_MDIO
 	select MFD_SYSCON
 	select REGMAP
-- 
2.20.0

