Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD82AADBA
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKHVoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHVoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:44:12 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64477C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 13:44:12 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so2865125ejk.2
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 13:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=wwFy1MmWeUmWZJvbY8QGWJ6gtRFMhrW66VcCJS/zn10=;
        b=jNwZ+u3BFfjMBax9cgIBpvzaKI0lxHpEvQ5ef/uS0wzVwKejgBVcwyOyRXkn7VhDCR
         QUiYrLQUESumtE4YDAaUuAQ1JxlFZynPAVMXP4jJdDhGFZ6XlQv/PfIM5GttvCyKe/1E
         QqW3lAmwBEs37mSdXLOn2H8yVz+TSmT398LkQIkCoBxvCoqKZ1Hi+pnjr3j2YzbLTfBt
         UBPLe89eAAtu/XG2UKLYPt2auwhjx3u4pG2Nf8HYkBq1GKhUpE4j63IQW2/EmpXs/Ken
         MZUTOhbIfB+CguXhy2JSLmRppDyqEjbzdS6rV56raDrATNVZAhKATeU+IBjBcLPe8Sdu
         f26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=wwFy1MmWeUmWZJvbY8QGWJ6gtRFMhrW66VcCJS/zn10=;
        b=J+fxwK3D0539q0l1dmGJae6dkoDG+Jshb+AWJN8my57g+1suHYdYb2SxNi6sljo2uq
         z6GZD4RtXMByK7yxnRFQZ0g01myIdTP/eWPWiu+Uv+mauE9U/iGQ08Pe2YBOivqcV6/j
         rvmYtlJlEPUIxujw5b4ruemR/dxN35OKWsgJQphJ4UaXLPKfoDTypVHoRJBN8YkxYZHV
         bui7PCzY2a5lvUhNnS1yNPMm/ksNMjX7z84kT+e7VfKAITt/1ioAQqztmy1Z2gzU4eJ0
         1IGW1MFdpVrPV74n5axMmcn7NkFEXJHhCJYLjta48/RfYQu1P+v7DoeV55m/klWIJe01
         xBOg==
X-Gm-Message-State: AOAM531R+0FzgzdAxkTZSKbQk58V3o5tY+A8WTXTR16U5t3c98wNjOhF
        C7J5U7ES831N3aXXn4rSv+F3HZGvx+nnng==
X-Google-Smtp-Source: ABdhPJylz/l5IXTg953SsTi89VzGRoMkZUSB9qEqZqlGzVsWFustsw1dUrpw4xVEl80pCUEhvlQDnA==
X-Received: by 2002:a17:906:4c41:: with SMTP id d1mr12868299ejw.485.1604871850899;
        Sun, 08 Nov 2020 13:44:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:493b:5170:637f:1fc7? (p200300ea8f232800493b5170637f1fc7.dip0.t-ipconnect.de. [2003:ea:8f23:2800:493b:5170:637f:1fc7])
        by smtp.googlemail.com with ESMTPSA id d7sm6940096ejt.50.2020.11.08.13.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 13:44:10 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] net: phy: realtek: support paged operations on RTL8201CP
Message-ID: <69882f7a-ca2f-e0c7-ae83-c9b6937282cd@gmail.com>
Date:   Sun, 8 Nov 2020 22:44:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8401-internal PHY identifies as RTL8201CP, and the init
sequence in r8169, copied from vendor driver r8168, uses paged
operations. Therefore set the same paged operation callbacks as
for the other Realtek PHY's.

Fixes: cdafdc29ef75 ("r8169: sync support for RTL8401 with vendor driver")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 2ba0d73bf..5844cf2d3 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -551,6 +551,8 @@ static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
 		.name           = "RTL8201CP Ethernet",
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc816),
 		.name		= "RTL8201F Fast Ethernet",
-- 
2.29.2

