Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C7718BCC0
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgCSQjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:39:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45685 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgCSQjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:39:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id b9so1274276pls.12;
        Thu, 19 Mar 2020 09:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQSZFWsT0x8YRkK7xZI/l3VNEnEYgWpCuVJYN8ynJQg=;
        b=WraUcIMl/Tj/q24ZqSIkaLd978dmLRa0VZQhmCAuu6t1Rlhiv9XR7C1RD6RzTwopX4
         yjOBx8n6cUu+Of8t2+x81eGjo52VhkMxP0JvlsN9+Knu0WZs9Um8jp6fgkUlR0jPcx0e
         dN4gWFqP6w05PXLQZCUTyQhtZw21yk/0rFMChXmtnZEyjTHpS2eGlL2R7TjvOK2sUKKj
         UpX4USpl4xK0gk0GAg+zBP9M60khEn85LBjynRWVk+x3Uu4WF9cmBhj7NYygSrNhX1Ei
         +lFmCsIx0jWtZC7RKgxQfC8UiSGhkNjxjOLEhrDSJWgoaZc4TMw2s4sItEF1ecknqn+t
         uJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iQSZFWsT0x8YRkK7xZI/l3VNEnEYgWpCuVJYN8ynJQg=;
        b=bpRng2XWE08pfQ6FdfQ0/ft2VH+UwQAd+je9Ry643bOKCU9LuL0kIa/unbyJeinjH+
         Wz3wG7fSDrh+u7kwj98BG3Fo3Jpb4T456h0WlqdKjxXNLouC+8wWtd/Mh4Pl7+0BnXTo
         yTFpsF9/CnXxCjqU/tOR0aWBhupU0cDDmVNNKwtpwEbn5zqRafXdcyvpcL7u7j15+xlR
         wTZCrtuwjcYyVOt/dCeg73kBVXOOim7gjyBOx5s9++59y34efMAlMZEAzVFQOgYMQ9xa
         gx/pfaz9zL5uoPeN04SC3X3hkJCcPfp/52Rv2ZY1jeooR7/B9Go36nbaKFVIx1jq/Yos
         7AFQ==
X-Gm-Message-State: ANhLgQ3Pc9r/Bbt/PzlJflXQIF1JwQ4WE2oJ/NIGszhUo832vMRLjuFp
        TZlQZKCG1BmycT9k/sARuiY=
X-Google-Smtp-Source: ADFU+vsXo2IIz0XsdUw47bb4DYW+n10YDzHmMx4YFDZTpB1KVGHlHsNM81ZsZqv+qeIavQcPKs3HGA==
X-Received: by 2002:a17:90b:1889:: with SMTP id mn9mr4584210pjb.85.1584635963198;
        Thu, 19 Mar 2020 09:39:23 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id e26sm2971500pfj.61.2020.03.19.09.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:39:22 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 0/7] introduce read_poll_timeout
Date:   Fri, 20 Mar 2020 00:39:03 +0800
Message-Id: <20200319163910.14733-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets is introduce read_poll_timeout macro, it is an extension
of readx_poll_timeout macro. the accessor function op just supports only
one parameter in the readx_poll_timeout macro, but this macro can
supports multiple variable parameters for it. so functions like
phy_read(struct phy_device *phydev, u32 regnum) and
phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
use this poll timeout framework.

the first patch introduce read_poll_timeout macro, and the second patch
redefined readx_poll_timeout macro by read_poll_timeout(), and the other
patches are examples using read_poll_timeout macro.


Dejin Zheng (7):
  iopoll: introduce read_poll_timeout macro
  iopoll: redefined readx_poll_timeout macro to simplify the code
  net: phy: introduce phy_read_mmd_poll_timeout macro
  net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: introduce phy_read_poll_timeout macro
  net: phy: use phy_read_poll_timeout() to simplify the code

 drivers/net/phy/aquantia_main.c | 16 +++++++--------
 drivers/net/phy/bcm84881.c      | 24 ++++++----------------
 drivers/net/phy/phy_device.c    | 18 ++++++-----------
 include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
 include/linux/phy.h             |  7 +++++++
 5 files changed, 55 insertions(+), 46 deletions(-)

-- 
2.25.0

