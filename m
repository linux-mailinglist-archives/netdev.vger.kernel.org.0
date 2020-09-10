Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37138265111
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgIJUlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:41:25 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58348 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgIJUab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:30:31 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E75622EAD16
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 20:30:26 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BA6FF600D7;
        Thu, 10 Sep 2020 20:30:06 +0000 (UTC)
Received: from us4-mdac16-31.ut7.mdlocal (unknown [10.7.66.142])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B6D472009A;
        Thu, 10 Sep 2020 20:30:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3548D1C0060;
        Thu, 10 Sep 2020 20:30:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CC1474C0073;
        Thu, 10 Sep 2020 20:30:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Sep
 2020 21:29:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/7] sfc: encap offloads on EF10
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Date:   Thu, 10 Sep 2020 21:29:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25656.007
X-TM-AS-Result: No-0.010000-8.000000-10
X-TMASE-MatchedRID: 5jEzp9DVdVNcobUo5TVGLf3HILfxLV/99/plKg1lCsjHN9tnHHgXhH5w
        2/Pwxc6w8XVI39JCRnSjfNAVYAJRApOvHLRB1lSRnFVnNmvv47t9LQinZ4QefL6qvLNjDYTwmTD
        wp0zM3zoqtq5d3cxkNU3guhS6ZRsxsXLM6LJSFOCiU7lM48KiqLR8uoWhlBxvxABMqOpnu529w3
        9RofAMCpUM7BEAXAiLIBsWFp6Vxyi4H1LUxCp0IlB3cChpiUaLQ4MNjn8G4SyjGuTpDaYh5In7C
        /ugmOEZV0052cEvC/lDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.010000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25656.007
X-MDID: 1599769806-uPeaSMli2ANv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF10 NICs from the 8000 series onwards support TX offloads (checksumming,
 TSO) on VXLAN- and NVGRE-encapsulated packets.  This series adds driver
 support for these offloads.

Edward Cree (7):
  sfc: decouple TXQ type from label
  sfc: define inner/outer csum offload TXQ types
  sfc: create inner-csum queues on EF10 if supported
  sfc: select inner-csum-offload TX queues for skbs that need it
  sfc: de-indirect TSO handling
  sfc: implement encapsulated TSO on EF10
  sfc: advertise encapsulated offloads on EF10

 drivers/net/ethernet/sfc/ef10.c           | 124 +++++++++++++++-------
 drivers/net/ethernet/sfc/ef100_tx.c       |   3 +-
 drivers/net/ethernet/sfc/efx.c            |   1 +
 drivers/net/ethernet/sfc/efx_channels.c   |  10 +-
 drivers/net/ethernet/sfc/efx_common.c     |  84 +++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h     |   3 +
 drivers/net/ethernet/sfc/ethtool_common.c |   2 +-
 drivers/net/ethernet/sfc/farch.c          |  22 ++--
 drivers/net/ethernet/sfc/mcdi_functions.c |  24 +++--
 drivers/net/ethernet/sfc/mcdi_functions.h |   2 +-
 drivers/net/ethernet/sfc/net_driver.h     |  51 +++++----
 drivers/net/ethernet/sfc/nic.h            |   4 +
 drivers/net/ethernet/sfc/ptp.c            |   5 +-
 drivers/net/ethernet/sfc/selftest.c       |   4 +-
 drivers/net/ethernet/sfc/selftest.h       |   4 +-
 drivers/net/ethernet/sfc/tx.c             |  24 ++++-
 drivers/net/ethernet/sfc/tx.h             |  26 +++++
 drivers/net/ethernet/sfc/tx_common.c      |  10 +-
 18 files changed, 302 insertions(+), 101 deletions(-)

