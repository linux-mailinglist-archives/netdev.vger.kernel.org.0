Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2169E143353
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgATVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:20:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43264 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:20:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id d16so972735wre.10
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mekMsZdxwqCpJbyPND5omhQpwmU0R++HZnB6035W2QI=;
        b=DB+BzJkRwndjup7pgFEVHlRrRVUQuua70B13Kr021Wx75XgzWsgpFDrFK5DKseej0L
         yx41+44b5RuAMOm9cl5DQTJpZ2NUT0AuKI3P7ZRdldJpITcgqdi6nke3r++lbFgb6qa5
         +R7tTDapEf1XQrjvNqTi4895BkTa1PBRxkzpeP0nf/uQ+3cDSKA+4iVvp3RyilQdypEH
         PmRA7sz/7+PXEdJ+83OsZ+Pvt/1oT0+4JsuFtp52xoITbGdS8/8Z8EtFJ+GuhLEs8xCp
         lohRCn/v6OV4tXAnMz1NTWTppiHJF71sNI1ZNXs9IJRp/GG60+Nll5ukSz8hDZlvQN8y
         6b5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mekMsZdxwqCpJbyPND5omhQpwmU0R++HZnB6035W2QI=;
        b=sT9aMXTmAz/5ExIdjpATAJgdN0WJCjfJrnhDDEr4gFXmcWURepqq8PLnaQEogCXihQ
         aocPqh/KrPaWzpwmF8PyrKP6L3GMQ//HadyU7h+jgX45bqaCWIYrxirj82+7IFd8CHe0
         jn1kkb8CCG1KVpaWZGQtrmls6NQ0syQrZgkBYsTntBowz/W5WMAUNcxdZAMBpVF+s94S
         EaHII0kTxTjg18gB3V8qx1dSCsKh1ya9BuJFhj8d2460mfEn3+utHnjcc2W8a2mmDLqH
         QJ87tO9Bh+JswPqJYgEKJGQgqMtE9pvbLqs1VSnCgj5bvLHNt4Ko0FpJqjYuk0nGpEjF
         cvYA==
X-Gm-Message-State: APjAAAU1hqNsTWJsKvOu93kOToduoCdCUL/Su+KdGm8s7kF5mcxTYIA6
        9VTQYHktltd889B99p51iqOV59pq
X-Google-Smtp-Source: APXvYqyFcX7TD82rfbhztm87hzkXeRdFwHapJGXgNuUjEfMfkvYGyDSQK6mhoCulcSYT4q4fokvnYQ==
X-Received: by 2002:adf:8541:: with SMTP id 59mr1359352wrh.307.1579555205599;
        Mon, 20 Jan 2020 13:20:05 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id p18sm847248wmg.4.2020.01.20.13.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 13:20:05 -0800 (PST)
Subject: [PATCH net-next 2/3] net: phy: add new version of phy_do_ioctl
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Message-ID: <9ed8f7eb-c2b7-ae14-c3b3-83b0aee655c4@gmail.com>
Date:   Mon, 20 Jan 2020 22:17:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new version of phy_do_ioctl that doesn't check whether net_device
is running. It will typically be used if suitable drivers attach the
PHY in probe already.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 16 +++++++++++++---
 include/linux/phy.h   |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index cf25fa3be..d76e038cf 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -433,18 +433,28 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_mii_ioctl);
 
 /**
- * phy_do_ioctl_running - generic ndo_do_ioctl implementation
+ * phy_do_ioctl - generic ndo_do_ioctl implementation
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
  * @cmd: ioctl cmd to execute
  */
-int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
+int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	if (!netif_running(dev) || !dev->phydev)
+	if (!dev->phydev)
 		return -ENODEV;
 
 	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
+EXPORT_SYMBOL(phy_do_ioctl);
+
+/* same as phy_do_ioctl, but ensures that net_device is running */
+int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	if (!netif_running(dev))
+		return -ENODEV;
+
+	return phy_do_ioctl(dev, ifr, cmd);
+}
 EXPORT_SYMBOL(phy_do_ioctl_running);
 
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 28e8d8102..3629f1369 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1231,6 +1231,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd);
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
+int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
-- 
2.25.0


