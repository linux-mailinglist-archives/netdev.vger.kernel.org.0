Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB546250E7
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiKKCjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiKKChY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:37:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5313C68AD5;
        Thu, 10 Nov 2022 18:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C985F61E7E;
        Fri, 11 Nov 2022 02:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA9BC43143;
        Fri, 11 Nov 2022 02:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134165;
        bh=TlRTej6p5DAvRimRlFJG+ZIda0Gi6+GX4ZxF++whkVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qg2XBiJQ7xwENkgjUqDIP9KD2kszk7g8DDosCK715WSG7wloVnEsxmHIdGOIWqack
         2pLTBEqkRlNghbF5onRy3wclCxa0XrimR0CQFVgg/Kw0kVfl2YjurmB505avVCUKuh
         SGoIdPFzzr81QR3hIQwCFqulEADw2qcvkL+Za27g1dMeJAxZ06Zy5NX1dsXh7z6DMb
         0d7P3iytUx/r3WSG3ocE9QfYkbmimpPVdp4aFMoJZHGa7RoKk6d222817hiAbe2kaY
         dAz02asTbQa4bE6nQELZSghdNlNjuAvM5UVclfN/or6blALXFrYUaeWdTpHAxXthXf
         11D44QhxFt45Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/4] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Thu, 10 Nov 2022 21:35:56 -0500
Message-Id: <20221111023556.228125-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023556.228125-1-sashal@kernel.org>
References: <20221111023556.228125-1-sashal@kernel.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f937b758a188d6fd328a81367087eddbb2fce50f ]

l2cap_global_chan_by_psm shall not return fixed channels as they are not
meant to be connected by (S)PSM.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 5c965f7b1709..10ca9fff8663 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1824,7 +1824,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
-- 
2.35.1

