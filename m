Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A6A5177D0
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387214AbiEBURs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiEBURq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:17:46 -0400
Received: from mxout03.lancloud.ru (mxout03.lancloud.ru [45.84.86.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FFEAE4C;
        Mon,  2 May 2022 13:14:14 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 0CCEF208D328
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] smsc911x: allow using IRQ0
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-sh@vger.kernel.org>
Organization: Open Mobile Platform
Message-ID: <656036e4-6387-38df-b8a7-6ba683b16e63@omp.ru>
Date:   Mon, 2 May 2022 23:14:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AlphaProject AP-SH4A-3A/AP-SH4AD-0A SH boards use IRQ0 for their SMSC
LAN911x Ethernet chip, so the networking on them must have been broken by
commit 965b2aa78fbc ("net/smsc911x: fix irq resource allocation failure")
which filtered out 0 as well as the negative error codes -- it was kinda
correct at the time, as platform_get_irq() could return 0 on of_irq_get()
failure and on the actual 0 in an IRQ resource.  This issue was fixed by
me (back in 2016!), so we should be able to fix this driver to allow IRQ0
usage again...

When merging this to the stable kernels, make sure you also merge commit
e330b9a6bb35 ("platform: don't return 0 from platform_get_irq[_byname]()
on error") -- that's my fix to platform_get_irq() for the DT platforms...

Fixes: 965b2aa78fbc ("net/smsc911x: fix irq resource allocation failure")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
CC: stable@vger.kernel.org

---
This patch is against DaveM's 'net.git' repo.

 drivers/net/ethernet/smsc/smsc911x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: net/drivers/net/ethernet/smsc/smsc911x.c
===================================================================
--- net.orig/drivers/net/ethernet/smsc/smsc911x.c
+++ net/drivers/net/ethernet/smsc/smsc911x.c
@@ -2431,7 +2431,7 @@ static int smsc911x_drv_probe(struct pla
 	if (irq == -EPROBE_DEFER) {
 		retval = -EPROBE_DEFER;
 		goto out_0;
-	} else if (irq <= 0) {
+	} else if (irq < 0) {
 		pr_warn("Could not allocate irq resource\n");
 		retval = -ENODEV;
 		goto out_0;
