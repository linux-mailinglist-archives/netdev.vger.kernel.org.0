Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA544B1E6
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 18:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240883AbhKIRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbhKIRYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 12:24:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B54C061766
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 09:21:33 -0800 (PST)
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636478491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vp4Gq2D7WeNTxTPghw0Ur2gvpSjzug/faMBSzKkl2hM=;
        b=KBTCooV4NbYR/lmBvSdNufPyNcQ2CSTmWIOHICbTuUhNNnPT2r9iFU1WYn0gQDahyZ0YGj
        Wr03XHhSXriTY0a9YxtsH2pKB9ljVCQM86BOKeWzL6p1k8focIFeRwqf0TrAU1RQsf9bwL
        R8yor5xd/KUgWfzHktQfQtF6t8E5mqxrwUsyZR2tkF0Lmnd2efCxmkarrm9ZhUJD1GqVE4
        KB+2I0OnwmjAhf1eLpInOLceqC1VLBIMWMXxLL2RfYxGSee/IRkRRfM65VhBoQhyCGKsKx
        Zi9UF1h2WD5p4wURcVMAKQ26ek97bWEplCp6Sx8ovnVEuLuxwTBcE2FV0OH/fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636478491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vp4Gq2D7WeNTxTPghw0Ur2gvpSjzug/faMBSzKkl2hM=;
        b=Qja/KHV5JTidZsdV59wMfxq6MiEf1iqz/Yc8HZvzcCzdfQa6lnUdBV7Zn6+p/Ke/x0MnRw
        oDP8PX4uECycvRCw==
To:     mkubecek@suse.cz
Cc:     Bastian Germann <bage@linutronix.de>, netdev@vger.kernel.org
Subject: [PATCH ethtool v2 1/1] netlink: settings: Correct duplicate condition
Date:   Tue,  9 Nov 2021 18:21:25 +0100
Message-Id: <20211109172125.10505-2-bage@linutronix.de>
In-Reply-To: <20211109172125.10505-1-bage@linutronix.de>
References: <20211109172125.10505-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

tb's fields ETHTOOL_A_LINKINFO_TP_MDIX and ETHTOOL_A_LINKINFO_TP_MDIX_CTRL
are used in this case. The condition is duplicate for the former. Fix that.

Signed-off-by: Bastian Germann <bage@linutronix.de>
Fixes: 10cc3ea337d1 ("netlink: partial netlink handler for gset (no option)")
Acked-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 6d10a07..c4f5d61 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -560,7 +560,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
 			   val, "Transceiver");
 	}
-	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX] &&
+	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL] &&
 	    port == PORT_TP) {
 		uint8_t mdix = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
 		uint8_t mdix_ctrl =
-- 
2.30.2

