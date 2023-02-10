Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9EB692610
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbjBJTGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbjBJTGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:06:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680467D3C1;
        Fri, 10 Feb 2023 11:06:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C16FB825BC;
        Fri, 10 Feb 2023 19:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29262C433D2;
        Fri, 10 Feb 2023 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676055980;
        bh=8lsCEgROoEtcfinfR/dx9LiLvvJFkEUqIvfocx0/KpM=;
        h=From:To:Cc:Subject:Date:From;
        b=KJajRT3LLMXYxiN2QGPYmk76Gp7r+VfGX3HmpoRBGrp+ai248ZCHWslVlfgkdXIyL
         YTgqHoR15OoVG2zCtPkQZaRNiX4yh6jTLBQbOHWManY7OOd42bIlhNJQrSUiqUh8a4
         EwMTq9EW/ZNGYrDiSgptLm06U/y/kdUWAXrOh17nubq4AHbndZsN+cMa43+gnx39uS
         AV4/JSQj5se4/aHRR9BTkucF7U97LuYvnlBGY21jk1JZ4taoEPAReTla3JCUzQsxvz
         kn9HmsW/VurtjNPhxdTfz4sJhdzD0z9aZ6cB9X1f0J6xj1Bu1MLkottP177s+Ds3WS
         H8GXaxKCvZbHQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        lorenzo.bianconi@redhat.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH bpf-next] net: lan966x: set xdp_features flag
Date:   Fri, 10 Feb 2023 20:06:04 +0100
Message-Id: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
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

Set xdp_features netdevice flag if lan966x nic supports xdp mode.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 580c91d24a52..b24e55e61dc5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -823,6 +823,11 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	port->phylink = phylink;
 
+	if (lan966x->fdma)
+		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
+				    NETDEV_XDP_ACT_REDIRECT |
+				    NETDEV_XDP_ACT_NDO_XMIT;
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(lan966x->dev, "register_netdev failed\n");
-- 
2.39.1

