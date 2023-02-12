Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B835B693753
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBLMmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLMmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:42:11 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113D059C3;
        Sun, 12 Feb 2023 04:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5JMgsdKL7tpHFaQdAmVM9hrD99xOzPhxMg5opoeNF9Y=; b=UXphuPVD37HYjr5HNUxxNtVQEb
        6VY0+1Skufj5sCKR5zarMhUxdM3IriQKHNWzdx3c/TQDTRazuhhiIzvJm8jy5ozd6dBmgfRt9NtCC
        USHaYfmN0fgrJZZ+Wcaw0lFnUH/Er/n7AVuXYjkswOZcwwS9VzcA6Nc3Lm+BJ2wbTvkVZre4Hv4/z
        rBMCGUkGZGi2xBENjuxrapKB4fbAqSAa7fP7GxzyvIl6VhFkq1/sRTCDyYemWq2qctY9blmHURGqn
        FD/c3mwqAf3MxQ0vHcPJnqu9jroB6DTgYUeZRbw/W/dr/npiNjnYju71oG6goA2EIMJImDBYI+1uH
        JTaOoNfA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pRBg7-00HO62-HN; Sun, 12 Feb 2023 12:41:59 +0000
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
Subject: [PATCH v5 0/2] Bluetooth: btrtl: add support for the RTL8723CS
Date:   Sun, 12 Feb 2023 13:41:50 +0100
Message-Id: <20230212124153.2415-1-bage@debian.org>
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
v5:
   * Make use of skb_pull_data's length check

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

