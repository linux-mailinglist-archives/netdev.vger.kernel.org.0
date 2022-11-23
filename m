Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810AA635ED2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiKWNEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiKWND4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:03:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C0AC903D;
        Wed, 23 Nov 2022 04:48:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCFB0B81FA1;
        Wed, 23 Nov 2022 12:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C1DC433D6;
        Wed, 23 Nov 2022 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207721;
        bh=rcmfqjry3WMbHJQe08DgVDGXLxyJCZsz/TJx9Hxvat8=;
        h=From:To:Cc:Subject:Date:From;
        b=an+Nq3ZWmdc2ZhCYoKYKLqoyBKVFum+xKAClzDWKEyzi7eTuX3h/o7InwC4XPMbqT
         M49DJICIPfDOXwpfIfhrJA0h1UxAPB9IBKdMefSnNSXW7FVlkDEmpD6p9X1mpmdRoI
         59ILnv8/s5vWfcIami5d2ClBr1U+6rM8vjlwLtqyGOWFB8ZOplJXWbuiVl/Ywd0sDX
         R3Qb0PTG9gbxnmVF2Kd2H5NDP7qN3gupBNtyTUSQQazZeXMkDxfF0S6n5RiKsCs7ri
         vyxXZ+MNAUQxd1L5THgouLMGaAqYGmEVFRrVlxQrVsPLiXabqoSYUAnX9+qsZ4+I4y
         9nw/7qGtr7CWg==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v3 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Wed, 23 Nov 2022 14:48:29 +0200
Message-Id: <20221123124835.18937-1-rogerq@kernel.org>
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

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 165 ++++++++++++-----------
 1 file changed, 89 insertions(+), 76 deletions(-)

-- 
2.17.1

