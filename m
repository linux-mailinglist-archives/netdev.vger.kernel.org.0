Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CD068F263
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjBHPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 10:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjBHPwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 10:52:38 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC423C5A;
        Wed,  8 Feb 2023 07:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HdLc279IoOTbR2U4yoZcdEiF8TRE9BmS0RHirhtN2ng=; b=a8PvWWZObboKV3ZpTy7lDN/fOp
        jJy7MMkZ34zg+eU0+VIac8YbzRODq6yD3c7bxyAJOrwcAqGmPX83nYFSZETVi5Z7d8kv4g419Hqic
        FvfxIl5bRw0DyMAAF+Fg0OLXhEsq07zWGlhLnZjvK9dSWSFnMnC84ROTeF3tVHYbFPK7nZAcE2lUY
        Xl2e/WVGpSDZ2xsJrGTi/ZvIzkJ+YB9DR3uc7TVf2p1TFTaO8iDgEzL3ySSehU/FCdduDjCQHDiQB
        osA1L2TYATvf/5zU+Wouw/bf24sJcXXEfwig0QXPI3Cvmkq5PUqdVNITJRmUN/rTIL0A2mIGQsDZj
        m7mB3JLA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pPmkD-00DxsN-9E; Wed, 08 Feb 2023 15:52:25 +0000
From:   Bastian Germann <bage@debian.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Bastian Germann <bage@debian.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 0/2] Bluetooth: btrtl: add support for the RTL8723CS
Date:   Wed,  8 Feb 2023 16:52:17 +0100
Message-Id: <20230208155220.1640-1-bage@debian.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pinebook uses RTL8723CS for WiFi and bluetooth. Unfortunately, RTL8723CS
has broken BT-4.1 support, so it requires a quirk.

Add a quirk and wire up 8723CS support in btrtl.
I was asked for a btmon output without the quirk;
however, using the chip without the quirk ends up in a bad state with
"Opcode 0x c77 failed: -56" (HCI_OP_READ_SYNC_TRAIN_PARAMS) on training.
A btmon output with the quirk active was already sent by Vasily.

v1 of this series was sent in July 2020 by Vasily Khoruzhick.
I have tested it to work on the Pinebook.

Changelog:
v2:
   * Rebase
   * Add uart-has-rtscts to device tree as requested by reviewer
v3:
   * Drop the device tree as it was split out and is already integrated.
   * Rename the quirk as requested by reviewer Marcel Holtmann
v4:
   * Use skb_pull_data as requested by reviewer Luiz Augusto von Dentz

Vasily Khoruzhick (2):
  Bluetooth: Add new quirk for broken local ext features page 2
  Bluetooth: btrtl: add support for the RTL8723CS

 drivers/bluetooth/btrtl.c   | 120 ++++++++++++++++++++++++++++++++++--
 drivers/bluetooth/btrtl.h   |   5 ++
 drivers/bluetooth/hci_h5.c  |   4 ++
 include/net/bluetooth/hci.h |   7 +++
 net/bluetooth/hci_event.c   |   4 +-
 5 files changed, 135 insertions(+), 5 deletions(-)

-- 
2.39.1

