Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C90621D87
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKHUSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKHUSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:18:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D5A14D32;
        Tue,  8 Nov 2022 12:18:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32837B81C4B;
        Tue,  8 Nov 2022 20:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E718C433D7;
        Tue,  8 Nov 2022 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667938705;
        bh=WyEheEiq/StleYaLyY18Lb8AoLR/BnuFGuWyCblPpM0=;
        h=Date:From:To:Cc:Subject:From;
        b=OLRidf0kOhpEWgDiOV7yjBHXPJhY9INixXclz9UkmID5M9jezvI6lu6pbNuP5Pwce
         xQ/rrXK/4jbLOXFwOZXSblpsjVTWQeHnEohV18pr1q2Nstl7UoK50fN/im1Wbw/drD
         hzqJsxrvUFwwVigS8btuokqYU/dHJIhb4t1JJEfNuxt8XTTEoO2foZVL60YfzMhgXz
         7Jo8U6a61wPTynDFkNBEdVOPhPTgzQTCQnmZ7qJyEuPYPfYzswbpaG7/aJ1CQOqeFa
         8/ITYLygMmWChmrxQfzE20FVJjA1WbL5EnIzEK5TDp6AA5lgA+KJ7ou86ukkXr4WtM
         0AxNtxcaXycTw==
Date:   Tue, 8 Nov 2022 14:18:05 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jouni Malinen <j@w1.fi>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3 0/7] Avoid clashing function prototypes
Message-ID: <cover.1667934775.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When built with Control Flow Integrity, function prototypes between
caller and function declaration must match. These mismatches are visible
at compile time with the new -Wcast-function-type-strict in Clang[1].

This series fixes a total of 424 -Wcast-function-type-strict warnings.

Link: https://reviews.llvm.org/D134831 [1]

Changes in v3:
 - Split non-related orinoco changes out of cgf80211 into a separate
   patch.
 - Mention Coccinelle in some of the patches where it was used
   to make some changes.
 - Add RB tags to a couple of patches.

Changes in v2:
 - Squash patches 1, 2 and 3 into a single patch cfg80211.
 - Add a couple more patches: bna and staging.
 - Fix 254 (227 in bna and 27 in staging) more
   -Wcast-function-type-strict warnings.
 - Link: https://lore.kernel.org/linux-hardening/cover.1666894751.git.gustavoars@kernel.org/

v1:
 - Link: https://lore.kernel.org/linux-hardening/cover.1666038048.git.gustavoars@kernel.org/

Gustavo A. R. Silva (7):
  wifi: orinoco: Avoid clashing function prototypes
  cfg80211: Avoid clashing function prototypes
  wifi: hostap: Avoid clashing function prototypes
  wifi: zd1201: Avoid clashing function prototypes
  wifi: airo: Avoid clashing function prototypes
  bna: Avoid clashing function prototypes
  staging: ks7010: Avoid clashing function prototypes

 drivers/net/ethernet/brocade/bna/bfa_cs.h     |  60 +++--
 drivers/net/ethernet/brocade/bna/bfa_ioc.c    |  10 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.h    |   8 +-
 drivers/net/ethernet/brocade/bna/bfa_msgq.h   |   8 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c   |   6 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c  |   6 +-
 drivers/net/ethernet/brocade/bna/bna_types.h  |  27 +-
 drivers/net/wireless/cisco/airo.c             | 204 +++++++-------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   2 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   | 244 +++++++++--------
 drivers/net/wireless/intersil/orinoco/wext.c  | 131 +++++----
 drivers/net/wireless/zydas/zd1201.c           | 174 ++++++------
 drivers/staging/ks7010/ks_wlan_net.c          | 248 +++++++++---------
 include/net/cfg80211-wext.h                   |  20 +-
 net/wireless/scan.c                           |   3 +-
 net/wireless/wext-compat.c                    | 180 ++++++-------
 net/wireless/wext-compat.h                    |   8 +-
 net/wireless/wext-sme.c                       |   5 +-
 18 files changed, 713 insertions(+), 631 deletions(-)

-- 
2.34.1

