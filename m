Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141753F15BD
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhHSJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbhHSJGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 05:06:30 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B5DC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 02:05:54 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gr13so11394914ejb.6
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 02:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=avdBfOFXMdxh5LUuOT/Y26UwCZnLaQOMunZqBLbNGVA=;
        b=edikmR2uWKXJkjcDxxQrs5EOfyplzW8KRdMAR9X1QiZPsAXxA7hCjV8V0AAThzACvd
         7DOI5WKWljZhbDewRGH8Y733HXnCzjo202FR+cyI7fGHZymji4+O6lNjuKF1w+h7MsQF
         ya2FYnuZeT4QTtn0WFk7fBWndguCyl2RiY++E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=avdBfOFXMdxh5LUuOT/Y26UwCZnLaQOMunZqBLbNGVA=;
        b=cW5RTkm/xIDZTlcuHv9ygtjKPhWdYCw9+c0HsQtux40KGk9QGmVsiVszy4Iv+kOIhS
         aF6jwUZR5fJs4hWkJDDcphfQmSeZhsrSxoairFr/uPyyzvAqLYbNYu+GqC3CWCZBBqDG
         DNsG79AHKdsWg/KPqxYD5Uw8XwLl8jSV0Q8St6AGb6e5jgZAN4tHrLsojdEKKBD0J5UV
         swNE+VJ91DtdKf/h2z73QEkiKAHcw7RMzq12o5e3V/maiGgwXdFfreKVX4oLGoYPXyNP
         ldb9wxq4U6WJclV7qxwX4gHYvn9JxCVxRW8xWphhs5fmA9clCAgcjvVmqA/5RW1Q9qI7
         TP+g==
X-Gm-Message-State: AOAM5315W3mzCL6qUra2Z8UB+wvhbm/XOjJZKZn29mBto9I1elP8SrIz
        00l/W43IhOWCLduS+BhdKWnwyA==
X-Google-Smtp-Source: ABdhPJx2PF353HZGATdrBf928LpiL/1Q8aQY5pB0yztlTFCepM3IUxMLxGuwqIziwWpPT9HTBW60SA==
X-Received: by 2002:a17:906:58c7:: with SMTP id e7mr14321313ejs.197.1629363953206;
        Thu, 19 Aug 2021 02:05:53 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id k21sm968747ejj.55.2021.08.19.02.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 02:05:52 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, Petko Manolov <petko.manolov@konsulko.com>
Subject: [PATCH] net: usb: pegasus: fixes of set_register(s) return value evaluation;
Date:   Thu, 19 Aug 2021 12:05:39 +0300
Message-Id: <20210819090539.15879-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
    Kicinski;
  - hurried up and removed redundant assignment in pegasus_open() before yet
    another checker complains;
  - explicitly check for negative value in pegasus_set_wol(), even if
    usb_control_msg_send() never return positive number we'd still be in sync
    with the rest of the driver style;

Fixes: 8a160e2e9aeb net: usb: pegasus: Check the return value of get_geristers() and friends;
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
---
 drivers/net/usb/pegasus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 652e9fcf0b77..1ef93082c772 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -446,7 +446,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -835,7 +835,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
@@ -932,7 +932,7 @@ pegasus_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	pegasus->wolopts = wol->wolopts;
 
 	ret = set_register(pegasus, WakeupControl, reg78);
-	if (!ret)
+	if (ret < 0)
 		ret = device_set_wakeup_enable(&pegasus->usb->dev,
 						wol->wolopts);
 	return ret;
-- 
2.30.2

