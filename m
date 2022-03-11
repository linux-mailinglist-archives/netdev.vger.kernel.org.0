Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E314D5E28
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiCKJQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbiCKJQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:16:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87291BBF45;
        Fri, 11 Mar 2022 01:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A9061F2B;
        Fri, 11 Mar 2022 09:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B9BC340E9;
        Fri, 11 Mar 2022 09:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646990110;
        bh=c61+9/J2HkxPYOFusMQumMxePvjg9hKFovxmJgey1to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iop+DWtIjJkMlUCEylX+HGdzTT0emHfBDcXbJbA2CRYwU5+uhcRCnZLYeO6/uvT1n
         flELcwfb+4plMyLSVah3m7+ZeOAokTJ3Ea6SWO2IhPmRKcSYsRcNMiJoJEH6i8kQ1s
         1ViRKtI9MRopgk/6pnYVQEYe6QGAnHSZ4NJ0O9i+sK/yS+eQZLx946qDg8nqVnvx/p
         NzxpCpke+Vp/mj89iQ+dM3An8jGu2SDYdpQ3Oq/ALZmV95kko71w7CAi4FiS9SCaCv
         2jejqYGMj6DEH2qVt2yMBaBIq7n8CO3E/5458yzWU2Cn6q1MxRbKk1rkqz51FrTFg1
         prfEadv7QFVRQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v5 bpf-next 3/3] veth: allow jumbo frames in xdp mode
Date:   Fri, 11 Mar 2022 10:14:20 +0100
Message-Id: <d5dc039c3d4123426e7023a488c449181a7bc57f.1646989407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646989407.git.lorenzo@kernel.org>
References: <cover.1646989407.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow increasing the MTU over page boundaries on veth devices
if the attached xdp program declares to support xdp fragments.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bfae15ec902b..1b5714926d81 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1528,9 +1528,14 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			goto err;
 		}
 
-		max_mtu = PAGE_SIZE - VETH_XDP_HEADROOM -
-			  peer->hard_header_len -
-			  SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		max_mtu = SKB_WITH_OVERHEAD(PAGE_SIZE - VETH_XDP_HEADROOM) -
+			  peer->hard_header_len;
+		/* Allow increasing the max_mtu if the program supports
+		 * XDP fragments.
+		 */
+		if (prog->aux->xdp_has_frags)
+			max_mtu += PAGE_SIZE * MAX_SKB_FRAGS;
+
 		if (peer->mtu > max_mtu) {
 			NL_SET_ERR_MSG_MOD(extack, "Peer MTU is too large to set XDP");
 			err = -ERANGE;
-- 
2.35.1

