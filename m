Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1681461CB
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgAWGId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:08:33 -0500
Received: from foss.arm.com ([217.140.110.172]:35352 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgAWGId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:08:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7BBA1FB;
        Wed, 22 Jan 2020 22:08:32 -0800 (PST)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AD7813F68E;
        Wed, 22 Jan 2020 22:08:32 -0800 (PST)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 0/2] Add ACPI bindings to the genet
Date:   Thu, 23 Jan 2020 00:08:21 -0600
Message-Id: <20200123060823.1902366-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series allows the BCM GENET, as used on the RPi4,
to attach when booted in an ACPI enviroment. The DSDT entry to trigger
this is seen below. The second patch in the set retrieves the MAC
address from the umac registers rather than carrying it directly in
the DSDT. This of course requires the firmware to pre-program it, so
we continue to fall back to a random one if it appears to be garbage.

+    Device (ETH0)
+    {
+      Name (_HID, "BCM6E4E")
+      Name (_CID, "BCM6E4E")
+      Name (_UID, 0)
+      Name (_CCA, 0x0)
+      Method (_STA)
+      {
+        Return (0xf)
+      }
+      Method (_CRS, 0x0, Serialized)
+      {
+        Name (RBUF, ResourceTemplate ()
+        {
+          Memory32Fixed (ReadWrite, 0xFd580000, 0x10000, )
+          Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) { 0xBD }
+          Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) { 0xBE }
+        })
+        Return (RBUF)
+      }
+      Name (_DSD, Package () {
+        ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+          Package () {
+          Package () { "phy-mode", "rgmii" },
+        }
+      })
+    }
+

Jeremy Linton (2):
  net: bcmgenet: Initial bcmgenet ACPI support
  net: bcmgenet: Fetch MAC address from the adapter

 .../net/ethernet/broadcom/genet/bcmgenet.c    | 64 ++++++++++++----
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 76 ++++++++++++-------
 2 files changed, 98 insertions(+), 42 deletions(-)

-- 
2.24.1

