Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35C51FCBB
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiEIMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiEIMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:30:19 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2B6128E;
        Mon,  9 May 2022 05:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nk3K4ta+0Fu9iVW2KDK+HeO3L5+ivAgXdNm4rc0aHqU=; b=YQhbAfbTZim8pB9/GaPgOS55Lf
        lyVlC0SAk+mJUYF7nm2BH3lyP1yiQYwg0xTTJ60LTvfxf7OeOvKuwUjWXqHLvItR8Y9aVmHzxvLD3
        exZXzPwZMYNpnQX+t+tDGDdBt8zwnzKwVAnd09nanDjw177RBB75B903RolyIEc4MY/Q=;
Received: from p200300daa70ef2003c9b1ea8f6ef4a42.dip0.t-ipconnect.de ([2003:da:a70e:f200:3c9b:1ea8:f6ef:4a42] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1no2T0-0003Fl-Vp; Mon, 09 May 2022 14:26:23 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf 4/4] netfilter: nft_flow_offload: fix offload with pppoe + vlan
Date:   Mon,  9 May 2022 14:26:16 +0200
Message-Id: <20220509122616.65449-4-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509122616.65449-1-nbd@nbd.name>
References: <20220509122616.65449-1-nbd@nbd.name>
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

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
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

