Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443652675FC
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:37:33 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:32798 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgIKWhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:37:32 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 547EE60055;
        Fri, 11 Sep 2020 22:37:32 +0000 (UTC)
Received: from us4-mdac16-20.ut7.mdlocal (unknown [10.7.65.244])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 52E092009A;
        Fri, 11 Sep 2020 22:37:32 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D94331C0057;
        Fri, 11 Sep 2020 22:37:31 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7C84F1C0069;
        Fri, 11 Sep 2020 22:37:31 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 23:37:21 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 0/7] sfc: encap offloads on EF10
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
Message-ID: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Date:   Fri, 11 Sep 2020 23:37:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-2.444500-8.000000-10
X-TMASE-MatchedRID: LW/88AYaZXtcobUo5TVGLf3HILfxLV/9V447DNvw38b5+tteD5RzhdyV
        rIZi/5O/U2QACx2DI6iJwy8DMYqNPVJAAk7j9W+XN19PjPJahlIhBdUXaqx1XZh4xM9oAcstETm
        TE0q+rtz6nzXjRUKe8VO9V994jC9DBRx9b+h52aqNCVVXBJuPJ016N0DD9tffmyiLZetSf8nJ4y
        0wP1A6AAOkBnb8H8GWjaPj0W1qn0TGVuWouVipcssOcOGkLxcGs0LzjNlgzEWRAHK6cgvqJQUs0
        ztDo/j4aojv6WcHkAYbGzxlp3KntXBjK8IcEtw8C+G7Ibu614nvkBCJEUhwPZBEcrkRxYJ4UjKn
        O1KVKKwSkbDwum07zqq0MV8nSMBvABfN1nnR24U=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.444500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599863852-AUfEwh9AvtlD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF10 NICs from the 8000 series onwards support TX offloads (checksumming,
 TSO) on VXLAN- and NVGRE-encapsulated packets.  This series adds driver
 support for these offloads.

Changes from v1:
 * Fix 'no TXQ of type' error handling in patch #1 (and clear up the
   misleading comment that inspired the wrong version)
 * Add comment in patch #5 explaining what the deal with TSOv3 is

Edward Cree (7):
  sfc: decouple TXQ type from label
  sfc: define inner/outer csum offload TXQ types
  sfc: create inner-csum queues on EF10 if supported
  sfc: select inner-csum-offload TX queues for skbs that need it
  sfc: de-indirect TSO handling
  sfc: implement encapsulated TSO on EF10
  sfc: advertise encapsulated offloads on EF10

 drivers/net/ethernet/sfc/ef10.c           | 124 +++++++++++++++-------
 drivers/net/ethernet/sfc/ef100_tx.c       |   9 +-
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
 drivers/net/ethernet/sfc/tx.c             |  39 +++++--
 drivers/net/ethernet/sfc/tx.h             |  26 +++++
 drivers/net/ethernet/sfc/tx_common.c      |  10 +-
 18 files changed, 318 insertions(+), 106 deletions(-)

