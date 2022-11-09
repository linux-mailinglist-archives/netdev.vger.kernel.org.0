Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D816220CC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 01:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiKIA2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 19:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiKIA2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 19:28:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E4AAD;
        Tue,  8 Nov 2022 16:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA245B81BDF;
        Wed,  9 Nov 2022 00:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B9C433D6;
        Wed,  9 Nov 2022 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667953698;
        bh=HWHf8Rl0nBj9nc3udlptxTqUuonteTAfMEYPiSz8dG4=;
        h=From:To:Cc:Subject:Date:From;
        b=q8bHSIZ1IMWsPyMHLigT5XjNnubx5J5ByjfwIQ5gSqiABwFvXHEttHj6trfOiskpm
         ui6O2j06eX9wveGxOPWfzZ0EBY46uPdhEcPm6FKA0gw6jg2nrHBsBW4OeP9bGjB1DE
         6mNDQRLI4oUheiSTHQBqwc9DcjrSb2Wc5crexZEqBJgacf56pvvKOJ9sKqaS3ilP98
         LkwpUKpRxGq2JdccJ6uC6gDt221EVzEa0M35ZUmjvqVzuVjkBXG65cqsOON7qO2DQm
         polFPC/b5YciteDnmsWIuPYaZ0Buc4w9PP34R6jP26F6ny/NpdElarpxP1t4CVWjiF
         NMvYdsInyuJ4g==
From:   Nathan Chancellor <nathan@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v3] net: mana: Fix return type of mana_start_xmit()
Date:   Tue,  8 Nov 2022 17:26:30 -0700
Message-Id: <20221109002629.1446680-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
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

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition. A new
warning in clang will catch this at compile time:

  drivers/net/ethernet/microsoft/mana/mana_en.c:382:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = mana_start_xmit,
                                    ^~~~~~~~~~~~~~~
  1 error generated.

The return type of mana_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
[nathan: Rebase on net-next and resolve conflicts
         Add note about new clang warning]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v3:
  - Take over for Nathan, as he is busy with other matters.
  - Rebase on net-next and resolve conflicts.
  - Add a note about new clang warning that will catch this issue at
    compile time.

v2: https://lore.kernel.org/20220929181411.61331-1-nhuck@google.com/

 drivers/net/ethernet/microsoft/mana/mana.h    | 2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index d58be64374c8..ffcd27cde17b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -388,7 +388,7 @@ struct mana_port_context {
 	struct mana_ethtool_stats eth_stats;
 };
 
-int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
+netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 318dbbb48279..91a8d3577c14 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -128,7 +128,7 @@ static int mana_map_skb(struct sk_buff *skb, struct mana_port_context *apc,
 	return -ENOMEM;
 }
 
-int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	enum mana_tx_pkt_format pkt_fmt = MANA_SHORT_PKT_FMT;
 	struct mana_port_context *apc = netdev_priv(ndev);

base-commit: 8e18be7610aebea50e9327c11afcd5eeaaa06644
-- 
2.38.1

