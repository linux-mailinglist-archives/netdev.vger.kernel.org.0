Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46738A936
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfHLVVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:21:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35523 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfHLVVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:21:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so19999851wrq.2
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cJJV0FH7m9OIW7AuVAn2lW7AzIHc+YQte9YSVygxTuE=;
        b=uT64xuvp02OCUwiqJd9/8G1OVl4sH94VvBxVTNF3aqaok/Jr0j7+YGZ+1AAhvCUaTV
         lHDVHFL3dzQzmQl26J3GOxREcyGRTheg9femG9nGu3oPIkCyO1hwyXZw3AmD8Zg0lx/T
         rgni2lWwMtkiDpPo69f77+hPFuLPoFnkoPxB4rXWRD/MtHVqJCSat/bOBMgzR3EkwBuj
         U3cMmZ7hNQ7JMuzqDdHHNQoQykwu1QJeb0CkEU7Bfa/26Ri1ll+1lZsRUYdLm/dfZVDS
         vuEoBgHoFkxpDtJNHlToMy6ZQkRqldxHT8E8VKM8aFtLPsHqchi9xGlfKIddLZtNsiZ0
         7IBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJJV0FH7m9OIW7AuVAn2lW7AzIHc+YQte9YSVygxTuE=;
        b=aIv9NqQmRdmwJVVoPqjiD2eW+dCRW4hLF71DMI6LUxvxtI9wypFymsaXIrsvTkHUqi
         6C5QftFvhJ6++3pTM/ga0xBYjb++fQe+kTNwBL9qlxDm75tGrOfdhS75HlbK52X+DNHE
         HNIRs1U1a4hTSTTzW4GzNoCK3ZJnS0NvUjO8VfJT7XG2l9vdmghLj4BQdVEEd0wV2hIf
         s4NxFYP3Q2ncrBBs+1gYA/vawBRf+6bWEwe8ihGls9Y68kd/03/i9Ith5Tpd3542DmVs
         REb1HKMe9C6ZO0cI181jXXd/vvk2fjGOPuJ7YiI5ccYIzNfywXg/EE5+GziE//i0sROI
         1S9A==
X-Gm-Message-State: APjAAAUxs4sLByt2oC+CoKpbw58GoA62wFbZd68qxFD6/kPSswejTG66
        95Lwf1ZM7G+bLqkNoXB2Iu3XqS9J
X-Google-Smtp-Source: APXvYqy8Mi9BTh8ScD9FaAYh1SRd6NVyPktG+z6y6O/YfsfEEc4cse8URu2aw3WBtjsRJ+eQ01w+ew==
X-Received: by 2002:adf:c7c7:: with SMTP id y7mr42012591wrg.44.1565644865387;
        Mon, 12 Aug 2019 14:21:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id h12sm11820352wrq.73.2019.08.12.14.21.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:21:04 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: phy: add __phy_speed_down and
 phy_resolve_min_speed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Message-ID: <e499c226-7141-d5be-990c-b46b7dd048f8@gmail.com>
Date:   Mon, 12 Aug 2019 23:20:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__phy_speed_down provides most of the functionality for phy_speed_down.
It makes use of new helper phy_resolve_min_speed that is based on the
sorting of the settings[] array.
In certain cases it may be helpful to be able to exclude legacy half
duplex modes, therefore prepare phy_resolve_min_speed() for it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 29 +++++++++++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index de085f255..d7331875e 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -316,6 +316,35 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
 
+static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
+	int i = ARRAY_SIZE(settings);
+
+	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
+
+	while (i--) {
+		if (test_bit(settings[i].bit, common)) {
+			if (fdx_only && settings[i].duplex != DUPLEX_FULL)
+				continue;
+			return settings[i].speed;
+		}
+	}
+
+	return SPEED_UNKNOWN;
+}
+
+int __phy_speed_down(struct phy_device *phydev)
+{
+	int min_common_speed = phy_resolve_min_speed(phydev, true);
+
+	if (min_common_speed == SPEED_UNKNOWN)
+		return -EINVAL;
+
+	return __set_linkmode_max_speed(phydev, min_common_speed,
+					phydev->advertising);
+}
+
 static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
 			     u16 regnum)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 781f4810c..4be6d3b47 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -665,6 +665,7 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
 		  unsigned long *mask);
 void of_set_phy_supported(struct phy_device *phydev);
 void of_set_phy_eee_broken(struct phy_device *phydev);
+int __phy_speed_down(struct phy_device *phydev);
 
 /**
  * phy_is_started - Convenience function to check whether PHY is started
-- 
2.22.0


