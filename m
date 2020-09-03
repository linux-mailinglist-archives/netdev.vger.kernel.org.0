Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1278125CC47
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgICVbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:31:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53292 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726679AbgICVbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:31:11 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3AF33600F8;
        Thu,  3 Sep 2020 21:31:11 +0000 (UTC)
Received: from us4-mdac16-55.ut7.mdlocal (unknown [10.7.66.26])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3866F80094;
        Thu,  3 Sep 2020 21:31:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AB078280053;
        Thu,  3 Sep 2020 21:31:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 50955180068;
        Thu,  3 Sep 2020 21:31:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 22:31:02 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 0/6] sfc: TXQ refactor
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Date:   Thu, 3 Sep 2020 22:30:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-4.464100-8.000000-10
X-TMASE-MatchedRID: RelX/0ijcsaLtl7R+4Qd0qiUivh0j2Pv9teeW6UfkyCIwqsz/VtAE0FR
        M9OK8U6B7KerkpfDPRJ0pmQclXiHl3IfTcumHnhSIwk7p1qp3JYrU8f3oY88YOJ4ZAtEhpMkL3c
        bWSYN50xiWfZq8AylnLzCX6O+PQTVNO5dlFRJNAZNq5/Y+tFvW6UvuG6BaZ8zRjHvrQ40Nxbv6F
        j2Xtj47Lniah1e9PtYFJvt04DpKMHbaLIgL14hE3Gg/sD2gWLW6VTG9cZxEjJwGpdgNQ0JrNKXO
        h9lf/Zv4vM1YF6AJbZFi+KwZZttL42j49Ftap9ExlblqLlYqXKBfflqz2sJlQZHWrArgJLyU6Tk
        RGXFrFJj8R51jb89dz9CHqZff8fOWZU2DHYon8TIYER3PPRRBhFBbMbF6zGdOkZJHKlneamQRHK
        5EcWCeFIypztSlSisEpGw8LptO86qtDFfJ0jAbwAXzdZ50duF
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.464100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599168668-bPY5Zl2dHGND
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

Changes from v1:
 * better explain patch #1 in the commit message, and rename
   xmit_more_available to xmit_pending
 * add new patch #2 applying the same approach to ef100, for consistency

Edward Cree (6):
  sfc: add and use efx_tx_send_pending in tx.c
  sfc: make ef100 xmit_more handling look more like ef10's
  sfc: use tx_queue->old_read_count in EF100 TX path
  sfc: use efx_channel_tx_[old_]fill_level() in Siena/EF10 TX datapath
  sfc: rewrite efx_tx_may_pio
  sfc: remove efx_tx_queue_partner

 drivers/net/ethernet/sfc/ef10.c       |  2 +-
 drivers/net/ethernet/sfc/ef100_tx.c   | 34 +++++----
 drivers/net/ethernet/sfc/ef100_tx.h   |  1 -
 drivers/net/ethernet/sfc/farch.c      |  2 +-
 drivers/net/ethernet/sfc/net_driver.h | 22 ++++--
 drivers/net/ethernet/sfc/nic_common.h | 40 +----------
 drivers/net/ethernet/sfc/tx.c         | 99 +++++++++++++++++----------
 drivers/net/ethernet/sfc/tx_common.c  |  9 +--
 8 files changed, 104 insertions(+), 105 deletions(-)

