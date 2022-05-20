Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35252F3E4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348541AbiETTn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350599AbiETTn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2F8199484;
        Fri, 20 May 2022 12:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 600C161BD2;
        Fri, 20 May 2022 19:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B44C36AE3;
        Fri, 20 May 2022 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075804;
        bh=EwW7HzXO9OKUwDAZY6TpEn7xpcCwzkVGJ3mCzpAXN4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ar6Ol3wXT9GvdWiMdsj3gwdG0HFN50K60lf+wct7esGB2CGyNr4fqsy3xTmmteGyj
         yCXD20+7pPWh+q6tiTFsTGAvsNwhqA2LkiSIuVoj/RuI1phxe1DsOftK62reeS5oxI
         4nSvILa5g3DKKeWw1FoMCqp/T8Y17QOlK3jCz8LxKr0nwdcFRu2Q81dzc/SFBfmbpo
         T41+gXTpAUc7JIT5qt+25Z9c2D4hxUiRsZsALzcXlCfrIsHBNWANlpYE1ZALrzO6uK
         XNsZIwBB4r/X8h/G2UUPnZ5yCb/4fDBmheaElbi2eWnM54xW4rLt7fhWCy2bxAS2q8
         qPyQTsSdEn8DA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, srini.raju@purelifi.com
Subject: [PATCH net-next 1/8] wifi: plfxlc: remove redundant NULL-check for GCC 12
Date:   Fri, 20 May 2022 12:43:13 -0700
Message-Id: <20220520194320.2356236-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC is upset that we check the return value of plfxlc_usb_dev()
even tho it can't be NULL:

drivers/net/wireless/purelifi/plfxlc/usb.c: In function ‘resume’:
drivers/net/wireless/purelifi/plfxlc/usb.c:840:20: warning: the comparison will always evaluate as ‘true’ for the address of ‘dev’ will never be NULL [-Waddress]
  840 |         if (!pl || !plfxlc_usb_dev(pl))
      |                    ^

plfxlc_usb_dev() returns an address of one of the members of pl,
so it's safe to drop these checks.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: srini.raju@purelifi.com
CC: kvalo@kernel.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/purelifi/plfxlc/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index d0e98b2f1365..8519cf0adfff 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -824,7 +824,7 @@ static int suspend(struct usb_interface *interface,
 	struct plfxlc_usb *pl = get_plfxlc_usb(interface);
 	struct plfxlc_mac *mac = plfxlc_usb_to_mac(pl);
 
-	if (!pl || !plfxlc_usb_dev(pl))
+	if (!pl)
 		return -ENODEV;
 	if (pl->initialized == 0)
 		return 0;
@@ -837,7 +837,7 @@ static int resume(struct usb_interface *interface)
 {
 	struct plfxlc_usb *pl = get_plfxlc_usb(interface);
 
-	if (!pl || !plfxlc_usb_dev(pl))
+	if (!pl)
 		return -ENODEV;
 	if (pl->was_running)
 		plfxlc_usb_resume(pl);
-- 
2.34.3

