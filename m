Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B66C08A4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 02:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCTBjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 21:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjCTBjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 21:39:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0530046B9;
        Sun, 19 Mar 2023 18:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B577BB80D47;
        Mon, 20 Mar 2023 00:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E184C433EF;
        Mon, 20 Mar 2023 00:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273856;
        bh=8U0+KCB4JzpOYrOfqQpnHMvfkiX3CwL64HOjTw2QnaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4bZT9dGNN8mDbxkerVh95rnREb2jZlcGeJc0CYLHRTK8RAUpiAxtfOBPZGAKI85A
         ocKC8DfHRt0LDEqhKrttWK3pidmYVYFVjKZ14L8RP7N9etCen4bcleoz6YHq9sBHL2
         zIKiLRGnXZq4TsHi/iAepIiCdc53NJGPyI3LczzwfZH6KCQDo7TyePLVaOzxEswNXy
         4QYCfN9UhhGyV6bzDSCTwwv85FlaW08K7F7Qjl8s8OcIcnhiFoztEAZcHWaM7TTuu2
         exxOxrp9cEd773XUTiIpgTD6OybvUTGXhy0ox3KWcoeAvP9kaSl9DjIkRqnzifI+pw
         1iXfXmHsyPnZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        lianhui tang <bluetlh@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/9] ca8210: fix mac_len negative array access
Date:   Sun, 19 Mar 2023 20:57:25 -0400
Message-Id: <20230320005732.1429533-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005732.1429533-1-sashal@kernel.org>
References: <20230320005732.1429533-1-sashal@kernel.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6c993779ea1d0cccdb3a5d7d45446dd229e610a3 ]

This patch fixes a buffer overflow access of skb->data if
ieee802154_hdr_peek_addrs() fails.

Reported-by: lianhui tang <bluetlh@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20230217042504.3303396-1-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index eff7571dbea20..76ca8c63bc379 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1955,6 +1955,8 @@ static int ca8210_skb_tx(
 	 * packet
 	 */
 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
+	if (mac_len < 0)
+		return mac_len;
 
 	secspec.security_level = header.sec.level;
 	secspec.key_id_mode = header.sec.key_id_mode;
-- 
2.39.2

