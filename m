Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7D651F1F7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 00:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbiEHWxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 18:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiEHWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 18:53:30 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2E2DEBA
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:49:38 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4KxKHg4GNgz9sT8;
        Mon,  9 May 2022 00:49:35 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1652050173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Kjai63MgmhUh+kvpvSc5KD0YP1HayXXOmGD4Q9B0UBA=;
        b=pwZgzELTV0QkcE92jsx6IQR8ugQ22Yu86jo03WGzgeCEVfWnHjA7TsUwy87amdksGnzNO0
        nSaXkpcOXlFGo8HZtJqTdKXfVmXPUxZ0RDZJvhRL3ZYtAhRlhHGl/G8Y/eC4dXzmq+vUCT
        vJSakngy1BovmzfWRl0L5hHsrCa21EyWltxMC7mKIA+4stHgZm8z7s53yffkpFBQLUUf5g
        3O6RyfrGdWkF0lcHcH0RDc3OQtNIfbTklycrJmmPp+rWmCYMUGHmQYx1sReX2rLTkjcMaD
        IEFie5JvbY2qK1OF+KJjuwuy1j/cahl3h5Ftg1dTxQD1998DKx5iVseKDi9/BQ==
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
Date:   Mon,  9 May 2022 00:48:44 +0200
Message-Id: <20220508224848.2384723-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was tested on a Buffalo WSR-2533DHP2. This is a board using a 
Mediatek MT7622 SoC and its 2.5G Ethernet MAC connected over a 2.5G 
HSGMII link to a RTL8367S switch providing 5 1G ports.
This is the only board I have using this switch.

With the DSA_TAG_PROTO_RTL8_4 tag format the TCP checksum for all TCP 
send packets is wrong. It is set to 0x83c6. The mac driver probably 
should do some TCP checksum offload, but it does not work. 

When I used the DSA_TAG_PROTO_RTL8_4T tag format the send packets are 
ok, but it looks like the system does TCP Large receive offload, but 
does not update the TCP checksum correctly. I see that multiple received 
TCP packets are combined into one (using tcpdump on switch port on 
device). The switch tag is also correctly removed. tcpdump complains
that the checksum is wrong, it was updated somewhere, but it is wrong.

Does anyone know what could be wrong here and how to fix this?

This uses the rtl8367s-sgmii.bin firmware file. I extracted it from a 
GPL driver source code with a GPL notice on top. I do not have the 
source code of this firmware. You can download it here:
https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.bin
Here are some information about the source:
https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.txt

This file does not look like intentional GPL. It would be nice if 
Realtek could send this file or a similar version to the linux-firmware 
repository under a license which allows redistribution. I do not have 
any contact at Realtek, if someone has a contact there it would be nice 
if we can help me on this topic.

Hauke Mehrtens (4):
  net: dsa: realtek: rtl8365mb: Fix interface type mask
  net: dsa: realtek: rtl8365mb: Get chip option
  net: dsa: realtek: rtl8365mb: Add setting MTU
  net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support

 drivers/net/dsa/realtek/rtl8365mb.c | 444 ++++++++++++++++++++++++++--
 1 file changed, 413 insertions(+), 31 deletions(-)

-- 
2.30.2

