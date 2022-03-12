Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34CA4D6C6F
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 05:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiCLEVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 23:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiCLEVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 23:21:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EED2738DD;
        Fri, 11 Mar 2022 20:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=fycX+0W01lwkWLDtUaJyvpZj5KgSVEIRZKJJ6G2XTZc=; b=kQK+Lz9y3Dk/XDrh/6d3DSBAfR
        wAWqoO7ga4l0/kJ6jEn3nfLCc/KHFMnZnubR5Kofc8QUDHs0GWheQbNd0lq7TIFbPNtMotrDuZYYj
        lzywRKyUJIMFUJzpG0Qphyib0f7LE1B8j2rO35E/hAQWHEtiMdO+5YHm30ieCgJ7EPEodukC/Ra5v
        mdomQNT1ioh1BpEt4QHJZvdGs43WqZD60nOXnnSCcxo4KvpV0v+LhEzcwHE79iPNWOdbP02AFizCH
        qow3MiALvbUtf9LIEcTIcOfznQLa8kxz4OkbLL1rIPEA192g/SXOMOjGcCxD7DHDlMmOgInG+csMg
        tdrEwvWw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nStEx-000k3M-1k; Sat, 12 Mar 2022 04:20:27 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Phil Sutter <n0-1@freewrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Daniel Walter <dwalter@google.com>
Subject: [PATCH] MIPS: RB532: fix return value of __setup handler
Date:   Fri, 11 Mar 2022 20:20:26 -0800
Message-Id: <20220312042026.10482-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
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

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from setup_kmac().

Fixes: 9e21c7e40b7e ("MIPS: RB532: Replace parse_mac_addr() with mac_pton().")
Fixes: 73b4390fb234 ("[MIPS] Routerboard 532: Support for base system")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
From: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Phil Sutter <n0-1@freewrt.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Daniel Walter <dwalter@google.com>
---
 arch/mips/rb532/devices.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-next-20220309.orig/arch/mips/rb532/devices.c
+++ linux-next-20220309/arch/mips/rb532/devices.c
@@ -301,11 +301,9 @@ static int __init plat_setup_devices(voi
 static int __init setup_kmac(char *s)
 {
 	printk(KERN_INFO "korina mac = %s\n", s);
-	if (!mac_pton(s, korina_dev0_data.mac)) {
+	if (!mac_pton(s, korina_dev0_data.mac))
 		printk(KERN_ERR "Invalid mac\n");
-		return -EINVAL;
-	}
-	return 0;
+	return 1;
 }
 
 __setup("kmac=", setup_kmac);
