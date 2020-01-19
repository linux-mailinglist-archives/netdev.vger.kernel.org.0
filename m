Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D113D141E31
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgASNdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:33:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34967 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASNdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:33:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so12055864wmb.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 05:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MuntTUmjRdAwKEQ2BkedcZdmmh4ox21g1QoMjYozgAU=;
        b=lnHb2JdUsH1PCUQm9PT7OJGxZ6k0v7jKEb2ZYXQlGtAUeuRGhCaVLwHZX7Wy1+C7hN
         Fpzd/Ox3gaeSHRSzH1JWwhwpz8JcxNX2cphqSApjOY9vl1R99ZL2NbX6oDKlv4aq178K
         qsd73vKlLOfRMFoQTlrpIm0aHQoynENbYB9rHE3BBP0yitYkn0TtBxSe3XUgT3M5Nzip
         nqxANWkSw+/OA+AVmujKV0wtFgMu3ReZD65nsC1wgqe96W/2epnirHPqjd/JwOuHtq5C
         a+KXqxAHplv1mstEKaczV9/nFqpsDj8RXTeepQKM0oLX190V2mLf56VnG54BjRJW4IlD
         X+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MuntTUmjRdAwKEQ2BkedcZdmmh4ox21g1QoMjYozgAU=;
        b=bKNjyjr1H6zXCxprzZYzvvYmCz3VRyTJ+iIi5TlWhl1aquRxVlgOhg2hXoPBpqtaBH
         UDO8A/NQRIf7RoIxWDkfTNJQbjM5zb7gzlpD/MYTXmsY6UZCtxEYGuguIhUCkF75UPQZ
         9Z5U0+i2Z3oz6fY6/OXA2LS0MG9xUvp0JZQGz1UEJlp5LKHbKyfzC3ETxj0xcNvBvi1x
         kjNP2p1dhIMbWanWF3J4x6NSfwofAm5RprrEHTam6XjzxUKQhwiAiUY/g5pvoe457Xo2
         qCCWD0lEiSWrhNfgIRamASEcSLtuKKRFQ9SUZw5UYQBDcbsPaqfMfKG9uam0cr/vwu6F
         nY0g==
X-Gm-Message-State: APjAAAW4lWYAuvW/JM2pIZbCaIbcqT7A+5SsfSpANB5Na9wpdm3RiFrW
        /+aenwKLC8Wtv1fi72Ea4zFWXwj2
X-Google-Smtp-Source: APXvYqx/bgADlsW8aRa5o54vD79n2BxfWRdEi4Hjlc9DnlYtl4DWPJm5lqHv+Gr5LjEVoc6tv1HDAw==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr13789245wmh.99.1579440794174;
        Sun, 19 Jan 2020 05:33:14 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id u8sm18707204wmm.15.2020.01.19.05.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 05:33:13 -0800 (PST)
Subject: [PATCH net-next 1/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Message-ID: <3e3291b4-9b87-e917-f007-2172cf393759@gmail.com>
Date:   Sun, 19 Jan 2020 14:31:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of network drivers has the same glue code to use phy_mii_ioctl
as ndo_do_ioctl handler. So let's add such a generic ndo_do_ioctl
handler to phylib.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 15 +++++++++++++++
 include/linux/phy.h   |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 541ed0149..da05b3480 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -432,6 +432,21 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 }
 EXPORT_SYMBOL(phy_mii_ioctl);
 
+/**
+ * phy_do_ioctl - generic ndo_do_ioctl implementation
+ * @dev: the net_device struct
+ * @ifr: &struct ifreq for socket ioctl's
+ * @cmd: ioctl cmd to execute
+ */
+int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	if (!netif_running(dev) || !dev->phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+}
+EXPORT_SYMBOL(phy_do_ioctl);
+
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 {
 	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2929d0bc3..996c4df11 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1231,6 +1231,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd);
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
+int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
-- 
2.25.0


