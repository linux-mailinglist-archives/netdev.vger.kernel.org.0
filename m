Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D11AFE85
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDSWEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:04:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgDSWEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 18:04:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QCpRfTzn+Yg9F1+scAAlsswP1NPJCxiI1Ni4Eq66Wjo=; b=crNCljqK+gzm/g2Aao0abGOJTG
        CZKa/X5bxSh2N6+3epewoWvF42PXR0M68eZibH4MGRvMsW/meUD/zwpN8wQhNuIhjO11llZH7k2zK
        LlzpSPqyE7kIb8u+Fo1EJck++BtJpQoexummhmUQGKMNEG2KKQeRnl9H4f7UOYo9Rp6c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQI2w-003hqh-4c; Mon, 20 Apr 2020 00:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 0/3]  FEC MDIO speedups
Date:   Mon, 20 Apr 2020 00:03:59 +0200
Message-Id: <20200419220402.883493-1-andrew@lunn.ch>
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

v2:
readl_poll_timeout()
Add patches to set bus frequency and preamble disable

v3:
Add Reviewed tags
uS->us
readl_poll_timeout_atomic()
Extend DT binding documentation

Andrew Lunn (3):
  net: ethernet: fec: Replace interrupt driven MDIO with polled IO
  net: ethernet: fec: Allow configuration of MDIO bus speed
  net: ethernet: fec: Allow the MDIO preamble to be disabled

 .../devicetree/bindings/net/fsl-fec.txt       |  1 +
 .../devicetree/bindings/net/mdio.yaml         | 12 +++
 drivers/net/ethernet/freescale/fec.h          |  4 +-
 drivers/net/ethernet/freescale/fec_main.c     | 85 +++++++++++--------
 4 files changed, 63 insertions(+), 39 deletions(-)

-- 
2.26.1

