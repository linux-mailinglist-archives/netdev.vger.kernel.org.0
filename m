Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699E51315DD
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgAFQOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2KTCVSvFPOHUS6R1rv4MAR08o+tqRzY+MkXczpNV5z0=; b=FaYMI/vKurQ6+8d2CcWnkKDttw
        MlFxHnOWRzbBnQo1JTz0VV0hDgflnYJfhST5egf/oBBIlDScT9R/Hp7HmhyFouaq0U0AjxKWEOXNk
        PLNDSB3T4SddUYYUyoXmllnNGV5mI7GXxc+ND2CT76IKPIpZ3D8//gWqQJFGxw6xYDlA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV13-0001Aq-SC; Mon, 06 Jan 2020 17:14:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/5] Unique mv88e6xxx IRQ names
Date:   Mon,  6 Jan 2020 17:13:47 +0100
Message-Id: <20200106161352.4461-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few boards which have multiple mv88e6xxx switches. With
such boards, it can be hard to determine which interrupts belong to
which switches. Make the interrupt names unique by including the
device name in the interrupt name. For the SERDES interrupt, also
include the port number. As a result of these patches ZII devel C
looks like:

 50:          0  gpio-vf610  27 Level     mv88e6xxx-0.1:00
 54:          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-0.1:00-g1-atu-prob
 56:          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-0.1:00-g1-vtu-prob
 58:          0  mv88e6xxx-g1   7 Edge      mv88e6xxx-0.1:00-g2
 61:          0  mv88e6xxx-g2   1 Edge      !mdio-mux!mdio@1!switch@0!mdio:01
 62:          0  mv88e6xxx-g2   2 Edge      !mdio-mux!mdio@1!switch@0!mdio:02
 63:          0  mv88e6xxx-g2   3 Edge      !mdio-mux!mdio@1!switch@0!mdio:03
 64:          0  mv88e6xxx-g2   4 Edge      !mdio-mux!mdio@1!switch@0!mdio:04
 70:          0  mv88e6xxx-g2  10 Edge      mv88e6xxx-0.1:00-serdes-10
 75:          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-0.1:00-watchdog
 76:          5  gpio-vf610  26 Level     mv88e6xxx-0.2:00
 80:          0  mv88e6xxx-g1   3 Edge      mv88e6xxx-0.2:00-g1-atu-prob
 82:          0  mv88e6xxx-g1   5 Edge      mv88e6xxx-0.2:00-g1-vtu-prob
 84:          4  mv88e6xxx-g1   7 Edge      mv88e6xxx-0.2:00-g2
 87:          2  mv88e6xxx-g2   1 Edge      !mdio-mux!mdio@2!switch@0!mdio:01
 88:          0  mv88e6xxx-g2   2 Edge      !mdio-mux!mdio@2!switch@0!mdio:02
 89:          0  mv88e6xxx-g2   3 Edge      !mdio-mux!mdio@2!switch@0!mdio:03
 90:          0  mv88e6xxx-g2   4 Edge      !mdio-mux!mdio@2!switch@0!mdio:04
 95:          3  mv88e6xxx-g2   9 Edge      mv88e6xxx-0.2:00-serdes-9
 96:          0  mv88e6xxx-g2  10 Edge      mv88e6xxx-0.2:00-serdes-10
101:          0  mv88e6xxx-g2  15 Edge      mv88e6xxx-0.2:00-watchdog

Interrupt names like !mdio-mux!mdio@2!switch@0!mdio:01 are created by
phylib for the integrated PHYs. The mv88e6xxx driver does not
determine these names.

Andrew Lunn (5):
  net: dsa: mv88e6xxx: Unique IRQ name
  net: dsa: mv88e6xxx: Unique SERDES interrupt names
  net: dsa: mv88e6xxx: Unique watchdog IRQ name
  net: dsa: mv88e6xxx: Unique g2 IRQ name
  net: dsa: mv88e6xxx: Unique ATU and VTU IRQ names

 drivers/net/dsa/mv88e6xxx/chip.c        | 11 +++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h        |  6 ++++++
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  5 ++++-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |  5 ++++-
 drivers/net/dsa/mv88e6xxx/global2.c     | 10 ++++++++--
 5 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.25.0.rc1

