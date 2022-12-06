Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C7644009
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbiLFJo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiLFJob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:44:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540861E3EE;
        Tue,  6 Dec 2022 01:44:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E287A615F0;
        Tue,  6 Dec 2022 09:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96443C433D6;
        Tue,  6 Dec 2022 09:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670319866;
        bh=rZuclQ68hbui/6ywtw7DI39V+iqIo04bBQ4w4jumsEg=;
        h=From:To:Cc:Subject:Date:From;
        b=SoNRpwQ6d+HRrVKCRigYh8WEkEVXLIyBRXT4CbRyOUs/DihBKr6zJQyr4w4WsI/NJ
         KDuGQvYdpshhCfqhbW0Ei+dbUhQnQInLMYdlPvPCg9fxbeFlhO30hOGMXKQDnv3eee
         JDolcMSkifc/nExoxbJMhHfvXmXLN1ppw1QPtzW5FmY2sjIMbmV1+1OecEJ+i9A3G9
         qDlVwOsxiaBHJH5tqTr3FeBBHDqrbOG1AM71ePcJdTvkGSWRl0z+xqUZ/ZAwqsf4N7
         YSrZyZ1vphQoM6ho/sWRuc+vKznct5sC7sNqmDc3Qc3Y0oSZuSGQWlzMyRYAX2wQtm
         cZT6v0u3qJfyA==
From:   Roger Quadros <rogerq@kernel.org>
To:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org
Cc:     andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@kernel.org>
Subject: [PATCH v5 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set channel operation
Date:   Tue,  6 Dec 2022 11:44:13 +0200
Message-Id: <20221206094419.19478-1-rogerq@kernel.org>
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

v5:
- Change reset failure error code from -EBUSY to -ETIMEDOUT

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

