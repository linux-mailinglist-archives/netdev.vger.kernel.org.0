Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DC447B27B
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 19:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240313AbhLTSDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 13:03:42 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:64018 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbhLTSDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 13:03:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=CfnGqaPvWPSL9O/lgob586ROT8ZgG94Plol0GBoWOSM=;
        b=gf6JvNVbEti3SGVdH6udwWlVq1UcwUt2zKX3lZVt5LNfsYkN6ao/iftYWtRGhlfCwzdf
        8uGW3alZrtvQVng+Si9VSF2HfZpxPo9T6x8wGSbcNTJ4MNKjnXkAnHnnlRNViDNlj76fCl
        AUIxpL/zW4faAaIO4Brpq8D1bXqarZ2tRIk/wxQ1rpQPgtL6vm+Wt2XeHzguPpnKp/E1iy
        yDfS5L5p1shrI9d9Z+s+KFc11k7t38qiziyzJiecyls8dzPKbJ/VBzB06XCYerDF3FTqX2
        txYPqneo4C/pJozdBn0f5eeTLV8k/Bz0qsogNaGFufeP758Xq2wxpb+cu+XiHsGQ==
Received: by filterdrecv-656998cfdd-ptr8m with SMTP id filterdrecv-656998cfdd-ptr8m-1-61C0C57A-2
        2021-12-20 18:03:38.102772415 +0000 UTC m=+7756579.962355144
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-1 (SG)
        with ESMTP
        id SIMuKpiiSYCqzf8bQuNJMA
        Mon, 20 Dec 2021 18:03:37.872 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 4B6487003AA; Mon, 20 Dec 2021 11:03:37 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v6 0/2] wilc1000: Add reset/enable GPIO support to SPI driver
Date:   Mon, 20 Dec 2021 18:03:38 +0000 (UTC)
Message-Id: <20211220180334.3990693-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvFU2nunBDPBrWLBt7?=
 =?us-ascii?Q?d71pPVerD0pCUy3SKVD5aCpCk6GnRjDcUvaoJsk?=
 =?us-ascii?Q?iofAJrvpCOa3wbP4RC9cvmQVY+mXZVMGGVoqOhM?=
 =?us-ascii?Q?B2SBYOcuOfuA3f2CYOV9VCLzwyI4Xu35r=2FDtzPc?=
 =?us-ascii?Q?0x9zYkmWGzWvxrnhIy5v=2FISqW4NwWJhDWZqT7C?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v6:
	- Convert line comments to block comments.
v5:
	- Fix a dt_binding_check error by including
	  <dt-bindings/gpio/gpio.h> in microchip,wilc1000.yaml.
v4:
	- Simplify wilc_wlan_power() by letting gpiod_set_value()
	  handle NULL gpios.
v3:
	- Fix to include correct header file.
	- Rename wilc_set_enable() to wilc_wlan_power().
	- Use devm_gpiod_get{,_optional}() instead of of_get_named_gpio()
	- Parse GPIO pins once at probe time.
v2:
	- Split documentation update and driver changes into seprate
          patches.

David Mosberger-Tang (2):
  wilc1000: Add reset/enable GPIO support to SPI driver
  wilc1000: Document enable-gpios and reset-gpios properties

 .../net/wireless/microchip,wilc1000.yaml      | 19 ++++++
 drivers/net/wireless/microchip/wilc1000/spi.c | 62 ++++++++++++++++++-
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 3 files changed, 79 insertions(+), 4 deletions(-)

-- 
2.25.1

