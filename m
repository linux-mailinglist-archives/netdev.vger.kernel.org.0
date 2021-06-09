Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877913A10B8
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhFIJ6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:58:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5354 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbhFIJ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:58:41 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0Mq90lYGz6tqL;
        Wed,  9 Jun 2021 17:52:53 +0800 (CST)
Received: from huawei.com (10.67.174.47) by dggeme758-chm.china.huawei.com
 (10.3.19.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 17:56:44 +0800
From:   He Ying <heying24@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <heying24@huawei.com>
Subject: [PATCH -next] netfilter: Make NETFILTER_NETLINK_HOOK depends on NF_TABLES
Date:   Wed, 9 Jun 2021 05:57:30 -0400
Message-ID: <20210609095730.185982-1-heying24@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.174.47]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiling errors happen when CONFIG_NETFILTER_NETLINK_HOOK = y
while CONFIG_NF_TABLES is not set:

net/netfilter/nfnetlink_hook.c: In function ‘nfnl_hook_put_nft_chain_info’:
net/netfilter/nfnetlink_hook.c:76:7: error: implicit declaration of function
‘nft_is_active’ [-Werror=implicit-function-declaration]
   76 |  if (!nft_is_active(net, chain))
      |       ^~~~~~~~~~~~~

Notice that nft_is_active macro is only defined when CONFIG_NF_TABLES
is enabled, so add dependency on NF_TABLES in NETFILTER_NETLINK_HOOK
configurations.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: He Ying <heying24@huawei.com>
---
 net/netfilter/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c81321372198..54395266339d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,6 +22,7 @@ config NETFILTER_FAMILY_ARP
 config NETFILTER_NETLINK_HOOK
 	tristate "Netfilter base hook dump support"
 	depends on NETFILTER_ADVANCED
+	depends on NF_TABLES
 	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
-- 
2.17.1

