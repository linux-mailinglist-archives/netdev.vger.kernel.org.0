Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1EF5B8CF8
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiINQ2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiINQ2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:28:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4701832EE
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 088D9B81722
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 16:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1A4C433C1;
        Wed, 14 Sep 2022 16:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663172847;
        bh=AOeWAoZMxsTUZOwo6hGSieJ+WVZ66zmO6hwjn3SyJvA=;
        h=From:To:Cc:Subject:Date:From;
        b=E2CG0qx9GowTn4XaLLMnoP7qSOSy2xkz+098Bprpgp++9eqg4XFEgVSraSbhOImT1
         T71Oug16ui8oS9vZUrpqNC8OEY2E6lN/yKocMrgf3G5izn9Dr34GDDqSpvXIQy/SAy
         MA1KxRhiAPlJS2oNhZ7CQ3nMVhhyEnJCKWbCznYcZIuzyGBtnT91zg94f79rmhWzAP
         K9wkcieU6YWKanwbcOQMum8TfqZeoOAX3JnJ4l50+KcJpBrd6vyj5lGSuydnSFUdF2
         QrALpQKH0DcWLzbaBQMj1b09iLbhGLui2i+Hsr6RJC+0kSflyhQ0HPErKjzQm7DkVe
         8zphGEwTzswYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 00/10] mlx5 MACSec Extended packet number and replay window offload
Date:   Wed, 14 Sep 2022 17:27:03 +0100
Message-Id: <20220914162713.203571-1-saeed@kernel.org>
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

v1->v2:
  - Fix 32bit build isse
  - Replay protection can work without EPN being enabled so moved the code out
    of the EPN enabled check 


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
 .../mellanox/mlx5/core/en_accel/macsec.c      | 631 +++++++++++++++++-
 .../mellanox/mlx5/core/en_accel/macsec.h      |   1 -
 .../ethernet/mellanox/mlx5/core/en_common.c   |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/events.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |   3 +
 drivers/net/macsec.c                          |  24 +-
 include/linux/mlx5/device.h                   |   8 +
 include/linux/mlx5/mlx5_ifc.h                 |  35 +-
 11 files changed, 670 insertions(+), 53 deletions(-)

-- 
2.37.3

