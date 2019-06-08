Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7673A09D
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 18:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbfFHQNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 12:13:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39801 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfFHQNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 12:13:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so2387624wrt.6
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 09:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x1w0y3c6X/HkF/zMDiEAq4/Vnu5siSptAlSysuVXN5M=;
        b=RTuHESL6rodYod3guWpgJX6rVKomYkDXMEOaOBOXjv7cttctmb7ufpbFMC5u5RXYat
         dsTF8pSaAvOPsy5uTO46b6Pn1OlN+wLmU9YEegb49zDCe0JF5ViHvvN6m+tuvJxNnJSg
         SY54VKqdhwtQu/VhZVnG01c175cHOkpKPV2qtUYElOPxi0/bd1d4If+J3JJhRhccb2dI
         O9XGdx/0Co6xV+9vedAyWqnnl2cQR6WxM6sumYn9PXB123e86rW1cX5zkGqiBNq9IalM
         JpgZMFLV88ev2QiNee53G9Z4fBpYdC72whLneDTa4Q0OFWDmtUuTuQ8rdNkauF+2EZCQ
         D/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x1w0y3c6X/HkF/zMDiEAq4/Vnu5siSptAlSysuVXN5M=;
        b=JkxCOGNnnkCuKnXeWf2DGPlLJeWKIz/k0UxgY5J++Dohz3o0iaj+afV2gW4DOLR8SN
         7eKIxSUo91jlpeIuE9HcqHwjUDduxJHM2mbPFlfQhj2YlgSgZn7S/3vTVGiZsz8OyYmc
         woeiLxq4OZiqMdCMzQaUuoCRX9CijH+6XIt0ZzWqStiJj+dFQp/V2BzJVXPfSi4S7L9V
         eOLUpCazMaZ3LW911/GjJAxbWs7zPmjbby2eH6hxan3E/tgimYaP7jQ7NosEdEBxT+nL
         v8H55ZeXIVOUvPv6+VnnIGdHu6xyyxuhPJ21Vl/hZI5U05cs4ppJC+9BNfXTH5AK56ep
         9pvw==
X-Gm-Message-State: APjAAAX+mOh0sNUNWUoyJ/A/jo4OmBdBJSRoaX5Ss5dJhTv856VY2km2
        7m7DaFDs6XzzSR7xAE33Mw4=
X-Google-Smtp-Source: APXvYqxmgggnLa4d/JbbO1Zy/N+KQoRAznbMJFIjTPtcNBWaM1xZYU121nAh1bVOqjUHyRBMdmxmnQ==
X-Received: by 2002:a5d:4e83:: with SMTP id e3mr4535423wru.263.1560010383475;
        Sat, 08 Jun 2019 09:13:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id l18sm3934221wrv.38.2019.06.08.09.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 09:13:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] RGMII delays for SJA1105 DSA driver
Date:   Sat,  8 Jun 2019 19:12:26 +0300
Message-Id: <20190608161228.5730-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset configures the Tunable Delay Lines of the SJA1105 P/Q/R/S
switches. These add a programmable phase offset on the RGMII RX and TX
clock signals and get used by the driver for fixed-link interfaces that
use the rgmii-id, rgmii-txid or rgmii-rxid phy-modes.

Tested on a board where RGMII delays were already set up, by adding
MAC-side delays on the RGMII interface towards a BCM5464R PHY and
noticing that the MAC now reports SFD, preamble, FCS etc. errors.

Conflicts trivially in drivers/net/dsa/sja1105/sja1105_spi.c with
https://patchwork.ozlabs.org/project/netdev/list/?series=112614&state=*
which must be applied first.

Vladimir Oltean (2):
  net: dsa: sja1105: Remove duplicate rgmii_pad_mii_tx from regs
  net: dsa: sja1105: Add RGMII delay support for P/Q/R/S chips

 drivers/net/dsa/sja1105/sja1105.h          |   3 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c | 100 ++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c      |  11 ++-
 3 files changed, 106 insertions(+), 8 deletions(-)

-- 
2.17.1

