Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D7D474825
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 17:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhLNQdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 11:33:23 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:24030 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbhLNQdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 11:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=IJV8PusPqPkrxAZlSJxF+oVTe0HORUxFLp6tQeLt1s8=;
        b=s3fyn9KBdTIQRjnoU6oHuN9EHJOZPk7jwxK3m/1iORFiNy1YlpqSrjkNOnvG0hfb/R/v
        OPggmibOMhMCxcVpVj3mOB3oC1UXFQDCLUqpIfEZmtzZ6Mej/56+JTeSHcDVOKt83LVbM6
        6CselkLxP4eutSaFa8+OZV6cG+lTnC2uXnFTc3mfWcLJ/CjuYLE9Bh+lMlQc9VsWu0P/7T
        6nGC3GhI1m1Yoq8x/5mYO7Z0xZDOj9aS8FyxDKjJwxUVwApocYak53IzX++eo0y7zFPbOD
        IHnAkcp0nTt9Txtvs/eaYO26D65NVDDMS3+ZqpxYC+bwNke3k55L3PTIJBouYfvA==
Received: by filterdrecv-64fcb979b9-2mw87 with SMTP id filterdrecv-64fcb979b9-2mw87-1-61B8C750-7D
        2021-12-14 16:33:20.485721837 +0000 UTC m=+7922123.955850576
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-1 (SG)
        with ESMTP
        id fPpvnHkiQ_awP5-wiFek1g
        Tue, 14 Dec 2021 16:33:20.203 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 6CF8E700269; Tue, 14 Dec 2021 09:33:19 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v4 0/2] Add reset/enable GPIO support to SPI driver
Date:   Tue, 14 Dec 2021 16:33:20 +0000 (UTC)
Message-Id: <20211214163315.3769677-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBoQ+OES1vxgY33Go?=
 =?us-ascii?Q?OnFY7WpVM1MtolvW065rR7eEZ+HpazFWrCv8kL2?=
 =?us-ascii?Q?2H0L5MCjp=2FpTmAxLGBlfG=2F2YY0CGd1ZrRE=2FR2vM?=
 =?us-ascii?Q?FL+9s1bL84pWlE2jb89owFk3R=2FgyEQdaRv=2FbHGq?=
 =?us-ascii?Q?nE5RrWT9+mmP19q2MwhmXC1g8+Tulinvrv731Gq?=
 =?us-ascii?Q?nLvS2G3Ob+kukT4tzmOVA=3D=3D?=
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

I made a mistake last night when checking whether gpiod_set_value() is
safe to call with a NULL gpiod descriptor (it is).  v4 of the patch
just fixes that mistake.  It does simplify the code nicely.

This version also fixes the error handling when the reset gpio is
missing.

David Mosberger-Tang (2):
  wilc1000: Add reset/enable GPIO support to SPI driver
  wilc1000: Document enable-gpios and reset-gpios properties

 .../net/wireless/microchip,wilc1000.yaml      | 17 ++++++
 drivers/net/wireless/microchip/wilc1000/spi.c | 58 ++++++++++++++++++-
 .../net/wireless/microchip/wilc1000/wlan.c    |  2 +-
 3 files changed, 73 insertions(+), 4 deletions(-)

-- 
2.25.1

