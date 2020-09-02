Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E747E25AD3E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 16:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIBOeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 10:34:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59446 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgIBOej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 10:34:39 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 69A856010C;
        Wed,  2 Sep 2020 14:34:28 +0000 (UTC)
Received: from us4-mdac16-40.ut7.mdlocal (unknown [10.7.66.159])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5F9BB800B4;
        Wed,  2 Sep 2020 14:34:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DAE21280052;
        Wed,  2 Sep 2020 14:34:27 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 77F8C800074;
        Wed,  2 Sep 2020 14:34:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep 2020
 15:34:22 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/5] sfc: TXQ refactor
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <d3c81ab7-6d2e-326f-e25e-e42095ce9e66@solarflare.com>
Date:   Wed, 2 Sep 2020 15:34:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25640.003
X-TM-AS-Result: No-3.352200-8.000000-10
X-TMASE-MatchedRID: Tc5eirJHGISLtl7R+4Qd0qiUivh0j2Pv9teeW6UfkyCIwqsz/VtAE0FR
        M9OK8U6B7KerkpfDPRJ0pmQclXiHl3IfTcumHnhSIwk7p1qp3JYrU8f3oY88YOJ4ZAtEhpMkL3c
        bWSYN50xiWfZq8AylnLzCX6O+PQTVHyjC+QCbXy0sisyWO3dp2wqiBO2qhCIGC7dU+sNmXtLK0r
        mwSIvD75dTOyk/f2qgOuSQ87VCo/mvvxILmKK/HDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyHEqm
        8QYBtMOzBYWIy5OJlMAWkd6ZLfvdFkU0ylW5YqxfA8arxKmjP6juXTncIYQ0d07hjkwb7H7qdCw
        S/UvddEbMwok6wMyOgmLzSDl7FB1GhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtniQWaoMYDBaY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.352200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25640.003
X-MDID: 1599057268-sO3fEU8RA-Wi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor and unify partner-TXQ handling in the EF100 and legacy drivers.

The main thrust of this series is to remove from the legacy (Siena/EF10)
 driver the assumption that a netdev TX queue has precisely two hardware
 TXQs (checksummed and unchecksummed) associated with it, so that in
 future we can have more (e.g. for handling inner-header checksums) or
 fewer (e.g. to free up hardware queues for XDP usage).

Edward Cree (5):
  sfc: add and use efx_tx_send_pending in tx.c
  sfc: use tx_queue->old_read_count in EF100 TX path
  sfc: use efx_channel_tx_[old_]fill_level() in Siena/EF10 TX datapath
  sfc: rewrite efx_tx_may_pio
  sfc: remove efx_tx_queue_partner

 drivers/net/ethernet/sfc/ef100_tx.c   |  8 ++-
 drivers/net/ethernet/sfc/net_driver.h | 18 +++--
 drivers/net/ethernet/sfc/nic_common.h | 40 +----------
 drivers/net/ethernet/sfc/tx.c         | 99 +++++++++++++++++----------
 drivers/net/ethernet/sfc/tx_common.c  |  5 +-
 5 files changed, 85 insertions(+), 85 deletions(-)

