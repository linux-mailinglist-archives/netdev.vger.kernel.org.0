Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D356250FB
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiKKCkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiKKCji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:39:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D8A6BDDA;
        Thu, 10 Nov 2022 18:36:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A94B461E85;
        Fri, 11 Nov 2022 02:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DB4C43143;
        Fri, 11 Nov 2022 02:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134176;
        bh=jaIfmu7Hf+LYHt/io+xZKFY3kE2DYxP+3IYPwsRmUe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6vD8uB8Fcbczd/TTINKk83Rn6whewxZMoAsrHBAs2s08jpsWMWm45MFfLsM6olgq
         y/dp7of1n65rzTv2toftk7d+b7S0m8WKWo0cJCMmDe81UGerijIqWXwcnbgkVNFmtb
         Vl/O24Z8G1Hxn6WO069miWyulFzt5/KGG9xJxAlsTILgn/SAeQpWEQef2M4hkcXTct
         C5gY3ad3EUxPS1JlsX1LXvS8GqHMhf02+j5WbmGFcLOVtcjaJ4ZZKTc6lQjZdN0A6h
         h0lVYR66TL1WwZ6bxaQtKoRkaIeRC4Kgit1h9b6O8E54dfaNwkBRsAnSMClOm+RO4/
         xEeAJhG5X7BiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/2] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm
Date:   Thu, 10 Nov 2022 21:36:11 -0500
Message-Id: <20221111023611.228238-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023611.228238-1-sashal@kernel.org>
References: <20221111023611.228238-1-sashal@kernel.org>
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
index ec04a7ea5537..6e93f2290ed5 100644
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

