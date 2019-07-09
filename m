Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC5363654
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfGINBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:01:22 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.135]:27224 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfGINBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562677276;
        s=strato-dkim-0002; d=jm0.eu;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=w7rYWP+OFlZFGWyRaeeNwYOZ0sxViOUMz3huSYU92RA=;
        b=JlGYuxluwtZEfWX0KXeavq+XZorC2tWFNOw2QTwWpnfAEOZTQCFOf0mI6Sn6U4civb
        XpNTeP14Lg/8H/API+pCsBwSh2oR5KHMA6Znj+fcBJmMniqWqAzKgYMeGvRsMLaZDNlq
        6OsNFF28JFDYkquxb1uvSdh0Jquu0LWQ90zCNVeCLPPj2flccQb8DBZYZxuWmH436ao5
        jz11JlMr9bSnl2IKK06785RZ4VfrqG+Ac0ZmPt1rm6Ug35gY1L6L87PeDHvNzP34+RrK
        +t9I6BpHfxUu8DuuXqDMxMndlQEYNZnUFv6FdMO6/FrW1hiTtl89rX+kYkrPiNdhxrED
        7QbA==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v69D1GEg6
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 9 Jul 2019 15:01:16 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua.mayer@jm0.eu>
Subject: [PATCH v2 0/4] Fix hang of Armada 8040 SoC in orion-mdio
Date:   Tue,  9 Jul 2019 15:00:57 +0200
Message-Id: <20190709130101.5160-1-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190706151900.14355-1-josua@solid-run.com>
References: <20190706151900.14355-1-josua@solid-run.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua.mayer@jm0.eu>

With a modular kernel as configured by Debian a hang was observed with
the Armada 8040 SoC in the Clearfog GT and Macchiatobin boards.

The 8040 SoC actually requires four clocks to be enabled for the mdio
interface to function. All 4 clocks are already specified in
armada-cp110.dtsi. It has however been missed that the orion-mdio driver
only supports enabling up to three clocks.

This patch-set allows the orion-mdio driver to handle four clocks and
adds a warning when more clocks are specified to prevent this particular
oversight in the future.

Changes since v1:
- fixed condition for priting the warning (Andrew Lunn)
- rephrased commit description for deferred probing (Andrew Lunn)
- fixed compiler warnings (kbuild test robot)

Josua Mayer (4):
  dt-bindings: allow up to four clocks for orion-mdio
  net: mvmdio: allow up to four clocks to be specified for orion-mdio
  net: mvmdio: print warning when orion-mdio has too many clocks
  net: mvmdio: defer probe of orion-mdio if a clock is not ready

 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt |  2 +-
 drivers/net/ethernet/marvell/mvmdio.c                        | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.16.4

