Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C4162B4C5
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiKPIOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiKPIOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:14:23 -0500
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7037EB878;
        Wed, 16 Nov 2022 00:13:39 -0800 (PST)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1668586416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hjmjzVkqQPjx/npqqU/y02BPLs+FOpb+o0cfroaLLuc=;
        b=PJB6PZXgOHV0D5d7q9mP/lyARL1pZXYxFup2lag2r+lsiIPB6rTt6ft4aDeQ7mtJIWG9bb
        1fKYeoN5E03KiWOuJOKM7ZLd7K3Ny9h2DgZhRPhNaFTsUPZ2++xv7LGQVkG2H/2Mans21t
        f/fZ4VYUYjEt+cVqtao1lt4HrdgUS4M=
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-patchest@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH v2] lag_conf: Added pointer check and continue
Date:   Wed, 16 Nov 2022 11:13:36 +0300
Message-Id: <20221116081336.83373-1-arefev@swemel.ru>
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

