Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5927D18CF0A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgCTNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:35:11 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37600 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgCTNfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:35:10 -0400
Received: by mail-pj1-f67.google.com with SMTP id ca13so2470433pjb.2;
        Fri, 20 Mar 2020 06:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MYgs/zkr6hc7o1ozUKVcYW4sWfXlOXbWmqtVG3HO+jw=;
        b=Zzb3Tlo1M7+SG+C768Whj1+P8aInEwGWMvUEdJV6m+xJC48pQZVusL6kj8Fo8pkSZ8
         9nmVwdFTYo7CBUJGzVUUhsQP3BsJ76iZ0avpaV/cbRqQmVyTMsrmYIMIsl0mMchGS4XB
         GbkA+5RwOgjZCdmqDrGXKaV/J6kbBabEo0bbftCmtjki25hdEvVybxQ2wQTQm1ECsz/K
         AywYmJ4c9ZC0I1dWn9jxqxtKwOvC+9JPWEjtfX4fiR7CRiC+vYBwEF/r/zNxM+cRWHq8
         pHNa2SpZFWyFPkDfs/Kppv5uacBw2f0u51SeWwxdaVSn6pZzdeE/fU11dnxBS7fJYvpO
         GNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MYgs/zkr6hc7o1ozUKVcYW4sWfXlOXbWmqtVG3HO+jw=;
        b=ZsqeReb+lSRH6IQYbkaal1QxDD1SunCwXIa89UXjjXkhkaNKyzIRrZKfPLMDG1bFZw
         s/g5HJglW6gMxq1SSqzMG7cs66w7zaKsj0FJ65Q0RhTCjsdatbprO/vxTZEqUTM4SmO2
         LqjWQAxXr7l11qtapMTwKWJf85zMFt+kvnbvHXSvAL7p8+M0P7jBNIEsBztKAMrM2ggJ
         ffaMB6hZ0zj3zZO6cgWvRwpLi4gXtKVr6w6uuC9HSBbVFdQ8GkYorQhgHrm/ogQPGwM+
         Oi02owRJwqddDfKSr2Olfna2nEv0gHPDoZMYxB4lsk+ixrOxuj4DlRIogEwvA8TYYglu
         9t9g==
X-Gm-Message-State: ANhLgQ1uocOb3hRmVVBOy9EuzMRT+6FuLIkKt7YW5ypMB8qRzbvvW78S
        s7t1WB4zi2fJZfBqPd/Lspg=
X-Google-Smtp-Source: ADFU+vvB3HdUq5aTm5FSckVkFEvQ/V41S5Axr/NDgBis6ch6qkBSRP77+8q0ZGDnIKJBiLIrtj6j0A==
X-Received: by 2002:a17:90a:9f96:: with SMTP id o22mr9280844pjp.88.1584711308880;
        Fri, 20 Mar 2020 06:35:08 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id 11sm5582857pfv.43.2020.03.20.06.35.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:35:08 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 6/7] net: phy: introduce phy_read_poll_timeout macro
Date:   Fri, 20 Mar 2020 21:34:30 +0800
Message-Id: <20200320133431.9354-7-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
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
v1 -> v2:
	- pass a phydev and a regnum to replace args... parameter in
	  the phy_read_poll_timeout(), and also handle the
	  phy_read() function's return error.
 
 include/linux/phy.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index bb351f8b8769..ecee7e436f89 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -714,6 +714,19 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, regnum);
 }
 
+#define phy_read_poll_timeout(val, cond, sleep_us, timeout_us, phydev, regnum) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read, val, cond || val < 0, sleep_us, \
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

