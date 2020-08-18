Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA372484ED
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHRMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:42:18 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36012 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbgHRMmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:42:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C4B722006A;
        Tue, 18 Aug 2020 12:41:58 +0000 (UTC)
Received: from us4-mdac16-59.at1.mdlocal (unknown [10.110.50.152])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C374B800A4;
        Tue, 18 Aug 2020 12:41:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 479CE40073;
        Tue, 18 Aug 2020 12:41:58 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0AFBD980085;
        Tue, 18 Aug 2020 12:41:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 13:41:53 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 0/4] sfc: more EF100 fixes
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <d8d6cdfc-7d4f-81ec-8b3e-bc207a2c7d50@solarflare.com>
Date:   Tue, 18 Aug 2020 13:41:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25610.005
X-TM-AS-Result: No-3.545300-8.000000-10
X-TMASE-MatchedRID: F4ugVhuTF/CAVlxKYvddDE5fxQhMok8efo0lncdGFFOI+XDGhL+iMl8v
        PNhBIHcIKQjLE0RqyiXpvdQrSWKMJ28Om8YFpkhcjpyluct2Nr0Ea8g1x8eqF5GPHiE2kiT472Q
        95D1Ji7EDjkKRcl7eTxitSPHZblZ+ofaD2zI+zzzwqDryy7bDIeRjXRoZjRDh0SxMhOhuA0TSlz
        ofZX/2b+LzNWBegCW2RYvisGWbbS9mIVC+RmEW7Wrz/G/ZSbVq+gtHj7OwNO2eVW/ZdL52j7pnX
        AzCWBMdo0+dP6o41mpSAGMflyWpojf5yTjnfd9NI+q+0WpTokrOfWsKQ7hlwoEF6AIo7F7PffJ5
        P15Zt4ED4ITVEnfNAnzm6hivSaZZop2lf3StGhISt1bcvKF7ZKbNmFZyaXzY
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.545300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25610.005
X-MDID: 1597754518-fqX0H44-x_xr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up some bugs in the initial EF100 submission, and re-fix
 the hash_valid fix which was incomplete.

The reset bugs are currently hard to trigger; they were found
 with an in-progress patch adding ethtool support, whereby
 ethtool --reset reliably reproduces them.

Edward Cree (4):
  sfc: really check hash is valid before using it
  sfc: take correct lock in ef100_reset()
  sfc: null out channel->rps_flow_id after freeing it
  sfc: don't free_irq()s if they were never requested

 drivers/net/ethernet/sfc/ef100_nic.c  | 10 ++++++----
 drivers/net/ethernet/sfc/net_driver.h |  2 ++
 drivers/net/ethernet/sfc/nic.c        |  4 ++++
 drivers/net/ethernet/sfc/rx_common.c  |  1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

