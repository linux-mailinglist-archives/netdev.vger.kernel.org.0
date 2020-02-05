Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EBF15397E
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 21:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBEUW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 15:22:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55226 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgBEUW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 15:22:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so3881068wmh.4
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 12:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Klj8G2YSdqVKi3c3bwSnMVskRKqAWrTyw69usHPX1tk=;
        b=e0HJlXFoGlx4Cwk50YDWU3/0ON2W6N9omsjHOwT+rg6Sqtt1qxFMnzftmPiktZZX5f
         eQq+92sem2ggnSR5WzINgdsq0CQ1772mmpYqPg3OZX+PRLv/g5tN1opOq1RiZfwNW+q5
         A4n25c94hVvxE6nIx40esDAilUBguzf07xBakKUU7e4DPxoEfD8tL3lP10NNSOXGZ6aP
         u77TI50ngP48eKN+F0tZNGcfwqQjFtDG7tAeZMp+nAEaSIeWSJe/VhGFMeb2f1gRMJYg
         idPRrm/Lqq9R0qewqSF83wLpB462oviO5ZCf7ZpSP5VA/BEN7Jlgp1ZhQK1L5knEs0Dp
         6W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Klj8G2YSdqVKi3c3bwSnMVskRKqAWrTyw69usHPX1tk=;
        b=tmjxUr86bZTo2Z9shKY+nmGRSzJwHLdwugHx64+vcGmF3A4GhySV/0otz0t+8RBLqi
         1GDSMHVQVtDCGiX4qwg6XkAQD/7Ppy31LHu7BP055Pv54yem4PdLbwNKOgS9rBslZjky
         a//xRBdcyMheplGFwKQwFDMvWo3NkyRYIQAGvgiKbgCEP30fX3EoQhMFQVZgi59ee4yR
         NmHiz+glS4mJHu/yhwsAVgaq1W0J8g99mqPImKvBOUonL4BEJNl1GvOpRpaL6++9jg2r
         p6Lk0EqXag0u5+rwl03DtG8ipupKj7P6/pcGF9aWMpGd/eokotgw6dDS1Yz+Ng+4DBbS
         pj0Q==
X-Gm-Message-State: APjAAAXXCNGWQvmgt6AZRpMvCEWBxtObpeTgQbtPDjx4C9Z5QpQwRXKl
        6qTwW7tkzles/7NVzUW0gyX0kxmS
X-Google-Smtp-Source: APXvYqx1zemAwNivDMW1DfTEzJdLc18Y8oXd9sS/zZUC98rUvnV04p5OsTtN7lfcC3aA1q3IGtu7dw==
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr7464350wme.82.1580934175440;
        Wed, 05 Feb 2020 12:22:55 -0800 (PST)
Received: from [192.168.178.85] (p579877E9.dip0.t-ipconnect.de. [87.152.119.233])
        by smtp.googlemail.com with ESMTPSA id o4sm1338780wrw.15.2020.02.05.12.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 12:22:54 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix performance regression related to PCIe max
 read request size
Message-ID: <342eb05f-0376-cb0f-5fea-cb1f171b4fdb@gmail.com>
Date:   Wed, 5 Feb 2020 21:22:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turned out that on low performance systems the original change can
cause lower tx performance. On a N3450-based mini-PC tx performance
in iperf3 was reduced from 950Mbps to ~900Mbps. Therefore effectively
revert the original change, just use pcie_set_readrq() now instead of
changing the PCIe capability register directly.

Fixes: 2df49d365498 ("r8169: remove fiddling with the PCIe max read request size")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index aaa316be6..a2168a147 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2477,15 +2477,18 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168b_1_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168c_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_enable(tp);
 		break;
 	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
+		pcie_set_readrq(tp->pci_dev, 512);
 		r8168e_hw_jumbo_enable(tp);
 		break;
 	default:
@@ -2515,6 +2518,9 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 		break;
 	}
 	rtl_lock_config_regs(tp);
+
+	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+		pcie_set_readrq(tp->pci_dev, 4096);
 }
 
 static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
-- 
2.25.0

