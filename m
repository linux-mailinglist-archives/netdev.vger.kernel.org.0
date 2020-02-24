Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A53169EF9
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgBXHPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:15:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37126 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgBXHPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:15:44 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so3682841plz.4;
        Sun, 23 Feb 2020 23:15:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E3dZo4uyTHIfwZ9buqAY9fgJTMYKM8S4o+B958cH0P0=;
        b=ehE+U/VgTg7m+pmMZp4h+iqFSuLlZSWHaLtxGJqjla6QPNjUUZuEuKw/tCz7PuBTnk
         CBq5+x6flfuP/ns7aBp/o/P3ZMlFcU77agAVttX9uv783bO6DpT42S1SljjagYHrHdqh
         sNZGAKrhFmMlwxDpE6qLBgN0CAAjZvZutJwUzlLqevQN6XIlptdqGbFaJBW7K38PDSet
         rNgayJaEDUuNm29xM/l+FmDKTfR9Wh1NsmdZTyJNuuFz8PyKs3PcMch8Y5KMqw5/vJac
         1yo7qCcNjpbmbP3/aB3Wv0mPtBQoCSwXYMAwhAyBr9weHp5ZIO/9PkDidANfLnPfUxbU
         Fe1A==
X-Gm-Message-State: APjAAAVX7YVV5M3o6K8yyHXRrrCNIGz3mZo/2Fqze1D3OZ4WOmcgRZqB
        7WfyU0DBu59nnaJ9bFGsNoM=
X-Google-Smtp-Source: APXvYqyZdO6HOxgfMd5MC+igzpT5WulQVFMxrwUSLIpPtC6nN/jtILTAjxyoe6dcCiVEJGYvwnAHVw==
X-Received: by 2002:a17:90a:2545:: with SMTP id j63mr19008657pje.128.1582528543711;
        Sun, 23 Feb 2020 23:15:43 -0800 (PST)
Received: from localhost (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id w25sm11267765pfi.106.2020.02.23.23.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:15:42 -0800 (PST)
From:   You-Sheng Yang <vicamo.yang@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Malani <pmalani@chromium.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        You-Sheng Yang <vicamo@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: r8151: check disconnect status after long sleep
Date:   Mon, 24 Feb 2020 15:15:41 +0800
Message-Id: <20200224071541.117363-1-vicamo.yang@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
being discconected from USB, may take up to 14 seconds each in practice,
and that has to be completed before USB may re-enumerate devices on the
bus. As a result, devices attached to the dock will only be available
after nearly 1 minute after the dock was plugged in:

  [ 216.388290] [250] r8152 2-1.4:1.0: usb_probe_interface
  [ 216.388292] [250] r8152 2-1.4:1.0: usb_probe_interface - got id
  [ 258.830410] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): PHY not ready
  [ 258.830460] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Invalid header when reading pass-thru MAC addr
  [ 258.830464] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Get ether addr fail

This can be reproduced on all kernel versions up to latest v5.6-rc2, but
after v5.5-rc7 the reproduce rate is dramatically lower to 1/30 or so
while it was around 1/2.

The time consuming for-loops are at:
https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L3206
https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L5400
https://elixir.bootlin.com/linux/v5.5/source/drivers/net/usb/r8152.c#L5537

Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
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

