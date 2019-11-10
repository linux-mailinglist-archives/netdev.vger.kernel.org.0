Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E14F6927
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 14:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKJNpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 08:45:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33404 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJNpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 08:45:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id a17so10114290wmb.0
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 05:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=MrBiRJ0AwISW3DBfFp0STOVwnoo5kDqFhWW7A8/G7D0=;
        b=kezscVKCpQtuIVoJFaJrNPFGwpu8EnbYIeZKTObiL/1eOJjV2GqMFneNLF1JIIE+TK
         fNQeUiioZvw4iV8sAPd/3FyXf63SlVUh2R+suZgyvI8A+AjGz5LN7D2bVpUPFBF/1BFk
         FDfGx75bqjaUmMaeir5++sVnXfc19lwTGHb2QkQzxa46Z1aejtbpvrhE52JcGuTLndzz
         5WUtZBppKl3NNmvHYsVIb7COulcb3sxhtcbPwpsP7FBu2EuL/XPCEWtr7V5KPXMTAG2i
         ESJ/gtgd7F1aaJX7Zznekoti9rZ9xre8Fe6ll7+07v+Sq5RgAxci5NRx5k1ZzOZDEOST
         JbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=MrBiRJ0AwISW3DBfFp0STOVwnoo5kDqFhWW7A8/G7D0=;
        b=mP+IOsJohET7c/twpFizF+SOvxeV+mQfpoIBI26aq6IkXSszYj+TUCJOiHkvccVySC
         SP9tRPXfAXetNHsTLxuViAjFheZh6UVMlECO1X9/S2aPW1n5zauhlN+l2Q28vxxLwBcQ
         9y54YduaVbpgbu6YjmETzHTaa06eeFX0Pqo6LMpf0/eORtguNUy085hhXzawTloRnhbv
         CXmA4bFOPHoIhO0Y+bsHCG7oUUYtwnCUZWm6Lk5xsrUNSeVkXwcnwGqXXmy/ZLIWnO9t
         GoY1cCrjD6Hsg+osmL0YzQln3bI+Vbf9Yu3MMCpt/Y8yUjwUURVXz3+oEA2SS4plhqCp
         UeMQ==
X-Gm-Message-State: APjAAAW3eMXS1ixhe/42ZKQLB1nOmZ3lo38k01Rs7Df33S9Am5KudU6r
        +sbBgySLDonB7qPqY0lzbRsj9IL3
X-Google-Smtp-Source: APXvYqxlMvG/MKk/sU8oODeWEYOz2gQveXTkR9I/+/+wyBL/TzRPd+ZD6t2RcE2xSgMMQvGtUeqpyQ==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr16797076wmb.102.1573393502648;
        Sun, 10 Nov 2019 05:45:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:bda1:5ec8:e3a9:19fd? (p200300EA8F4DA200BDA15EC8E3A919FD.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:bda1:5ec8:e3a9:19fd])
        by smtp.googlemail.com with ESMTPSA id g8sm12735183wmk.23.2019.11.10.05.45.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 05:45:01 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: respect EEE user setting when restarting
 network
Message-ID: <dbc0b252-4bbd-4f93-6cc1-1bdd64159f8f@gmail.com>
Date:   Sun, 10 Nov 2019 14:44:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if network is re-started, we advertise all supported EEE
modes, thus potentially overriding a manual adjustment the user made
e.g. via ethtool. Be friendly to the user and preserve a manual
setting on network re-start.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d4345493f..249b68d00 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -680,6 +680,7 @@ struct rtl8169_private {
 	struct rtl8169_counters *counters;
 	struct rtl8169_tc_offsets tc_offset;
 	u32 saved_wolopts;
+	int eee_adv;
 
 	const char *fw_name;
 	struct rtl_fw *rtl_fw;
@@ -2101,6 +2102,10 @@ static int rtl8169_set_eee(struct net_device *dev, struct ethtool_eee *data)
 	}
 
 	ret = phy_ethtool_set_eee(tp->phydev, data);
+
+	if (!ret)
+		tp->eee_adv = phy_read_mmd(dev->phydev, MDIO_MMD_AN,
+					   MDIO_AN_EEE_ADV);
 out:
 	pm_runtime_put_noidle(d);
 	return ret;
@@ -2131,10 +2136,16 @@ static const struct ethtool_ops rtl8169_ethtool_ops = {
 static void rtl_enable_eee(struct rtl8169_private *tp)
 {
 	struct phy_device *phydev = tp->phydev;
-	int supported = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
+	int adv;
+
+	/* respect EEE advertisement the user may have set */
+	if (tp->eee_adv >= 0)
+		adv = tp->eee_adv;
+	else
+		adv = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
 
-	if (supported > 0)
-		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, supported);
+	if (adv >= 0)
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
 }
 
 static void rtl8169_get_mac_version(struct rtl8169_private *tp)
@@ -6719,6 +6730,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
+	tp->eee_adv = -1;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
-- 
2.24.0

