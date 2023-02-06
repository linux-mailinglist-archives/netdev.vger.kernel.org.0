Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F368CAA4
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBFXjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBFXji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:39:38 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E749524125;
        Mon,  6 Feb 2023 15:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0NkuGutGnpoXOxfngHhh2vxTrjVGUeZm0lOH3QfaZ0o=; b=A5MtcuJGJ009/D1f7dhPtBP8rx
        fBL+XKO3AnkkL/95sRoQCcLJhK9sSEv0WaMNXe8h2RL2v+p0z57a2/DUZ4HHtCTMjP7O2pG92fqRK
        aflyanceF2yksynK4IzumthDPnhCzsOzjx74U82eOvjLHAU6JdI6Uru1xM+9so6iO69Aa/Hn07hQA
        XTteCeyNJUoCA/WAIYPdSVQzPmt4vyenriJH7zSqK/6sqONLldsukJx2wX+ke5KcCppY17rVYu92V
        HECOsiU5UHIb41baD2OdIEQYlfWyUu+Zm5Ihbyery2efD1GjTwiH3ta4b2XJ4mDD9HzpFiTLsRRnX
        eQ3gUKWw==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pPB53-00CT8W-AU; Mon, 06 Feb 2023 23:39:25 +0000
From:   Bastian Germann <bage@debian.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bastian Germann <bage@debian.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 0/2] Bluetooth: btrtl: add support for the RTL8723CS
Date:   Tue,  7 Feb 2023 00:39:09 +0100
Message-Id: <20230206233912.9410-1-bage@debian.org>
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

