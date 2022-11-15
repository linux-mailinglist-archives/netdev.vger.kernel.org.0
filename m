Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADA66293C8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiKOJEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKOJEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:04:41 -0500
X-Greylist: delayed 478 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Nov 2022 01:04:40 PST
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29B6E0B6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:04:40 -0800 (PST)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1668502598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=titrkMrDcowcbFHiIEkft2+i/QPFU6J/UtsyULbfVp4=;
        b=guilbAL7ooXHiYs7CzcuqZVJ0qvqu6zHiMmzLxPl7XECNmqQQxjdTVRZx8rsoFwAvbFTgU
        Izlt2TOyjAy3vSKwLyMzJAnxmpNCAeu5Qh0sHyojJfJbRkQybR/jLi5HROpSISYOcFukbN
        r9KKeu/WrXWwwoE+xXMkSD6WcknjW38=
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: [PATCH] lag_conf: Added pointer check
Date:   Tue, 15 Nov 2022 11:56:37 +0300
Message-Id: <20221115085637.72193-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return value of a function 'kmalloc_array' is dereferenced at lag_conf.c:347
without checking for null, but it is usually checked for this function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 drivers/net/ethernet/netronome/nfp/flower/lag_conf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index 63907aeb3884..95ba6e92197d 100644
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
@@ -308,6 +308,8 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
 
 		acti_netdevs = kmalloc_array(entry->slave_cnt,
 					     sizeof(*acti_netdevs), GFP_KERNEL);
+		if (!acti_netdevs)
+		 break;
 
 		/* Include sanity check in the loop. It may be that a bond has
 		 * changed between processing the last notification and the
-- 
2.25.1

