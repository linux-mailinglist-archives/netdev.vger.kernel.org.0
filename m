Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFAA38B8DE
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhETVS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 17:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhETVS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 17:18:26 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBDBC061574;
        Thu, 20 May 2021 14:17:04 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k14so23982129eji.2;
        Thu, 20 May 2021 14:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1hn6+pud/VwdmBZ5hvHt7UVqtcVYsS0pOmed7474aI=;
        b=h1niVe0GHP5qCgymZCGrDQ87b9Hk6RpBM3TJneUXLyAp9wx5lYGgEoh6+3awlKcx4E
         YCejFNRZLxv5Ast8GBiFPR0o0kWsZlEzGsGt20hLZRnrRHbarU612s5EAEAgUncAYdzU
         i/Zjc1fw8+nDNj4fKdq97K6UlCrn6KA5VS18rP3rG7B26qdPdc9h0wEMmkYva8ytOsx8
         8hASi2bzjExeBBuR89a1adDY+vseWyO+99me641ch+5IyrKOn4iLo6TZ/yS+/M5fqswq
         9oKYJvxs57j7GRWpjUOLoaO4lX5dSknpnQlXhs4+/8mYcPxJrBth7myQs3k9u1giPRoL
         FRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P1hn6+pud/VwdmBZ5hvHt7UVqtcVYsS0pOmed7474aI=;
        b=P8cpfTHyjSgHN163tvhpbN/j5qgTQScKNXzSUhn/WsG/K0HM1NCWtIDRmQ/NGw4/wI
         gkSM1GJUINXjKbLYS/3l6ws0iiG95sKB/Z1v5IR8+PLEFyDZiDxp7fpx8MrWEoGTy0Nl
         rmmlTBGEtHaugTCaKax4bsHBUKRuPp4Z1d/ac+U69Kj6azrsS/WPqRHfPXfnDVUmnRLs
         GTnMcxHpBrSFGxn4HYgLEaY1YhilA2aVwgIy3pwtWQBsidWO0gFYkATDNx0eB7WyWazn
         8uo7p8VyFZkL91PnKwNZqVn9EgABwaoJUZTFJy+AQ2fOyMgxrP+/2thOCW39ANesslsv
         fKcQ==
X-Gm-Message-State: AOAM532xcQnLq25P/hWPfElK4+58HWSsDr3+Rg4VKvITq4rkweCHFUR/
        zTi3EK2HUf97OmeH504homg=
X-Google-Smtp-Source: ABdhPJz1Gi5WscCanz1btdOQT2cQrGNQ1RckUXBcgZyVu/rdgVUZaB4gT5CNgPsFpPnrpwtV3I8Kdw==
X-Received: by 2002:a17:906:1e44:: with SMTP id i4mr6476561ejj.61.1621545423104;
        Thu, 20 May 2021 14:17:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w10sm2084212ejq.48.2021.05.20.14.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 14:17:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 0/2] Adapt the sja1105 DSA driver to the SPI controller's transfer limits
Date:   Fri, 21 May 2021 00:16:55 +0300
Message-Id: <20210520211657.3451036-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series changes the SPI transfer procedure in sja1105 to take into
consideration the buffer size limitations that the SPI controller driver
might have.

Changes in v3:
- Avoid a signed vs unsigned issue in the interpretation of SIZE_MAX.
- Move the max transfer length checks to probe time, since nothing will
  change dynamically.

Changes in v2:
Remove the driver's use of cs_change and send multiple, smaller SPI
messages instead of a single large one.

Vladimir Oltean (2):
  net: dsa: sja1105: send multiple spi_messages instead of using
    cs_change
  net: dsa: sja1105: adapt to a SPI controller with a limited max
    transfer size

 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 28 ++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         | 66 +++++--------------
 .../net/dsa/sja1105/sja1105_static_config.h   |  2 +
 4 files changed, 49 insertions(+), 48 deletions(-)

-- 
2.25.1

