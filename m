Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48D40AE7C
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhINNAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhINNAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D363A610CE;
        Tue, 14 Sep 2021 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631624334;
        bh=ezcA3ZDJPL2vACxGORP6odKdKBTyLznV0kB56uDxqcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ+hcJjw4QvFB8LzCmFgCy1OVJMTsG29JfmrK1kThfWPNsGshAy3yRs8LCcrkNssN
         VpSgciRwI3seXdpuHRWClx6DcpuvqQAc1/GmAjd437ZA+VAl8UyN8Zo0U90ZFpQ6hq
         L9cFZKAy96WOjE7NA/bxA1sEGU2/UUTGpmMfhkXs+XFAu3I6y4ouS9d4wv9gFzUzvp
         NPwdClevKXwT0HFnECJn/ahNxpZG0gqTZr/McW6CJmLGoEsf7Zr4i57kvgv2do8CjP
         +5H2veeYQy2bdZYD3CYzlQSL57Pa8ustH7qfLGiVxjfy/VA/JUohcwB36fj4/K7Dvp
         mqTrcWBKX4QvQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 2/2] devlink: Delete not-used single parameter notification APIs
Date:   Tue, 14 Sep 2021 15:58:29 +0300
Message-Id: <1403fe624b0ece5ce989dbb9ced77a02f0ac5db7.1631623748.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631623748.git.leonro@nvidia.com>
References: <cover.1631623748.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in specific devlink_param_*publish(), because same
output can be achieved by using devlink_params_*publish() in correct
places.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  4 ----
 net/core/devlink.c    | 48 -------------------------------------------
 2 files changed, 52 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 154cf0dbca37..cd89b2dc2354 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1653,10 +1653,6 @@ void devlink_param_unregister(struct devlink *devlink,
 			      const struct devlink_param *param);
 void devlink_params_publish(struct devlink *devlink);
 void devlink_params_unpublish(struct devlink *devlink);
-void devlink_param_publish(struct devlink *devlink,
-			   const struct devlink_param *param);
-void devlink_param_unpublish(struct devlink *devlink,
-			     const struct devlink_param *param);
 int devlink_port_params_register(struct devlink_port *devlink_port,
 				 const struct devlink_param *params,
 				 size_t params_count);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a856ae401ea5..f30121f07467 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10121,54 +10121,6 @@ void devlink_params_unpublish(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_params_unpublish);
 
-/**
- * devlink_param_publish - publish one configuration parameter
- *
- * @devlink: devlink
- * @param: one configuration parameter
- *
- * Publish previously registered configuration parameter.
- */
-void devlink_param_publish(struct devlink *devlink,
-			   const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	list_for_each_entry(param_item, &devlink->param_list, list) {
-		if (param_item->param != param || param_item->published)
-			continue;
-		param_item->published = true;
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_NEW);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(devlink_param_publish);
-
-/**
- * devlink_param_unpublish - unpublish one configuration parameter
- *
- * @devlink: devlink
- * @param: one configuration parameter
- *
- * Unpublish previously registered configuration parameter.
- */
-void devlink_param_unpublish(struct devlink *devlink,
-			     const struct devlink_param *param)
-{
-	struct devlink_param_item *param_item;
-
-	list_for_each_entry(param_item, &devlink->param_list, list) {
-		if (param_item->param != param || !param_item->published)
-			continue;
-		param_item->published = false;
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_DEL);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(devlink_param_unpublish);
-
 /**
  *	devlink_port_params_register - register port configuration parameters
  *
-- 
2.31.1

