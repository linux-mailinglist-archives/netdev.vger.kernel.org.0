Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1149A38B7FF
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbhETUED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbhETUEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:04:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2779BC061574;
        Thu, 20 May 2021 13:02:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lg14so27155806ejb.9;
        Thu, 20 May 2021 13:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piApn4hueZMiHkK7L5NTTYDLJqVrmyE+9skDaAkLOww=;
        b=Lor68eBWMLZ4VX2/MTf/Nu0a1XrjNwI0lhXArFDkmNwK6GUAvO/d9w2IZJrLiqb9Ue
         BJriTeuwZYXG0E7az1j501OngiWtVMnxBoKCeSqXS4JbzNTVtiGaeQsmGMduApYk2w4R
         b4mJiHM5XO+65LWKq5JsidqSmLUYX7hAHl2BQqWwR1AkdujHAgsWxDjQgDilr/pRFJel
         1hrkUZ8P4aA4l0ye1r8JcYsSPqu1KMgI61ScaVVg4Gf1KUK9B5J8FW7ZKD+w2e2f6Ayc
         X2nsz8BVHEwkdKJta0OWYXaY73IfOZCJC2Kh5uNncJkCWPCylqPu8xKIvBGeAOquhNP1
         c+lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piApn4hueZMiHkK7L5NTTYDLJqVrmyE+9skDaAkLOww=;
        b=gJV+3MSAZ/w9HG+rMNp6JrzFRsyCO/wEiaTsDb3Ws8lXI4ahSyTbLJuOcP66Qrg/MG
         /bzwgXH5B5XSfe19MqjJhCI2HCSlVnlxF2AePodd+fRk0Q0rTKnxHF3SPK22FPgJ60pw
         PFTGDHQJvJ30nDpPXM+H1yGUIrDCMxoLF4HQ3O7JBXv3vGHD62iKtW8sGxKNZ43sDj+s
         As3v+pL7i/5tWd49A8X9CnlrFQhHR6CIJPtE4J2dZn5MVmhNTaNaWizVPJ5hEzvfl3jD
         qB/W1vJ7OOU3YJQp36TwJtkXprBAHrLNcOgykJyojYv7cc39xqaH2ufhSW/yb32v5EQi
         T1IQ==
X-Gm-Message-State: AOAM532vHLuPFYEGxAfrrl6rg7+gGMwG8+NeiUjErW4cYraO5tFJXb/B
        wuOHVM1Jo3CF4Mt5BstIFoM=
X-Google-Smtp-Source: ABdhPJzeEUxkPlXRveR9Z/OwCFGBnLKqkwTfmkYvxOIVXIwG5n6aFWCQJHKZe8TStnfDA8c0pIJ4/Q==
X-Received: by 2002:a17:906:5d0a:: with SMTP id g10mr6239711ejt.349.1621540958717;
        Thu, 20 May 2021 13:02:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id y10sm1974288ejh.105.2021.05.20.13.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:02:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/2] Adapt the sja1105 DSA driver to the SPI controller's transfer limits
Date:   Thu, 20 May 2021 23:02:21 +0300
Message-Id: <20210520200223.3375421-1-olteanv@gmail.com>
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

Changes in v2:
Remove the driver's use of cs_change and send multiple, smaller SPI
messages instead of a single large one.

Vladimir Oltean (2):
  net: dsa: sja1105: send multiple spi_messages instead of using
    cs_change
  net: dsa: sja1105: adapt to a SPI controller with a limited max
    transfer size

 drivers/net/dsa/sja1105/sja1105_spi.c | 80 ++++++++++++---------------
 1 file changed, 34 insertions(+), 46 deletions(-)

-- 
2.25.1

