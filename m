Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F45B4A59
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 23:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiIJVns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 17:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIJVnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 17:43:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF0DA3;
        Sat, 10 Sep 2022 14:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3DF2CE0AF2;
        Sat, 10 Sep 2022 21:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAA1C433D6;
        Sat, 10 Sep 2022 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844785;
        bh=Yy+QJ8tlNvHmBxspzZ1dLNGVkG6l9ASkDRXsHYTOjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WPAj8S77okmp67E4M/0/jyMUTX3tA8pMXU1QhqVCfgXAC6PscAyMR2tDtN43uoAvU
         kyUC2l8zeOZpwiENRHDunnThDSGbCcx28mwpZTo8wu3qxOX4SHSRDOQLfXYMCGL8LZ
         ZmFN+tndQC8nCYrl8kA/ORFwRntwnCd8XLWPnvcHhiDQgMIj++FdVWLuOmUqya/MYm
         y8pYKZR4SfZomphqT+A/1SrdU2PaoLxjzcQ5sE3WLWwpf+XzsoO0rbg2jYYSZh60AK
         LZQwT3eE3zkjBonUBowdEbiorbu62HaFS3JibvSOduw8VGAF0IwNPxaP10J4G3KklK
         +l5oVtCY1ewEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Qiong <liqiong@nfschina.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, varkabhadram@gmail.com,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/5] ieee802154: cc2520: add rc code in cc2520_tx()
Date:   Sat, 10 Sep 2022 17:19:36 -0400
Message-Id: <20220910211938.70997-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211938.70997-1-sashal@kernel.org>
References: <20220910211938.70997-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit ffd7bdddaab193c38416fd5dd416d065517d266e ]

The rc code is 0 at the error path "status & CC2520_STATUS_TX_UNDERFLOW".
Assign rc code with '-EINVAL' at this error path to fix it.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Link: https://lore.kernel.org/r/20220829071259.18330-1-liqiong@nfschina.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index d50add705a79a..436cf2007138a 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -512,6 +512,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
 		goto err_tx;
 
 	if (status & CC2520_STATUS_TX_UNDERFLOW) {
+		rc = -EINVAL;
 		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
 		goto err_tx;
 	}
-- 
2.35.1

