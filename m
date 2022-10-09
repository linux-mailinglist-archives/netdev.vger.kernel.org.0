Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D585F90D0
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbiJIW1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiJIW0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:26:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3D027CF8;
        Sun,  9 Oct 2022 15:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0DDAB80E09;
        Sun,  9 Oct 2022 22:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07171C433B5;
        Sun,  9 Oct 2022 22:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353852;
        bh=qd2i4tybodrnYJgJ/z55dTiwmf1DCHNDvw1vSahM3EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4iirJwZjMorK8XyQFU11KvJa1iCwkaWKRD1suDcAbZN2EHe4GGucfT+YKwVSMHVJ
         O83X3sau32+jOyv/UOitQtjDyJL7XkBH1siS4JNyrUkI5TbGIYzdlClLitHe02a9KM
         inE+C3D0+V438GS4PflMlM5Z5c7I4ge/WPuPepdFZtbWI54Hsr5SdflrfeIsgQHz+g
         /AHCseDMxiQYcuQpd+fAZkEfYykxJHAYy/l0n+9VRJalb8WaASuUJX1Jh80dslMKz9
         Sh3i19/01RtZmPlYTAg6uh5RIXUcT6cm7BKWdDAiE0s0ZXEcz1IGoU3cSbJ62m2r3+
         G3m3LKgjLXJ/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Lukasz Stelmach <l.stelmach@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 42/73] net: ax88796c: Fix return type of ax88796c_start_xmit
Date:   Sun,  9 Oct 2022 18:14:20 -0400
Message-Id: <20221009221453.1216158-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit fcb7c210a24209ea8f6f32593580b57f52382ec2 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of ax88796c_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Acked-by: Lukasz Stelmach <l.stelmach@samsung.com>
Link: https://lore.kernel.org/r/20220912194031.808425-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 6ba5b024a7be..f1d610efd69e 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -381,7 +381,7 @@ static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
 	return 1;
 }
 
-static int
+static netdev_tx_t
 ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
-- 
2.35.1

