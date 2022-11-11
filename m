Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317376255B4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiKKIsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiKKIsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:48:08 -0500
X-Greylist: delayed 87 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 00:48:07 PST
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A2182C41
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:48:07 -0800 (PST)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1otPgL-000N67-Ki;
        Fri, 11 Nov 2022 09:46:37 +0100
Received: from [82.197.179.206] (helo=[192.168.169.11])
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1otPgL-000Dpr-Cy;
        Fri, 11 Nov 2022 09:46:37 +0100
X-Authenticated-Sender-Id: thomas@kupper.org
Message-ID: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
Date:   Fri, 11 Nov 2022 09:46:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
Subject: [PATCH v2 net 1/1] amd-xgbe: fix active cable
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When determine the type of SFP, active cables were not handled.

Add the check for active cables as an extension to the passive cable check.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
---
  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4064c3e3dd49..1ba550d5c52d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct 
xgbe_prv_data *pdata)
      }

      /* Determine the type of SFP */
-    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
-        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+    if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
+         phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
+         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
          phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
      else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
          phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
--
2.34.1

