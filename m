Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13A5018E737
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgCVG4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:34 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35047 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgCVG4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:32 -0400
Received: by mail-pj1-f65.google.com with SMTP id g9so406157pjp.0;
        Sat, 21 Mar 2020 23:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WQSKzafM7XFxtd981Wvw9C+IRYOwS/r46Gbh5bxGTy4=;
        b=tEQPCNpb1lkCcr9Y/XcWR5g64jLNTWyDy/H3GhER6fx1AY7JRabIKemHRgv9Si/5p0
         F+cL+4+3wV/D6xoLlKgGhs9DUV5cpn7g9lzulHLBhyob5Egn6ManbTpbtdCEsKntpuTF
         kZUXNXkPyB+zlu83L97lGt5Iq0JWxuGn6kkkaw9RCeV640V1B73npss4SgqEff7fvqUQ
         VaWcakYaeA+4YwIciX/RxczVuvvCVHF3xDPJ0bJNp3ZiiJ5zmwr4zWNybvkCb7sac4mj
         FdfVzgjPVlFzTjY5maiq2lmYxR1ngM9GtT4ivJk9OklCmVqD9sabArbDKu9xQAGc9Qpx
         wuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WQSKzafM7XFxtd981Wvw9C+IRYOwS/r46Gbh5bxGTy4=;
        b=h5aolZ2cZkJMgmbweY37oPxZAnez6dV6/0+cRnQh+rRE6aBdW7IdvwQRcKl41fmH/L
         OEx7dxyxnMYssUSH9Wn70nHwgJCfV2GNGLWQxmwVsj6KlxKy29iy+Tbk27dxS2VMw/kv
         EObZUdZHpOdFxQ3bqRSILCC4r/qV0iuTtqm1vJgRcqCRYViUnDO4IONOpRsNBG37a6ai
         qRu/bjp3YuKiMbjbSIMMRVKQdTFKQrjInMGs6caoaPPDaccD7wFH+bkobC7JEtSU8RFR
         nlDcYllA8bCgUvGVvW9ucmqnyknx9x+wRKhiGfFMMo7aSWOr72iwnBuVjJUKaV3CtQ6o
         BoHA==
X-Gm-Message-State: ANhLgQ0txOHT796SUO1FmWNqFEnEjg08gqwbVVatZNRhjCClvIRF/FzC
        5kc/8K9SPRZ5riIKZp/RIWE=
X-Google-Smtp-Source: ADFU+vsBiVU9jZYyVkYCP5Qui8BNsCPj7yjYFniAwCVmJux3OlYSGrQ8nsWEWOPHyGNHRmPl9VTRFA==
X-Received: by 2002:a17:902:562:: with SMTP id 89mr16777632plf.58.1584860191049;
        Sat, 21 Mar 2020 23:56:31 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id y30sm10271391pff.67.2020.03.21.23.56.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:30 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 7/9] net: phy: introduce phy_read_poll_timeout macro
Date:   Sun, 22 Mar 2020 14:55:53 +0800
Message-Id: <20200322065555.17742-8-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is sometimes necessary to poll a phy register by phy_read()
function until its value satisfies some condition. introduce
phy_read_poll_timeout() macros that do this.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v3 -> v4:
	- deal with precedence issues for parameter cond.
v2 -> v3:
	- modify the parameter order of newly added functions.
	  phy_read_poll_timeout(val, cond, sleep_us, timeout_us, \
				phydev, regnum)
				||
				\/
	  phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
				timeout_us)
v1 -> v2:
	- pass a phydev and a regnum to replace args... parameter in
	  the phy_read_poll_timeout(), and also handle the
	  phy_read() function's return error.
 
 include/linux/phy.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 42a5ec9288d5..f2e0aea13a2f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -714,6 +714,19 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, regnum);
 }
 
+#define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, timeout_us) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read, val, (cond) || val < 0, sleep_us, \
+				timeout_us, phydev, regnum); \
+	if (val <  0) \
+		ret = val; \
+	if (ret) \
+		phydev_err(phydev, "%s failed: %d\n", __func__, ret); \
+	ret; \
+})
+
+
 /**
  * __phy_read - convenience function for reading a given PHY register
  * @phydev: the phy_device struct
-- 
2.25.0

