Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05C51D8BD
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392342AbiEFNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343556AbiEFNWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:22:30 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA5564709
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 06:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5sm77WW8oeptNyKKzjFQExbRMu2tQxOt2w1bYFv387g=; b=imX4tqrSJ/6w/XUmO9UaPoxBBH
        4Yoild3tA7D8LK2jjxN4SneuLXL+z0qLCcnYig72Updhgs3TG4zgrEGMaQe5O8UbGeNWYi2xiTyCj
        ydSwkPFQECfoPm/thb83OIevAXNwnx+dSOA7Hevsd1aYa7YqBfLC/mAz+AxlEhLl6wco=;
Received: from p200300daa70ef2004175abbac4c8f9c2.dip0.t-ipconnect.de ([2003:da:a70e:f200:4175:abba:c4c8:f9c2] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nmxr3-0005Kx-O0; Fri, 06 May 2022 15:18:45 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH 4/4] netfilter: nft_flow_offload: fix offload with pppoe + vlan
Date:   Fri,  6 May 2022 15:18:41 +0200
Message-Id: <20220506131841.3177-4-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506131841.3177-1-nbd@nbd.name>
References: <20220506131841.3177-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running a combination of PPPoE on top of a VLAN, we need to set
info->outdev to the PPPoE device, otherwise PPPoE encap is skipped
during software offload.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d88de26aad75..187b8cb9a510 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -123,7 +123,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			info->outdev = path->dev;
+			if (!info->outdev)
+				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-- 
2.35.1

