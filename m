Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B1601A5B
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiJQUg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiJQUfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC8D7D781;
        Mon, 17 Oct 2022 13:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D95FE61272;
        Mon, 17 Oct 2022 20:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E2C433D6;
        Mon, 17 Oct 2022 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038754;
        bh=O51h1IkbGHXc8GoS+R+788LmBhDQsi4CZfclbd5koes=;
        h=Date:From:To:Cc:Subject:From;
        b=Y3tuAH0laMBhDZUpROhTGF3IH1W1zh6ILuZV8ddO26YvkbfnMWI+V62qNOj9BcNta
         iyPqAIGBQk62p6t4HT4tmyaRC2rhnMXSpv8HcTI3XJi0eSpLIgIAT1OcxE+xbVBicP
         3dg1EUGG4jsi5IJ58crRv7JkFBawGsC6cW2Gs4lVCZTAKkoDlObIh5WmxMuuCRl/mh
         ssZtwvC2N9tAnBGaj/8QlHYcxxkxs+dwBCbZmEkTCVqsZYDgJZuM0itSbK6zTfilyM
         HnrmWucoBaJ9UyrCxmnUFkuFpBGl8HKi80T3tt3ukp90yz8p7sGDtkTxDbtXeEv50q
         /GiAK8ymVzcZA==
Date:   Mon, 17 Oct 2022 15:32:25 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jouni Malinen <j@w1.fi>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/6][next] Avoid clashing function prototypes
Message-ID: <cover.1666038048.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

This series fixes a total of 170 -Wcast-function-type-strict warnings.

Link: https://reviews.llvm.org/D134831 [1]

Gustavo A. R. Silva (6):
  orinoco: Avoid clashing function prototypes
  cfg80211: Avoid clashing function prototypes
  ipw2x00: Remove unnecessary cast to iw_handler in ipw_wx_handlers
  hostap: Avoid clashing function prototypes
  zd1201: Avoid clashing function prototypes
  airo: Avoid clashing function prototypes

 drivers/net/wireless/cisco/airo.c             | 203 ++++++++-------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   2 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   | 245 ++++++++++--------
 drivers/net/wireless/intersil/orinoco/wext.c  | 131 +++++-----
 drivers/net/wireless/zydas/zd1201.c           | 173 +++++++------
 include/net/cfg80211-wext.h                   |  20 +-
 net/wireless/scan.c                           |   3 +-
 net/wireless/wext-compat.c                    | 180 ++++++-------
 net/wireless/wext-compat.h                    |   8 +-
 net/wireless/wext-sme.c                       |   5 +-
 10 files changed, 503 insertions(+), 467 deletions(-)

-- 
2.34.1

