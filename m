Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24C4EFDF2
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 04:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiDBCTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 22:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiDBCTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 22:19:37 -0400
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5CEB120A381;
        Fri,  1 Apr 2022 19:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=BINrC
        NBNH44euvnshLFjjJf4FagiFC3JLY+4VjHPKL8=; b=Vz+Zad/M0vsawnPWVgkqK
        /c+k91Ifj1zun7LHfDYmuArkwVK78gTiClRy9VrHucLD5fDGn1s6bSyOEZ1CK6dQ
        YUGKcWLC5GQntclMK0PBjOjEWIWC3DniZmIon3h2Qnks/HkBd4/sjgPe3pF6Hqy2
        HGu00KW5k5DJdflkTuxFz4=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp2 (Coremail) with SMTP id GtxpCgCH7DktskdiqyxVAA--.10933S4;
        Sat, 02 Apr 2022 10:17:25 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH v2] ice: Fix memory leak in ice_get_orom_civd_data()
Date:   Sat,  2 Apr 2022 10:17:15 +0800
Message-Id: <20220402021715.4740-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgCH7DktskdiqyxVAA--.10933S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw17Xr48Zr1kGw1DGr1rZwb_yoWDCwc_uw
        47XryfJrW5W3WFy3y5tayfua40vr1DXF95Za13tayfX345Cr9FqasYvrWfXr40gr15AF9r
        Ar43ta43C345tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_yxRPUUUUU==
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiQxXWjFc7YXss4QAAs3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A memory chunk was allocated for orom_data in ice_get_orom_civd_data()
by vzmalloc(). But when ice_read_flash_module() fails, the allocated
memory is not freed, which will lead to a memory leak.

We can fix it by freeing the orom_data when ce_read_flash_module() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 4eb0599714f4..13cdb5ea594d 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -641,6 +641,7 @@ ice_get_orom_civd_data(struct ice_hw *hw, enum ice_bank_select bank,
 	status = ice_read_flash_module(hw, bank, ICE_SR_1ST_OROM_BANK_PTR, 0,
 				       orom_data, hw->flash.banks.orom_size);
 	if (status) {
+		vfree(orom_data);
 		ice_debug(hw, ICE_DBG_NVM, "Unable to read Option ROM data\n");
 		return status;
 	}
-- 
2.25.1

