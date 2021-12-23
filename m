Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B0547DD07
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345883AbhLWBOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:12 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:18064 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241466AbhLWBOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=umwnLomDnL8JV4cAJEilJ/xdGNnjtl/WMw/dTXYXnHw=;
        b=XaMT+NPDkMBwRbNRZ5nRuZewLyDWkWRsKt0OjjotqbZA5gZ/4Mr952ZLdrWQlkAWkT22
        3ep1d56SkgTGHRdHk942/yDUNP/FvzId1G2ygcDXyq84vd+gePBibmJKVeXV9YwBfYZcNV
        gQdSChdqCVd6rOG2KEHP2lmIa5Yo/JgyrJ1uu/++8vIvVEUTrfDP9whKL6AtZH32LX0nmv
        vtMNkh6n2lAqaGZF9QAvunsif6eXLFVbvA8sRUe8REk4j875uz5OfiZwjHq7ysBusRsKZA
        sL3lh45yxbtwUA6U1QNx6Xcu1Z7M/egVgOABzz3q51G5VQoNxN0ee+e6SKZ+zXSw==
Received: by filterdrecv-75ff7b5ffb-w7hgd with SMTP id filterdrecv-75ff7b5ffb-w7hgd-1-61C3CD5E-9
        2021-12-23 01:14:06.198059899 +0000 UTC m=+9687226.166389619
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id j-W6BjeiQ9uWp7sLPSK6Ng
        Thu, 23 Dec 2021 01:14:06.044 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 1B3B97011B9; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 14/50] wilc1000: if there is no tx packet, don't increment
 packets-sent counter
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-15-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOR25dwhR8xVxUiJR?=
 =?us-ascii?Q?PvfwopFiHKgJmz5nG7pPD2E+83y=2Fm+RHtKjsCtp?=
 =?us-ascii?Q?gPwMsMrHiC8Af1aM9ryNHWuHG4x4Wz2GyUEQIBD?=
 =?us-ascii?Q?i2+5kSvvgCCLrZidcLd9VFMgC=2FEWIehLtgHFUOy?=
 =?us-ascii?Q?jHvQs8SzYfEDzhkTgFLCJDv=2FSmhkOIswdEw69E?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Granted, this case is mostly theoretical as the queue should never be
empty in this place, and hence tqe should never be NULL, but it's
still wrong to count a packet that doesn't exist.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 979615914d420..7106e6be719c1 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -893,10 +893,10 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		u8 mgmt_ptk = 0;
 
 		tqe = wilc_wlan_txq_remove_from_head(wilc, vmm_entries_ac[i]);
-		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		if (!tqe)
 			break;
 
+		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		vif = tqe->vif;
 		if (vmm_table[i] == 0)
 			break;
-- 
2.25.1

