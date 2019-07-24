Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB676737B5
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387701AbfGXTSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:18:46 -0400
Received: from mx.0dd.nl ([5.2.79.48]:52734 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfGXTSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 15:18:42 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 0FA3B5FD5A;
        Wed, 24 Jul 2019 21:18:38 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="qk4AZsEl";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id B55091D25CA9;
        Wed, 24 Jul 2019 21:18:37 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com B55091D25CA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563995917;
        bh=weikOzuhvuizQxHFtpYezAOwp5TBaaOl/uv7IuspKpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qk4AZsEllY3v75JVxR6ajoFWPeuoPeo2b6yXCZTaYGB8drhLwBYb6jjhjdejvvZ8i
         XX/8uhoWK57x3pVsZjs/vBQyo1Ghxy5qYRSesADZgTRsKt9i8TUbEpHjfaoy5Fgqx2
         BwLEt2NsYOUnEiXi8ZD7fiYuvop1rEDc4M/nrMD5f3EHxIv3wfla0tQqKcyUzmjZat
         pmE92U+n8xil0eXTHse1/d580opj0BS6+6P6ZIalndBhHrWbtypE9Q8qSWufBiu9Sb
         GXdZYezkOylEG7wHzkfG/FL7mGfh5WTYuAz/YcIBgj5yV0ePzP1ECBE6DUpCA5NbOw
         b6GxLdGQ+0TNA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        John Crispin <john@phrozen.org>
Subject: [PATCH net-next 0/3] net: ethernet: mediatek: convert to phylink.
Date:   Wed, 24 Jul 2019 21:17:23 +0200
Message-Id: <20190724191725.3903-1-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches converts mediatek driver to phylink api.
SGMII support is only tested with fixed speed of 2.5Gbit on a Bananapi R64.
Frank tested these patches on this Bananapi R64 (mt7622) and
Bananapi R2 (mt7623).
Tested on hardware: mt7621, mt7622 and mt7623.

René van Dorst (3):
  net: ethernet: mediatek: Add basic PHYLINK support
  net: ethernet: mediatek: Re-add support SGMII
  dt-bindings: net: ethernet: Update mt7622 docs and dts to reflect the
    new phylink API

 .../arm/mediatek/mediatek,sgmiisys.txt        |   2 -
 .../dts/mediatek/mt7622-bananapi-bpi-r64.dts  |  28 +-
 arch/arm64/boot/dts/mediatek/mt7622.dtsi      |   1 -
 drivers/net/ethernet/mediatek/Kconfig         |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c  |  72 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 486 ++++++++++++------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  67 ++-
 drivers/net/ethernet/mediatek/mtk_sgmii.c     |  65 ++-
 8 files changed, 436 insertions(+), 287 deletions(-)

To: <netdev@vger.kernel.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: Frank Wunderlich <frank-w@public-files.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-mediatek@lists.infradead.org
Cc: linux-mips@vger.kernel.org
Cc: John Crispin <john@phrozen.org>
-- 
2.20.1

