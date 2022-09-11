Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D635B51FA
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiIKXlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIKXlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C31C26578
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4B761134
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEAFC433C1;
        Sun, 11 Sep 2022 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939681;
        bh=XcbxVA2lWozD8pkGHIxeqqBr5EK2PgU9Odegs8u8uP8=;
        h=From:To:Cc:Subject:Date:From;
        b=YAHSsAATcPHD9mIqDNRn/H26GzKu1Qjgl+OvpOlK82UC+Ky/qFWiXL8gE8lDDOCVF
         x9O/zWhpJOhwJJ2Y8eBQda27L2gu7g3oFqhg2IMHhsOrBx1gNi2ryQLy+4mkJcWgZc
         rbMop9G7+SxH0RCjlwlLVogLrH/LQbIQXtV+ddCr8eCByN939Fzs+IFcqZ+Ok1aD8G
         ypb+EWyEbgUKEzajn8gt/pbzogYVLrmlqUieT3gBoEphNMfQmNPpzprv7p1Yprknnu
         yzPRe49EgKuBH1AinkLmWzYjpLL2hmjfS69KGEOc7LfXkwJJbpJvExuJAILMIsbqwr
         pOMD2NcYSmNgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 00/10] mlx5 MACSec Extended packet number and replay window offload
Date:   Mon, 12 Sep 2022 00:40:49 +0100
Message-Id: <20220911234059.98624-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
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

From: Saeed Mahameed <saeedm@nvidia.com>

This is a follow up series to the previously submitted mlx5 MACsec offload [1]
earlier this release cycle.

In this series we add the support for MACsec Extended packet number and 
replay window offloads.

First patch is a simple modification (code movements) to the core macsec code
to allow exposing the EPN related user properties to the offloading
device driver.

The rest of the patches are mlx5 specific, we start off with fixing some
trivial issues with mlx5 MACsec code, and a simple refactoring to allow 
additional functionality in mlx5 macsec to support EPN and window replay
offloads.
 A) Expose mkey creation functionality to MACsec
 B) Expose ASO object to MACsec, to allow advanced steering operations,
    ASO objects are used to modify MACsec steering objects in fastpath.

1) Support MACsec offload extended packet number (EPN)
    
    MACsec EPN splits the packet number (PN) into two 32-bits fields,
    epn_lsb (32 least significant bits (LSBs) of PN) and epn_msb (32
    most significant bits (MSBs) of PN).
    Epn_msb bits are managed by SW and for that HW is required to send
    an object change event of type EPN event notifying the SW to update
    the epn_msb in addition, once epn_msb is updated SW update HW with
    the new epn_msb value for HW to perform replay protection.
    To prevent HW from stopping while handling the event, SW manages
    another bit for HW called epn_overlap, HW uses the latter to get
    an indication regarding how to read the epn_msb value correctly
    while still receiving packets.
    Add epn event handling that updates the epn_overlap and epn_msb for
    every 2^31 packets according to the following logic:
    if epn_lsb crosses 2^31 (half sequence number wraparound) upon HW
    relevant event, SW updates the esn_overlap value to OLD (value = 1).
    When the epn_lsb crosses 2^32 (full sequence number wraparound)
    upon HW relevant event, SW updates the esn_overlap to NEW
    (value = 0) and increment the esn_msb.
    When using MACsec EPN a salt and short secure channel id (ssci)
    needs to be provided by the user, when offloading EPN need to pass
    this salt and ssci to the HW to be used in the initial vector (IV)
    calculations.

2) Support MACsec offload replay window
    
    Support setting replay window size for MACsec offload.
    Currently supported window size of 32, 64, 128 and 256
    bit. Other values will be returned as invalid parameter.


[1] https://lwn.net/Articles/907262/ 


Emeel Hakim (10):
  net: macsec: Expose extended packet number (EPN) properties to macsec
    offload
  net/mlx5: Fix fields name prefix in MACsec
  net/mlx5e: Fix MACsec initialization error path
  net/mlx5e: Fix MACsec initial packet number
  net/mlx5: Add ifc bits for MACsec extended packet number (EPN) and
    replay protection
  net/mlx5e: Expose memory key creation (mkey) function
  net/mlx5e: Create advanced steering operation (ASO) object for MACsec
  net/mlx5e: Move MACsec initialization from profile init stage to
    profile enable stage
  net/mlx5e: Support MACsec offload extended packet number (EPN)
  net/mlx5e: Support MACsec offload replay window

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../mellanox/mlx5/core/en_accel/macsec.c      | 637 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/macsec.h      |   1 -
 .../ethernet/mellanox/mlx5/core/en_common.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/events.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |   3 +
 drivers/net/macsec.c                          |  24 +-
 include/linux/mlx5/device.h                   |   8 +
 include/linux/mlx5/mlx5_ifc.h                 |  35 +-
 11 files changed, 674 insertions(+), 55 deletions(-)

-- 
2.37.3

