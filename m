Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6332A2522
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgKBHZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgKBHZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:25:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B81C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 23:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=xFDic8WzdGemxJgvwxKaFH2G2gRDJ46dwr45bFfosps=; b=SThfjHtB0TSxI973Y8J+w01BQ0
        wB63zwBz1vRe8RCXfcpYNKPJJvcNvwjqA+Wns3cQqABMICZ50KoJx+/VAdRbQK1UZy0mtW4CzlMjD
        OeB9s0+4rWWMlift85o5ChIepAo+b/7v18/CGbnj4EjOdrfksuq2kQsZNGikslQtxTV5AKYvq5lp/
        lYnyngSeXsq005i9fN6yi0IwNyot+uxT42SCh/OmgNHEjskke9q+N+mKgavrRyfR+yrzE19Z8T37a
        x6mUN4HqemOL180+iIzk/kSdWgTvhIO3TdNS6pff5jvN3gquSFEn1o2oFOt5y4uG/iJzoYljztrtC
        e03QC53w==;
Received: from [2601:1c0:6280:3f0::60d5] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZUD7-00045l-0Y; Mon, 02 Nov 2020 07:25:02 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: [PATCH] staging: wimax: depends on NET
Date:   Sun,  1 Nov 2020 23:24:56 -0800
Message-Id: <20201102072456.20303-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):

ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_alloc':
op-msg.c:(.text+0xa9): undefined reference to `__alloc_skb'
ld: op-msg.c:(.text+0xcc): undefined reference to `genlmsg_put'
ld: op-msg.c:(.text+0xfc): undefined reference to `nla_put'
ld: op-msg.c:(.text+0x168): undefined reference to `kfree_skb'
ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_data_len':
op-msg.c:(.text+0x1ba): undefined reference to `nla_find'
ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_send':
op-msg.c:(.text+0x311): undefined reference to `init_net'
ld: op-msg.c:(.text+0x326): undefined reference to `netlink_broadcast'
ld: drivers/staging/wimax/stack.o: in function `__wimax_state_change':
stack.c:(.text+0x433): undefined reference to `netif_carrier_off'
ld: stack.c:(.text+0x46b): undefined reference to `netif_carrier_on'
ld: stack.c:(.text+0x478): undefined reference to `netif_tx_wake_queue'
ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_exit':
stack.c:(.exit.text+0xe): undefined reference to `genl_unregister_family'
ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_init':
stack.c:(.init.text+0x1a): undefined reference to `genl_register_family'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: netdev@vger.kernel.org
---
 drivers/staging/wimax/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201102.orig/drivers/staging/wimax/Kconfig
+++ linux-next-20201102/drivers/staging/wimax/Kconfig
@@ -5,6 +5,7 @@
 
 menuconfig WIMAX
 	tristate "WiMAX Wireless Broadband support"
+	depends on NET
 	depends on RFKILL || !RFKILL
 	help
 
