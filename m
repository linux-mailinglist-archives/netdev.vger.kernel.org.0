Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8F963C125
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiK2NfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiK2NfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:35:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFDC1134;
        Tue, 29 Nov 2022 05:35:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07679B811BC;
        Tue, 29 Nov 2022 13:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C6AC433C1;
        Tue, 29 Nov 2022 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669728908;
        bh=AgrFaXDHO4T8urlnogCwZ98IvUvFDANZ++DIGe943KE=;
        h=From:To:Cc:Subject:Date:From;
        b=jV9BEps1XGs/8fKcoiR/Q1JO799qkN+235RF8yuZya24QM90/LEk0eNABaGTehX1i
         /BdztpcW1MvnwMxAURXmVb3m8gFbeBfeEQUgICBUypOlEyMmYT0VoqEjviZMSnhBui
         fD2rFON+a5Pm4IJGoNU7RgE5diimosEHT3Lre9T5xYB0x/wst9GaCEucNDxrJXVmLS
         9EKoFn4FjSuY22UQs08H/dsEJS+OaneyvcIo5IN1ZmeY2ERiQ37nbuw7xzqDwUN1ik
         r7/7jLft+MWmNNy2SSf9Jpbxb82SE3bKBVf+Ro7D6m5fpGkW51tN5y+GzRRfNywcCT
         bHfoaiQUiFU0g==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v4 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Tue, 29 Nov 2022 15:34:55 +0200
Message-Id: <20221129133501.30659-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This contains a critical bug fix for the recently merged suspend/resume
support [1] that broke set channel operation. (ethtool -L eth0 tx <n>)

As there were 2 dependent patches on top of the offending commit [1]
first revert them and then apply them back after the correct fix.

[1] fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")

cheers,
-roger

Changelog:
v4:
- move am65_cpsw_nuss_ndev_add_tx_napi() earlier to avoid declaration.
- print error and error out if soft RESET failed in
  am65_cpsw_nuss_ndo_slave_open()
- move struct 'am65_cpsw_host *host' where 'common' is defined.

v3:
- revert offending commit before applying the updated patch.
- drop optimization patch to be sent separately.

v2:
- Fix build warning
 drivers/net/ethernet/ti/am65-cpsw-nuss.c:562:13: warning: variable 'tmo' set but not used [-Wunused-but-set-variable]

Roger Quadros (6):
  Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
    suspend/resume"
  Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
    suspend/resume"
  Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
  net: ethernet: ti: am65-cpsw: Add suspend/resume support
  net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
    suspend/resume
  net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
    suspend/resume

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 197 ++++++++++++-----------
 1 file changed, 105 insertions(+), 92 deletions(-)

-- 
2.17.1

