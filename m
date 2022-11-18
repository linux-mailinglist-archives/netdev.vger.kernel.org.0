Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8399D62EED8
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241300AbiKRIDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbiKRIDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:03:23 -0500
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460E8A1AC;
        Fri, 18 Nov 2022 00:03:21 -0800 (PST)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1668758598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y44J0Pt/nPO/pSFOAkMZfH8CxwueGH3Mwo6TRIGNryY=;
        b=FD3cv8GSsHNdpUradPl+tbsouvGeOVBrKzpKMCCfsnh+FaxwTusA77Ln0eEfgq1Ww9FrtZ
        D2a/MSg7Vet+FVU+usqJGBC+ngO6xDIW+9msuHNaPE3fLe4n3e+3CR1PicupTvyZuwb4ir
        HenHsjazlccNVJqh+UIdXio4iqEEyUI=
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH net v3] nfp: flower: Added pointer check and continue
Date:   Fri, 18 Nov 2022 11:03:17 +0300
Message-Id: <20221118080317.119749-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return value of a function 'kmalloc_array' is dereferenced at 
lag_conf.c:347 without checking for null, 
but it is usually checked for this function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.
Fixes: bb9a8d031140 ("nfp: flower: monitor and offload LAG groups")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 drivers/net/ethernet/netronome/nfp/flower/lag_conf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index 63907aeb3884..1aaec4cb9f55 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
@@ -276,7 +276,7 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
 
 	mutex_lock(&lag->lock);
 	list_for_each_entry_safe(entry, storage, &lag->group_list, list) {
-		struct net_device *iter_netdev, **acti_netdevs;
+		struct net_device *iter_netdev, **acti_netdevs = NULL;
 		struct nfp_flower_repr_priv *repr_priv;
 		int active_count = 0, slaves = 0;
 		struct nfp_repr *repr;
@@ -308,6 +308,10 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
 
 		acti_netdevs = kmalloc_array(entry->slave_cnt,
 					     sizeof(*acti_netdevs), GFP_KERNEL);
+		if (!acti_netdevs) {
+			schedule_delayed_work(&lag->work, NFP_FL_LAG_DELAY);
+			continue;
+		}
 
 		/* Include sanity check in the loop. It may be that a bond has
 		 * changed between processing the last notification and the
-- 
2.25.1

