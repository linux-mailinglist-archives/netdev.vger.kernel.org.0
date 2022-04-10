Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648544FACE8
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiDJIcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235852AbiDJIcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24365A59E;
        Sun, 10 Apr 2022 01:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA1F60F09;
        Sun, 10 Apr 2022 08:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D491C385A8;
        Sun, 10 Apr 2022 08:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579387;
        bh=RzNVrIlb72ynOl7Enk1/ch5qBhk/Dwwk6Cey1dPF/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiZp5PjSv4nU9NfvUovs6xwK23b2Xu/dJNNfJYdf7IriLGoV/IotOMZAlP5dnL7VV
         i+rOLO++/IdhS4vZ3rb3gs1r8CP584hG1VRN+zpf2b+jOsX+wzS1CcqNExe5+uzHf1
         V46r3rWAGFCy7kZxRmzm0736OKs+Flyeq+TuWv110HRris7Jl924GVzHczDK1ojtOM
         6xCM5UglaGVCs8UiI3/83NVNlFFN20e0aBBKBaJn88RZiPFdh6eWxQqUKoVOnOjKke
         MqBlKl1tzwZ8cEGZx8I+jHTfrN7gLNWQ6SJTIxON6W2j54vTh41FRPDmUvq3nSxqIS
         eRpZWvwYZoPIw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 17/17] net/mlx5: Don't perform lookup after already known sec_path
Date:   Sun, 10 Apr 2022 11:28:35 +0300
Message-Id: <11bd0d9c142e229e09d37651c99a2c90637135c5.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need to perform extra lookup in order to get already
known sec_path that was set a couple of lines above. Simply reuse it.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index d30922e1b60f..6859f1c1a831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -332,7 +332,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		return;
 	}
 
-	sp = skb_sec_path(skb);
 	sp->xvec[sp->len++] = xs;
 	sp->olen++;
 
-- 
2.35.1

