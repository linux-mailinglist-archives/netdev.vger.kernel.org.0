Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B930213C7F
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGCP2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:28:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40682 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbgGCP2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:28:16 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A4C63200AE;
        Fri,  3 Jul 2020 15:28:15 +0000 (UTC)
Received: from us4-mdac16-49.at1.mdlocal (unknown [10.110.50.132])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 13701800B5;
        Fri,  3 Jul 2020 15:28:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2814910007B;
        Fri,  3 Jul 2020 15:28:13 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6ABEAB40066;
        Fri,  3 Jul 2020 15:28:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:28:08 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 00/15] sfc_ef100: driver for EF100 family NICs, part
 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Date:   Fri, 3 Jul 2020 16:28:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-6.020600-8.000000-10
X-TMASE-MatchedRID: L1rnSOHgdze8V7HcFx2lJMnUT+eskUQPRiPTMMc/MmlahAEL9o+TW5f6
        orgBh2tKM4hLs4cdh7FRGE2QuZOacCheGzJN8xqhuZBZOg7RfX80AJe3B5qfBsM5LQWFwBdKjet
        DNZX3ItgNXjrHKbpKiuboSGZPdV4HTYHIeMqWcq4XK/dRaOWlvTVfUuzvrtymAwAObkR2opY6rp
        gCnO/ZYVZnA+MM1ykAlMaIBm0udyiUxcEEQbqEuFVeGWZmxN2MfXRAc+s3RFdXDLXlLBNaqvBUq
        5JsuvxSwa0v5c8zVPp3/TlvMElFHYqEDaEbYNOrqJSK+HSPY+/pVMb1xnESMi/dwuJsXYm3edRs
        VpejKZ7lGeC1fZ8vnexsL9XDoOGTTX7PJ/OU3vKDGx/OQ1GV8t0H8LFZNFG7bkV4e2xSge4qFy9
        rS4GWetUvQptLn78EEiGbrN9ZGy1s6S4/4InMEb7rweoAIK8o
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.020600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790095-hnVQ5PIxvoQI
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to maintain bisectability while splitting into patches of a
 reasonable size, I had to do a certain amount of back-and-forth with
 stubs for things that the common code may try to call, mainly because
 we can't do them until we've set up MCDI, but we can't set up MCDI
 without probing the event queues, at which point a lot of the common
 machinery becomes reachable from event handlers.
Consequently, this first series doesn't get as far as actually sending
 and receiving packets.  I have a second series ready to follow it
 which implements the datapath (and a few other things like ethtool).

(Would folks prefer the whole thing submitted in one series?  It's 27
 patches in total.)

Edward Cree (15):
  sfc_ef100: add EF100 register definitions
  sfc_ef100: register accesses on EF100
  sfc_ef100: skeleton EF100 PF driver
  sfc_ef100: reset-handling stub
  sfc_ef100: PHY probe stub
  sfc_ef100: don't call efx_reset_down()/up() on EF100
  sfc_ef100: implement MCDI transport
  sfc_ef100: implement ndo_open/close and EVQ probing
  sfc_ef100: process events for MCDI completions
  sfc_ef100: read datapath caps, implement check_caps
  sfc_ef100: extend ef100_check_caps to cover datapath_caps3
  sfc_ef100: actually perform resets
  sfc_ef100: probe the PHY and configure the MAC
  sfc_ef100: read device MAC address at probe time
  sfc_ef100: implement ndo_get_phys_port_{id,name}

 drivers/net/ethernet/sfc/Kconfig         |  10 +
 drivers/net/ethernet/sfc/Makefile        |   8 +
 drivers/net/ethernet/sfc/ef100.c         | 583 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_ethtool.c |  26 +
 drivers/net/ethernet/sfc/ef100_ethtool.h |  12 +
 drivers/net/ethernet/sfc/ef100_netdev.c  | 280 +++++++++
 drivers/net/ethernet/sfc/ef100_netdev.h  |  17 +
 drivers/net/ethernet/sfc/ef100_nic.c     | 620 ++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h     |  32 ++
 drivers/net/ethernet/sfc/ef100_regs.h    | 693 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rx.c      |  30 +
 drivers/net/ethernet/sfc/ef100_rx.h      |  19 +
 drivers/net/ethernet/sfc/ef100_tx.c      |  62 ++
 drivers/net/ethernet/sfc/ef100_tx.h      |  22 +
 drivers/net/ethernet/sfc/efx_common.c    |   9 +-
 drivers/net/ethernet/sfc/io.h            |  16 +-
 drivers/net/ethernet/sfc/mcdi.h          |   4 +-
 drivers/net/ethernet/sfc/net_driver.h    |  14 +-
 18 files changed, 2449 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_regs.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.h

