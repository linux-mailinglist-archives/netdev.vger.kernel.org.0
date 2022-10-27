Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07F5610281
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiJ0UQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbiJ0UQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:16:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F5E645D2;
        Thu, 27 Oct 2022 13:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03AAC624DE;
        Thu, 27 Oct 2022 20:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85D3C433C1;
        Thu, 27 Oct 2022 20:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666901815;
        bh=8HAK4m6E3POACA1m3I3Cl8FtXlz0B1YchOPXq9lU5BU=;
        h=Date:From:To:Cc:Subject:From;
        b=k+5h+9HliD+/DKxTYK+Ll9WsQoU4+6L/tUCabezbJnN9zjPXXrxFq0CUllRzMWU6l
         eXja6U6i6FMLBPBLVR9R3Pxb01oQjTKdx4JMRI0p3v+0W2KYOwatXdmOc+Z9QLPNbr
         wFIDqWSiWcoyWXGXVEUZDDHm7MwlpZH6Ye7DW5s4cXaQ4XhuIJMfqwun9M7yq9eURT
         KM/19EZqjB4sMLsqEiP8KZxFeNSzWqoklEbPaNDD/8ldutTBm9vN0l1z3sygu6fOIZ
         FwUkcYVlAZfSGtRAfvOklVs+9YilA+rg4CjepT47G6qzGueP3K+L18s3or3oKTGMvP
         S9GYaIAy6PhsQ==
Date:   Thu, 27 Oct 2022 15:16:51 -0500
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
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 0/6] Avoid clashing function prototypes
Message-ID: <cover.1666894751.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Changes in v2:
 - Squash previous patches 1, 2 and 3 into a single patch
   cfg80211.
 - Add a couple more patches: bna and staging.
 - Fix 254 (227 in bna and 27 in staging) more
   -Wcast-function-type-strict warnings.

v1:
 - Link: https://lore.kernel.org/linux-hardening/cover.1666038048.git.gustavoars@kernel.org/

Gustavo A. R. Silva (6):
  cfg80211: Avoid clashing function prototypes
  hostap: Avoid clashing function prototypes
  zd1201: Avoid clashing function prototypes
  airo: Avoid clashing function prototypes
  bna: Avoid clashing function prototypes
  staging: ks7010: Avoid clashing function prototypes

 drivers/net/ethernet/brocade/bna/bfa_cs.h     |  60 +++--
 drivers/net/ethernet/brocade/bna/bfa_ioc.c    |  10 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.h    |   8 +-
 drivers/net/ethernet/brocade/bna/bfa_msgq.h   |   8 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c   |   6 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c  |   6 +-
 drivers/net/ethernet/brocade/bna/bna_types.h  |  27 +-
 drivers/net/wireless/cisco/airo.c             | 204 ++++++++-------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   2 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   | 234 ++++++++++--------
 drivers/net/wireless/intersil/orinoco/wext.c  | 113 +++++----
 drivers/net/wireless/zydas/zd1201.c           | 162 ++++++------
 drivers/staging/ks7010/ks_wlan_net.c          | 184 +++++++-------
 include/net/cfg80211-wext.h                   |  20 +-
 net/wireless/scan.c                           |   3 +-
 net/wireless/wext-compat.c                    | 180 ++++++--------
 net/wireless/wext-compat.h                    |   8 +-
 net/wireless/wext-sme.c                       |   5 +-
 18 files changed, 661 insertions(+), 579 deletions(-)

-- 
2.34.1

