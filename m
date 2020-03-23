Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2069218F839
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgCWPHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:07:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37865 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:07:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id a32so7329724pga.4;
        Mon, 23 Mar 2020 08:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MWMlIjTk5KuF2+RRlAxJbPgNkWmTokiEC+TY2tIstt0=;
        b=NXGL0uflfR0jVYuRAQ5XJCitGJMb+V0WVZjersIHsn+ApsXjvPBWnxWMNCNB2ZhZTG
         o/gHoAeTR8qWZrl6sW7xeDtbOzvpA7r1dnTC4PIdqazilVlLrdW1JwG6okiFNi3/RGjj
         cRVjZNBsGbFWidbM0egcyhWyYXdaNrEArLTZcxrq4j/cnh6mKqzKEXoLhruLk4AyOPyZ
         qkSE0veQOWdN6Lvj/9ak4fdK8hXKGwU8vcK0YFS0dAVECJfZMAh/1VfMK/npi1gniB4g
         h159ZPnwGec/Ms7g9ZiJbejHeO7H0AgJKKWgSzrnZo2To1PcOKq7joIdVh4P5Cn4BkV2
         z8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MWMlIjTk5KuF2+RRlAxJbPgNkWmTokiEC+TY2tIstt0=;
        b=KZbgTsnt++GKuaqudEOY39J2Wkr8tlQkwUu4IsbSpq9Qpsl8T6E0MVtfCml9Y+2Wea
         KW8PHPpicul7L7AE13UOo25vHiLbucPieakwZMaL2V9WcZ1W6GvhIp3QBXXzJczYHWvi
         HpgSwlJH2BvzX5YUSiIjHkwBtDcJPFmcD+wT8JwtJh+LRx0cieTwT+L6EoFlYwgM6UI5
         vCEL63YLRQ4Uh7GUg54GTJT4BNNLVx+SWP/unEB+RJnfIj4mfhSzq1PbVDfbDUOtH+hl
         wMz1gRXu1fc0mwTLrw1HfLqVmM8LUzi8Vf9mv1iLsk8GQ96nlvu+WOVgEUTfeyI+A84j
         +mKQ==
X-Gm-Message-State: ANhLgQ2PRx4TZKPoR5btHoBIbZSFkZVLlcfDTTgPvIquG4ZoCkbUH9VS
        QhxMs1PB9EtBfTNqGVgLuKA=
X-Google-Smtp-Source: ADFU+vvGmOZEtQRejUIuZGRogY9F9FvUT0yyRDJ10ryQf0Fvxkx9yOJqwWZtFfmjkulMY4PjZzhGmQ==
X-Received: by 2002:aa7:9ec7:: with SMTP id r7mr10541482pfq.191.1584976033203;
        Mon, 23 Mar 2020 08:07:13 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id g11sm13457935pfm.4.2020.03.23.08.07.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:07:12 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 08/10] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 23:05:58 +0800
Message-Id: <20200323150600.21382-9-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify the code in phy_poll_reset() function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v6 -> v7:
	- adapt to a newly added parameter sleep_before_read.
v5 -> v6:
	- add some check for keep the code more similar.
v4 -> v5:
	- it can add msleep before call phy_read_poll_timeout()
	  to keep the code more similar. so add it.
v3 -> v4:
	- drop it.
v2 -> v3:
	- adapt to it after modifying the parameter order of the
	  newly added function
v1 -> v2:
	- remove the handle of phy_read()'s return error.

 drivers/net/phy/phy_device.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..3b8f6b0b47b5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,18 +1059,12 @@ EXPORT_SYMBOL(phy_disconnect);
 static int phy_poll_reset(struct phy_device *phydev)
 {
 	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
-	unsigned int retries = 12;
-	int ret;
-
-	do {
-		msleep(50);
-		ret = phy_read(phydev, MII_BMCR);
-		if (ret < 0)
-			return ret;
-	} while (ret & BMCR_RESET && --retries);
-	if (ret & BMCR_RESET)
-		return -ETIMEDOUT;
+	int ret, val;
 
+	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
+				    50000, 600000, true);
+	if (ret)
+		return ret;
 	/* Some chips (smsc911x) may still need up to another 1ms after the
 	 * BMCR_RESET bit is cleared before they are usable.
 	 */
-- 
2.25.0

