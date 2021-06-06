Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0665A39CF7E
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFFO0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 10:26:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46583 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230025AbhFFO0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 10:26:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id D64245C00D7;
        Sun,  6 Jun 2021 10:24:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 06 Jun 2021 10:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=y8WPXSPuKnJEPS5sF
        IZh0lvk0zHHbfGWV6UgpVK2L+0=; b=QJC5cb3hf3/B15ybOmc+iTA0icApuhtGi
        vU9JAlepBv2E+23HsVhOyBfv3c7YBMaRcInO09Mv/UN7WpnM3OIK63Px9nUsByYo
        0QZmLJELUuJ5VBYcoUCbQYbNRi6g5YF/E76Ktyte/U4Ivbfb4is2O2iDtHIxkYO8
        HuYveZ0rmPlulx9GW9e1Sx+vbJlehdf5NfJ/OYLESZKDbv6NOIyQp7LAaXdvJd6R
        0H748gnqqjt+O5SPNNu5XHKFrro4DcuDK5OULTLrWD+g4OOdBAIUJ8WbVcof4kof
        tleD06UWaRjyIMy1GwLc9aRWvXOUpKWAPT6BshNkihr1um3iRSu8A==
X-ME-Sender: <xms:q9q8YPRFXIL8dw1L4O1PQTKumQ35bm4cICZWFAHi1usnAMcqvQ6soQ>
    <xme:q9q8YAwdCcVurrJ9LCv4gREH6flmRBaY_yAkZOfyD451RLmFryrUKG0BVZ_3F77XL
    FgbyRSmXnv85gk>
X-ME-Received: <xmr:q9q8YE1-ajvXMQdH796xhqfap8GKJpf-Ov-9DLYK9-yo0hWW02adL1840bi7mjFntKRvjtqT-eD->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedthedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:q9q8YPBgsHNAqsdk_9ubD7zLCJtzJ5afZ9UktbY0f4twc8VTWsGYvA>
    <xmx:q9q8YIiqtHKUjcNr3irdkF9VQGd_3gSoYyJqH4QI-EH5Fj0V6LIZsA>
    <xmx:q9q8YDpoac6DJbM4cAvYZGBCQO-CrAeaCI2meiDqlq1uSv8WxBdVZQ>
    <xmx:rNq8YDUQ968aiN9T-Xl7PRanddYapuweRCvYvxzOmeX3ldhMTRzLpw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 6 Jun 2021 10:24:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        vladyslavt@nvidia.com, andrew@lunn.ch, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ethtool: Fix NULL pointer dereference during module EEPROM dump
Date:   Sun,  6 Jun 2021 17:24:22 +0300
Message-Id: <20210606142422.1589376-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When get_module_eeprom_by_page() is not implemented by the driver, NULL
pointer dereference can occur [1].

Fix by testing if get_module_eeprom_by_page() is implemented instead of
get_module_info().

[1]
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 [...]
 CPU: 0 PID: 251 Comm: ethtool Not tainted 5.13.0-rc3-custom-00940-g3822d0670c9d #989
 Call Trace:
  eeprom_prepare_data+0x101/0x2d0
  ethnl_default_doit+0xc2/0x290
  genl_family_rcv_msg_doit+0xdc/0x140
  genl_rcv_msg+0xd7/0x1d0
  netlink_rcv_skb+0x49/0xf0
  genl_rcv+0x1f/0x30
  netlink_unicast+0x1f6/0x2c0
  netlink_sendmsg+0x1f9/0x400
  __sys_sendto+0xe1/0x130
  __x64_sys_sendto+0x1b/0x20
  do_syscall_64+0x3a/0x70
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c97a31f66ebc ("ethtool: wire in generic SFP module access")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 2a6733a6449a..5d38e90895ac 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -95,7 +95,7 @@ static int get_module_eeprom_by_page(struct net_device *dev,
 	if (dev->sfp_bus)
 		return sfp_get_module_eeprom_by_page(dev->sfp_bus, page_data, extack);
 
-	if (ops->get_module_info)
+	if (ops->get_module_eeprom_by_page)
 		return ops->get_module_eeprom_by_page(dev, page_data, extack);
 
 	return -EOPNOTSUPP;
-- 
2.31.1

