Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1A551DE20
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444091AbiEFRL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444081AbiEFRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 13:11:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C426EC62;
        Fri,  6 May 2022 10:08:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ED53620A2;
        Fri,  6 May 2022 17:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D41C385A8;
        Fri,  6 May 2022 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651856880;
        bh=Bmv24wDzPPLP1a8A/geDsPVqFBaz6EzwVn0bnMkZ/JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcvMS6YVhuCba+GOfhSJPiAMSN4zas94rnPnrkmhFHAe0NMsz+1qtcSKPqcdoBCsS
         gQ31NCxUsSpvgTBm1IePywJy/jJ1Z/9kvX2Au6SMfz6qSaYLUjr8SruSG7RXxQeU3K
         ah/3NKDAC3dL/QxnRwjrWEDxqBmhPMQ2XkQHybazofb+B7goAIuc5J/WdFtg5BDUI4
         V72MWtQFVVtLDHSfZnsUVcdKvudnTS+WfnCdrq5DypTlX4iiujpGmymyYN9b6O5rEX
         MNhch6zzrF20CqfxipE51IW6sjmF3bjhU15B329lTBkWtpj57UBEfYKNRHhWw3i1Qr
         zoTqiLmLR+tAQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, hayeswang@realtek.com,
        linux-usb@vger.kernel.org
Subject: [PATCH net-next 4/6] r8152: switch to netif_napi_add_weight()
Date:   Fri,  6 May 2022 10:07:49 -0700
Message-Id: <20220506170751.822862-5-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506170751.822862-1-kuba@kernel.org>
References: <20220506170751.822862-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8152 uses a custom napi weight, switch to the new
API for setting custom weight.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: hayeswang@realtek.com
CC: linux-usb@vger.kernel.org
---
 drivers/net/usb/r8152.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d3b53db57c26..c2da3438387c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9732,10 +9732,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, tp);
 
-	if (tp->support_2500full)
-		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);
-	else
-		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);
+	netif_napi_add_weight(netdev, &tp->napi, r8152_poll,
+			      tp->support_2500full ? 256 : 64);
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
-- 
2.34.1

