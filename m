Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D736BC279
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjCPA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbjCPA3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:29:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BE413D55;
        Wed, 15 Mar 2023 17:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 647EFB81FA4;
        Thu, 16 Mar 2023 00:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84F8C433D2;
        Thu, 16 Mar 2023 00:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678926551;
        bh=tm3elQtT/lCKqgc2H9IHHDTP9rG20UYB6xYEBj2emzA=;
        h=From:To:Cc:Subject:Date:From;
        b=pREeXnNwMC6XMO6orEdKbXe78bK5eA2PIcqUmDpJ23QrvSw/Y1V9ddbeFBZnMLxGi
         jJuCFETHvBheWUvkLmb0OKxoqNadQGwPqoueuK7Lm1Xn4zLdrstOLRuChfNID2xwJH
         f5eZ0eyVQf7wi2NkmwSp2MxXiiEcQQj8OjFWvofQuKR9bx/NOhCaXAV1xFO+DKQOjr
         EJQQ99HAczNgO8IgM+lyrH4ajNavm2gxbBWo+gcdEUzNv/8S9lLrFsRi0VFtDt4oHe
         RgWTr/BnnPOVScB+khcpseCDXu1jW4RTzeRsQj6FAJxLtZEETU58VELDKk43cRkITl
         z16FXvl+ZZUoQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo@kernel.org, tariqt@nvidia.com, bpf@vger.kernel.org
Subject: [PATCH net] net: xdp: don't call notifiers during driver init
Date:   Wed, 15 Mar 2023 17:29:03 -0700
Message-Id: <20230316002903.492497-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Nothing should be tracking the device until its registered.

Fixes: 4d5ab0ad964d ("net/mlx5e: take into account device reconfiguration for xdp_features flag")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ast@kernel.org
CC: daniel@iogearbox.net
CC: hawk@kernel.org
CC: john.fastabend@gmail.com
CC: lorenzo@kernel.org
CC: tariqt@nvidia.com
CC: bpf@vger.kernel.org
---
 net/core/xdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 87e654b7d06c..5722a1fc6e9e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
 		return;
 
 	dev->xdp_features = val;
+
+	if (dev->reg_state < NETREG_REGISTERED)
+		return;
 	call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
 }
 EXPORT_SYMBOL_GPL(xdp_set_features_flag);
-- 
2.39.2

