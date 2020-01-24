Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809191486EF
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391843AbgAXOTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:19:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391785AbgAXOTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAEFB2087E;
        Fri, 24 Jan 2020 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875572;
        bh=y1jq6q/MHA24dUHg5NYF2kSpOlzsac5RCXoBp3kQHv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkbSYupCTUgs+EQ0oPM6XmxOp47gv88W8KPcRvG0a5s1mdTZm0dCTDhplSfCI11o2
         i1gQOlOynWKVmmyLBFqvBEyXgjwR7O1D1lE60wI8WLIgKNbcDC1EvtU4QELsz3iXYv
         ETvS20/sSPJ1Oz4CA2fw2b7VIsJMqBmyO1z3cSfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Antti Laakso <antti.laakso@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 065/107] ptp: free ptp device pin descriptors properly
Date:   Fri, 24 Jan 2020 09:17:35 -0500
Message-Id: <20200124141817.28793-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

[ Upstream commit 75718584cb3c64e6269109d4d54f888ac5a5fd15 ]

There is a bug in ptp_clock_unregister(), where ptp_cleanup_pin_groups()
first frees ptp->pin_{,dev_}attr, but then posix_clock_unregister() needs
them to destroy a related sysfs device.

These functions can not be just swapped, as posix_clock_unregister() frees
ptp which is needed in the ptp_cleanup_pin_groups(). Fix this by calling
ptp_cleanup_pin_groups() in ptp_clock_release(), right before ptp is freed.

This makes this patch fix an UAF bug in a patch which fixes an UAF bug.

Reported-by: Antti Laakso <antti.laakso@intel.com>
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
Link: https://lore.kernel.org/netdev/3d2bd09735dbdaf003585ca376b7c1e5b69a19bd.camel@intel.com/
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 61fafe0374cea..b84f16bbd6f24 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -170,6 +170,7 @@ static void ptp_clock_release(struct device *dev)
 {
 	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
 
+	ptp_cleanup_pin_groups(ptp);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	ida_simple_remove(&ptp_clocks_map, ptp->index);
@@ -302,9 +303,8 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 
-	ptp_cleanup_pin_groups(ptp);
-
 	posix_clock_unregister(&ptp->clock);
+
 	return 0;
 }
 EXPORT_SYMBOL(ptp_clock_unregister);
-- 
2.20.1

