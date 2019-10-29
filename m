Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7C0E8B0F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 15:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389468AbfJ2Ont (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 10:43:49 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:57756 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388712AbfJ2Ont (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 10:43:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id 4D68A23F057;
        Tue, 29 Oct 2019 15:43:45 +0100 (CET)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.067
X-Spam-Level: 
X-Spam-Status: No, score=-3.067 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.167, BAYES_00=-1.9] autolearn=ham
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I0AFw6_a2NNy; Tue, 29 Oct 2019 15:43:44 +0100 (CET)
Received: from lem-wkst-02.lemonage.de. (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPA id CDF9923F8AA;
        Tue, 29 Oct 2019 15:43:42 +0100 (CET)
From:   Lars Poeschel <poeschel@lemonage.de>
Cc:     Lars Poeschel <poeschel@lemonage.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jilayne Lovejoy <opensource@jilayne.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Steve Winslow <swinslow@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Allison Randal <allison@lohutok.net>,
        Johan Hovold <johan@kernel.org>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH v11 0/7] nfc: pn533: add uart phy driver
Date:   Tue, 29 Oct 2019 15:43:13 +0100
Message-Id: <20191029144320.17718-1-poeschel@lemonage.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patch series is to add a uart phy driver to the
pn533 nfc driver.
It first changes the dt strings and docs. The dt compatible strings
need to change, because I would add "pn532-uart" to the already
existing "pn533-i2c" one. These two are now unified into just
"pn532". Then the neccessary changes to the pn533 core driver are
made. Then the uart phy is added.
As the pn532 chip supports a autopoll, I wanted to use this instead
of the software poll loop in the pn533 core driver. It is added and
activated by the last to patches.
The way to add the autopoll later in seperate patches is chosen, to
show, that the uart phy driver can also work with the software poll
loop, if someone needs that for some reason.
In v11 of this patchseries I address a byte ordering issue reported
by kbuild test robot in patch 5/7.

Cc: Lars Poeschel <poeschel@lemonage.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jilayne Lovejoy <opensource@jilayne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Cc: Steve Winslow <swinslow@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Johan Hovold <johan@kernel.org>
Cc: Simon Horman <horms@verge.net.au>

Lars Poeschel (7):
  nfc: pn533: i2c: "pn532" as dt compatible string
  nfc: pn532: Add uart phy docs and rename it
  nfc: pn533: Add dev_up/dev_down hooks to phy_ops
  nfc: pn533: Split pn533 init & nfc_register
  nfc: pn533: add UART phy driver
  nfc: pn533: Add autopoll capability
  nfc: pn532_uart: Make use of pn532 autopoll

 .../net/nfc/{pn533-i2c.txt => pn532.txt}      |  25 +-
 drivers/nfc/pn533/Kconfig                     |  11 +
 drivers/nfc/pn533/Makefile                    |   2 +
 drivers/nfc/pn533/i2c.c                       |  32 +-
 drivers/nfc/pn533/pn533.c                     | 281 +++++++++++++--
 drivers/nfc/pn533/pn533.h                     |  40 ++-
 drivers/nfc/pn533/uart.c                      | 323 ++++++++++++++++++
 drivers/nfc/pn533/usb.c                       |  16 +-
 8 files changed, 667 insertions(+), 63 deletions(-)
 rename Documentation/devicetree/bindings/net/nfc/{pn533-i2c.txt => pn532.txt} (42%)
 create mode 100644 drivers/nfc/pn533/uart.c

-- 
2.23.0

