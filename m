Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8C12A99A
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLZCQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:29 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55982 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLZCQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:28 -0500
Received: by mail-pj1-f67.google.com with SMTP id d5so2739953pjz.5;
        Wed, 25 Dec 2019 18:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdiVljbiL8yD+9AexClzPzh6XW5pK8fMUd89Hf0ztvQ=;
        b=W37FvhJeyxb84SQJ+1Y0H9SGyBC2kt9YIffHiklgwF6o/B8ZR2unePWVrA1WTl7swa
         DzirMLrs79HbgkM20zewmV82tMF2RCfY9WjyKoNnQ1UjLlPHca0opK/Y9fp7gKY8UofV
         oJSxoVg0Fi2zep3R8/D7Q1q2OosIH1VwQTTSRMDlf8po6nNKqjFBcjLvg/3SAXcr0SlT
         VoshZkYFEyhzYR9rZtGwHYj1p7+9tMwijMs7goGSzpaUdnQZCwqMMhRw0XI3OEGS3PWG
         mab8CjTzga1tU9FLvpvqmn+LoN6I07Y9Uu/XwZ+9obLhPRZjdFbjlvGHIp8tCHEuvZF/
         8d/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdiVljbiL8yD+9AexClzPzh6XW5pK8fMUd89Hf0ztvQ=;
        b=fmYtfSO977jtazFN63A1r1SrDRppb30FhiAL3gILOY5Ye6s3i5uPxsDAgJeNZQSjtJ
         bu1HnJ8sXRgvv8Tlwc7GZ4ICAznCWqhE7ioS7Jb/HrM186M02jMBIe9XShzLjeL6uv57
         CqT/Fw1m4OUtXCxk1EqzA4Qqgh1WkxPF5pwZjHHV9kPEhbB+CRcN/S609HpSp3mysHUv
         ot5WG2s8fh9DOzbl1Ia1RFBak9zVDaGJgBUxak+0/taJPJa36QJHe0qEU/4zH8/DDwrY
         BJY4PrBR9ktlKKO0VXcC4Gk94kmL81vY5kd5EiwtQyLi00CcneqbUdXIazt+Cv1wssgf
         ZEdQ==
X-Gm-Message-State: APjAAAUJeQ1C2HvXzsHbn7gk6dw37QibbkzcH1yHyVoWBO7AXcufpyrB
        GTzfyvo7ElARjmN/eMv0Jf4FcoV2
X-Google-Smtp-Source: APXvYqxFbpIdfeGwM/ZEawUgCkXBaJ1k1y08pfEFoxWVfnNQ+5YifkEKM6/xesujqBhCyQbEgiftyQ==
X-Received: by 2002:a17:90a:c301:: with SMTP id g1mr16195114pjt.67.1577326588015;
        Wed, 25 Dec 2019 18:16:28 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:27 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 04/12] net: ethtool: Use the PHY time stamping interface.
Date:   Wed, 25 Dec 2019 18:16:12 -0800
Message-Id: <6dbc095ff1744a2ddeecf98912faddab828affd4.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/ethtool/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index aed2c2cf1623..88f7cddf5a6f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2096,8 +2096,8 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	memset(&info, 0, sizeof(info));
 	info.cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		err = phydev->drv->ts_info(phydev, &info);
+	if (phy_has_tsinfo(phydev)) {
+		err = phy_ts_info(phydev, &info);
 	} else if (ops->get_ts_info) {
 		err = ops->get_ts_info(dev, &info);
 	} else {
-- 
2.20.1

