Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1256B8DF5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjCNI7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjCNI7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104C385B0E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B756AB818B8
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E00C433EF;
        Tue, 14 Mar 2023 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784351;
        bh=iocWtO/7iHieePJNhjmBhxiXwPoD/5UKvVkAR+VEVEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhaSTQElHkt/mmClvoX6eGR6unMBwduAxj3/XNZpfbK8GvS7twmGAKlf3zCgbpALT
         erF/U4Kt6TXKCZUnnJX6Dk863ajw0l+gxnyznfUh0mLjp0yb7j1xL0cp/E1DFDgrPF
         ao1Muxsza3kfzt7ayEvNeQhWgn4Eo3Tpn8OsxpEoRXFxw4Mk6vQewXehfxJHVGCfMj
         gnikQPNKoiVaZGHKt4DnokScyKpa4hclRCj64G5eKC5uLJv7+AYToFtOULZuJC2Fw+
         SLfscsXsphTPFaQ4iwkkFAoe4Gjbbv2N6qEyLd4V4qjQEr441SZ4vTMO8aDhkm2nHk
         +Jf8rgGUWYtSw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 4/9] xfrm: add new device offload acquire flag
Date:   Tue, 14 Mar 2023 10:58:39 +0200
Message-Id: <f5da0834d8c6b82ab9ba38bd4a0c55e71f0e3dab.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
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

From: Raed Salem <raeds@nvidia.com>

During XFRM acquire flow, a default SA is created to be updated later,
once acquire netlink message is handled in user space. When the relevant
policy is offloaded this default SA is also offloaded to IPsec offload
supporting driver, however this SA does not have context suitable for
offloading in HW, nor is interesting to offload to HW, consequently needs
a special driver handling apart from other offloaded SA(s).
Add a special flag that marks such SA so driver can handle it correctly.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h    | 5 +++++
 net/xfrm/xfrm_state.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e1f70e8e424..33ee3f5936e6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -138,6 +138,10 @@ enum {
 	XFRM_DEV_OFFLOAD_PACKET,
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_FLAG_ACQ = 1,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
@@ -145,6 +149,7 @@ struct xfrm_dev_offload {
 	unsigned long		offload_handle;
 	u8			dir : 2;
 	u8			type : 2;
+	u8			flags : 2;
 };
 
 struct xfrm_mode {
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 2ab3e09e2227..7cca0a1fa5ff 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1272,6 +1272,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xso->dir = xdo->dir;
 			xso->dev = xdo->dev;
 			xso->real_dev = xdo->real_dev;
+			xso->flags = XFRM_DEV_OFFLOAD_FLAG_ACQ;
 			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
 					     GFP_ATOMIC);
 			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
-- 
2.39.2

