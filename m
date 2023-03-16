Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7578D6BDB3C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 23:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjCPWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 18:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPWCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 18:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73F56A9E4;
        Thu, 16 Mar 2023 15:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42AC6620F9;
        Thu, 16 Mar 2023 22:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45240C433D2;
        Thu, 16 Mar 2023 22:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679004158;
        bh=kpHgwiAqIDraPVYtTQGcOgmprbnNh5n+bh7bORuwKUs=;
        h=From:To:Cc:Subject:Date:From;
        b=VALRbTK1xosyl1FEm3VF2DRvYFJmrP0fecPjaGvb6KsLZ54OTYl/6uF0sJGgvsrul
         YgwXA+drdIGKtMMzOZkc7cxAVekxHJJ1V4rdaQNm522Epnms4omex0MdIhbI6vPtTy
         q6DKJZXNW5zl8Vp/BHW5/boUl77zY4qnPodpl80Z34vUxAWRAeCckIPoXRI2+yLinw
         vL+gUyvB82qEGzcGVD+HDz5eCSkIYr0CB77U/kI9E2JUX2aS6RCHkbQe9AzRx9J0aV
         ZjKsqQYcNKGiLQ6QZhy6aMX8NUyIIQJqKsdh6nYNGPPDFcJ+Q4dgBA0zTCS8P4SkdF
         qe4P4JVocGLew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo@kernel.org, tariqt@nvidia.com, bpf@vger.kernel.org
Subject: [PATCH net v2] net: xdp: don't call notifiers during driver init
Date:   Thu, 16 Mar 2023 15:02:34 -0700
Message-Id: <20230316220234.598091-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers will commonly perform feature setting during init, if they use
the xdp_set_features_flag() helper they'll likely run into an ASSERT_RTNL()
inside call_netdevice_notifiers_info().

Don't call the notifier until the device is actually registered.
Nothing should be tracking the device until its registered and
after its unregistration has started.

Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfiguration for xdp_features flag")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: only call for REGISTERED devices, not dead ones
v1: https://lore.kernel.org/all/20230316002903.492497-1-kuba@kernel.org/

CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: hawk@kernel.org
CC: john.fastabend@gmail.com
CC: lorenzo@kernel.org
CC: tariqt@nvidia.com
CC: bpf@vger.kernel.org
---
 net/core/xdp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 87e654b7d06c..b5737e47ec41 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -781,7 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
 		return;
 
 	dev->xdp_features = val;
-	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
+
+	if (dev->reg_state == NETREG_REGISTERED)
+		call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
 }
 EXPORT_SYMBOL_GPL(xdp_set_features_flag);
 
-- 
2.39.2

