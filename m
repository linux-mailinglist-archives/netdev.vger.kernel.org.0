Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C62018A579
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCRU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCRU4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103A420A8B;
        Wed, 18 Mar 2020 20:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564961;
        bh=QF/GYMkHLxXCI0oXGqXah6iopHeOKnwoPfvv7v33fx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkSiSj/Sg18f6YKXn7JRz8KdjAYvl9n6ujYjy8lkUmcThvpz8txi5H/YqeGpU51VO
         21BddRA8dH+XMzFXNjZNNWMLeDuV8JWUM53DMLQm2PYWmuf+d+owI9FRvW8iuj8L/S
         RGkKaGwOEv3Ovl4nHl9ehFXYFaND+/pzmqLuZjQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     You-Sheng Yang <vicamo.yang@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/28] r8152: check disconnect status after long sleep
Date:   Wed, 18 Mar 2020 16:55:32 -0400
Message-Id: <20200318205555.17447-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: You-Sheng Yang <vicamo.yang@canonical.com>

[ Upstream commit d64c7a08034b32c285e576208ae44fc3ba3fa7df ]

Dell USB Type C docking WD19/WD19DC attaches additional peripherals as:

  /: Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
      |__ Port 1: Dev 11, If 0, Class=Hub, Driver=hub/4p, 5000M
          |__ Port 3: Dev 12, If 0, Class=Hub, Driver=hub/4p, 5000M
          |__ Port 4: Dev 13, If 0, Class=Vendor Specific Class,
              Driver=r8152, 5000M

where usb 2-1-3 is a hub connecting all USB Type-A/C ports on the dock.

When hotplugging such dock with additional usb devices already attached on
it, the probing process may reset usb 2.1 port, therefore r8152 ethernet
device is also reset. However, during r8152 device init there are several
for-loops that, when it's unable to retrieve hardware registers due to
being disconnected from USB, may take up to 14 seconds each in practice,
and that has to be completed before USB may re-enumerate devices on the
bus. As a result, devices attached to the dock will only be available
after nearly 1 minute after the dock was plugged in:

  [ 216.388290] [250] r8152 2-1.4:1.0: usb_probe_interface
  [ 216.388292] [250] r8152 2-1.4:1.0: usb_probe_interface - got id
  [ 258.830410] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): PHY not ready
  [ 258.830460] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Invalid header when reading pass-thru MAC addr
  [ 258.830464] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Get ether addr fail

This happens in, for example, r8153_init:

  static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
			    void *data, u16 type)
  {
    if (test_bit(RTL8152_UNPLUG, &tp->flags))
      return -ENODEV;
    ...
  }

  static u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index)
  {
    u32 data;
    ...
    generic_ocp_read(tp, index, sizeof(tmp), &tmp, type | byen);

    data = __le32_to_cpu(tmp);
    ...
    return (u16)data;
  }

  static void r8153_init(struct r8152 *tp)
  {
    ...
    if (test_bit(RTL8152_UNPLUG, &tp->flags))
      return;

    for (i = 0; i < 500; i++) {
      if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
          AUTOLOAD_DONE)
        break;
      msleep(20);
    }
    ...
  }

Since ocp_read_word() doesn't check the return status of
generic_ocp_read(), and the only exit condition for the loop is to have
a match in the returned value, such loops will only ends after exceeding
its maximum runs when the device has been marked as disconnected, which
takes 500 * 20ms = 10 seconds in theory, 14 in practice.

To solve this long latency another test to RTL8152_UNPLUG flag should be
added after those 20ms sleep to skip unnecessary loops, so that the device
probe can complete early and proceed to parent port reset/reprobe process.

This can be reproduced on all kernel versions up to latest v5.6-rc2, but
after v5.5-rc7 the reproduce rate is dramatically lowered to 1/30 or less
while it was around 1/2.

Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a7f9c1886bd4c..cadf5ded45a9b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2696,6 +2696,8 @@ static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
 		}
 
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	return data;
@@ -4055,7 +4057,10 @@ static void r8153_init(struct r8152 *tp)
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
 		    AUTOLOAD_DONE)
 			break;
+
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	data = r8153_phy_status(tp, 0);
@@ -4170,7 +4175,10 @@ static void r8153b_init(struct r8152 *tp)
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
 		    AUTOLOAD_DONE)
 			break;
+
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	data = r8153_phy_status(tp, 0);
-- 
2.20.1

