Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B9D5AC4BC
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiIDOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 10:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIDOSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 10:18:10 -0400
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB96B2E689
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 07:18:08 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id UqRoo6N75sfCIUqRooeLOU; Sun, 04 Sep 2022 16:18:07 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 04 Sep 2022 16:18:07 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] ice: switch: Simplify memory allocation
Date:   Sun,  4 Sep 2022 16:18:02 +0200
Message-Id: <55ff1825aee6e655c41cb6770ca44f0fbdbfec00.1662301068.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'rbuf' is locale to the ice_get_initial_sw_cfg() function.
There is no point in using devm_kzalloc()/devm_kfree().

use kzalloc()/kfree() instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
As a side effect, it also require less memory. devm_kzalloc() has a small
memory overhead, and requesting ICE_SW_CFG_MAX_BUF_LEN (i.e. 2048) bytes,
4096 are really allocated.
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 697feb89188c..eb6e19deb70d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2274,9 +2274,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
 	int status;
 	u16 i;
 
-	rbuf = devm_kzalloc(ice_hw_to_dev(hw), ICE_SW_CFG_MAX_BUF_LEN,
-			    GFP_KERNEL);
-
+	rbuf = kzalloc(ICE_SW_CFG_MAX_BUF_LEN, GFP_KERNEL);
 	if (!rbuf)
 		return -ENOMEM;
 
@@ -2324,7 +2322,7 @@ int ice_get_initial_sw_cfg(struct ice_hw *hw)
 		}
 	} while (req_desc && !status);
 
-	devm_kfree(ice_hw_to_dev(hw), rbuf);
+	kfree(rbuf);
 	return status;
 }
 
-- 
2.34.1

