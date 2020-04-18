Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AD01AE8DA
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 02:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgDRAET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 20:04:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDRAES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 20:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fIizg/doKHNGVoFd0xJwcbHIoyVAoL8dSj2Y49y4oCg=; b=qYqabecfAt259veLBjv4dUySXu
        FBjAeAiuLbXKwmgWDKZl8IOGZFxi9teKLPcGKsk9O0TXAO8wD7/oxr91qG6ecGGLOIMbmol7PaKEi
        uL4ClLNTzQy4eGtnJC1o+JhGGoO0jDyOCplvn0MLGWj5dUCmoNyMgNppOt/RAoS6veDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPaxs-003NKT-PN; Sat, 18 Apr 2020 02:04:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 0/3] FEC MDIO speedups
Date:   Sat, 18 Apr 2020 02:03:52 +0200
Message-Id: <20200418000355.804617-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset gives a number of speedups for MDIO with the FEC.
Replacing interrupt driven with polled IO brings a big speedup due to
the overheads of interrupts compared to the short time interval.
Clocking the bus faster, when the MDIO targets supports it, can double
the transfer rate. And suppressing the preamble, if devices support
it, makes each transaction faster.

By default the MDIO clock remains 2.5MHz and preables are used. But
these can now be controlled from the device tree. Since these are
generic properties applicable to more than just FEC, these have been
added to the generic MDIO binding documentation.

Andrew Lunn (3):
  net: ethernet: fec: Replace interrupt driven MDIO with polled IO
  net: ethernet: fec: Allow configuration of MDIO bus speed
  net: ethernet: fec: Allow the MDIO preamble to be disabled

 .../devicetree/bindings/net/fsl-fec.txt       |  1 +
 .../devicetree/bindings/net/mdio.yaml         |  8 ++
 drivers/net/ethernet/freescale/fec.h          |  4 +-
 drivers/net/ethernet/freescale/fec_main.c     | 85 +++++++++++--------
 4 files changed, 59 insertions(+), 39 deletions(-)

-- 
2.26.1

