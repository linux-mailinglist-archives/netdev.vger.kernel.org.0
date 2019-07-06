Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B3611DE
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfGFPbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:31:09 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([85.215.255.131]:28984 "EHLO
        mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfGFPbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 11:31:09 -0400
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Jul 2019 11:31:09 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1562427068;
        s=strato-dkim-0002; d=jm0.eu;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=6IxTDqC+QHelMHB1CGki1VGMkwd9+YyaJlHxjWYobWs=;
        b=LTYAx2e2aUF5p4PSqJGwybqhXhJFks6GyFTcWL7cjSDvfYnyFE2uaz2Coz0b6rLVob
        mt4FOPArBiZ577mJzUIgxbq9cQQtCxvcHx1npq2XHW0lQWBf4V390+MNshZVB0vEdlf5
        yEd1Ncn/SYK2AMhGShUex+5K1+WrFH1ydegJHmHb9HiCKPbIT9o5tptHzqQRvNu7pbhg
        WtYkE8blxuYwkN/daeVNtmVd0fajP2v9fZVPV4vgAEW318r48/Fc5ENDBgLCVrGR4OJr
        AXcedGsUnwzbLIpUtDslfOhC8xe+HILMtveJcd0cIA1DoMztsKqN0eORsJsP7CCly1qF
        4DMQ==
X-RZG-AUTH: ":JmMXYEHmdv4HaV2cbPh7iS0wbr/uKIfGM0EPWe8EZQbw/dDJ/fVPBaXaSiaF5/mu26zWKwNU"
X-RZG-CLASS-ID: mo05
Received: from linux-1tvp.lan
        by smtp.strato.de (RZmta 44.24 DYNA|AUTH)
        with ESMTPSA id h0a328v66FJ76MU
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 6 Jul 2019 17:19:07 +0200 (CEST)
From:   josua@solid-run.com
To:     netdev@vger.kernel.org
Cc:     Josua Mayer <josua@solid-run.com>
Subject: [PATCH 0/4] Fix hang of Armada 8040 SoC in orion-mdio
Date:   Sat,  6 Jul 2019 17:18:56 +0200
Message-Id: <20190706151900.14355-1-josua@solid-run.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josua Mayer <josua@solid-run.com>

With a modular kernel as configured by Debian a hang was observed with
the Armada 8040 SoC in the Clearfog GT and Macchiatobin boards.

The 8040 SoC actually requires four clocks to be enabled for the mdio
interface to function. All 4 clocks are already specified in
armada-cp110.dtsi. It has however been missed that the orion-mdio driver
only supports enabling up to three clocks.

This patch-set allows the orion-mdio driver to handle four clocks and
adds a warning when more clocks are specified to prevent this particular
oversight in the future.

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

