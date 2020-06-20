Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE3202668
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgFTUlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50453 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFTUlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id l17so11500410wmj.0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9VisfBKwEdlL5gfhqyqG2mtBtVY9G2cVZRgFvwxUHBw=;
        b=nRPtSwILvaCIbd1tbS885ELCNxyGb2fRVweab/gcKGNL5MSSpkAhcx5vnUHKtmJYmt
         x40tB/KezRPhv99aAPFkNbSJjwVuXS8VcAQ5Kikt0ND+fVghJFVKbAi5YTiUb/3qU3ss
         FvO90KlZZwbU3EzlkyTUgezFmBfrBBTYXHXWqxJBcvtmj/BaMbFOBvZscX0J/YRTYt9w
         dEjXKbfUado0PbjinFRfE1vh+mK9PQu7rT40K1RrGYhlyPbz1rw9CQjFUABkZsrm69N/
         btEX9KcpKezxRgOKUh9nh8i/G1rS6lyHJgxNz3k8jFjl8F2u66tEKG/jYmBWp8H/C9JY
         AbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9VisfBKwEdlL5gfhqyqG2mtBtVY9G2cVZRgFvwxUHBw=;
        b=mMcVUT1lxwRlQsUSzqCHR0BSCNL39Rrf81upS9UWHB9kRxdtxOdUzkfXEP9Z0621tO
         +W/Xk9i1kDFB6YpBDymR1SUEKboJnqFpU69z3TBzAxrsAoO66t4+bDc/C9Slxr+HwMjH
         wpyPNKWoIFDeShTU7eTU2IqudrNvc3GImwyrpntZCR0Lj0Wd2wqyjH9148v8vbbUlaPf
         moS2AIjHy0MQDhv/MfuhtcDRL4khLUnJVTYUQtRvvRK8ul2xdVBVFwHe3gobKUbp9yZ6
         bGTnBVSeAHv0UGI6h9m9FWdn5CiI6wjuKkIjyGVFU/5K56cOMVy3f8qKO87bgmZBs0aP
         bryA==
X-Gm-Message-State: AOAM530XZsOEaAAt3EWOfzOGXutzbohOMck97qwJIY04/z1QzeSSXMxf
        AXK37wt2XLfP43HkaxaTV63X9gkY
X-Google-Smtp-Source: ABdhPJz0oYW9oQriiwsGE0Z9mAPZD240fdk9xKOPYUc4usnsk8zNau2cWnFAQM9Gx+yF6F/I0GF0/Q==
X-Received: by 2002:a1c:8186:: with SMTP id c128mr10749379wmd.114.1592685601021;
        Sat, 20 Jun 2020 13:40:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id v24sm13311433wrd.92.2020.06.20.13.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:00 -0700 (PDT)
Subject: [PATCH net-next 1/7] net: core: try to runtime-resume detached device
 in __dev_open
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <89c52082-13ad-25ca-88b1-133573037e95@gmail.com>
Date:   Sat, 20 Jun 2020 22:35:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A netdevice may be marked as detached because the parent is
runtime-suspended and not accessible whilst interface or link is down.
An example are PCI network devices that go into PCI D3hot, see e.g.
__igc_shutdown() or rtl8169_net_suspend().
If netdevice is down and marked as detached we can only open it if
we runtime-resume it before __dev_open() calls netif_device_present().

Therefore, if netdevice is detached, try to runtime-resume the parent
and only return with an error if it's still detached.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/core/dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc238814..ffa8c371d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -143,6 +143,7 @@
 #include <linux/net_namespace.h>
 #include <linux/indirect_call_wrapper.h>
 #include <net/devlink.h>
+#include <linux/pm_runtime.h>
 
 #include "net-sysfs.h"
 
@@ -1492,8 +1493,13 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 
 	ASSERT_RTNL();
 
-	if (!netif_device_present(dev))
-		return -ENODEV;
+	if (!netif_device_present(dev)) {
+		/* may be detached because parent is runtime-suspended */
+		if (dev->dev.parent)
+			pm_runtime_resume(dev->dev.parent);
+		if (!netif_device_present(dev))
+			return -ENODEV;
+	}
 
 	/* Block netpoll from trying to do any rx path servicing.
 	 * If we don't do this there is a chance ndo_poll_controller
-- 
2.27.0


