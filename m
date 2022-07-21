Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911DD57C8E8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 12:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiGUK1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 06:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiGUK1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 06:27:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2CC5D5BC;
        Thu, 21 Jul 2022 03:27:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c139so1371918pfc.2;
        Thu, 21 Jul 2022 03:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hnx5MUx2Qay45VKPxChWILBO1CDCjk/WOYP9rCnQ4A4=;
        b=YjrQI/1ayvgUAdDFhvxjLCh8wm+uE3CWIbPq68wdA8NBOFkpBB3jGi5PbI0nTmwVEz
         AfF1r15nTjZXSKAOQOeMsoreVGtp/c6p3q9dBFT/3JAUT6XYZQiGcigD2R0wm23bIat4
         2DSIKDf73m7pjDxycdQZGYwR6vnwZv85dUaH8FFa6rE73Fw2u8xQKMXbiOb7ZuPGoW52
         ESGVeRtj3Nvm6fu9j86/IOrSlFvkirayrQKyxs+cY+3aMqwQNSy3aEzLB9Gvic0Pfatf
         McmMruj7L3jFaykFy6wsnwhzU5NDxZRHtQ9Fn+M52/+4fdEGzZxpY2Vu6NQcuaj3vzKO
         0KVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hnx5MUx2Qay45VKPxChWILBO1CDCjk/WOYP9rCnQ4A4=;
        b=RnGpypPHc1lKFFb6o8O5SFyquD3ZK+bTVE2D2kzS2uM108op5iPDVWBn9X/4dCxZXq
         PL0+jkscV8btbxcbro8omdEb7wZr98BcKnKf4C2p+DDvNlRFRp/auTP0pFtVSVgMfQz4
         LPQtOczDA6FCgKOzGu7fxDrlIhm76/peNtndlcpt/v9E/iHBoLVVcwrXJBq3sUfceDP4
         dWcI7orUr06GUykvlLikmdlAx2Vi9Kkn6stxrtZmI/wTiR+u6yK+IoRH6jtLzxvlufQD
         eAvwsNROQT1unPeS8vxtcCUYtIGKMukRSnRrA6VgiXPngHraZ6UMBY+YGU1BT9NlZpxk
         /3MA==
X-Gm-Message-State: AJIora+nEksDwYzH4t7WWaGJNujNKL6okZKpBPo7bQnOLPmIYrNidvsf
        8z5nv3lEnNbSjg1WRtsY+p1Paj91GwjH9Vd2vTU=
X-Google-Smtp-Source: AGRyM1veomwcwmD7njgdLv3uDNpUEWGyLAwEAdjYT3F5q9MrhFq81H8SEWHFwnAb2VVpBxeBowdtHQ==
X-Received: by 2002:a63:8441:0:b0:41a:8f86:a6dc with SMTP id k62-20020a638441000000b0041a8f86a6dcmr301636pgd.296.1658399220798;
        Thu, 21 Jul 2022 03:27:00 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.googlemail.com with ESMTPSA id f64-20020a17090a28c600b001ef7c7564fdsm3285752pjd.21.2022.07.21.03.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:27:00 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, idosch@nvidia.com,
        petrm@nvidia.com, linux-kernel@vger.kernel.org,
        Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 1/2] mlxsw: use netif_is_any_bridge_port() instead of open code
Date:   Thu, 21 Jul 2022 19:26:47 +0900
Message-Id: <20220721102648.2455-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code which is netif_is_bridge_port() || netif_is_ovs_port() is
defined as a new helper function on netdev.h like netif_is_any_bridge_port
that can check both IFF flags in 1 go. So use netif_is_any_bridge_port()
function instead of open code. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 23d526f13f1c..3a16c24154e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8590,9 +8590,7 @@ static int mlxsw_sp_inetaddr_port_event(struct net_device *port_dev,
 					unsigned long event,
 					struct netlink_ext_ack *extack)
 {
-	if (netif_is_bridge_port(port_dev) ||
-	    netif_is_lag_port(port_dev) ||
-	    netif_is_ovs_port(port_dev))
+	if (netif_is_any_bridge_port(port_dev) || netif_is_lag_port(port_dev))
 		return 0;

 	return mlxsw_sp_inetaddr_port_vlan_event(port_dev, port_dev, event,
--
2.34.1

