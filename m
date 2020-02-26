Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6621702B9
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgBZPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:37:57 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45302 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbgBZPh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:37:57 -0500
Received: by mail-pg1-f193.google.com with SMTP id r77so1445980pgr.12;
        Wed, 26 Feb 2020 07:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVyxLUdFZ6k2/LWuzpd/gZEBBa95t0IpAukk6u0aGLU=;
        b=BmpwcnnraZvpu2po0fbuvHX0FFdBeYXSwaFAtSXuwcctk2j7Bvlt0TSXXTwtOow//z
         7nsyLLf2sl0dDYAd1W33LSWZoQ6H2aj9QjDev0UnBqx7Ct76RPn2Adt1V2jU7nr1TIN5
         N5lW+fLjb4JQvs6Rrdu+Tzxmp+NU2HqKGLTNerWdXE6aM3JrmtlTeNlH+wdXzyGsI5eQ
         NNsGetqthvYf/WTjNI0t4ghT71SiXZcw8yOu/E7DRcCoGVtoJvHj47+E3qs4ZexsgzIl
         2mWucXhwmoYGmfmcSwp5cBHZ3bQWdRoJMbxk+Id2WQxMoCVbi/6SKyYiHTYImpLU6+aX
         pn5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bVyxLUdFZ6k2/LWuzpd/gZEBBa95t0IpAukk6u0aGLU=;
        b=GSujQr7Iz9ZY0FL8DYCrna5ByuqtDbW6XUBz78IZdxmStzI3+gvn1iVfxULemgkSlF
         YPKZcz0nGhHkVUfGAY9kGhxcPpksXdfNt6OU341JuF1TY3BetGctniAxxejvSYaDv9mL
         ETpZDLdyturFMBiKAYZNFwUStyhRO5OnI+XumvUgYgByPRPIz3Hedm3DjFYY13dFva7l
         KudJNjIbF5xZg8DaVWDiagzqTMJMPIODzSGER75kVaOOK05HZur68uLkpu/fKeTICEFS
         7MPosS6j19XN6++oNa2GwD0AVl9vfzzWoSWlxrScclryXZ+wVcErxd+Dmklqcz1SlR/q
         4LXQ==
X-Gm-Message-State: APjAAAVCMZSy27/O6OXMEWZu2xZNlO4/bThXCzCTcn82ZkTKzsHhoc0p
        lnKVfjvef/sg2sfGVtEheMg=
X-Google-Smtp-Source: APXvYqzXUOD2tiaHtoxdp2NNpqiW9o8kJJbfJcIh+ZUZ2dcaNFlqZ8NdnApwBtzOL6KhoTi11XmbaA==
X-Received: by 2002:a63:cf4f:: with SMTP id b15mr4286585pgj.287.1582731473931;
        Wed, 26 Feb 2020 07:37:53 -0800 (PST)
Received: from localhost (114-136-150-109.emome-ip.hinet.net. [114.136.150.109])
        by smtp.gmail.com with ESMTPSA id c15sm3499768pja.30.2020.02.26.07.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:37:52 -0800 (PST)
From:   You-Sheng Yang <vicamo@gmail.com>
To:     davem@davemloft.net
Cc:     grundler@chromium.org, hayeswang@realtek.com,
        kai.heng.feng@canonical.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, pmalani@chromium.org,
        vicamo.yang@canonical.com, vicamo@gmail.com
Subject: [PATCH v2] r8152: check disconnect status after long sleep
Date:   Wed, 26 Feb 2020 23:37:10 +0800
Message-Id: <20200226153710.239838-1-vicamo@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224.144714.329725174070305071.davem@davemloft.net>
References: <20200224.144714.329725174070305071.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: You-Sheng Yang <vicamo.yang@canonical.com>

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

---
Changes since v1:
 - update patch title, commit messages.

---
 drivers/net/usb/r8152.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 78ddbaf6401b..95b19ce96513 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3221,6 +3221,8 @@ static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
 		}
 
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	return data;
@@ -5402,7 +5404,10 @@ static void r8153_init(struct r8152 *tp)
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
 		    AUTOLOAD_DONE)
 			break;
+
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	data = r8153_phy_status(tp, 0);
@@ -5539,7 +5544,10 @@ static void r8153b_init(struct r8152 *tp)
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
2.25.0

